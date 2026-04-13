//
//  Binding+Ext.swift
//  Challenge13
//
//  Created by Caio Mandarino on 13/04/26.
//

import SwiftUI

extension Binding where Value == Bool {
    init<T>(value: Binding<T?>) {
        self.init {
            value.wrappedValue != nil
        } set: { newValue in
            if !newValue {
                value.wrappedValue = nil
            }
        }
    }
}
