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
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil) // 초기화
    }

    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) { // 블루투스 상태가 변경될 때마다 호출
        isPoweredOn = peripheral.state == .poweredOn // 값 설정 true 반환
        if isPoweredOn {
//            setupPeripheral()
        }
    }

    func setupPeripheral() { // 주변 장치로 동작하기 위한 설정
        let customServiceUUID = CBUUID(string: "1812")
               let customService = CBMutableService(type: customServiceUUID, primary: true) // 맞춤형 서비스를 정의하고 주요서비스로 지정

               // HID 정보 특성
               let hidInfoUUID = CBUUID(string: "2A4A") // HID 정보 특성 UUID
               let hidInfoData = Data([0x01, 0x01, 0x00])
               let hidInfoCharacteristic = CBMutableCharacteristic(type: hidInfoUUID, properties: [.read], value: hidInfoData, permissions: [.readable]) // CBMutableCharacteristic 객체를 생성하여 HID 정보 특성을 정의

               // HID 보고서 특성
               let reportUUID = CBUUID(string: "2A4D")
               reportCharacteristic = CBMutableCharacteristic(type: reportUUID, properties: [.read, .notify], value: nil, permissions: [.readable])

               customService.characteristics = [hidInfoCharacteristic, reportCharacteristic].compactMap { $0 }
               peripheralManager?.add(customService) // 서비스 추가

        startAdvertising()
    }

    func startAdvertising() { // 광고 시작
        let advertisementData: [String: Any] = [
            CBAdvertisementDataLocalNameKey: "MyHIDDevice Test",
            CBAdvertisementDataServiceUUIDsKey: [CBUUID(string: "1812")]
        ]
        peripheralManager?.startAdvertising(advertisementData)
        isAdvertising = true
        print("광고 시작!")
    }

    func stopAdvertising() { // 광고 멈춤
        peripheralManager?.stopAdvertising()
        isAdvertising = false
        print("광고 멈춤")
    }

    func sendHIDReport(data: Data) {
        guard let reportCharacteristic = reportCharacteristic else { return }
        peripheralManager?.updateValue(data, for: reportCharacteristic, onSubscribedCentrals: nil) // HID 보고서 데이터 전송
        print("코드 전송 \(data)")
    }

    // 서비스가 추가되었을 때
    func peripheralManager(_ peripheral: CBPeripheralManager, didAdd service: CBService, error: Error?) {
        if let error = error {
            print("Error adding service: \(error)")
            return
        }
        print("Service added: \(service.uuid)")
    }
    
}
