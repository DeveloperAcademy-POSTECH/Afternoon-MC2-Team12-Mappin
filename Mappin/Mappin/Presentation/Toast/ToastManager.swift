//
//  ToastManager.swift
//  Mappin
//
//  Created by byo on 2023/05/09.
//

import Foundation

final class ToastManager: ObservableObject, ToastManagerProtocol {
    static let shared = ToastManager()
    
    @Published private var model: Model?
    
    var currentMessage: String? {
        model?.message
    }
    
    private init() {
        setupTimerForExpiration()
    }
    
    func setMessage(_ message: String) {
        model = Model(message: message, lastTime: .now())
    }
    
    private func setupTimerForExpiration() {
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            self?.removeModelIfExpired()
        }
    }
    
    private func removeModelIfExpired() {
        guard let model = model else {
            return
        }
        if model.isExpired() {
            self.model = nil
        }
    }
}

private extension ToastManager {
    struct Model {
        let message: String
        let lastTime: DispatchTime
        let duration: TimeInterval = 2
        
        func isExpired() -> Bool {
            lastTime < DispatchTime.now() - duration
        }
    }
}
