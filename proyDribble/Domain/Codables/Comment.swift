//
//  Comment.swift
//  proyDribble
//
//  Created by user178067 on 12/10/20.
//

import Foundation
import FirebaseFirestoreSwift

struct Comment: Encodable{
    @DocumentID
    var documentId: String?
    var date: Date?
    var id: String
    var name: String
    var text: String
}
