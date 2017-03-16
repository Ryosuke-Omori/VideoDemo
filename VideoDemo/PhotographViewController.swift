import UIKit

class PhotographViewController : UIViewController {
    
    var maxX : CGFloat!
    var maxY : CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.maxX = self.view.layer.frame.size.width
        self.maxY = self.view.layer.frame.size.height
        
        let photographView : PhotographView = PhotographView(frame: CGRect(x: 0, y: self.maxY/2, width: self.maxX, height: self.maxY/2))
        self.view.addSubview(photographView)
        
    }
    
}
