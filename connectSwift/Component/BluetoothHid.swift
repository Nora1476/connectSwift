//
//  BluetoothHid.swift
//  connectSwift
//
//  Created by BonghuiJo on 5/22/24.
//

import SwiftUI

struct BluetoothHid: View {
    @StateObject var bluetoothManager = BluetoothHIDManager()
    
    var body: some View {
        VStack {
            Text("Bluetooth HID Keyboard")
                .font(.title2)
                .padding()
            
            if bluetoothManager.isConnected {
                Text("Connected")
                    .foregroundColor(.green)
            } else {
                Text("Connecting...")
                    .foregroundColor(.red)
            }
            
            List {
                ForEach(bluetoothManager.peripherals, id: \.identifier) { device in
                    Button(action: {
                        bluetoothManager.connectToDevice(device)
                    }) {
                        Text(device.name ?? "Unknown")
                            .foregroundColor(.blue)
                    }
                }
            }
            .padding()
            
            HStack {
                ForEach(1..<5) { number in
                    Button(action: {
                        bluetoothManager.sendKeyboardInput(UInt8(number))
                    }) {
                        Text("\(number)")
                            .font(.largeTitle)
                            .frame(width: 60, height: 60)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding(5)
                    }
                }
            }
        }
        .padding()
        .onAppear {
                   bluetoothManager.startScanning()
               }
    }
}

struct BluetoothHid_Previews: PreviewProvider {
    static var previews: some View {
        BluetoothHid()
    }
}
