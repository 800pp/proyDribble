//
//  StringValidationExtension.swift
//  proyDribble
//
//  Created by user178067 on 12/6/20.
//

import Foundation

extension String{
    enum ValidationType {
        case email
        case dni
        case name
        case phone
    }
    
    enum ValidationRegex: String{
        case email = "[A-Za-z0-9._%+-]+@[A-Za-z.-]+\\.[A-Za-z]{2,64}"
        case dni = "[0-9]{8}"
        case name = "[A-Za-z]{2,64}"
        case phone = "[0-9]{9}"
    }
    
    func isValid(_ v: ValidationType) -> Bool{
        
        let format = "SELF MATCHES %@"
        var regex = ""
        switch v {
        case .email:
            regex = ValidationRegex.email.rawValue
        case .dni:
            regex = ValidationRegex.dni.rawValue
        case .name:
            regex = ValidationRegex.name.rawValue
        case .phone:
            regex = ValidationRegex.phone.rawValue
        }
        
        return NSPredicate(format: format, regex).evaluate(with: self)
    }
}
