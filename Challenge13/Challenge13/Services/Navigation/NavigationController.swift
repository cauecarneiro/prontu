//
//  NavigationController.swift
//  Challenge13
//
//  Created by Caio Mandarino on 01/04/26.
//

import SwiftUI

@Observable final class NavigationController {
    var path: NavigationPath = .init()
    
    func push<T: Hashable>(router: T) {
        path.append(router)
    }
    
    func pop() {
        guard !path.isEmpty else { return }
        
        path.removeLast()
    }
}
