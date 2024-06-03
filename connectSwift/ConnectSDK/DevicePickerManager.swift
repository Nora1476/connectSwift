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

class DevicePickerManager: NSObject, ObservableObject, CLLocationManagerDelegate, DevicePickerDelegate, DiscoveryManagerDelegate, ConnectableDeviceDelegate {
    
    private var discoveryManager: DiscoveryManager?
    private var locationManager: CLLocationManager!
 
    @Published var devices: [ConnectableDevice] = []
    @Published var selectedDevice: ConnectableDevice?
//    @Published var webOSTVService = WebOSTVService()

    
    override init() {
        super.init()
        setupLocationManager()
        
        discoveryManager = DiscoveryManager.shared()
        discoveryManager?.pairingLevel = DeviceServicePairingLevelOn
        discoveryManager?.delegate = self
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
        discoveryManager?.stopDiscovery()
        discoveryManager?.startDiscovery()
        
        print("Device Picker")
    }
    

    
    //DevicePicker 동작
    func devicePicker(_ picker: DevicePicker!, didSelect device: ConnectableDevice!) {
        selectedDevice = device
        selectedDevice?.delegate = self
        
        selectedDevice?.setPairingType(DeviceServicePairingTypePinCode)
        selectedDevice?.connect()
        
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
       
    
    
    
    
    //기기 컨트롤
    func volumeUp() {
           guard let device = selectedDevice else {
               print("No device selected")
               return
           }
           
           guard let volumeControl = device.volumeControl() else {
               print("No volume control available on the selected device")
               return
           }
           
           volumeControl.volumeUp(success: { _ in
               print("Volume up successful")
           }, failure: { error in
               print("Volume up error: \(String(describing: error))")
           })
       }
    func volumeDown(){
        selectedDevice?.volumeControl().volumeDown(success: { _ in
            print("volume Down")
        }, failure: { error in
            print("volume Down error \(String(describing: error))")
        })
    }
    func mouseClick(){
        selectedDevice?.mouseControl().click(success: { _ in
            print("click success")
        }, failure: { error in
            print("click error \(String(describing: error))")
        })
    }
    func keyHome(){
        selectedDevice?.keyControl().home(success: { _ in
            print("key Home")
        }, failure: { error in
            print("key home \(String(describing: error))")
        })
    }
    

}
