import Foundation
import Paparazzo

public class LicensePlateDetectionFilter: Filter {
    
    public var preview: UIImage = UIImage(named: "nomer") ?? UIImage()
    
    public var title: String = "Убрать номер"
    
    let deepBeliefBridge = DeepBeliefBridge()
    
    public func apply(_ sourceImage: UIImage, completion: @escaping ((_ resultImage: UIImage) -> Void)){
        
        if !checkIfCarExist(image: sourceImage) {
            completion(sourceImage)
            return
        }
        
        if #available(iOS 9.0, *) {
            let context = CIContext()
            let options = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
            let ciDetector = CIDetector(ofType: CIDetectorTypeText, context: context, options: options)
            
            guard let cgImage = sourceImage.cgImage else {
                completion(sourceImage)
                return
            }
            let ciImage = CIImage(cgImage: cgImage)
            
            let features = ciDetector?.features(in: ciImage)
            let ciImageSize = ciImage.extent.size
            let transform = CGAffineTransform(scaleX: 1, y: -1).translatedBy(x: 0, y: -ciImageSize.height)
            
            UIGraphicsBeginImageContext(sourceImage.size)
            
            sourceImage.draw(at: CGPoint.zero)
            
            features?.forEach { feature in
                
                var plateRect = feature.bounds.applying(transform)
                
                let viewSize = sourceImage.size
                let scale = min(viewSize.width / ciImageSize.width, (viewSize.height / ciImageSize.height))
                let offsetX = (viewSize.width - ciImageSize.width * scale) / 2.0
                let offsetY = (viewSize.height - ciImageSize.height * scale) / 2.0
                
                plateRect = plateRect.applying(CGAffineTransform(scaleX: scale, y: scale))
                plateRect.origin.x += offsetX
                plateRect.origin.y += offsetY
                
                let plateOffset : CGFloat = 40
                plateRect.origin.x -= plateOffset
                plateRect.origin.y -= plateOffset
                plateRect.size.width += plateOffset * 2
                plateRect.size.height += plateOffset * 2
                
                
                let image = sourceImage.cropImage(rect: plateRect)
                if checkIfPlateExist(image: image) {
                    image.applyBlurWithRadius(20, tintColor: UIColor(white: 0.11, alpha: 0.73), saturationDeltaFactor: 1.8)?.draw(in: plateRect)
                }
                
            }
            
            let resultImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            completion(resultImage ?? sourceImage)
        } else {
            completion(sourceImage)
        }
        
    }
    
    func checkIfCarExist(image: UIImage) -> Bool {
        let semaphore = DispatchSemaphore(value: 1)
        let array = [
        "minivan",
        "beach wagon",
        "jeep",
        "pickup",
        "minibus",
        "garbage truck",
        "cab",
        "tractor",
        "harvester",
        "limousine",
        "ambulance",
        "fire engine",
        "steam locomotive",
        "tow truck",
        "car wheel",
        "police van",
        "trailer truck",
        "racer",
        "car mirror",
        "moving van",
        "motor scooter",
        "snowplow",
        "grille"
        ]
        var haveCar = false
        deepBeliefBridge.process(image) { (results: Dictionary) in
            for (key, element) in results {
                if let probability = element as? NSNumber,
                    let name = key as? String {
                    if array.contains(name) && probability.doubleValue > 0.1 {
                        haveCar = true
                    }
                }
            }
            semaphore.signal()
        }
        let timeout = DispatchTime.now() + .seconds(2)
        _ = semaphore.wait(timeout: timeout)
        return haveCar
    }
    
    func checkIfPlateExist(image: UIImage) -> Bool {
        var plateValue : Double = 0
        let semaphore = DispatchSemaphore(value: 1)
        deepBeliefBridge.process(image) { (results: Dictionary) in
            let probabilityValue = results.first(where: { tuple -> Bool in
                return tuple.key.hashValue == -2999369068221942730
            } )?.value
            
            if let probability = probabilityValue as? NSNumber {
                let data = UIImageJPEGRepresentation(image, 0.8)
                let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
                let documentsDirectory = paths[0]
                let filename = documentsDirectory.appendingPathComponent("\(probability).png")
                try? data?.write(to: filename)
                print(probability)
                plateValue = probability.doubleValue
            }
            semaphore.signal()
        }
        let timeout = DispatchTime.now() + .seconds(2)
        _ = semaphore.wait(timeout: timeout)
        print(plateValue)
        return plateValue > 0.003 && plateValue < 0.5
    }
    
}
