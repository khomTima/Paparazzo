import ImageSource

final class FiltersInteractorImpl: FiltersInteractor {
    let image: ImageSource
    let filters: [Filter]
    
    init(image: ImageSource, filters: [Filter]) {
        self.image = image
        self.filters = filters
    }
}
