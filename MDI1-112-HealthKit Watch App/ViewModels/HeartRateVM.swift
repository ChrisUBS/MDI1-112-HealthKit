//
//  HeartRateVM.swift
//  MDI1-112-HealthKit
//
//  Created by Christian Bonilla on 25/11/25.
//

import Foundation
import HealthKit
import Combine

#if targetEnvironment(simulator)
private let USE_MOCK = true
#else
private let USE_MOCK = false
#endif

@MainActor
final class HeartRateVM: ObservableObject {
    @Published var bpmText: String = "--"
    @Published var status: String = "Not started"
    @Published var authorized: Bool = false

    private let hk = HealthKitService()
    private var stream: AnyObject?
    private var cancellables: Set<AnyCancellable> = []

    func requestAuth() async {
        if USE_MOCK {
            authorized = true
            status = "Demo mode"
            return
        }

        do {
            try await hk.requestAuthorization()
            authorized = true
            status = "Authorized"
        } catch {
            authorized = false
            status = "Not authorized"
        }
    }

    func start() {
        guard authorized else { status = "Not authorized"; return }

        if USE_MOCK {
            let mock = MockHeartRateStream()
            hookStream(mock)
            mock.start()
            stream = mock
        } else {
            let real = HeartRateStream(store: hk.store)
            hookStream(real)
            try? real.start()
            stream = real
        }
    }

    func pause() {
        if let s = stream as? MockHeartRateStream { s.pause() }
        if let s = stream as? HeartRateStream { s.pause() }
    }

    func resume() {
        if let s = stream as? MockHeartRateStream { s.resume() }
        if let s = stream as? HeartRateStream { s.resume() }
    }

    func end() {
        if let s = stream as? MockHeartRateStream { s.end() }
        if let s = stream as? HeartRateStream { s.end() }
    }

    // MARK: - Bindings
    private func hookStream(_ s: MockHeartRateStream) {
        s.$bpm
            .receive(on: DispatchQueue.main)
            .sink { [weak self] v in self?.bpmText = v.map(String.init) ?? "--" }
            .store(in: &cancellables)

        s.$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] st in self?.status = vmStatusText(st) }
            .store(in: &cancellables)
    }

    private func hookStream(_ s: HeartRateStream) {
        s.$bpm
            .receive(on: DispatchQueue.main)
            .sink { [weak self] v in self?.bpmText = v.map(String.init) ?? "--" }
            .store(in: &cancellables)

        s.$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] st in self?.status = vmStatusText(st) }
            .store(in: &cancellables)
    }
}

private func vmStatusText(_ st: HKWorkoutSessionState) -> String {
    switch st {
    case .running: return "Live"
    case .paused: return "Paused"
    case .ended: return "Ended"
    default: return "Not started"
    }
}
