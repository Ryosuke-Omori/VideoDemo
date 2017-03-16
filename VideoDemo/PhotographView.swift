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

public class PhotographView : UIView, AVCaptureFileOutputRecordingDelegate {
    
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var uploadButton: UIButton!
    
    var isRecording : Bool = false
    
    var fileOutput : AVCaptureMovieFileOutput?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.loadNib()
        
        self.avInitialization()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.loadNib()
    }
    
    private func loadNib() {
        let view = Bundle.main.loadNibNamed("PhotographView", owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        self.addSubview(view)
    }
    
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
    
    @IBAction func onClickRecordBtn(_ sender: Any) {
        if self.isRecording {   // 録画終了
            self.fileOutput?.stopRecording()
            self.isRecording = !(self.isRecording)
        } else {                // 録画開始
            let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
            let documentDirectory = paths[0] as String
            let filePath : String? = "\(documentDirectory)/temp.mp4"
            let fileURL : NSURL = NSURL(fileURLWithPath: filePath!)
            self.fileOutput?.startRecording(toOutputFileURL: fileURL as URL!, recordingDelegate: self)
            self.isRecording = !(self.isRecording)
        }
        self.recordButton.setTitle(!(self.isRecording) ? "RECORD" : "STOP", for: UIControlState.normal)
    }
    
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
