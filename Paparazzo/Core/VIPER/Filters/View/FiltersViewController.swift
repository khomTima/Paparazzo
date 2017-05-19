import ImageSource
import UIKit

final class FiltersViewController: UIViewController, FiltersViewInput {
    
    private let filtersView = FiltersView()
    
    // MARK: - UIViewController
    
    override func loadView() {
        view = filtersView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        forcePortraitOrientation()
        navigationController?.setNavigationBarHidden(true, animated: animated)
        UIApplication.shared.setStatusBarHidden(true, with: .fade)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    // MARK: - FiltersViewInput
    
    @nonobjc func setTitle(_ title: String) {
        filtersView.setTitle(title)
    }
    
    var onDiscardButtonTap: (() -> ())? {
        get { return filtersView.onDiscardButtonTap }
        set { filtersView.onDiscardButtonTap = newValue }
    }
    
    var onConfirmButtonTap: ((_ previewImage: CGImage?) -> ())? {
        get { return filtersView.onConfirmButtonTap }
        set { filtersView.onConfirmButtonTap = newValue }
    }
    
    func setImage(_ image: ImageSource, previewImage: ImageSource?, completion: @escaping () -> ()) {
        filtersView.setImage(image, previewImage: previewImage, completion: completion)
    }
    
    // MARK: - FiltersViewController
    
    func setTheme(_ theme: FiltersUITheme) {
        filtersView.setTheme(theme)
    }
    
    // MARK: - Dispose bag
    
    private var disposables = [AnyObject]()
    
    func addDisposable(_ object: AnyObject) {
        disposables.append(object)
    }
    
    
    // MARK: - Private
    
    private func forcePortraitOrientation() {        
        let initialDeviceOrientation = UIDevice.current.orientation
        let targetDeviceOrientation = UIDeviceOrientation.portrait
        let targetInterfaceOrientation = UIInterfaceOrientation.portrait
        
        if UIDevice.current.orientation != targetDeviceOrientation {
            
            UIApplication.shared.setStatusBarOrientation(targetInterfaceOrientation, animated: true)
            UIDevice.current.setValue(NSNumber(value: targetInterfaceOrientation.rawValue as Int), forKey: "orientation")
            
            DispatchQueue.main.async {
                UIDevice.current.setValue(NSNumber(value: initialDeviceOrientation.rawValue as Int), forKey: "orientation")
            }
        }
    }

}
