//
//  PlalyerView.swift
//  VideoDemo
//
//  Created by 大森　亮佑 on 2017/03/17.
//  Copyright © 2017年 RyosukeOmori. All rights reserved.
//

import UIKit
import AVFoundation
import CoreMedia

class AVPlayerView : UIView {
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override class var layerClass : AnyClass {
        return AVPlayerLayer.self
    }
}

public class PlayerView : UIView {
    
    let BG_COLOR : UIColor = UIColor.black
    
    var playerURL : URL!
    var playerItem : AVPlayerItem!
    var videoPlayer : AVPlayer!
    
    var footerView : UIView!
    var startButton : UIButton!
    
    var isPlaying : Bool = false
    
    public init(url: URL, frame: CGRect) {
        super.init(frame: frame)
        self.playerURL = url
        
        self.backgroundColor = self.BG_COLOR
        
        self.avInitialization()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func avInitialization() {
        let avAsset = AVURLAsset(url: self.playerURL)
        self.playerItem = AVPlayerItem(asset: avAsset)
        self.videoPlayer = AVPlayer(playerItem: self.playerItem)
        
        let videoPlayerView = AVPlayerView(frame: self.bounds)
        let layer = videoPlayerView.layer as! AVPlayerLayer
        layer.videoGravity = AVLayerVideoGravityResizeAspect
        layer.player = self.videoPlayer
        self.layer.addSublayer(layer)
        
        self.footerInitialization()
    }
    
    private func footerInitialization() {
        // footerView生成
        self.footerView = UIView(frame: CGRect(x: 0, y: self.bounds.height*(4/5), width: self.bounds.width, height: self.bounds.height/5))
        self.footerView.backgroundColor = self.BG_COLOR
        self.footerView.alpha = 0.70
        self.addSubview(footerView)
        
        // startButton生成
        self.startButton = UIButton(frame: CGRect(x: self.bounds.width*0.3, y: 0, width: self.bounds.width*0.4, height: self.footerView.frame.height))
        self.startButton.setTitle("PLAY", for: .normal)
        self.startButton.setTitleColor(UIColor.green, for: .normal)
        self.startButton.addTarget(self, action: #selector(PlayerView.switchBtnMode), for: .touchUpInside)
        self.footerView.addSubview(self.startButton)
        
        // 動画完了イベント取得
        let center = NotificationCenter.default
        center.addObserver(self,
                           selector: #selector(PlayerView.onMovieEnd),
                           name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                           object: nil)
    }
    
    internal func switchBtnMode() {
        if self.isPlaying {         // 一時停止
            self.videoPlayer.pause()
        } else {                    // 開始
            self.videoPlayer.play()
        }
        self.isPlaying = !(self.isPlaying)
        self.startButton.setTitle(!(self.isPlaying) ? "PLAY" : "PAUSE", for: .normal)
        self.startButton.alpha = !(self.isPlaying) ? 0.7 : 0.3
    }
    
    internal func onMovieEnd() {
        self.switchBtnMode()
        self.videoPlayer.seek(to: CMTimeMakeWithSeconds(0, Int32(NSEC_PER_SEC)))
    }
    
}
