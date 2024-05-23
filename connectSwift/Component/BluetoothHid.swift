//
//  BluetoothHid.swift
//  connectSwift
//
//  Created by BonghuiJo on 5/22/24.
//

import SwiftUI

struct BluetoothHid: View {
    @ObservedObject var bluetoothHIDManager = BluetoothHIDManager()
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    bluetoothHIDManager.startAdvertising()
                }) {
                    Text("Start")
                        .frame(width: 150, height: 50)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
                
                Button(action: {
                    bluetoothHIDManager.stopAdvertising()
                }) {
                    Text("Stop")
                        .frame(width: 150, height: 50)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
            }
            VStack {
                if bluetoothHIDManager.isPoweredOn {
                    Text("Bluetooth is powered on")
                } else {
                    Text("Bluetooth is not powered on")
                }
                
                if bluetoothHIDManager.isAdvertising {
                    Text("Advertising as HID device")
                } else {
                    Text("Not advertising")
                }
            }
            HStack {
                Button(action: {
                    let reportData = Data([0x31]) // 아스키코드 1
                    bluetoothHIDManager.sendHIDReport(data: reportData)
                }) {
                    Text("1")
                        .frame(width: 50, height: 50)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
                
                Button(action: {
                    let reportData = Data([0x32]) // 아스키코드 2
                    bluetoothHIDManager.sendHIDReport(data: reportData)
                }) {
                    Text("2")
                        .frame(width: 50, height: 50)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
                
                Button(action: {
                    let reportData = "Hello"
                    if let data = reportData.data(using: .ascii){
                        bluetoothHIDManager.sendHIDReport(data: data)
                    }
                }) {
                    Text("Hello")
                        .frame(width: 50, height: 50)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
                
            }
        }
        .padding()
    }
}

struct BluetoothHid_Previews: PreviewProvider {
    static var previews: some View {
        BluetoothHid()
    }
}
