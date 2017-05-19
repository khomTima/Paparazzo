import UIKit

final class FilterDummy: Filter {
    let preview = UIImage(named: "")
    
    let title = "lol kek chebureck"
    
    func apply(_ sourceImage: UIImage, completion: ((_ resultImage: UIImage) -> Void)) {
        completion(sourceImage)
    }
}
