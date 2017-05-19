import ImageSource

final class FiltersInteractorImpl: FiltersInteractor {
    private let originalImage: ImageSource
    private let filters: [Filter]?
    
    init(image: ImageSource, filters: [Filter]?) {
        self.originalImage = image
        self.filters = filters
    }
}
