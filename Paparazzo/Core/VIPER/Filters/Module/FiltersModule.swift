import ImageSource

public protocol FiltersModule: class {
    var onDiscard: (() -> ())? { get set }
    var onConfirm: ((ImageSource) -> ())? { get set }
}
