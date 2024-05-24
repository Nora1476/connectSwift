//
//  DiscoveryListener.swift
//  connectSwift
//
//  Created by BonghuiJo on 5/24/24.
//

import Foundation
import ConnectSDK
import CoreLocation
import NetworkExtension


class DiscoveryListener: NSObject, ObservableObject, DiscoveryManagerDelegate, CLLocationManagerDelegate {
    private var discoveryManager: DiscoveryManager?
    private var locationManager: CLLocationManager!
    
    @Published var devices: [ConnectableDevice] = [] // 디바이스 목록을 저장수
    
    override init() {
        super.init()
        initialize()
    }
    
    //위치권한 허용
    private func setupLocationManager() {
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
    }
    // 위치권한 권한허용 요청
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            print("Location access granted.")
        } else {
            print("Location access denied.")
        }
    }
    
    func initialize() {
        setupLocationManager()
        
        discoveryManager = DiscoveryManager.shared()
        discoveryManager?.delegate = self
        discoveryManager?.pairingLevel = DeviceServicePairingLevelOn
        
        print("initialize")
    }
    
    func startScan() {
        discoveryManager?.startDiscovery()
//        discoveryManager?.devicePicker()
        print("디바이스 스캔 시작")
    }
    
    
     // DiscoveryManagerDelegate methods
     func discoveryManager(_ manager: DiscoveryManager!, didFind device: ConnectableDevice!) {
         print("onDeviceAdded: \(String(describing: device))")
         devices.append(device)
     }
     
     func discoveryManager(_ manager: DiscoveryManager!, didUpdate device: ConnectableDevice!) {
         print("onDeviceUpdated: \(String(describing: device))")
         if let index = devices.firstIndex(of: device) {
             devices[index] = device
         }
     }
    func discoveryManager(_ manager: DiscoveryManager!, didLose device: ConnectableDevice!) {
        print("onDeviceRemoved: \(String(describing: device))")
        devices.removeAll { $0 == device }
    }
    func discoveryManager(_ manager: DiscoveryManager!, discoveryFailed error: Error!) {
        print("onDiscoveryFailed: \(String(describing: error))")
    }
}
