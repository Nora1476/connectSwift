//
//  BluetoothHIDManager.swift
//  connectSwift
//
//  Created by BonghuiJo on 5/22/24.
//


import Foundation
import CoreBluetooth

class BluetoothHIDManager: NSObject, ObservableObject, CBPeripheralManagerDelegate {
    var peripheralManager: CBPeripheralManager?
    @Published var isPoweredOn = false
    @Published var isAdvertising = false
    private var reportCharacteristic: CBMutableCharacteristic?

    override init() {
        super.init()
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil) //초기화
    }

    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        isPoweredOn = peripheral.state == .poweredOn //값설정 ture반환
        if isPoweredOn {
            setupPeripheral()
        }
    }

    func setupPeripheral() { //주변창치로 동작하기 위한 설정
        let hidServiceUUID = CBUUID(string: "1812") //HID 서비스 UUID
        let hidService = CBMutableService(type: hidServiceUUID, primary: true) //HID 서비스를 정의

        // HID 정보 특성
        let hidInfoUUID = CBUUID(string: "2A4A") //HID 정보 특성 UUID
        let hidInfoData = Data([0x01, 0x01, 0x00])
        let hidInfoCharacteristic = CBMutableCharacteristic(type: hidInfoUUID, properties: [.read], value: hidInfoData, permissions: [.readable]) //CBMutableCharacteristic 객체를 생성하여 HID 정보 특성을 정의

        // HID 보고서 특성
        let reportUUID = CBUUID(string: "2A4D")
        reportCharacteristic = CBMutableCharacteristic(type: reportUUID, properties: [.read, .notify], value: nil, permissions: [.readable])

        hidService.characteristics = [hidInfoCharacteristic, reportCharacteristic].compactMap { $0 }
        peripheralManager?.add(hidService)

        startAdvertising()
    }

    func startAdvertising() {
        let advertisementData: [String: Any] = [
            CBAdvertisementDataLocalNameKey: "MyHIDDevice",
            CBAdvertisementDataServiceUUIDsKey: [CBUUID(string: "1812")]
        ]
        peripheralManager?.startAdvertising(advertisementData)
        isAdvertising = true
    }

    func sendHIDReport(data: Data) {
        guard let reportCharacteristic = reportCharacteristic else { return }
        peripheralManager?.updateValue(data, for: reportCharacteristic, onSubscribedCentrals: nil)
    }

    // 중앙 장치가 특성에 구독했을 때
    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didSubscribeTo characteristic: CBCharacteristic) {
        print("Central subscribed to characteristic: \(characteristic.uuid)")
    }

    // 중앙 장치가 특성 구독을 해제했을 때
    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didUnsubscribeFrom characteristic: CBCharacteristic) {
        print("Central unsubscribed from characteristic: \(characteristic.uuid)")
    }

    // 중앙 장치가 주변 장치에 연결되었을 때
    func peripheralManager(_ peripheral: CBPeripheralManager, didAdd service: CBService, error: Error?) {
        if let error = error {
            print("Error adding service: \(error.localizedDescription)")
            return
        }
        print("Service added: \(service.uuid)")
    }
}
