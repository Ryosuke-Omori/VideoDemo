import UIKit
import AVFoundation

class PhotographViewController : UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var AV_MONITOR_SIZE : CGRect!
    
    @IBOutlet weak var recButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    
    var photographView : PhotographView?
    var playerView : PlayerView?
    
    var imagePicker : UIImagePickerController!
    
    var maxX : CGFloat!
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
    
    @IBAction func onClickRecBtn(_ sender: Any) {
        self.photographView = PhotographView(frame: self.AV_MONITOR_SIZE)
        self.view.addSubview(self.photographView!)
    }
    
    @IBAction func onClickPlayBtn(_ sender: Any) {
        self.present(self.imagePicker, animated: true, completion: nil)
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let pickedURL : URL = info[UIImagePickerControllerReferenceURL] as! URL
        self.playerView = PlayerView(url: pickedURL, frame: self.AV_MONITOR_SIZE)
        self.view.addSubview(self.playerView!)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
