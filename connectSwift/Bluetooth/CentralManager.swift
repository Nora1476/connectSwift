//
//  CentralManager.swift
//  connectSwift
//
//  Created by BonghuiJo on 5/23/24.
//

import Foundation
import CoreBluetooth

class CentralManager: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    var centralManager: CBCentralManager!
    var discoveredPeripheral: CBPeripheral?
    var targetCharacteristic: CBCharacteristic?

    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            print("Bluetooth is powered on")
            centralManager.scanForPeripherals(withServices: [CBUUID(string: "A0E06F4B-AB45-4B27-BAFC-2BF3C8E5E72D")], options: nil)
        case .poweredOff:
            print("Bluetooth is powered off")
        case .resetting:
            print("Bluetooth is resetting")
        case .unauthorized:
            print("Bluetooth is unauthorized")
        case .unsupported:
            print("Bluetooth is unsupported")
        case .unknown:
            print("Bluetooth state is unknown")
        @unknown default:
            print("A previously unknown Bluetooth state occurred")
        }
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print("Discovered peripheral: \(peripheral)")
        discoveredPeripheral = peripheral
        discoveredPeripheral?.delegate = self
        centralManager.stopScan()
        centralManager.connect(peripheral, options: nil)
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected to peripheral: \(peripheral)")
        peripheral.discoverServices([CBUUID(string: "A0E06F4B-AB45-4B27-BAFC-2BF3C8E5E72D")])
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let error = error {
            print("Error discovering services: \(error.localizedDescription)")
            return
        }
        guard let services = peripheral.services else { return }
        for service in services {
            print("Discovered service: \(service)")
            peripheral.discoverCharacteristics([CBUUID(string: "2A4D")], for: service)
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let error = error {
            print("Error discovering characteristics: \(error.localizedDescription)")
            return
        }
        guard let characteristics = service.characteristics else { return }
        for characteristic in characteristics {
            print("Discovered characteristic: \(characteristic)")
            if characteristic.uuid == CBUUID(string: "2A4D") {
                targetCharacteristic = characteristic
                peripheral.setNotifyValue(true, for: characteristic)
                print("Subscribed to characteristic: \(characteristic.uuid)")
            }
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error {
            print("Error updating value for characteristic: \(error.localizedDescription)")
            return
        }
        if characteristic.uuid == targetCharacteristic?.uuid {
            if let value = characteristic.value {
                let asciiString = String(data: value, encoding: .ascii)
                print("Received value: \(asciiString ?? "nil")")
            }
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error {
            print("Error writing value for characteristic: \(error.localizedDescription)")
            return
        }
        print("Successfully wrote value for characteristic: \(characteristic.uuid)")
    }
}

