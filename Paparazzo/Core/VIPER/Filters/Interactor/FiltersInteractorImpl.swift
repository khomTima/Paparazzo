import ImageSource

final class FiltersInteractorImpl: FiltersInteractor {
    private let originalImage: ImageSource
    
    init(image: ImageSource) {
        self.originalImage = image
    }
}
