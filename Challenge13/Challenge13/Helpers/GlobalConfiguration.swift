//
//  GlobalConfiguration.swift
//  Challenge13
//
//  Created by Caio Mandarino on 14/04/26.
//

import Foundation
import SwiftUI

enum GlobalConfiguration {
    static var primaryGreen: Color { Color(.primaryGreen) }
    static var primaryBlue: Color { Color(.primaryBlue) }
    
    static var normalSpacing: CGFloat { 16 }
    static var normalCornerRadius: CGFloat { 12 }
        
    static var dataFileName: String { "dados" }
    static var fileExtension: String { "json" }
}
