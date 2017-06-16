import UIKit

class SepiaFilter: CoreImageFilterBase {
    convenience init() {
        self.init(ciFilterName: "CISepiaTone", preview: UIImage(named: "sepia"), title: "Сепия")
    }
}
