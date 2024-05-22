//
//  File.swift
//  connectSwift
//
//  Created by BonghuiJo on 5/21/24.
//

import Foundation
import CoreBluetooth

class BluetoothManager: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    var centralManager: CBCentralManager?    //BLE 중앙 관리자
    var peripheral: CBPeripheral?  //현재 연결된 주변 기기
    
    //상태변화를 자동감지
    @Published var isConnected = false
    @Published var peripherals: [CBPeripheral] = []   //발견된 기기를 저장하는 배열
    @Published var isScanning = false // 스캔 상태 변수
    
    // 쓰기 가능한 특성을 저장하는 변수
    var writableCharacteristic: CBCharacteristic?
    
    // 초기화
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    // CBCentralManager상태가 변경될때 호출
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            // Bluetooth가 켜져 있을 때의 상태 처리
        } else {
            // Handle different states
        }
    }
    
    // 스캔 시작 메서드
    func startScanning() {
        peripherals.removeAll()
        centralManager?.scanForPeripherals(withServices: nil, options: nil) //매개변수 넘겨주면 특정 서비스만 스캔가능
        isScanning = true
        print("스캔 시작")
    }
    
    // 스캔 중지 메서드
    func stopScanning() {
        centralManager?.stopScan()
        isScanning = false
        print("스캔 중지")
    }
    
    // 새로운 주변 기기를 발견할 때
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if let name = peripheral.name, !name.isEmpty, !peripherals.contains(where: { $0.identifier == peripheral.identifier }) { //기기이름이 null이 아닐때만 배열에 추가
            peripherals.append(peripheral)
        }
    }
    
    // 주변기기와 연결되었을 때
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        isConnected = true
        self.peripheral = peripheral
        peripheral.delegate = self
        peripheral.discoverServices(nil)
        print("연결 성공: \(peripheral.name ?? "Unknown")")
    }
    
    // 연결이 끊어졌을 때
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        isConnected = false
        centralManager?.scanForPeripherals(withServices: nil, options: nil)
        print("연결 끊어짐: \(peripheral.name ?? "Unknown")")
    }
    
    // 연결 시도
    func connectToPeripheral(_ peripheral: CBPeripheral) {
        centralManager?.connect(peripheral, options: nil)
        print("연결 시도: \(peripheral.name ?? "Unknown")")
    }
    
    
    // 주변기기 services 발견 시
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let error = error {
            print("서비스 발견 오류: \(error.localizedDescription)")
            return
        }
        
        if let services = peripheral.services {
            for service in services {
                peripheral.discoverCharacteristics(nil, for: service)
                print("서비스 발견: \(service.uuid.uuidString)")
            }
        }
    }
    // 주변기기 characteristics 발견 시
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let error = error {
            print("특성 발견 오류: \(error.localizedDescription)")
            return
        }
        
        if let characteristics = service.characteristics {
            for characteristic in characteristics {
                //print("특성 발견: \(characteristic.uuid)")
                
                // 읽기 가능한 특성의 값을 읽음
                if characteristic.properties.contains(.read) {
                    peripheral.readValue(for: characteristic)
                    //print("데이터 읽기 요청: \(characteristic.uuid)")
                }
                
                // 쓰기 가능한 특성을 저장
                if characteristic.properties.contains(.write) {
                    print("쓰기 가능한 특성: \(characteristic.uuid)")
                    writableCharacteristic = characteristic
                    writeDataToCharacteristic(data: "Hello Bluetooth!")
                    print("데이터 쓰기 성공")
                }
            }
        }
    }
    
    //didUpdateValueFor : characteristic)의 값이 업데이트되었을 때 호출. BLE 장치에서 데이터를 읽어올 때 사용.
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error {
            print("데이터 읽기 오류: \(error.localizedDescription)")
            return
        }
        
        if let data = characteristic.value {
            let dataString = String(data: data, encoding: .utf8) ?? "데이터 변환 오류"
            print("읽은 데이터 (UUID: \(characteristic.uuid)): \(dataString)")
        }
    }
    
    // 쓰기 가능한 특성에 데이터 쓰기 메서드
    func writeDataToCharacteristic(data: String) {
        guard let characteristic = writableCharacteristic else {
            print("쓰기 가능한 특성을 찾을 수 없습니다.")
            return
        }
        
        if let dataToWrite = data.data(using: .utf8) {
            peripheral?.writeValue(dataToWrite, for: characteristic, type: .withResponse)
//            print("데이터 쓰기 요청: \(dataToWrite) to \(characteristic.uuid)")
        } else {
            print("데이터 변환 오류")
        }
    }
}
