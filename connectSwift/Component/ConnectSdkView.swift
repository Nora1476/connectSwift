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
    private var webOSTVService = WebOSTVService()
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
            
            Spacer(minLength: 20)
            
            Text("Discovered Devices: \(discoveryListener.deviceCount)")
            List(discoveryListener.devices, id: \.self) { device in
                Text(device.friendlyName ?? "Unknown Device")
                    .onTapGesture {
                        webOSTVService.initialize(device: device)
                    }
            }
            if discoveryListener.deviceCount == 0 {
                Text("No devices found")
            }
            Spacer()
        }
        .navigationTitle("ConnectSDK View")
    }
}
#Preview {
    ConnectSdkView()
}

