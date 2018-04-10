/// Holds zero or more validations for a `Validatable` model.
///
/// Validations are simply `Validator`s where the validatable data is `M`.
public struct Validations<M>: ExpressibleByArrayLiteral, Sequence, CustomStringConvertible where M: Validatable {
    /// Internal storage.
    internal var storage: [Validator<M>]

    /// See `CustomStringConvertible`.
    public var description: String {
        return storage.map { $0.description }.joined(separator: "\n")
    }

    /// Create an empty `Validations` struct. You can also use an empty dictionary `[:]`.
    public init(_ model: M.Type) {
        self.storage = []
    }

    /// See `ExpressibleByDictionaryLiteral`.
    public init(arrayLiteral elements: Validator<M>...) {
        self.storage = elements
    }

    /// Adds a new `Validation` to at the supplied key path and readable path.
    ///
    ///     try validations.add(\.name, at: ["name"], .range(5...) && .alphanumeric)
    ///
    /// - parameters:
    ///     - keyPath: `KeyPath` to validatable property.
    ///     - path: Readable path. Will be displayed when showing errors.
    ///     - validation: `Validation` to run on this property.
    public mutating func add<T>(_ keyPath: KeyPath<M, T>, at path: [String], _ validator: Validator<T>) {
        add(keyPath, at: path, "is " + validator.readable, { value in
            try validator.validate(value)
        })
    }

    /// Adds a custom `Validation` to at the supplied key path and readable path.
    ///
    ///     try validations.add(\.name, at: ["name"], "is vapor") { name in
    ///         guard name == "vapor" else { throw }
    ///     }
    ///
    /// - parameters:
    ///     - keyPath: `KeyPath` to validatable property.
    ///     - path: Readable path. Will be displayed when showing errors.
    ///     - readable: Readable string describing this validation.
    ///     - custom: Closure accepting the `KeyPath`'s value.
    ///               Throw a `ValidationError` here if the data is invalid.
    public mutating func add<T>(_ keyPath: KeyPath<M, T>, at path: [String], _ readable: String, _ custom: @escaping (T) throws -> Void) {
        add("\(path.joined(separator: ".")): \(readable)") { model in
            do {
                try custom(model[keyPath: keyPath])
            } catch var error as ValidationError {
                error.path += path
                throw error
            }
        }
    }

    /// Adds a completely custom `Validation` to the `Validations`.
    ///
    ///     try validations.add("name is vapor") { model in
    ///         guard model.name == "vapor" else { throw }
    ///     }
    ///
    /// - parameters:
    ///     - readable: Readable string describing this validation.
    ///     - custom: Closure accepting the model.  Throw a `ValidationError` here if the model is invalid.
    public mutating func add(_ readable: String, _ custom: @escaping (M) throws -> Void) {
        let modelValidator: Validator<M> = .init(readable) { model in
            try custom(model)
        }
        add(modelValidator)
    }

    /// Adds a new `Validation`.
    public mutating func add(_ validation: Validator<M>) {
        self.storage.append(validation)
    }

    /// See `Sequence`.
    public func makeIterator() -> Array<Validator<M>>.Iterator {
        return storage.makeIterator()
    }
}

extension Validations where M: Reflectable {
    /// Adds a new `Validation` to at the supplied key path. Readable path will be reflected.
    ///
    ///     try validations.add(\.name, .range(5...) && .alphanumeric)
    ///
    /// - parameters:
    ///     - keyPath: `KeyPath` to validatable property.
    ///     - validation: `Validation` to run on this property.
    public mutating func add<T>(_ keyPath: KeyPath<M, T>, _ validator: Validator<T>) throws {
        try add(keyPath, at: M.reflectProperty(forKey: keyPath)?.path ?? [], validator)
    }


    /// Adds a new custom `Validation` to at the supplied key path. Readable path will be reflected.
    ///
    ///     try validations.add(\.name, "is vapor") { name in
    ///         guard name == "vapor" else { throw }
    ///     }
    ///
    /// - parameters:
    ///     - keyPath: `KeyPath` to validatable property.
    ///     - readable: Readable string describing this validation.
    ///     - custom: Closure accepting the `KeyPath`'s value.
    ///               Throw a `ValidationError` here if the data is invalid.
    public mutating func add<T>(_ keyPath: KeyPath<M, T>, _ readable: String, _ custom: @escaping (T) throws -> Void) throws {
        try add(keyPath, at: M.reflectProperty(forKey: keyPath)?.path ?? [], readable, custom)
    }
}
