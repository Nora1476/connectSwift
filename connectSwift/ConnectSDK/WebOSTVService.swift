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
   
    
    @Published var isConnected: Bool = false //연결상태
    
    func initialize(device: ConnectableDevice) {
        mDevice = device
        mDevice?.delegate = self

        
//        webOSService = mDevice?.service(withName: "WebOSWervice") as? WebOSTVService
        mDevice?.setPairingType(DeviceServicePairingTypePinCode)
        
        mDevice?.connect()
        DispatchQueue.main.async {
            self.isConnected = true
            print(self.isConnected)
        }
        
        print("연결 시도")
        print("connectedService : \(String(describing: mDevice?.connectedServiceNames()))")
        print("requiresPairing : \(String(describing: deviceService?.requiresPairing))")
    }
    
    func disConnect(){
        mDevice?.disconnect()
        deviceService?.disconnect()
        
        
        DispatchQueue.main.async{
            self.isConnected = false
            
        }
    }
    
    
    //기기 컨트롤 매서드
    func volumeUp(){
        mDevice?.volumeControl().volumeUp(success: { _ in
        print("volume up")
        }, failure: { error in
            print("volume up error \(String(describing: error))")
        })
    }
    func volumeDown(){
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
    func mouseLeft(){
        mDevice?.mouseControl().move(CGVector.init(dx: -10, dy: 0)
                                     , success: { _ in print("move left success")}
                                     , failure: { error in print("fail\(String(describing:error?.localizedDescription))")
        })
    }
    func mouseRight(){
        mDevice?.mouseControl().move(CGVector.init(dx: +10, dy: 0)
                                     , success: { _ in print("move right success")}
                                     , failure: { error in print("fail\(String(describing:error?.localizedDescription))")
        })
    }
    func keyHome(){
        mDevice?.keyControl().home(success: { _ in
            print("key Home")
        }, failure: { error in
            print("key home \(String(describing: error))")
        })
    }
    func keyLeft(){
        mDevice?.keyControl().left(success: { _ in
            print("key left")
        }, failure: { error in
            print("key left \(String(describing: error))")
        })
    }
    func keyRight(){
        mDevice?.keyControl().right(success: { _ in
            print("key right")
        }, failure: { error in
            print("key right \(String(describing: error))")
        })
    }
    func inputText(){
        mDevice?.textInputControl().sendText("h"
                                             , success: { _ in print("success")}
                                             , failure: {error in print("fail\(String(describing:error?.localizedDescription))")})
    }
    
    
    
    // ConnectableDeviceDelegate 매서드
    func connectableDeviceConnectionRequired(_ device: ConnectableDevice!, for service: DeviceService!) {
        print("ServiceID \(String(describing: service.serviceDescription.serviceId))")
    }
    func connectableDevice(_ device: ConnectableDevice!, service: DeviceService!, pairingRequiredOfType pairingType: Int32, withData pairingData: Any!) {
        print("ServiceID: \(device.friendlyName ?? "Unknown Device")")
    }
    func connectableDeviceReady(_ device: ConnectableDevice!) { //기기 연결 준비되었을 때
        print("Connected tooo: \(device.friendlyName ?? "Unknown Device")")
    }
    func connectableDeviceDisconnected(_ device: ConnectableDevice!, withError error: Error!) { //기기와 연결 끊어졌을 때
        if let e = error {
            print("Disconnected from \(device.friendlyName ?? "Unknown Device"): \(e.localizedDescription)")
        }
    }

    
    // DeviceServiceDelegate 매서드
    func deviceServiceConnectionRequired(_ service: DeviceService!) { // 서비스 연결 필요할 때
        print("Connection required for service: \(service.serviceDescription?.serviceId ?? "Unknown Service ID")")
    }
    
    func deviceServiceConnectionSuccess(_ service: DeviceService!) {   //서비스에 성공적으로 연결되었을 때
        print("Connected to \(service.serviceDescription?.friendlyName ?? "Unknown Device")")
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
    }
    func deviceServicePairingSuccess(_ service: DeviceService!) { //서비스 페어링 완료되었을때
        print("Pairing success for service: \(service.serviceDescription?.friendlyName ?? "Unknown Device")")
    }
    func deviceService(_ service: DeviceService!, pairingFailedWithError error: Error!) { //페어링 실패했을때
        print("Pairing failed with error: \(error.localizedDescription)")
    }
    
}
