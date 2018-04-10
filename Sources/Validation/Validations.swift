/// Holds zero or more validations for a `Validatable` model.
public struct Validations<M>: ExpressibleByDictionaryLiteral, Sequence where M: Validatable {
    /// Internal storage.
    internal var storage: [ValidationKey<M>: Validation]

    /// Create an empty `Validations` struct. You can also use an empty dictionary `[:]`.
    public init(_ model: M.Type) {
        self.storage = [:]
    }

    /// See `ExpressibleByDictionaryLiteral`.
    public init(dictionaryLiteral elements: (ValidationKey<M>, Validation)...) {
        self.storage = [:]
        for (key, validator) in elements {
            storage[key] = validator
        }
    }

    /// Adds a new `Validation` to at the supplied key path and readable path.
    ///
    ///     try validations.add(\.name, at: ["name"], .count(5...) && .alphanumeric)
    ///
    /// - parameters:
    ///     - keyPath: `KeyPath` to validatable property.
    ///     - path: Readable path. Will be displayed when showing errors.
    ///     - validation: `Validation` to run on this property.
    public mutating func add<T>(_ keyPath: KeyPath<M, T>, at path: [String], _ validation: Validation)
        where T: ValidationDataRepresentable
    {
        storage[M.validationKey(keyPath, at: path)] = validation
    }

    /// See `Sequence`.
    public func makeIterator() -> Dictionary<ValidationKey<M>, Validation>.Iterator {
        return storage.makeIterator()
    }
}

extension Validations where M: Reflectable {
    /// Adds a new `Validation` to at the supplied key path. Readable path will be reflected.
    ///
    ///     try validations.add(\.name, .count(5...) && .alphanumeric)
    ///
    /// - parameters:
    ///     - keyPath: `KeyPath` to validatable property.
    ///     - validation: `Validation` to run on this property.
    public mutating func add<T>(_ keyPath: KeyPath<M, T>, _ validation: Validation) throws
        where T: ValidationDataRepresentable
    {
        try storage[M.validationKey(keyPath)] = validation
    }
}
