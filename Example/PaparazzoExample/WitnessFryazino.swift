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
        
        let face = haveFace(sourceImage: sourceImage)
        
        let size = sourceImage.size
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        
        let backgroundRect = CGRect.init(x: 0,
                                         y: 0,
                                         width: size.width,
                                         height: size.height)
        sourceImage.draw(in: backgroundRect)
        
        let stampRect : CGRect
        
        if !face.has {
            let ratio = ceil(stamp.size.height / backgroundRect.height)
            let stampSize = CGSize(width: ceil(stamp.size.width/ratio), height: ceil(stamp.size.height/ratio))
            
            let offsetY = (backgroundRect.height - stampSize.height)/2
            let offset = backgroundRect.width / 32
            stampRect = CGRect(
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
        } else {
            
            guard let faceRect = face.rect else {
                completion(sourceImage)
                return
            }
            
            
            let witnessFaceSize =  CGSize(width: 100,
                                          height: 100)
            let faceRate : CGFloat = faceRect.size.height / witnessFaceSize.height
            print(faceRate)
            let stampSize = CGSize(width: ceil(stamp.size.width * faceRate), height: ceil(stamp.size.height * faceRate))
            
            let left : Bool =  faceRect.size.width + faceRect.origin.x < (size.width / 2)
            let bigFace = (size.width / faceRect.size.width) < 4
            var offsetX : CGFloat = 0
            if left {
                offsetX = ceil((faceRect.origin.x + faceRect.size.width) - stampSize.width/2.5)
                if !bigFace {
                    offsetX += ceil(faceRect.size.width * 2)
                } else {
                    offsetX += ceil(faceRect.size.width / 2)
                }
            } else {
                offsetX = ceil(faceRect.origin.x - stampSize.width/1.5)
                if !bigFace {
                    offsetX -= ceil(faceRect.size.width * 2)
                } else {
                    offsetX -= ceil(faceRect.size.width / 2)
                }
            }
            let offsetY = ceil(faceRect.origin.y)
            
            stampRect = CGRect(
                origin:
                CGPoint(
                    x: offsetX,
                    y: offsetY - ceil(faceRect.size.height * 0.2)
                ),
                size:
                CGSize(
                    width: stampSize.width,
                    height: stampSize.height
                )
            )
            
        }
        
        
        stamp.draw(in: stampRect)
        
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        completion(newImage)
    }
    
    func haveFace(sourceImage: UIImage) -> (has: Bool, rect: CGRect?) {
        let context = CIContext()
        let options = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
        let ciDetector = CIDetector(ofType: CIDetectorTypeFace, context: context, options: options)
        
        guard let cgImage = sourceImage.cgImage else {
            return (false, nil)
        }
        let ciImage = CIImage(cgImage: cgImage)
        
        guard let  features = ciDetector?.features(in: ciImage) else {
            return (false, nil)
        }
        
        if features.count != 1 {
            return (false, nil)
        }
        
        let ciImageSize = ciImage.extent.size
        let transform = CGAffineTransform(scaleX: 1, y: -1).translatedBy(x: 0, y: -ciImageSize.height)
        
        var faceRect = CGRect.zero
        
        features.forEach { feature in
            
            faceRect = feature.bounds.applying(transform)
            
            let viewSize = sourceImage.size
            let scale = min(viewSize.width / ciImageSize.width, (viewSize.height / ciImageSize.height))
            let offsetX = (viewSize.width - ciImageSize.width * scale) / 2.0
            let offsetY = (viewSize.height - ciImageSize.height * scale) / 2.0
            
            faceRect = faceRect.applying(CGAffineTransform(scaleX: scale, y: scale))
            faceRect.origin.x += offsetX
            faceRect.origin.y += offsetY
            
            faceRect.size.width += 40
            faceRect.size.height += 140
            faceRect.origin.y -= 80
            faceRect.origin.x -= 20
            
            
            
        }
        
        return (true, faceRect)
        
    }
}
