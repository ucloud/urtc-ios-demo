//
//  SettingViewController.swift
//  UCloudRtcSdk-ios-demo-swift
//
//  Created by Tony on 2019/10/17.
//  Copyright © 2019 Tony. All rights reserved.
//

import UIKit
import UCloudRtcSdk_ios

class SettingViewController: UIViewController {
    
    @IBOutlet weak var videoProfileSeg: UISegmentedControl?
    @IBOutlet weak var communicationProfile: UISegmentedControl?
    @IBOutlet weak var broadcastProfile: UISegmentedControl?
    //视频分辨率
    var videoProfile :UCloudRtcEngineVideoProfile?
    //本地流权限
    var streamProfile :UCloudRtcEngineStreamProfile?
    //房间类型
    var roomType :UCloudRtcEngineRoomType?
    //是否开启自动发布
    var isAutoPublish: Bool?
    //是否开启自动订阅
    var isAutoSubscribe: Bool?
    //是否打印日志
    var isDebug: Bool?
    //是否采用纯音频模式
    var isOnlyAudio: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isAutoPublish = true
        self.isAutoSubscribe = true
        self.isDebug = true
        self.isOnlyAudio = false
        //默认为480*360
        self.videoProfile = ._VideoProfile_360P_1
        self.videoProfileSeg?.selectedSegmentIndex = 1
        //默认为全部权限
        self.streamProfile = .streamProfileAll
        self.communicationProfile?.selectedSegmentIndex = 2
        self.roomType = .communicate
    }
    
    @IBAction func autoPub(_ sender: UISwitch) {
        let isButtonOn: Bool = sender.isOn
        if isButtonOn {
            self.isAutoPublish = true
        } else {
            self.isAutoPublish = false
            
        }
    }
    
    @IBAction func autoSub(_ sender: UISwitch) {
        let isButtonOn: Bool = sender.isOn
        if isButtonOn {
            self.isAutoSubscribe = true
        } else {
            self.isAutoSubscribe = false
            
        }
    }
    
    @IBAction func isBug(_ sender: UISwitch) {
        let isButtonOn: Bool = sender.isOn
        if isButtonOn {
            self.isDebug = true
        } else {
            self.isDebug = false
            
        }
    }
    
    @IBAction func isOnlyAudio(_ sender: UISwitch) {
        let isButtonOn: Bool = sender.isOn
        if isButtonOn {
            self.isOnlyAudio = true
        } else {
            self.isOnlyAudio = false
            
        }
    }
    
    //分辨率设置
    @IBAction func selectedProfile(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            
            self.videoProfile = ._VideoProfile_180P
            break
        case 1:
            
            self.videoProfile = ._VideoProfile_360P_1
            break
        case 2:
            
            self.videoProfile = ._VideoProfile_360P_2
            break
        case 3:
            
            self.videoProfile = ._VideoProfile_480P
            break
        case 4:
            
            self.videoProfile = ._VideoProfile_720P
            break
        default:
            
            break
        }
    }
    
    @IBAction func changeRoomType(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            
            self.roomType = .communicate
            self.communicationProfile?.isHidden = false
            self.broadcastProfile?.isHidden = true
            break
        case 1:
            
            self.roomType = .broadcast
            self.communicationProfile?.isHidden = true
            self.broadcastProfile?.isHidden = false
            break
        default:
            
            break
        }
    }
    
    //communication 流权限设置
    @IBAction func selectedLimit(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            
            self.streamProfile = .streamProfileUpload
            break
        case 1:
            
            self.streamProfile = .streamProfileDownload
            break
        case 2:
            
            self.streamProfile = .streamProfileAll
            break
        default:
            
            break
        }
    }
    
    //broadcast 流权限k设置
    @IBAction func broadcastLimit(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            
            self.streamProfile = .streamProfileUpload
            break
        case 1:
            
            self.streamProfile = .streamProfileDownload
            break
        default:
            
            break
        }
    }
    
    @IBAction func save(_ sender: Any) {
        self.dismiss(animated: true, completion: {
            let dictionary:NSDictionary = ["isAutoPublish":self.isAutoPublish!,"isAutoSubscribe":self.isAutoSubscribe!,"isDebug":self.isDebug!,"isOnlyAudio":self.isOnlyAudio!,"videoProfile":self.videoProfile!.rawValue,"streamProfile":self.streamProfile!.rawValue,"roomType":self.roomType!.rawValue]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "doSetting"), object: self, userInfo: dictionary as? [AnyHashable : Any])
        })
    }

}
