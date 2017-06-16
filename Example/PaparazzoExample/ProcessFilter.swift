import UIKit

class ProcessFilter: CoreImageFilterBase {
    convenience init() {
        self.init(ciFilterName: "CIPhotoEffectProcess", preview: UIImage(named: "izumrud"), title: "Изумруд")
    }
}
