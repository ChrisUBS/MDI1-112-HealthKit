//
//  HealthKitService.swift
//  MDI1-112-HealthKit
//
//  Created by Christian Bonilla on 25/11/25.
//

import HealthKit
import Combine

enum HKError: Error { case notAvailable, notAuthorized }

final class HealthKitService: NSObject, ObservableObject {
    @Published var isAuthorized: Bool = false

    let store = HKHealthStore()
    private let heartType = HKQuantityType.quantityType(forIdentifier: .heartRate)!

    func requestAuthorization() async throws {
        guard HKHealthStore.isHealthDataAvailable() else { throw HKError.notAvailable }
        try await store.requestAuthorization(toShare: [], read: [heartType])
        let status = store.authorizationStatus(for: heartType)
        guard status == .sharingAuthorized else { throw HKError.notAuthorized }
    }
}
