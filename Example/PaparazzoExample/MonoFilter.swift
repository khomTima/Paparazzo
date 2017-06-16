import UIKit

class MonoFilter: CoreImageFilterBase {
    convenience init() {
        self.init(ciFilterName: "CIPhotoEffectMono", preview: UIImage(named: "mono"), title: "Серый")
    }
}
