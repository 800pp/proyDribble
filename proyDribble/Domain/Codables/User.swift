//
//  User.swift
//  proyDribble
//
//  Created by user178067 on 12/10/20.
//

import Foundation
import FirebaseFirestoreSwift

struct User: Codable{
    
    @DocumentID var documentid: String?
    var dni: Int
    var password: String
    var name: String
    var phone: Int
    var mail: String
    //var birdthdate: Date
    
}

struct Following: Codable{
    @DocumentID var documentid: String?
    var id: String
    var name: String
    var at: String
}
