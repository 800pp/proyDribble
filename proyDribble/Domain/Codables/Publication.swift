//
//  Publication.swift
//  proyDribble
//
//  Created by user178067 on 12/10/20.
//

import Foundation
import FirebaseFirestoreSwift

struct Publication: Codable{
    @DocumentID
    var documentId: String?
    var likes: Int
    var title: String
    var description: String
    var user: tempUser
    //var date: Date
}

struct tempUser: Codable {
    var id: String
    var name: String
}
