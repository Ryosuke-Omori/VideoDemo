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


/// LayerをAVPlayerLayerに変換するためのラッパークラス
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


/// 渡された動画データPathを元に動画の再生をするUIViewクラス
public class PlayerView : UIView {
    
    /// バックグラウンドカラー
    let BG_COLOR : UIColor = UIColor.black
    
    /// 呼び出し元から渡される動画データPath
    var playerURL : URL!
    /// 動画の状態を管理するオブジェクト
    var videoPlayer : AVPlayer!
    
    /// 操作ボタン群のラッパービュー
    var footerView : UIView!
    /// 再生、停止ボタン
    var startButton : UIButton!
    /// リセットボタン
    var resetButton : UIButton!
    
    /// 再生中かどうかの真偽値
    var isPlaying : Bool = false
    
    /// コンストラクタ
    ///
    /// - Parameters:
    ///   - url: 再生したい動画データPath(URL)
    ///   - frame: 位置、サイズ(CGRect)
    public init(url: URL, frame: CGRect) {
        super.init(frame: frame)
        self.playerURL = url
        
        self.backgroundColor = self.BG_COLOR
        
        self.avInitialization()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /// 動画機能の初期設定
    private func avInitialization() {
        let avAsset = AVURLAsset(url: self.playerURL)
        let playerItem = AVPlayerItem(asset: avAsset)
        self.videoPlayer = AVPlayer(playerItem: playerItem)
        
        let videoPlayerView = AVPlayerView(frame: self.bounds)
        let layer = videoPlayerView.layer as! AVPlayerLayer
        layer.videoGravity = AVLayerVideoGravityResizeAspect
        layer.player = self.videoPlayer
        self.layer.addSublayer(layer)
        
        self.footerInitialization()
    }
    
    /// フッタービュー、ボタン群の初期設定
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
        
        // resetButton生成
        self.resetButton = UIButton(frame: CGRect(x: 0, y: 0, width: self.bounds.width*0.3, height: self.footerView.frame.height))
        self.resetButton.setTitle("RESET", for: .normal)
        self.resetButton.setTitleColor(UIColor.red, for: .normal)
        self.resetButton.addTarget(self, action: #selector(PlayerView.onMovieEnd), for: .touchUpInside)
        self.footerView.addSubview(self.resetButton)
    }
    
    /// startButton押下時イベント
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
    
    /// 動画完了時イベント
    internal func onMovieEnd() {
        self.switchBtnMode()
        self.videoPlayer.seek(to: CMTimeMakeWithSeconds(0, Int32(NSEC_PER_SEC)))
    }
    
}
