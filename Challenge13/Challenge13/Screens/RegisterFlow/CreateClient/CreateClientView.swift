////
////  CreateClientView.swift
////  Challenge13
////
////  Created by Caio Mandarino on 01/04/26.
////
//

import SwiftUI

struct CreateClientView: View {
    @State var openImportContacts: Bool = false
    @State var selectedContact: ImportContact?
    
    var body: some View {
        VStack {
            Text("Hello, CreateClientView!")
            
            if let contact = selectedContact {
                Text("Contato: \(contact.name) - \(contact.number)")
                    .padding()
            }
            
            Button("Import Contact") {
                openImportContacts = true
            }
        }
        .background(
            ContactPickerView(isPresented: $openImportContacts) { selectedContact = $0 }
        )
    }
}


#Preview {
    CreateClientView()
}



