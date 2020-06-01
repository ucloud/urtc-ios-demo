//
//  MeetingRoomCell.m
//  UCloudRtcSdkDemo
//
//  Created by tony on 2019/4/28.
//  Copyright © 2019年 ucloud. All rights reserved.
//

protocol MeetingRoomCellDelegate:NSObjectProtocol{
    /**开启或关闭视频*/
    func didMuteStream(stream:UCloudRtcStream,muteVideo:Bool)
    /**开启或关闭音频*/
    func didMuteStream(stream:UCloudRtcStream,muteAudio:Bool)
}

class MeetingRoomCell:UICollectionViewCell {
    
    public var stream : UCloudRtcStream?
    public var delegate : MeetingRoomCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.gray
    }
    
    func configureWithStream(stream:UCloudRtcStream) {
        self.stream = stream
        stream.render(on: self.contentView)
        if (stream.userId != nil) {
            let streamLabel: UILabel = UILabel(frame:CGRect(x:0, y:0, width:self.frame.size.width, height:30))
            streamLabel.textColor = UIColor.white
            streamLabel.textAlignment = .center
            streamLabel.text = String(format: "id: %@", stream.userId)
            self.contentView.addSubview(streamLabel)
            let audioBtn: UIButton = UIButton(frame: CGRect(x:self.frame.size.width-20, y:self.frame.size.height-20, width:20, height:20))
            audioBtn.setImage(UIImage(named: "microphone.png"),for: .normal)
            audioBtn.setImage(UIImage(named: "microphone_close.png"), for: .selected)
            audioBtn.addTarget(self, action: Selector("audioClick:"), for: .touchUpInside)
            self.contentView.addSubview(audioBtn)
            let videoBtn: UIButton = UIButton(frame: CGRect(x:self.frame.size.width-45, y:self.frame.size.height-20, width:20, height:20))
            videoBtn.setImage(UIImage(named: "camera_btn_on.png"), for: .normal)
            videoBtn.setImage(UIImage(named: "camera_btn_off.png"), for: .selected)
            videoBtn.addTarget(self, action: Selector("videoClick:"), for: .touchUpInside)
            self.contentView.addSubview(videoBtn)
        }
    }

    
   @objc func audioClick(_ btn: UIButton) {
        btn.isSelected = !btn.isSelected
        self.delegate?.didMuteStream(stream: self.stream!, muteAudio: btn.isSelected)
    }
    
   @objc func videoClick(_ btn: UIButton) {
        btn.isSelected = !btn.isSelected
        self.delegate?.didMuteStream(stream: self.stream!, muteVideo: btn.isSelected)
    }
    
}

