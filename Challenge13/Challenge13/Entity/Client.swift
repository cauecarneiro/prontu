//
//  Client.swift
//  Challenge13
//
//  Created by Caio Mandarino on 03/04/26.
//

import SwiftData
import Foundation

@Model
final class Client {
    @Attribute(.unique) var id: UUID
 
    init(id: UUID = UUID()) {
        self.id = id
    }
}
