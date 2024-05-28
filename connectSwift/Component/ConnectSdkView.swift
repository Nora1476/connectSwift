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
    
    //    @StateObject private var devicePicker = DevicePickerManager()
    var body: some View {
        VStack {
            HStack {
                
                Button(action: {
                    //                        devicePicker.startDiscovery()
                    discoveryListener.startScan()
                }) {
                    Text("Start Scan")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                Button(action: {
                    discoveryListener.stopScan()
                }) {
                    Text("Stop Scan")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
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
            
            HStack{
                Button(action: {
                    webOSTVService.volumeUp()
                }) {
                    Text("VolumeUp")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                Button(action: {
                    webOSTVService.volumeDown()
                }) {
                    Text("VolumeDown")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            Spacer()
            
            HStack{
                Button(action: {
                    webOSTVService.keyHome()
                }){
                    Text("keyHome")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
        }
        .navigationTitle("ConnectSDK View")
    }
}
#Preview {
    ConnectSdkView()
}

