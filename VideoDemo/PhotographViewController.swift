import UIKit
import AVFoundation


/// PhotographViewとPlayerViewのデモ用VC
class PhotographViewController : UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    /// PhotographViewとPlayerViewのサイズ
    var AV_MONITOR_SIZE : CGRect!
    
    /// PhotographView起動スイッチ
    @IBOutlet weak var recButton: UIButton!
    /// PlayerView起動スイッチ
    @IBOutlet weak var playButton: UIButton!
    
    /// PhotographViewオブジェクト
    var photographView : PhotographView?
    /// PlayerViewオブジェクト
    var playerView : PlayerView?
    
    /// PlayerViewで再生する動画データを取得するためのUIImagePickerControllerオブジェクト
    var imagePicker : UIImagePickerController!
    
    /// 自身の横幅
    var maxX : CGFloat!
    /// 自身の縦幅
    var maxY : CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ViewSize取得
        self.maxX = self.view.layer.frame.size.width
        self.maxY = self.view.layer.frame.size.height
        
        self.AV_MONITOR_SIZE = CGRect(x: 0, y: self.maxY/2, width: self.maxX, height: self.maxY/2)
        
        // ImagePickerControllerの生成
        self.imagePicker = UIImagePickerController()
        self.imagePicker.delegate = self
        self.imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.imagePicker.allowsEditing = false
        self.imagePicker.mediaTypes = ["public.movie"]
        
    }
    
    /// recButton押下時イベント
    ///
    /// - Parameter sender: (UIButton)
    @IBAction func onClickRecBtn(_ sender: Any) {
        // AVViewをクリア
        self.clearAvVIew()
        
        // PhotographView生成
        self.photographView = PhotographView(frame: self.AV_MONITOR_SIZE)
        self.view.addSubview(self.photographView!)
    }
    
    /// playButton押下時イベント
    ///
    /// - Parameter sender: (UIButton)
    @IBAction func onClickPlayBtn(_ sender: Any) {
        // ImagePickerControllerを立ち上げる
        self.present(self.imagePicker, animated: true, completion: nil)
    }
    
    /// PhotographViewとPlayerViewのクリア
    private func clearAvVIew() {
        // PlayerViewがあったら削除
        self.playerView?.removeFromSuperview()
        self.playerView = nil
        
        // PhotographViewがあったら削除
        self.photographView?.removeFromSuperview()
        self.photographView = nil
    }
    
    
    // ImagePickerController内でアイテムを選択した際に呼ばれるUIImagePickerControllerDelegateメソッド
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // 選択したアイテムのURLを取得
        let pickedURL : URL = info[UIImagePickerControllerReferenceURL] as! URL
        
        // AVViewをクリア
        self.clearAvVIew()
        
        // PlayerView生成
        self.playerView = PlayerView(url: pickedURL, frame: self.AV_MONITOR_SIZE)
        self.view.addSubview(self.playerView!)
        
        // ImagePickerControllerを閉じる
        self.dismiss(animated: true, completion: nil)
    }
    
    // ImagePickerController内でキャンセルが押下された際に呼ばれるUIImagePickerControllerDelegateメソッド
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // ImagePickerControllerを閉じる
        self.dismiss(animated: true, completion: nil)
    }
}
