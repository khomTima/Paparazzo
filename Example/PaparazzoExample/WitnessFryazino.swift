import Foundation
import Paparazzo

class WitnessFryazino: Filter {
    public var preview: UIImage = UIImage(named: "svidetel")!
    
    public var title: String = "Свидетель"
    
    public func apply(_ sourceImage: UIImage, completion: @escaping ((_ resultImage: UIImage) -> Void)){
        guard let stamp = UIImage.init(named: "witness") else {
            completion(sourceImage)
            return
        }
        
        
        let size = sourceImage.size
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        
        let backgroundRect = CGRect.init(x: 0,
                                         y: 0,
                                         width: size.width,
                                         height: size.height)
        sourceImage.draw(in: backgroundRect)
        
        let ratio = ceil(stamp.size.height / backgroundRect.height)
        let stampSize = CGSize(width: ceil(stamp.size.width/ratio), height: ceil(stamp.size.height/ratio))
        
        let offsetY = (backgroundRect.height - stampSize.height)/2
        let offset = backgroundRect.width / 32
        let stampRect = CGRect(
            origin:
            CGPoint(
                x: backgroundRect.width - stampSize.width - offset,
                y: backgroundRect.height - stampSize.height - offsetY
            ),
            size:
            CGSize(
                width: stampSize.width,
                height: stampSize.height
            )
        )
        stamp.draw(in: stampRect)
        
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        completion(newImage)
    }
}
