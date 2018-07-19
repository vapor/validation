//
//  EmptyValidator.swift
//  Validation
//
//  Created by Frédéric Ruaudel on 19/07/2018.
//

import Foundation

extension Validator where T: Collection {
    public static var empty: Validator<T> {
        return EmptyValidator().validator()
    }
}

fileprivate struct EmptyValidator<T>: ValidatorType where T: Collection {
    var validatorReadable: String {
        return "empty"
    }
    
    func validate(_ data: T) throws {
        guard data.isEmpty else {
            throw BasicValidationError("is not empty")
        }
    }
}
