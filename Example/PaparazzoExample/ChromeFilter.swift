import UIKit

class ChromeFilter: CoreImageFilterBase {
    convenience init() {
        self.init(ciFilterName: "CIPhotoEffectChrome", preview: UIImage(named: "chrome"), title: "Хром")
    }
}
