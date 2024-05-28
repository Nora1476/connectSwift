//
//  webOSTVService.swift
//  connectSwift
//
//  Created by BonghuiJo on 5/23/24.
//

import Foundation
import ConnectSDK

class WebOSTVService: NSObject, ObservableObject, ConnectableDeviceDelegate, DeviceServiceDelegate {
    
    
    private var mDevice: ConnectableDevice?
    private var deviceService: DeviceService?
    private var webOSService : WebOSTVService?
    
    func initialize(device: ConnectableDevice) {
        mDevice = device
        mDevice?.delegate = self
        webOSService = device.services.first(where: { $0 is WebOSTVService }) as? WebOSTVService  //WebOSTVService 타입의 첫 번째 서비스를 변수에 할당
        
        mDevice?.setPairingType(DeviceServicePairingTypePinCode)
        mDevice?.connect()
        print("연결 성공")
    }
    
    
    func volumeUp(){
        //        webOSService?.volumeUp()
        mDevice?.volumeControl().volumeUp(success: { _ in
            print("volume up")
        }, failure: { error in
            print("volume up error \(String(describing: error))")
        })
    }
    func volumeDown(){
        //        webOSService?.volumeDown()
        mDevice?.volumeControl().volumeDown(success: { _ in
            print("volume Down")
        }, failure: { error in
            print("volume Down error \(String(describing: error))")
        })
    }
    func mouseClick(){
        mDevice?.mouseControl().click(success: { _ in
            print("click success")
        }, failure: { error in
            print("click error \(String(describing: error))")
        })
    }
    func keyHome(){
        //        webOSService?.keyHome()
        mDevice?.keyControl().home(success: { _ in
            print("key Home")
        }, failure: { error in
            print("key home \(String(describing: error))")
        })
    }
    
    
    
    // ConnectableDeviceDelegate 매서드
    func connectableDeviceReady(_ device: ConnectableDevice!) { //기기 연결 준비되었을 때
        print("Connected to \(device.friendlyName ?? "Unknown Device")")
        
 
    }
    
    func connectableDeviceDisconnected(_ device: ConnectableDevice!, withError error: Error!) { //기기와 연결 끊어졌을 때
        print("Disconnected from \(device.friendlyName ?? "Unknown Device"): \(error.localizedDescription)")
    }
    
    func connectableDevice(_ device: ConnectableDevice!, capabilitiesAdded added: [Any]!, removed: [Any]!) { //기기의 기능이 추가되거나 제거되었을 때
        print("Capabilities changed for \(device.friendlyName ?? "Unknown Device")")
    }
    
    // DeviceServiceDelegate 매서드
    func deviceServiceConnectionRequired(_ service: DeviceService!) { // 서비스 연결 필요할 때
        print("Connection required for service: \(service.serviceDescription?.serviceId ?? "Unknown Service ID")")
    }
    
    func deviceServiceConnectionSuccess(_ service: DeviceService!) {   //서비스에 성공적으로 연결되었을 때
        print("Connected to \(service.serviceDescription?.friendlyName ?? "Unknown Device")")
    }
    
    func deviceService(_ service: DeviceService!, capabilitiesAdded added: [Any]!, removed: [Any]!) { //서비스의 기능이 추가되거나 제거되었을 때
        print("Capabilities changed for service: \(service.serviceDescription?.friendlyName ?? "Unknown Device")")
    }
    
    func deviceService(_ service: DeviceService!, disconnectedWithError error: Error!) { //서비스 연결중 오류 발생 시
        if let error = error {
            print("Disconnected with error: \(error.localizedDescription)")
        } else {
            print("Disconnected")
        }
    }
    func deviceService(_ service: DeviceService!, didFailConnectWithError error: Error!) { //서비스 연결 시도가 실패했을 때
        print("Connection failed with error: \(error.localizedDescription)")
    }
    
    
    //페어링 관련 매서드
    func deviceService(_ service: DeviceService!, pairingRequiredOf pairingType: DeviceServicePairingType, withData pairingData: Any!) { //서비스에 페어링이 필요할 때
        print("Pairing required for service: \(service.serviceDescription?.friendlyName ?? "Unknown Device")")
        if pairingType == DeviceServicePairingTypePinCode {
            print("페어링 핀코드입력 동작: \(service.serviceDescription?.friendlyName ?? "Unknown Device")")
        }
    }
    func deviceServicePairingSuccess(_ service: DeviceService!) { //서비스 페어링 완료되었을때
        print("Pairing success for service: \(service.serviceDescription?.friendlyName ?? "Unknown Device")")
    }
    func deviceService(_ service: DeviceService!, pairingFailedWithError error: Error!) { //페어링 실패했을때
        print("Pairing failed with error: \(error.localizedDescription)")
    }
    
}
