//
//  BluetoothHIDManager.swift
//  connectSwift
//
//  Created by BonghuiJo on 5/22/24.
//


import Foundation
import CoreBluetooth

class BluetoothHidCopy: NSObject, ObservableObject, CBPeripheralManagerDelegate {
    var peripheralManager: CBPeripheralManager?
    @Published var isPoweredOn = false
    @Published var isAdvertising = false
    private var reportCharacteristic: CBMutableCharacteristic?
    
    //        private var heartRateMeasurementCharacteristic: CBMutableCharacteristic?
    
    //    private var manufacturerNameCharacteristic: CBMutableCharacteristic?
    //    private var modelNumberCharacteristic: CBMutableCharacteristic?
    
    //    private var batteryLevelCharacteristic: CBMutableCharacteristic?
    
    //    private var temperatureMeasurementCharacteristic: CBMutableCharacteristic?
    
    //    private var bloodPressureMeasurementCharacteristic: CBMutableCharacteristic?
    //       private var intermediateCuffPressureCharacteristic: CBMutableCharacteristic?
    //       private var bloodPressureFeatureCharacteristic: CBMutableCharacteristic?
    
    //    private var locationAndSpeedCharacteristic: CBMutableCharacteristic?
    //    private var navigationCharacteristic: CBMutableCharacteristic?
    //    private var positionQualityCharacteristic: CBMutableCharacteristic?
    
    override init() {
        super.init()
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil) //초기화
    }
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) { //블루투스 상태가 변경될때마다 호출
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
        peripheralManager?.add(hidService) //서비스 추가
        
        
        
        //                let heartRateServiceUUID = CBUUID(string: "180D") // 심박수 서비스 UUID(등록가능)
        //                let heartRateService = CBMutableService(type: heartRateServiceUUID, primary: true) // 심박수 서비스를 정의
        //
        //                // 심박수 측정 특성
        //                let heartRateMeasurementUUID = CBUUID(string: "2A37") // 심박수 측정 특성 UUID
        //                heartRateMeasurementCharacteristic = CBMutableCharacteristic(type: heartRateMeasurementUUID, properties: [.read, .notify], value: nil, permissions: [.readable]) // CBMutableCharacteristic 객체를 생성하여 심박수 측정 특성을 정의
        //                // 심박수 측정 위치 특성
        //                let bodySensorLocationUUID = CBUUID(string: "2A38") // 심박수 측정 위치 특성 UUID
        //                let bodySensorLocationData = Data([1]) // 예: 가슴(1)
        //                let bodySensorLocationCharacteristic = CBMutableCharacteristic(type: bodySensorLocationUUID, properties: [.read], value: bodySensorLocationData, permissions: [.readable])
        //                heartRateService.characteristics = [heartRateMeasurementCharacteristic, bodySensorLocationCharacteristic].compactMap { $0 }
        //                peripheralManager?.add(heartRateService) // 서비스 추가
        
        
        
        //        let deviceInfoServiceUUID = CBUUID(string: "180A") // Device Information 서비스 UUID
        //               let deviceInfoService = CBMutableService(type: deviceInfoServiceUUID, primary: true) // Device Information 서비스를 정의
        //               // 제조업체 이름 특성
        //               let manufacturerNameUUID = CBUUID(string: "2A29") // 제조업체 이름 특성 UUID
        //               let manufacturerNameData = "MyManufacturer".data(using: .utf8)
        //               manufacturerNameCharacteristic = CBMutableCharacteristic(type: manufacturerNameUUID, properties: [.read], value: manufacturerNameData, permissions: [.readable])
        //
        //               // 모델 번호 특성
        //               let modelNumberUUID = CBUUID(string: "2A24") // 모델 번호 특성 UUID
        //               let modelNumberData = "Model123".data(using: .utf8)
        //               modelNumberCharacteristic = CBMutableCharacteristic(type: modelNumberUUID, properties: [.read], value: modelNumberData, permissions: [.readable])
        //
        //               deviceInfoService.characteristics = [manufacturerNameCharacteristic, modelNumberCharacteristic].compactMap { $0 }
        //               peripheralManager?.add(deviceInfoService) // 서비스 추가
        
        
        
        //        let batteryServiceUUID = CBUUID(string: "180F") // 배터리 서비스 UUID
        //        let batteryService = CBMutableService(type: batteryServiceUUID, primary: true) // 배터리 서비스를 정의
        //
        //        // 배터리 레벨 특성
        //        let batteryLevelUUID = CBUUID(string: "2A19") // 배터리 레벨 특성 UUID
        //        let batteryLevelData = Data([100]) // 초기 배터리 레벨 (100%)
        //        batteryLevelCharacteristic = CBMutableCharacteristic(type: batteryLevelUUID, properties: [.read, .notify], value: nil, permissions: [.readable])
        //
        //        batteryService.characteristics = [batteryLevelCharacteristic].compactMap { $0 }
        //        peripheralManager?.add(batteryService) // 서비스 추가
        
        
        
        
        //        let thermometerServiceUUID = CBUUID(string: "1809") // 건강 온도계 서비스 UUID
        //        let thermometerService = CBMutableService(type: thermometerServiceUUID, primary: true) // 건강 온도계 서비스를 정의
        //
        //        // 체온 측정 특성
        //        let temperatureMeasurementUUID = CBUUID(string: "2A1C") // 체온 측정 특성 UUID
        //        let temperatureMeasurementData = Data([0x00, 0x00, 0x00, 0x00, 0x00]) // 초기 체온 데이터 (예시)
        //        temperatureMeasurementCharacteristic = CBMutableCharacteristic(type: temperatureMeasurementUUID, properties: [.read, .notify], value: nil, permissions: [.readable])
        //
        //        thermometerService.characteristics = [temperatureMeasurementCharacteristic].compactMap { $0 }
        //        peripheralManager?.add(thermometerService) // 서비스 추가
        
        
        //        let bloodPressureServiceUUID = CBUUID(string: "1810") // 혈압 서비스 UUID
        //               let bloodPressureService = CBMutableService(type: bloodPressureServiceUUID, primary: true) // 혈압 서비스를 정의
        //
        //               // 혈압 측정 특성
        //               let bloodPressureMeasurementUUID = CBUUID(string: "2A35") // 혈압 측정 특성 UUID
        //               bloodPressureMeasurementCharacteristic = CBMutableCharacteristic(type: bloodPressureMeasurementUUID, properties: [.notify], value: nil, permissions: [.readable])
        //
        //               // 중간 커프 압력 특성
        //               let intermediateCuffPressureUUID = CBUUID(string: "2A36") // 중간 커프 압력 특성 UUID
        //               intermediateCuffPressureCharacteristic = CBMutableCharacteristic(type: intermediateCuffPressureUUID, properties: [.notify], value: nil, permissions: [.readable])
        //
        //               // 혈압 기능 특성
        //               let bloodPressureFeatureUUID = CBUUID(string: "2A49") // 혈압 기능 특성 UUID
        //               let bloodPressureFeatureData = Data([0x00]) // 혈압 기능 데이터 예시
        //               bloodPressureFeatureCharacteristic = CBMutableCharacteristic(type: bloodPressureFeatureUUID, properties: [.read], value: bloodPressureFeatureData, permissions: [.readable])
        //
        //               bloodPressureService.characteristics = [bloodPressureMeasurementCharacteristic, intermediateCuffPressureCharacteristic, bloodPressureFeatureCharacteristic].compactMap { $0 }
        //               peripheralManager?.add(bloodPressureService) // 서비스 추가
        
        
        
        //        let locationServiceUUID = CBUUID(string: "1819") // 위치 및 내비게이션 서비스 UUID
        //        let locationService = CBMutableService(type: locationServiceUUID, primary: true) // 위치 및 내비게이션 서비스를 정의
        //
        //        // 위치 및 속도 특성
        //        let locationAndSpeedUUID = CBUUID(string: "2A67") // 위치 및 속도 특성 UUID
        //        locationAndSpeedCharacteristic = CBMutableCharacteristic(type: locationAndSpeedUUID, properties: [.notify], value: nil, permissions: [.readable])
        //
        //        // 내비게이션 특성
        //        let navigationUUID = CBUUID(string: "2A68") // 내비게이션 특성 UUID
        //        navigationCharacteristic = CBMutableCharacteristic(type: navigationUUID, properties: [.notify], value: nil, permissions: [.readable])
        //
        //        // 위치 품질 특성
        //        let positionQualityUUID = CBUUID(string: "2A69") // 위치 품질 특성 UUID
        //        let positionQualityData = Data([0x00]) // 위치 품질 데이터 예시
        //        positionQualityCharacteristic = CBMutableCharacteristic(type: positionQualityUUID, properties: [.read], value: positionQualityData, permissions: [.readable])
        //
        //        locationService.characteristics = [locationAndSpeedCharacteristic, navigationCharacteristic, positionQualityCharacteristic].compactMap { $0 }
        //        peripheralManager?.add(locationService) // 서비스 추가
        
        
        startAdvertising()
    }
    
    func startAdvertising() { //광고 시작
        let advertisementData: [String: Any] = [
            CBAdvertisementDataLocalNameKey: "MyHIDDevice",
            CBAdvertisementDataServiceUUIDsKey: [CBUUID(string: "1812")]
            
            //                        CBAdvertisementDataLocalNameKey: "MyHeartRateDevice",
            //                        CBAdvertisementDataServiceUUIDsKey: [CBUUID(string: "180D")]
            
            //            CBAdvertisementDataLocalNameKey: "MyDeviceInfo",
            //            CBAdvertisementDataServiceUUIDsKey: [CBUUID(string: "180A")]
            
            //            CBAdvertisementDataLocalNameKey: "MyBatteryDevice",
            //            CBAdvertisementDataServiceUUIDsKey: [CBUUID(string: "180F")]
            
            //            CBAdvertisementDataLocalNameKey: "MyThermometerDevice",
            //            CBAdvertisementDataServiceUUIDsKey: [CBUUID(string: "1809")]
            
            //            CBAdvertisementDataLocalNameKey: "MyBloodPressureDevice",
            //                        CBAdvertisementDataServiceUUIDsKey: [CBUUID(string: "1810")]
            
            //            CBAdvertisementDataLocalNameKey: "MyLocationDevice",
            //            CBAdvertisementDataServiceUUIDsKey: [CBUUID(string: "1819")]
            
            
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
        //        guard let reportCharacteristic = reportCharacteristic else { return }
        //        peripheralManager?.updateValue(data, for: reportCharacteristic, onSubscribedCentrals: nil) //아스키코드 전송
        print("코드 전송 \(data)")
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

