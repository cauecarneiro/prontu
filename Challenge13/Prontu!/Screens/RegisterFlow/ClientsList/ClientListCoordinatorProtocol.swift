//
//  ClientListCoordinatorProtocol.swift
//  Challenge13
//
//  Created by Caio Mandarino on 03/04/26.
//

import Foundation

protocol ClientListCoordinatorProtocol: AnyObject {
    func navigateToEditClient(client: Client)
    func presentToCreateClient()
}
