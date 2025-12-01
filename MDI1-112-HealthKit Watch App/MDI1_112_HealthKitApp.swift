//
//  MDI1_112_HealthKitApp.swift
//  MDI1-112-HealthKit Watch App
//
//  Created by Christian Bonilla on 25/11/25.
//

import SwiftUI

@main
struct MDI1_112_HealthKit_Watch_AppApp: App {
    @StateObject private var vm = HeartRateVM()
    var body: some Scene {
        WindowGroup {
            HeartRateView()
                .environmentObject(vm)
        }
    }
}
