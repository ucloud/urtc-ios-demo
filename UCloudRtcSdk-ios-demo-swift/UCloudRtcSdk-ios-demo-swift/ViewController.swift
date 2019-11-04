//
//  ViewController.swift
//  UCloudRtcSdk-ios-demo-swift
//
//  Created by Tony on 2019/10/12.
//  Copyright © 2019 Tony. All rights reserved.
//

import UIKit
import UCloudRtcSdk_ios

class ViewController: UIViewController {
    
    var engineSetting: NSDictionary?
    @IBOutlet weak var userTextField: UITextField?
    @IBOutlet weak var segment: UISegmentedControl?
    @IBOutlet weak var userLabel: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.engineSetting = NSDictionary()  as NSDictionary
        self.navigationController?.isNavigationBarHidden = true
        self.userTextField?.attributedPlaceholder = NSAttributedString(string: "请输入房间号", attributes: [NSAttributedString.Key.foregroundColor:UIColor(white: 1, alpha: 0.4)])
        self.userLabel?.text = self.getUserId()
        NotificationCenter.default.addObserver(self, selector: #selector(doSetting), name: NSNotification.Name(rawValue:"doSetting"), object: nil)
    }
    
    @objc func doSetting(_ noti: NSNotification) {
        let dic = noti.userInfo
        self.engineSetting = dic  as NSDictionary?
    }
    
    //随机生成h用户ID
    func getUserId() -> String {
        let userId: String = "\(arc4random()%1000)"
        return userId
    }
    
    //加入房间
    func didEnterRoomWithUserId(){
        OperationQueue.main.addOperation({
            self.performSegue(withIdentifier: "gotoMeetingRoom", sender: nil)
        })
    }
    
    
    @IBAction func didLoginAction(_ sender: Any) {
        let roomName: String = (self.userTextField?.text!)!
        if roomName.isEmpty {
            CBToast.showToastAction(message: "请输入房间号")
            return
        }else{
            //点击加入房间
            self.didEnterRoomWithUserId()
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: (Any)?) {
        if segue.identifier == "gotoMeetingRoom" {
            let meeting = segue.destination as! MeetingRoomViewController
            meeting.userId = self.userLabel?.text as NSString?
            meeting.roomId = self.userTextField?.text as NSString?
            meeting.appId = "URtc-h4r1txxy"
            meeting.appKey = "9129304dbf8c5c4bf68d70824462409f"
            meeting.token = ""
            meeting.engineSetting = self.engineSetting!
            if self.segment!.selectedSegmentIndex == 0 {
                meeting.engineMode = .trival
            } else {
                meeting.engineMode = .normal
                
            }
        }
    }
    
}

