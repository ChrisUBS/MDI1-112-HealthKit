//
//  SessionControls.swift
//  MDI1-112-HealthKit
//
//  Created by Christian Bonilla on 25/11/25.
//

import SwiftUI

struct SessionControls: View {
    @EnvironmentObject var vm: HeartRateVM

    var body: some View {
        HStack {
            Button("Start") { vm.start() }
            Button("Pause") { vm.pause() }
            Button("End") { vm.end() }
        }
        .buttonStyle(.bordered)
        .font(.system(.footnote, design: .rounded))
    }
}
