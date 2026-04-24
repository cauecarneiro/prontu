//
//  ScreenMonitorService.swift
//  Challenge13
//
//  Created by Caio Mandarino on 11/04/26.
//

import Foundation
import SwiftUI
import Combine

final class ScreenMonitorService {
    
    static let shared = ScreenMonitorService()
    
    private var publisher: PassthroughSubject<SceneStatus, Never> = .init()
    
    var sceneDidUpdate: AnyPublisher<SceneStatus, Never> {
        publisher.eraseToAnyPublisher()
    }
    
    private init() {}
    
    func updateScreen(screen: ScenePhase) {
        let sceneStatus: SceneStatus = screen == .active ? .active : .inactive
        publisher.send(sceneStatus)
    }
    
    enum SceneStatus {
        case active
        case inactive
    }
}
