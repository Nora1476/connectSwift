//
//  DevicePicker.swift
//  connectSwift
//
//  Created by BonghuiJo on 5/24/24.
//
import Foundation
import ConnectSDK
import CoreLocation
import SwiftUI

class DevicePickerManager: NSObject, ObservableObject, CLLocationManagerDelegate, DevicePickerDelegate, DiscoveryManagerDelegate {
    
    private var locationManager: CLLocationManager!
 
    @Published var devices: [ConnectableDevice] = []
    @Published var selectedDevice: ConnectableDevice?
    @Published var showPicker: Bool = false
//    @Published var webOSTVService = WebOSTVService()

    
    override init() {
        super.init()
        setupLocationManager()
        DiscoveryManager.shared().delegate = self
        DiscoveryManager.shared().startDiscovery()
    }
    
    private func setupLocationManager() {
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            print("Location access granted.")
        } else {
            print("Location access denied.")
        }
    }
    
    func showDevicePicker() {
        print("Device Picker")
        DispatchQueue.main.async {
            self.showPicker = true
        }
    }
    
    
    //기기 컨트롤
    func volumeUp(){
        selectedDevice?.volumeControl().volumeUp(success: { _ in
        }, failure: { error in
            print("volume up error \(String(describing: error))")
        })
    }
    func volumeDown(){
        selectedDevice?.volumeControl().volumeDown(success: { _ in
            print("volume Down")
        }, failure: { error in
            print("volume Down error \(String(describing: error))")
        })
    }
    
    
    //DevicePicker 동작
    func devicePicker(_ picker: DevicePicker!, didSelect device: ConnectableDevice!) {
        device.setPairingType(DeviceServicePairingTypePinCode)
        device.connect()
        self.showPicker = false
        
        print("연결 시도")
    }
    
    
    // DiscoveryManagerDelegate 메서드
    func discoveryManager(_ manager: DiscoveryManager!, didFind device: ConnectableDevice!) {
        DispatchQueue.main.async {
            self.devices.append(device)
        }
    }
    func discoveryManager(_ manager: DiscoveryManager!, didLose device: ConnectableDevice!) {
        DispatchQueue.main.async {
            if let index = self.devices.firstIndex(where: { $0.id == device.id }) {
                self.devices.remove(at: index)
            }
        }
    }
    func discoveryManager(_ manager: DiscoveryManager!, didUpdate device: ConnectableDevice!) {
        DispatchQueue.main.async {
            print("onDeviceUpdated Service: \(String(describing: device.services))")
            if let index = self.devices.firstIndex(where: { $0.id == device.id }) {//중복방지
                self.devices[index] = device
            }
        }
    }
    
    // ConnectableDeviceDelegate 메서드 구현
       func connectableDeviceReady(_ device: ConnectableDevice!) {
           print("Device is ready: \(device.friendlyName ?? "Unknown")")
       }
       func connectableDeviceDisconnected(_ device: ConnectableDevice!, withError error: Error!) {
           print("Device disconnected: \(device.friendlyName ?? "Unknown"), error: \(error?.localizedDescription ?? "No error")")
       }
       func connectableDevice(_ device: ConnectableDevice!, pairingRequiredOfType pairingType: DeviceServicePairingType, withData pairingData: [AnyHashable : Any]!) {
           if pairingType == DeviceServicePairingTypePinCode {
               DispatchQueue.main.async {
                  print("Pincode 입력필요")
               }
           }
       }
       

}
