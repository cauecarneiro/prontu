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
    
    private var publisher: PassthroughSubject<ScenePhase, Never> = .init()
    
    var sceneDidUpdate: AnyPublisher<ScenePhase, Never> {
        publisher.eraseToAnyPublisher()
    }
    
    private init() {}
    
    func updateScreen(screen: ScenePhase) {
        publisher.send(screen)
    }
}
