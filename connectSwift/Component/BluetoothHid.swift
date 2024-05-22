//
//  BluetoothHid.swift
//  connectSwift
//
//  Created by BonghuiJo on 5/22/24.
//

import SwiftUI

struct BluetoothHid: View {
    @ObservedObject var bluetoothHIDManager = BluetoothHIDManager() //객체 초기화됨시롱 init() 매서드 호출

    var body: some View {
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
                    let reportData = Data([0x33]) // 아스키코드 3
                    bluetoothHIDManager.sendHIDReport(data: reportData)
                }) {
                    Text("3")
                        .frame(width: 50, height: 50)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()

                Button(action: {
                    let reportData = Data([0x34]) // 아스키코드 4
                    bluetoothHIDManager.sendHIDReport(data: reportData)
                }) {
                    Text("4")
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
