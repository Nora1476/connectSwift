//
//  Bluetooth.swift
//  connectSwift
//
//  Created by BonghuiJo on 5/21/24.
//

import SwiftUI
import CoreBluetooth

struct BluetoothView: View {
    @ObservedObject var bluetoothManager = BluetoothManager() //클래스의 인스턴스를 관찰

    var body: some View {
        VStack {
            HStack {
                if bluetoothManager.isScanning {
                    Button(action: {
                        bluetoothManager.stopScanning()
                    }) {
                        Text("Stop Scan")
                            .foregroundColor(.red)
                            .fontWeight(.bold)
                    }
                } else {
                    Button(action: {
                        bluetoothManager.startScanning()
                    }) {
                        Text("Start Scan")
                            .foregroundColor(.blue)
                            .fontWeight(.bold)
                    }
                }
                Spacer()
            }
            if bluetoothManager.peripherals.isEmpty {
                Text("Start Scan 버튼을 눌러주세요.")
                    .foregroundColor(.gray)
                    .padding()
                Spacer()
            } else {
                //id = 반복하여 뷰를 생성하는데, 각 항목을 고유하게 식별할 수 있는 키
                List(bluetoothManager.peripherals, id: \.identifier) { peripheral in
                    HStack {
                        Text(peripheral.name ?? "Unknown")
                        Spacer()
                        //블루투스 장치가 현재 연결되어 있는지 여부를 확인하고, 연결된 장치가 목록에 있는 특정 장치와 동일한지 여부
                        if bluetoothManager.isConnected && bluetoothManager.peripheral?.identifier == peripheral.identifier {
                            Text("Connected")
                                .foregroundColor(.green)
                        } else {
                            Button(action: {
                                bluetoothManager.connectToPeripheral(peripheral)
                            }) {
                                Text("Connect")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("Bluetooth View")
    }
}

#Preview {
    BluetoothView()
}
