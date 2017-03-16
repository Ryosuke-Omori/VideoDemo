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
    
    @IBOutlet weak var startButton: UIButton!
    
    var playerURL : URL!
    
    var playerItem : AVPlayerItem!
    
    var videoPlayer : AVPlayer!
    
    public init(url: URL, frame: CGRect) {
        super.init(frame: frame)
        self.playerURL = url
        self.loadNib()
        
        self.avInitialization()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.loadNib()
    }
    
    private func loadNib() {
        let view = Bundle.main.loadNibNamed("PlayerView", owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        self.addSubview(view)
    }
    
    private func avInitialization() {
        let avAsset = AVURLAsset(url: self.playerURL)
        self.playerItem = AVPlayerItem(asset: avAsset)
        self.videoPlayer = AVPlayer(playerItem: self.playerItem)
        
        let videoPlayerView = AVPlayerView(frame: self.bounds)
        let layer = videoPlayerView.layer as! AVPlayerLayer
        layer.videoGravity = AVLayerVideoGravityResizeAspect
        layer.player = self.videoPlayer
        self.layer.insertSublayer(layer, above: self.startButton.layer)
        
//        self.layer.insertSublayer(self.startButton.layer, at: 1)
    }
    
}
