/// A model property containing the Swift key path for accessing it.
public struct ValidationKey: Hashable {
    /// See `Hashable.hashValue`
    public var hashValue: Int {
        return keyPath.hashValue
    }

    /// See `Equatable`
    public static func ==(lhs: ValidationKey, rhs: ValidationKey) -> Bool {
        return lhs.keyPath == rhs.keyPath
    }

    /// The Swift keypath
    fileprivate var keyPath: AnyKeyPath

    /// Path segments to this key's value.
    public var path: [String]

    /// The property's type. Storing this as `Any` since we lost the type info converting to AnyKeyPAth
    public var type: Any.Type

    /// Create a new `ValidationKey`.
    fileprivate init<T>(keyPath: AnyKeyPath, path: [String], type: T.Type) {
        self.keyPath = keyPath
        self.path = path
        self.type = type
    }
}

extension Validatable {
    /// Accesses the `ValidationDataRepresentable`
    public func getValidationData(at validationKey: ValidationKey) throws -> ValidationData {
        return try (self[keyPath: validationKey.keyPath] as ValidationDataRepresentable).makeValidationData()
    }
}

extension Validatable {
    /// Create a validation key for the supplied key path.
    public static func key<T>(_ keyPath: KeyPath<Self, T>, at path: [String]) -> ValidationKey where T: ValidationDataRepresentable {
        return ValidationKey(keyPath: keyPath, path: path, type: T.self)
    }
}

extension Validatable where Self: Reflectable {
    /// Create a validation key for the supplied key path.
    public static func key<T>(_ keyPath: KeyPath<Self, T>) -> ValidationKey where T: ValidationDataRepresentable {
        return try! self.key(keyPath, at: Self.reflectProperty(forKey: keyPath)?.path ?? [])
    }
}
