//
//  connectSDK.swift
//  connectSwift
//
//  Created by BonghuiJo on 5/20/24.
//

import SwiftUI
import ConnectSDK
struct ConnectSdkView: View {
    @StateObject private var discoveryListener = DiscoveryListener()
    var body: some View {
        VStack {
            Button(action: {
                discoveryListener.startScan()
            }) {
                Text("Start Scan")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            Spacer()
        }
        .navigationTitle("ConnectSDK View")
    }
}
#Preview {
    ConnectSdkView()
}

