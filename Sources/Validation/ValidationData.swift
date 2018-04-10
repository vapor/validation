///// Data types supported by the `Validation` package.
//public struct ValidationData {
//    /// Supported validation data.
//    internal enum Storage {
//        case bool(Bool)
//        case string(String)
//        case int(Int)
//        case double(Double)
//        case data(Data)
//        case date(Date)
//        case array([ValidationData])
//        case dictionary([String: ValidationData])
//        case null
//    }
//
//    // MARK: Static
//
//    /// Creates `ValidationData` from a `Bool`.
//    public static func bool(_ value: Bool) -> ValidationData {
//        return .init(.bool(value))
//    }
//
//    /// Creates `ValidationData` from a `String`.
//    public static func string(_ value: String) -> ValidationData {
//        return .init(.string(value))
//    }
//
//    /// Creates `ValidationData` from an `Int`.
//    public static func int(_ value: Int) -> ValidationData {
//        return .init(.int(value))
//    }
//
//    /// Creates `ValidationData` from a `Double`.
//    public static func double(_ value: Double) -> ValidationData {
//        return .init(.double(value))
//    }
//
//    /// Creates `ValidationData` from `Data`.
//    public static func data(_ value: Data) -> ValidationData {
//        return .init(.data(value))
//    }
//
//    /// Creates `ValidationData` from a `Date`.
//    public static func date(_ value: Date) -> ValidationData {
//        return .init(.date(value))
//    }
//
//    /// Creates `ValidationData` from a `[ValidationData]`.
//    public static func array(_ value: [ValidationData]) -> ValidationData {
//        return .init(.array(value))
//    }
//    
//    /// Creates `ValidationData` from a `[String: ValidationData]`.
//    public static func dictionary(_ value: [String: ValidationData]) -> ValidationData {
//        return .init(.dictionary(value))
//    }
//
//    /// Creates null `ValidationData`.
//    public static var null: ValidationData {
//        return .init(.null)
//    }
//
//    /// Internal storage.
//    internal var storage: Storage
//
//    /// Creates a new `ValidationData` from `Storage`.
//    internal init(_ storage: Storage) {
//        self.storage = storage
//    }
//
//    // MARK: Instance
//
//    /// Returns a `Bool` if this `ValidationData` contains one.
//    public var bool: Bool? {
//        switch storage {
//        case .bool(let value): return value
//        default: return nil
//        }
//    }
//
//    /// Returns a `String` if this `ValidationData` contains one.
//    public var string: String? {
//        switch storage {
//        case .string(let value): return value
//        default: return nil
//        }
//    }
//
//    /// Returns an `Int` if this `ValidationData` contains one.
//    public var int: Int? {
//        switch storage {
//        case .int(let value): return value
//        default: return nil
//        }
//    }
//
//    /// Returns a `Double` if this `ValidationData` contains one.
//    public var double: Double? {
//        switch storage {
//        case .double(let value): return value
//        default: return nil
//        }
//    }
//
//    /// Returns a `Data` if this `ValidationData` contains one.
//    public var data: Data? {
//        switch storage {
//        case .data(let value): return value
//        default: return nil
//        }
//    }
//
//    /// Returns a `Date` if this `ValidationData` contains one.
//    public var date: Date? {
//        switch storage {
//        case .date(let value): return value
//        default: return nil
//        }
//    }
//
//    /// Returns a `[ValidationData]` if this `ValidationData` contains one.
//    public var array: [ValidationData]? {
//        switch storage {
//        case .array(let value): return value
//        default: return nil
//        }
//    }
//
//    /// Returns a `[String: ValidationData]` if this `ValidationData` contains one.
//    public var dictionary: [String: ValidationData]? {
//        switch storage {
//        case .dictionary(let value): return value
//        default: return nil
//        }
//    }
//
//    /// Returns `true` if this `ValidationData` is null.
//    public var isNull: Bool {
//        switch storage {
//        case .null: return true
//        default: return false
//        }
//    }
//
//
//}
//
//
///// Capable of being represented by `ValidationData`.
///// Custom types you want to validate must conform to this protocol.
//public protocol ValidationDataRepresentable {
//    /// Converts to validation data
//    func convertToValidationData() throws -> ValidationData
//}
//
//extension Bool: ValidationDataRepresentable {
//    /// See `ValidationDataRepresentable`
//    public func convertToValidationData() -> ValidationData {
//        return .bool(self)
//    }
//}
//
//extension String: ValidationDataRepresentable {
//    /// See `ValidationDataRepresentable`
//    public func convertToValidationData() -> ValidationData {
//        return .string(self)
//    }
//}
//
//
//extension FixedWidthInteger {
//    /// See `ValidationDataRepresentable`
//    public func convertToValidationData() throws -> ValidationData {
//        guard self > Int.min && self < Int.max else {
//            throw BasicValidationError("`\(Self.self)` value \(self) cannot be represented as an `Int`.")
//        }
//        return .int(numericCast(self))
//    }
//}
//
//extension Int: ValidationDataRepresentable { }
//extension Int8: ValidationDataRepresentable { }
//extension Int16: ValidationDataRepresentable { }
//extension Int32: ValidationDataRepresentable { }
//extension Int64: ValidationDataRepresentable { }
//extension UInt: ValidationDataRepresentable { }
//extension UInt8: ValidationDataRepresentable { }
//extension UInt16: ValidationDataRepresentable { }
//extension UInt32: ValidationDataRepresentable { }
//extension UInt64: ValidationDataRepresentable { }
//
//extension Double: ValidationDataRepresentable {
//    /// See `ValidationDataRepresentable`
//    public func convertToValidationData() -> ValidationData {
//        return .double(self)
//    }
//}
//
//extension Data: ValidationDataRepresentable {
//    /// See `ValidationDataRepresentable`
//    public func convertToValidationData() -> ValidationData {
//        return .data(self)
//    }
//}
//
//extension Date: ValidationDataRepresentable {
//    /// See `ValidationDataRepresentable`
//    public func convertToValidationData() -> ValidationData {
//        return .date(self)
//    }
//}
//
//extension Array: ValidationDataRepresentable {
//    /// See `ValidationDataRepresentable`
//    public func convertToValidationData() throws -> ValidationData {
//        var items: [ValidationData] = []
//        for el in self {
//            // FIXME: conditional conformance
//            guard let data = el as? ValidationDataRepresentable else {
//                throw BasicValidationError("`\(Element.self)` is not `ValidationDataRepresentable`.")
//            }
//            try items.append(data.convertToValidationData())
//        }
//        return .array(items)
//    }
//}
//
//extension Dictionary: ValidationDataRepresentable {
//    /// See `ValidationDataRepresentable`
//    public func convertToValidationData() throws  -> ValidationData {
//        var items: [String: ValidationData] = [:]
//        for (key, el) in self {
//            // FIXME: conditional conformance
//            guard let data = el as? ValidationDataRepresentable else {
//                throw BasicValidationError("`\(Value.self)` is not `ValidationDataRepresentable`.")
//            }
//            guard let st = key as? String else {
//                throw BasicValidationError("`\(Key.self)` is not `String`.")
//            }
//
//            items[st] = try data.convertToValidationData()
//        }
//        return .dictionary(items)
//    }
//}
//
//extension Optional: ValidationDataRepresentable {
//    /// See `ValidationDataRepresentable`
//    public func convertToValidationData() throws -> ValidationData {
//        switch self {
//        case .none: return .null
//        case .some(let s):
//            // FIXME: conditional conformance
//            guard let data = s as? ValidationDataRepresentable else {
//                throw BasicValidationError("`\(Wrapped.self)` is not `ValidationDataRepresentable`.")
//            }
//            return try data.convertToValidationData()
//        }
//    }
//}
