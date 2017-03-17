//
//  PhotographView.swift
//  VideoDemo
//
//  Created by 大森　亮佑 on 2017/03/17.
//  Copyright © 2017年 RyosukeOmori. All rights reserved.
//

import UIKit
import AVFoundation
import Photos


/// 動画の撮影、フォトライブラリへの保存を行うUIViewクラス
public class PhotographView : UIView, AVCaptureFileOutputRecordingDelegate {
    
    /// 撮影時のプレビュー
    @IBOutlet weak var previewView: UIView!
    /// 動画の撮影ボタン
    @IBOutlet weak var recordButton: UIButton!
    
    /// 撮影中かどうかの真偽値
    var isRecording : Bool = false
    
    /// 撮影した動画データのWriterクラス
    var fileOutput : AVCaptureMovieFileOutput?
    
    /// コンストラクタ
    ///
    /// - Parameter frame: 位置、サイズ(CGRect)
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.loadNib()
        
        self.avInitialization()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.loadNib()
    }
    
    /// xibファイルとの紐付け
    private func loadNib() {
        let view = Bundle.main.loadNibNamed("PhotographView", owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        self.addSubview(view)
    }
    
    /// 動画機能の初期設定
    private func avInitialization() {
        // セッション
        let captureSession = AVCaptureSession()
        
        // 入力（前面カメラ）
        guard let videoDevice = AVCaptureDevice.defaultDevice(
            withDeviceType: .builtInWideAngleCamera,
            mediaType: AVMediaTypeVideo,
            position: .front)
            else { fatalError("no front camera. but don't all iOS 10 devices have them?")}
        let videoInput = try! AVCaptureDeviceInput.init(device: videoDevice)
        captureSession.addInput(videoInput)
        // 入力（マイク）
        let audioDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeAudio)
        let audioInput = try! AVCaptureDeviceInput.init(device: audioDevice)
        captureSession.addInput(audioInput);
        // 出力（動画ファイル）
        self.fileOutput = AVCaptureMovieFileOutput()
        captureSession.addOutput(fileOutput)
        
        // プレビュー
        self.previewView.bounds = self.bounds
        if let videoLayer = AVCaptureVideoPreviewLayer.init(session: captureSession) {
            videoLayer.frame = self.previewView.bounds
            videoLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
            self.previewView.layer.addSublayer(videoLayer)
        }
        
        // セッションの開始
        DispatchQueue.global(qos: .userInitiated).async {
            captureSession.startRunning()
        }
    }
    
    /// recordButton押下時イベント
    ///
    /// - Parameter sender: (UIButton)
    @IBAction func onClickRecordBtn(_ sender: Any) {
        if self.isRecording {   // 録画終了
            self.fileOutput?.stopRecording()
        } else {                // 録画開始
            // 動画保存先Pathの取得
            let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
            let documentDirectory = paths[0] as String
            let filePath : String? = "\(documentDirectory)/temp.mp4"
            let fileURL : NSURL = NSURL(fileURLWithPath: filePath!)
            //撮影開始
            self.fileOutput?.startRecording(toOutputFileURL: fileURL as URL!, recordingDelegate: self)
        }
        self.isRecording = !(self.isRecording)
        // recordButtonのラベルを変更
        self.recordButton.setTitle(!(self.isRecording) ? "RECORD" : "STOP", for: UIControlState.normal)
    }
    
    // 動画の撮影が終了された時に呼ばれるAVCaptureFileOutputRecordingDelegateメソッド
    public func capture(_ captureOutput: AVCaptureFileOutput!, didFinishRecordingToOutputFileAt outputFileURL: URL!, fromConnections connections: [Any]!, error: Error!) {
        // ライブラリへの保存
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: outputFileURL)
        }) { completed, error in
            if completed {
                print("Video is saved!")
            }
        }
    }
    
}
