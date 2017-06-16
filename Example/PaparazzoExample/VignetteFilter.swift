import Foundation
import Paparazzo

class VignetteFilter: Filter {
    public var preview: UIImage = UIImage(named: "vinetka") ?? UIImage()
    
    public var title: String = "Виньетка"

    public func apply(_ sourceImage: UIImage, completion: @escaping ((_ resultImage: UIImage) -> Void)){
        let context = CIContext(options: nil)
        
        if let currentFilter = CIFilter(name: "CIVignette") {
            let beginImage = CIImage(image: sourceImage)
            currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
            currentFilter.setValue(1.0, forKey: kCIInputIntensityKey)
            
            if let output = currentFilter.outputImage {
                if let cgimg = context.createCGImage(output, from: output.extent) {
                    let processedImage = UIImage(cgImage: cgimg)
                    completion(processedImage)
                    return
                }
            }
        }
        completion(sourceImage)
    }
}
