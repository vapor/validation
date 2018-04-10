public struct Validations: ExpressibleByDictionaryLiteral {
    /// Internal storage.
    internal var storage: [ValidationKey: Validator]

    /// See `ExpressibleByDictionaryLiteral`.
    public init(dictionaryLiteral elements: (ValidationKey, Validator)...) {
        self.storage = [:]
        for (key, validator) in elements {
            storage[key] = validator
        }
    }
}
