//
//  Memory.swift
//  PigeonServices
//
//  Created by Bridge Dudley on 7/12/23.
//

import Foundation
import FirebaseFirestore

struct Memory: Codable {
    var id: String?
    let imagePath: String
    let message: String
    let status: String
    let seen: Bool
    let seenDate: Timestamp?
}
