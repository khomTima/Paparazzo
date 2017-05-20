import UIKit
import Paparazzo

final class FilterDummy: Filter {

    var preview: UIImage {
        return UIImage(named: "egorPreview")!
    }
    
    let title = "lol kek chebureck"
    
    public func apply(_ sourceImage: UIImage, completion: @escaping ((UIImage) -> Void)) {
        let stamp = UIImage.init(named: "transparent-stamp")
        let image = sourceImage
        let size = image.size

        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        
        let resultRect = CGRect.init(x: 0, y: 0, width: size.width, height: size.height)
        image.draw(in: resultRect)
        stamp?.draw(in: CGRect.init(x: 0, y: 0, width: size.width, height: size.height).insetBy(dx: size.width * 0.2, dy: size.height * 0.2))
        
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        completion(newImage)
    }
}
