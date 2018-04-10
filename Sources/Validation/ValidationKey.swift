/// Represents a key on a `Validatable` model referencing `ValidationData`. This is combined with
/// a `Validtion` to run on that data in `Validations`.
///
///     let key: ValidationKey<User> = User.validationKey(\.name)
///
public struct ValidationKey<M>: Hashable where M: Validatable {
    /// See `Hashable`
    public var hashValue: Int {
        return keyPath.hashValue
    }

    /// See `Equatable`
    public static func ==(lhs: ValidationKey, rhs: ValidationKey) -> Bool {
        return lhs.keyPath == rhs.keyPath
    }

    /// The Swift keypath. Use `get(from:)` to access value from the model.
    private var keyPath: AnyKeyPath

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

    /// Accesses the `ValidationData`.
    ///
    ///     let nameKey: ValidationKey<User> = User.validationKey(\.name)
    ///     let name = try nameKey.get(from: user)
    ///     print(name) // ValidationData
    ///
    /// - parameters:
    ///     - model: `Validatable` model to access the `ValidationData` from.
    public func get(from model: M) throws -> ValidationData {
        return try (model[keyPath: keyPath] as ValidationDataRepresentable).convertToValidationData()
    }
}

extension Validatable {
    /// Create a `ValidationKey` for the supplied `KeyPath` and readable path.
    ///
    ///     let key: ValidationKey<User> = User.validationKey(\.name, at: ["name"])
    ///
    /// - parameters:
    ///     - keyPath: `KeyPath` to validatable property on this model.
    ///     - path: Readable path, will be displayed when showing errors.
    public static func validationKey<T>(_ keyPath: KeyPath<Self, T>, at path: [String]) -> ValidationKey<Self>
        where T: ValidationDataRepresentable
    {
        return ValidationKey(keyPath: keyPath, path: path, type: T.self)
    }
}

extension Validatable where Self: Reflectable {
    /// Create a `ValidationKey` for the supplied `KeyPath`. The readable path will be reflected.
    ///
    ///     let key: ValidationKey<User> = User.validationKey(\.name)
    ///
    /// - parameters:
    ///     - keyPath: `KeyPath` to validatable property on this model.
    public static func validationKey<T>(_ keyPath: KeyPath<Self, T>) throws -> ValidationKey<Self>
        where T: ValidationDataRepresentable
    {
        return try validationKey(keyPath, at: Self.reflectProperty(forKey: keyPath)?.path ?? [])
    }
}
