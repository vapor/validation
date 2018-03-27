import Core

public struct Validations: ExpressibleByDictionaryLiteral {
    /// Store the key and query field.
    internal var storage: [ValidationKey: Validator]

    /// See ExpressibleByDictionaryLiteral
    public init(dictionaryLiteral elements: (ValidationKey, Validator)...) {
        self.storage = [:]
        for (key, validator) in elements {
            storage[key] = validator
        }
    }
}

/// A model property containing the
/// Swift key path for accessing it.
public struct ValidationKey: Hashable {
    /// See `Hashable.hashValue`
    public var hashValue: Int {
        return keyPath.hashValue
    }

    /// See `Equatable.==`
    public static func ==(lhs: ValidationKey, rhs: ValidationKey) -> Bool {
        return lhs.keyPath == rhs.keyPath
    }

    /// The Swift keypath
    public var keyPath: AnyKeyPath

    /// The respective CodingKey path.
    public var path: [String]

    /// The properties type.
    /// Storing this as `Any` since we lost
    /// the type info converting to AnyKeyPAth
    public var type: Any.Type

    /// True if the property on the model is optional.
    /// The `type` is the Wrapped type if this is true.
    public var isOptional: Bool

    /// Create a new model key.
    internal init<T>(keyPath: AnyKeyPath, path: [String], type: T.Type, isOptional: Bool) {
        self.keyPath = keyPath
        self.path = path
        self.type = type
        self.isOptional = isOptional
    }
}

extension Validatable where Self: Reflectable {
    /// Create a validation key for the supplied key path.
    public static func key<T>(_ path: KeyPath<Self, T>) -> ValidationKey where T: ValidationDataRepresentable {
        return try! ValidationKey(
            keyPath: path,
            path: Self.reflectProperty(forKey: path)?.path ?? [],
            type: T.self,
            isOptional: false
        )
    }

    /// Create a validation key for the supplied key path.
    public static func key<T>(_ path: KeyPath<Self, T?>) -> ValidationKey where T: ValidationDataRepresentable {
        return try! ValidationKey(
            keyPath: path,
            path: Self.reflectProperty(forKey: path)?.path ?? [],
            type: T.self,
            isOptional: true
        )
    }
}
