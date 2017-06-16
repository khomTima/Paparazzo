import UIKit

class InstantFilter: CoreImageFilterBase {
    convenience init() {
        self.init(ciFilterName: "CIPhotoEffectInstant", preview: UIImage(named: "vanil"), title: "Ваниль")
    }
}
