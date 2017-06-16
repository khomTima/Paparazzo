import ImageIO
import ImageSource
import CoreGraphics
import MobileCoreServices

final class FiltersInteractorImpl: FiltersInteractor {
    let image: ImageSource
    let filters: [Filter]
    var modifiedImage: ImageSource?
    
    init(image: ImageSource, filters: [Filter]) {
        self.image = image
        self.filters = filters
    }
    
    func apply(filter: Filter, completion: @escaping ((_ modifiedImage: ImageSource) -> Void)) {
        let options = ImageRequestOptions(size: .fullResolution, deliveryMode: .best)
        
        image.requestImage(options: options) { [weak self] (result: ImageRequestResult<UIImage>) in
            if let image = result.image {
                DispatchQueue.global(priority: .high).async {
                    filter.apply(image, completion: { filteredImage in
                        
                        let path = (NSTemporaryDirectory() as NSString).appendingPathComponent("\(UUID().uuidString).jpg")
                        let url = URL(fileURLWithPath: path)
                        let destination = CGImageDestinationCreateWithURL(url as CFURL, kUTTypeJPEG, 1, nil)
                        
                        if let destination = destination {
                            guard let cgImage = filteredImage.cgImage else { return }
                            
                            CGImageDestinationAddImage(destination, cgImage, nil)
                            
                            if CGImageDestinationFinalize(destination) {
                                let imageSource = LocalImageSource(path: path, previewImage: cgImage)
                                DispatchQueue.main.async {
                                    self?.modifiedImage = imageSource
                                    completion(imageSource)
                                }
                            }
                        }
                    })
                }
            }
        }
    }
}
