//
//  HeartRateView.swift
//  MDI1-112-HealthKit
//
//  Created by Christian Bonilla on 25/11/25.
//

import SwiftUI

struct HeartRateView: View {
    @EnvironmentObject var vm: HeartRateVM

    var body: some View {
        VStack(spacing: 10) {
            Text("Heart")
                .font(.system(.caption, design: .rounded))
                .opacity(0.8)

            // Main BPM display
            Text(vm.bpmText)
                .font(.system(.largeTitle, design: .rounded).weight(.semibold))
                .minimumScaleFactor(0.7)
                .accessibilityLabel("Heart rate")
                .accessibilityValue("\(vm.bpmText) beats per minute")
                .accessibilityHint(vm.status)

            Text(vm.status)
                .font(.system(.footnote, design: .rounded))
                .opacity(0.7)
                .accessibilityHidden(true)

            if !vm.authorized {
                Button("Allow Health Access") {
                    Task { await vm.requestAuth() }
                }
                .buttonStyle(.borderedProminent)
                .accessibilityLabel("Allow Health Access")
                .accessibilityHint("Grants permission to read your heart rate from HealthKit")

            } else {
                SessionControls()
                    .accessibilityElement(children: .contain)
                    .accessibilityLabel("Session controls")
                    .accessibilityHint("Start, pause, or end the live heart rate session")
            }
        }
        .padding(8)
        .accessibilityElement(children: .contain)
    }
}
