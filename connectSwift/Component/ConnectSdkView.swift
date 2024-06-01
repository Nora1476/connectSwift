//
//  connectSDK.swift
//  connectSwift
//
//  Created by BonghuiJo on 5/20/24.
//

import SwiftUI
import ConnectSDK
struct ConnectSdkView: View {
    @StateObject var devicePickerManager = DevicePickerManager()
    @StateObject private var webOSTVService = WebOSTVService()
    
    //기본버튼 디자인
    func basicBtn(text: String)-> some View {
        Text(text)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
    }
    
    var body: some View {
        
        VStack {
            HStack {
                Button(action: {
                    devicePickerManager.showDevicePicker()
                }) {
                    basicBtn(text: "Start Scan")
                }
                Button(action: {
                }) {
                    basicBtn(text: "Stop Scan")
                }
            }
            
            List(devicePickerManager.devices, id: \.id) { device in
                VStack(alignment: .leading) {
                    Text(device.friendlyName ?? "Unknown Device")
                        .font(.headline)
                    Text(device.modelName ?? "Unknown Model")
                        .font(.subheadline)
                }
                .onTapGesture {
                    devicePickerManager.devicePicker(nil, didSelect: device)
                }
            }
            Spacer()
            
            
            HStack{
                Button(action: {
                    webOSTVService.volumeUp()
                }) {
                    basicBtn(text: "VolumeUp")
                }
                Button(action: {
                    webOSTVService.volumeDown()
                }) {
                    basicBtn(text: "VolumeDown")
                }
            }
            Spacer()
            
            HStack{
                Button(action: {
                    webOSTVService.mouseClick()
                }){
                    basicBtn(text: "Click")
                }
                Button(action: {
                    webOSTVService.mouseLeft()
                }){
                    basicBtn(text: "←M")
                }
                Button(action: {
                    webOSTVService.mouseRight()
                }){
                    basicBtn(text: "M→")
                }
            }
            
            HStack{
                Button(action: {
                    webOSTVService.keyHome()
                }){
                    basicBtn(text: "keyHome")
                }
                Button(action: {
                    webOSTVService.keyLeft()
                }){
                    basicBtn(text: "←Key")
                }
                Button(action: {
                    webOSTVService.keyRight()
                }){
                    basicBtn(text: "Key→")
                }
            }
        }
        .navigationTitle("ConnectSDK View")
    }
    
    
    
}
#Preview {
    ConnectSdkView()
}

