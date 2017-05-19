import Foundation

public protocol Filter {
    
    var preview: UIImage { get }
    
    var title: String { get }
    
    func apply(_ sourceImage: UIImage, completion: ((_ resultImage: UIImage) -> Void))
}
