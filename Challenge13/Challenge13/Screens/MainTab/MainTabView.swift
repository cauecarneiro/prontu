//
//  MainTabView.swift
//  Challenge13
//
//  Created by Caio Mandarino on 01/04/26.
//

import SwiftUI

struct MainTabView: View {
    
    @ObservedObject var viewModel: MainTabViewModel
    
    struct StringValues {
        static var agenda: String { "Agenda" }
        static var register: String { "Register" }
        static var report: String { "Report" }
    }
    
    var body: some View {
        TabView(selection: $viewModel.selectedTab) {
            Tab(StringValues.agenda, systemImage: "calendar", value: .agenda) {
                
            }
            
            Tab(StringValues.register, systemImage: "person", value: .agenda) {
                
            }
            
            Tab(StringValues.report, systemImage: "calendar", value: .agenda) {
                
            }
        }
    }
}

#Preview {
    MainTabView(viewModel: .init())
}
