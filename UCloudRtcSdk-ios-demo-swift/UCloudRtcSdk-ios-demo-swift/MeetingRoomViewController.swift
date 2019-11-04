//
//  MeetingRoomViewController.swift
//  UCloudRtcSdk-ios-demo-swift
//
//  Created by Tony on 2019/10/12.
//  Copyright © 2019 Tony. All rights reserved.
//
import UIKit


class MeetingRoomViewController : UIViewController,UCloudRtcEngineDelegate,UICollectionViewDelegate, UICollectionViewDataSource ,MeetingRoomCellDelegate {
    public var engineSetting : NSDictionary?
    public var engineMode : UCloudRtcEngineMode?
    public var roomId : NSString?
    public var appId : NSString?
    public var appKey : NSString?
    public var userId : NSString?
    public var token : NSString?
    public var roomName : NSString?
    
    private var kHorizontalCount: Int = 3
    
    @IBOutlet weak var listView: UICollectionView?
    @IBOutlet weak var localView: UIView?
    @IBOutlet weak var settingView: UIView?
    @IBOutlet weak var widthOfSettingView: NSLayoutConstraint?
    @IBOutlet weak var heightOfListView: NSLayoutConstraint?
    @IBOutlet weak var bottomButton: UIButton?
    @IBOutlet weak var roomNameLabel: UILabel?
    var streamList: NSMutableArray?
    var isConnected: Bool?
//    var popupMenu: YBPopupMenu?
    var seconds: Int32?
    var minutes: Int32?
    var hours: Int32?
    var timer: Timer?
    var manager : UCloudRtcEngine?
    var canSubstreamList : NSMutableArray?
    var bigScreenStream : UCloudRtcStream?
    
    var collectionView:UICollectionView?;
    let CELL_ID = "cell_id";
    let ScreenHeight = UIScreen.main.bounds.size.height
    let ScreenWidth = UIScreen.main.bounds.size.width
    
    @IBOutlet weak var startBtn: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isConnected = false
        canSubstreamList = NSMutableArray()
        self.streamList = NSMutableArray()
        self.roomNameLabel?.text = String(format: "ROOM:%@", self.roomId!)
        self.listView?.register(UINib(nibName: "MeetingRoomCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        //初始化engine
        self.manager = UCloudRtcEngine.init(userId:self.userId! as String, appId: self.appId! as String, roomId:self.roomId! as String , appKey: self.appKey! as String, token:self.token! as String)
        self.manager?.delegate = self
        //指定SDK模式
        self.manager?.engineMode = self.engineMode!
        //自定义配置
        if (self.engineSetting?.count != 0){
            self.settingSDK(self.engineSetting!)
        }
        //加入房间
        self.manager?.joinRoomWithcompletionHandler({(data, response, error) -> Void in})
        
        createCollectionView();
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.manager?.setLocalPreview(self.localView!)
        self.bigScreenStream = self.manager?.localStream
    }
    
    func settingSDK(_ setting: NSDictionary) {
        let isAutoPublish:Bool = setting["isAutoPublish"] as! Bool
        let isAutoSubscribe: Bool = setting["isAutoSubscribe"] as! Bool
        let isOnlyAudio: Bool =  setting["isOnlyAudio"] as! Bool
        let videoProfile: Int = setting["videoProfile"] as! Int
        let streamProfile: Int = setting["streamProfile"] as! Int
        let roomType: Int = setting["roomType"] as! Int
        let isDebug: Bool = setting["isDebug"] as! Bool
        
        self.manager?.isAutoPublish = isAutoPublish
        self.manager?.isAutoSubscribe = isAutoSubscribe
        self.manager?.isOnlyAudio = isOnlyAudio
        if isDebug == false{
            self.manager?.logger?.setLogLevel(.UCloudRtcLogLevel_OFF)
        }
        switch roomType {
            case 0:
                self.manager?.roomType = .communicate
                break
            case 1:
                self.manager?.roomType = .broadcast
                break
            default:
                break
            }
            switch videoProfile {
            case 0:
                self.manager?.videoProfile = ._VideoProfile_180P
                break
            case 1:
                self.manager?.videoProfile = ._VideoProfile_360P_1
                break
            case 2:
                self.manager?.videoProfile = ._VideoProfile_360P_2
                break
            case 3:
                self.manager?.videoProfile = ._VideoProfile_480P
                break
            case 4:
                self.manager?.videoProfile = ._VideoProfile_720P
                break
            default:
                break
            }
            switch streamProfile {
            case 0:
                self.manager?.streamProfile = .streamProfileUpload
                break
            case 1:
                self.manager?.streamProfile = .streamProfileDownload
                break
            case 2:
                self.manager?.streamProfile = .streamProfileAll
                break
            default:
                break
            }
    }
    
    //开始视频录制
    @IBAction func startRecord(_ sender: UIButton) {
        if sender.titleLabel?.text == "开始录制" {
            CBToast.showToastAction(message: "开始录制视频")
            let recordConfig = UCloudRtcRecordConfig.init()
            recordConfig.mainviewid = userId as String?;
            recordConfig.mimetype = 3;
            recordConfig.mainviewmt = 1;
            recordConfig.bucket = "urtc-test";
            recordConfig.region = "cn-bj";
            recordConfig.watermarkpos = 1;
            recordConfig.width = 360;
            recordConfig.height = 480;
            self.manager?.startRecord(recordConfig)
            
            self.hours = 0
            self.minutes = 0
            self.seconds = 0
             self.timer = Timer.init(timeInterval: 1, target: self, selector: #selector(foTimer(_:)), userInfo: nil, repeats: true)
            RunLoop.current.add(self.timer!, forMode: .default)
        }
    }
    
    //停止视频录制
    @IBAction func stopRecord(_ sender: UIButton) {
        self.manager?.stopRecord()
        CBToast.showToastAction(message: "停止录制视频")
        self.startBtn?.setTitle("开始录制", for: .normal)
        self.timer?.invalidate()
        self.timer = nil;
    }
    
    @objc func foTimer(_ timer:Timer) -> Void {
        self.seconds = self.seconds! + 1
        if self.seconds == 60 {
            self.minutes = self.minutes! + 1
            self.seconds = 0
        }
        if self.minutes == 60 {
            self.hours = self.hours! + 1
            self.minutes = 0
        }
        self.startBtn?.setTitle(String(format: "%.2d:%.2d:%.2d", self.hours!,self.minutes!,self.seconds!), for: .normal)
    }

    
    //退出房间
    @IBAction func leaveRoom(_ sender: Any) {
        let alertController = UIAlertController(title: "提示",
                                                message: "您确定要退出房间吗？", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "确定", style: .default, handler: {
            action in
            self.manager?.leaveRoom()
        })
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    //切换本地摄像头
    @IBAction func didSwitchCameraAction(_ sender: Any) {
        self.manager?.switchCamera()
    }
    
    //开启/禁用麦克风
    @IBAction func didSetMicrophoneMuteAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        self.manager?.setMute(sender.isSelected)
    }
    
    //开启/禁用扬声器
    @IBAction func didOpenLoudspeakerAction(_ sender: UIButton) {
        self.manager?.openLoudspeaker(sender.isSelected)
        sender.isSelected = !sender.isSelected
    }
    
    //开启/禁用本地视频
    @IBAction func didOpenVideoAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        self.manager?.openCamera(!sender.isSelected)
    }
    @IBAction func showSubscribeList(_ sender: UIButton){
        
    }
    
    //MARK:发布流
    @IBAction func didPublishStreamAction(_ sender: Any) {
        if self.isConnected == true {
            let alertController = UIAlertController(title: "提示",
                                                    message: "您确定要取消发布吗？", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            let okAction = UIAlertAction(title: "确定", style: .default, handler: {
                action in
                self.manager?.unPublish()
            })
            alertController.addAction(cancelAction)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
        else {
            self.manager?.localStream.render(on: self.localView)
            self.manager?.publish()
            self.bigScreenStream = self.manager?.localStream
        }
    }
    
    //更新视频窗口布局
    func reloadVideos() {
        var temp:Int =  kHorizontalCount * 5
        temp = Int((self.collectionView?.frame.width)!) - temp
        temp = temp / kHorizontalCount
        let width: CGFloat = CGFloat(temp)
        let height: CGFloat = width/3.0*4.0+5.0
        let count: Int = Int(self.streamList!.count)
        let c:Float = (Float(count / kHorizontalCount))
        var row: Int32 = Int32(ceil(c))
        row = row < 4 ? row : 4
        self.heightOfListView?.constant = height*CGFloat(row)
        self.view.layoutSubviews()
        collectionView?.reloadData()
    }
    
    //创建远程视频显示区域
    func createCollectionView() {
        let flowLayout = UICollectionViewFlowLayout();
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 100, width: ScreenWidth, height: 260), collectionViewLayout: flowLayout)
        collectionView!.backgroundColor = UIColor.clear;
        collectionView!.delegate = self;
        collectionView!.dataSource = self;
        flowLayout.itemSize = CGSize(width: 90, height: 120)
        collectionView!.register(MeetingRoomCell.self, forCellWithReuseIdentifier: CELL_ID);
        self.view.addSubview(collectionView!);
    }
    
    //MARK: - UICollectionView 代理
    //分区数
     func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1;
     }
    //每个分区含有的 item 个数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.streamList!.count;
    }
    //返回 cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_ID, for: indexPath) as! MeetingRoomCell
        for view in cell.contentView.subviews {
            view.removeFromSuperview()
        }
        cell.configureWithStream(stream: self.streamList?[indexPath.row] as! UCloudRtcStream)
        cell.delegate = self
        return cell;
    }
    //最小行间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5.0;
    }
    //item 对应的点击事件 大小视频切换
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let stream:UCloudRtcStream = self.streamList?[indexPath.row] as! UCloudRtcStream
        if (self.bigScreenStream != nil){
            self.streamList?.replaceObject(at: indexPath.row, with: self.bigScreenStream!)
        }else{
            self.streamList?.remove(stream)
        }
        self.bigScreenStream = stream
        self.listView?.reloadData()
        stream.render(on: self.localView)
     }
    
    
    //MARK: ------UCloudRtcEngineDelegate method-----
    func uCloudRtcEngineDidJoinRoom(_ canSubStreamList: NSMutableArray) {
        CBToast.showToastAction(message: "加入房间成功")
        self.isConnected = true;
        //远端所有可订阅的流将在这里展示  仅在非自动订阅模式下 否则为空
        canSubstreamList = canSubStreamList;
    }
    
    /**新成员加入*/
    func uCloudRtcEngine(_ manager: UCloudRtcEngine, memberDidJoinRoom memberInfo: [AnyHashable : Any]) {
        CBToast.showToastAction(message: NSString(format: "用户:%@ 加入房间", memberInfo["user_id"] as! String))
    }
    
    /**成员退出*/
    func uCloudRtcEngine(_ manager: UCloudRtcEngine, memberDidLeaveRoom memberInfo: [AnyHashable : Any]) {
        CBToast.showToastAction(message: NSString(format: "用户:%@ 离开房间", memberInfo["user_id"] as! String))
    }
    
    /**非自动订阅模式下 可订阅流加入*/
    func uCloudRtcEngine(_ channel: UCloudRtcEngine, newStreamHasJoinRoom stream: UCloudRtcStream) {
        CBToast.showToastAction(message: "有新的流可以订阅")
        canSubstreamList?.add(stream)
    }
    
    /**非自动订阅模式下 可订阅流退出*/
    func uCloudRtcEngine(_ channel: UCloudRtcEngine, streamHasLeaveRoom stream: UCloudRtcStream) {
        CBToast.showToastAction(message: "可订阅的流离开")
        canSubstreamList?.remove(stream)
    }
    
    /**非自动订阅模式下 订阅成功的回调*/
    func uCloudRtcEngine(_ channel: UCloudRtcEngine, didSubscribe stream: UCloudRtcStream) {
        CBToast.showToastAction(message: "订阅成功")
        canSubstreamList?.remove(stream)
        self.reloadVideos()
    }
    
    /**退出房间*/
    func uCloudRtcEngineDidLeaveRoom(_ manager: UCloudRtcEngine) {
        CBToast.showToastAction(message: "退出房间")
        self.dismiss(animated: true) {}
    }
    
    /**发布状态的变化*/
    func uCloudRtcEngine(_ manager: UCloudRtcEngine, didChange publishState: UCloudRtcEnginePublishState) {
        switch publishState {
        case .unPublish:
            self.isConnected = false
        case .publishing:
            CBToast.showToastAction(message: "正在发布...")
        case .publishSucceed:
            CBToast.showToastAction(message: "发布成功")
            self.isConnected = true;
            self.bottomButton?.setTitle("发布成功", for: .normal)
        case .republishing:
            self.bottomButton?.setTitle("正在重新发布...", for: .normal)
        case .publishFailed:
            self.isConnected = false;
            CBToast.showToastAction(message: "开始发布")
        case .publishStoped:
            self.isConnected = false;
            CBToast.showToastAction(message: "发布已停止")
            self.bottomButton?.setTitle("开始发布", for: .normal)
        default:
          break
        }
    }
    
    /**收到远程流*/
    func uCloudRtcEngine(_ manager: UCloudRtcEngine, receiveRemoteStream stream: UCloudRtcStream) {
        self.streamList?.add(stream)
        self.reloadVideos()
    }
    
    /**远程流断开(本地移除对应的流)*/
    func uCloudRtcEngine(_ manager: UCloudRtcEngine, didRemove stream: UCloudRtcStream) {
        self.isConnected = true;
        var deleteStream:UCloudRtcStream = UCloudRtcStream()
        for obj in self.streamList! {
            if (obj as! UCloudRtcStream).userId == stream.userId{
                deleteStream = (obj as! UCloudRtcStream)
                break
            }
        }
        self.streamList?.remove(deleteStream)
        self.reloadVideos()
    }
    
    /**错误处理*/
    func uCloudRtcEngine(_ manager: UCloudRtcEngine, error: UCloudRtcError) {
        switch error.errorType{
            case .tokenInvalid:
                CBToast.showToastAction(message:"token无效")
                break;
            case .joinRoomFail:
                CBToast.showToastAction(message: NSString(format: "加入房间失败：%@", error.message))
                break;
            case .publishStreamFail: do {
                self.isConnected = false;
                self.bottomButton?.setTitle("开始发布", for: .normal)
                CBToast.showToastAction(message: NSString(format: "发布失败：%@", error.message))
            }
            break;
            default:
                CBToast.showToastAction(message: NSString(format: "错误%ld:%@", error.code ,error.message))
                break;
            }
    }
    
    /**开始视频录制的回调*/
    func uCloudRtcEngine(_ manager: UCloudRtcEngine, startRecord recordResponse: [AnyHashable : Any]) {
        CBToast.showToastAction(message: NSString(format: "视频录制文件:%@", recordResponse["FileName"] as! CVarArg))
    }
    
    
    //MARK: MeetingRoomCellDelegate methods
    func didMuteStream(stream: UCloudRtcStream, muteAudio: Bool) {
        self.manager?.setRemoteStream(stream, muteAudio: muteAudio)
    }
    
    func didMuteStream(stream: UCloudRtcStream, muteVideo: Bool) {
        self.manager?.setRemoteStream(stream, muteVideo: muteVideo)
    }
}
