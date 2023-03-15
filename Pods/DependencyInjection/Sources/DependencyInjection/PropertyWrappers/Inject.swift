@propertyWrapper
public struct Inject<T> {
    public let wrappedValue: T

    public init() {
        wrappedValue = DIContainer.resolve(T.self)
    }
}
