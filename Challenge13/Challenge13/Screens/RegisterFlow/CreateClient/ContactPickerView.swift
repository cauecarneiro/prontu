//
//  ContactPickerView.swift
//  Challenge13
//
//  Created by Cauê Carneiro on 08/04/26.
//

import SwiftUI
import ContactsUI

struct ContactPickerView: UIViewControllerRepresentable {
    @Binding var isPresented: Bool
    var onSelect: (ImportContact) -> Void
    
    func makeUIViewController(context: Context) -> UIViewController {
        let vc = UIViewController()
        vc.view.backgroundColor = .clear
        return vc
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        if isPresented && uiViewController.presentedViewController == nil {
            let picker = CNContactPickerViewController()
            picker.delegate = context.coordinator
            
            DispatchQueue.main.async {
                uiViewController.present(picker, animated: true)
            }
        }
    }
    
    func makeCoordinator() -> ContactPickerDelegate {
        ContactPickerDelegate(self)
    }
    
    class ContactPickerDelegate: NSObject, CNContactPickerDelegate {
        var parent: ContactPickerView
        
        init(_ parent: ContactPickerView) {
            self.parent = parent
        }
        
        func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
            let contact = ImportContact(
                name: "\(contact.givenName) \(contact.familyName)",
                number: contact.phoneNumbers.first!.value.stringValue
            )
            parent.onSelect(contact)
            parent.isPresented = false
        }
        
        func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
            parent.isPresented = false
        }
    }
}
