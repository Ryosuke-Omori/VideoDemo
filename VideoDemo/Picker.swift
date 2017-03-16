//import UIKit
//import AVFoundation
//
//class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
//    
//    var myImagePicker: UIImagePickerController!
//    var myImageView: UIImageView!
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        self.title = "Select a Image"
//        
//        myImageView = UIImageView(frame: self.view.bounds)
//        
//        // インスタンス生成
//        myImagePicker = UIImagePickerController()
//        
//        // デリゲート設定
//        myImagePicker.delegate = self
//        
//        // 画像の取得先はフォトライブラリ
//        myImagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
//        
//        // 画像取得後の編集を不可に
//        myImagePicker.allowsEditing = false
//        
//        myImagePicker.mediaTypes = ["public.movie"]
//    }
//    
//    override func viewDidAppear(_ animated: Bool) {
//        self.present(myImagePicker, animated: true, completion: nil)
//        
//    }
//    
//    /**
//     画像が選択された時に呼ばれる.
//     */
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//        //選択された画像を取得.
//        //        let myURL: URL  = URL(fileURLWithPath: (info[UIImagePickerControllerMediaURL] as! String))
//        let myURL = info[UIImagePickerControllerReferenceURL] as! URL
//        
//        //選択された画像を表示するViewControllerを生成.
//        let playerViewController = PlayerViewController()
//        
//        //選択された画像を表示するViewContorllerにセットする.
//        playerViewController.playerURL = myURL
//        
//        myImagePicker.pushViewController(playerViewController, animated: true)
//    }
//    
//    /**
//     画像選択がキャンセルされた時に呼ばれる.
//     */
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        
//        // モーダルビューを閉じる
//        self.dismiss(animated: true, completion: nil)
//    }
//    
//    
//}
