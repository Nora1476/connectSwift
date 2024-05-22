//
//  BluetoothHIDManager.swift
//  connectSwift
//
//  Created by BonghuiJo on 5/22/24.
//

import Foundation
import CoreBluetooth

class BluetoothHIDManager: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    @Published var isConnected = false
    @Published var peripherals: [CBPeripheral] = []
    
    var centralManager: CBCentralManager!
    var connectedPeripheral: CBPeripheral?
    var reportCharacteristic: CBCharacteristic?
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    func startScanning() {
        if centralManager.state == .poweredOn {
                  centralManager.scanForPeripherals(withServices: nil, options: nil)
                  print("스캔시작")
              } else {
                  print("블루투스 꺼져있음")
              }
    }
    
    func connectToDevice(_ device: CBPeripheral) {
        connectedPeripheral = device
        connectedPeripheral?.delegate = self
        centralManager.stopScan()
        centralManager.connect(device, options: nil)
        print("디바이스 연결 시도: \(device.name ?? "Unknown")")
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            startScanning()
        } else {
            print("블루투스 사용 불가능!")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if let name = peripheral.name, !name.isEmpty,
           !peripherals.contains(where: { $0.identifier == peripheral.identifier }) { //이름이 있는 디바이스만 배열에 추가
            peripherals.append(peripheral)
            print("검색된 기기: \(name)")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        isConnected = true
        peripheral.delegate = self
        peripheral.discoverServices([CBUUID(string: "1812")])
        
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        for service in services {
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else { return }
        for characteristic in characteristics {
            if characteristic.uuid == CBUUID(string: "2A4D") {
                reportCharacteristic = characteristic
            }
        }
    }
    
    func sendKeyboardInput(_ input: UInt8) {
        guard let reportCharacteristic = reportCharacteristic else { return }
        let reportData = Data([0x00, input, 0x00])
        connectedPeripheral?.writeValue(reportData, for: reportCharacteristic, type: .withoutResponse)
    }
}
