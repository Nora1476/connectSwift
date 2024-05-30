//
//  DiscoveryListener.swift
//  connectSwift
//
//  Created by BonghuiJo on 5/24/24.
//

import Foundation
import ConnectSDK
import CoreLocation
import SwiftUI

class DiscoveryListener: NSObject, ObservableObject, DiscoveryManagerDelegate, CLLocationManagerDelegate {
    private var discoveryManager: DiscoveryManager?
    private var locationManager: CLLocationManager!
    
    @Published var webOSTVService = WebOSTVService()
    @Published var devices: [ConnectableDevice] = []
    @Published var deviceCount: Int = 0

    override init() {
        super.init()
        initialize()
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


    func initialize() {
        setupLocationManager()
        
        discoveryManager = DiscoveryManager.shared()
        discoveryManager?.pairingLevel = DeviceServicePairingLevelOn
        discoveryManager?.delegate = self

        print("initialize")
    }
    
    func startScan() {
        devices.removeAll()
        discoveryManager?.startDiscovery()
        print("디바이스 스캔 시작")
    }
    
    func stopScan() {
        discoveryManager?.stopDiscovery()
        print("디바이스 스캔 중지")
    }

    func connectToDevice(_ device: ConnectableDevice) {
        webOSTVService.initialize(device: device)
    }

    
    // DiscoveryManagerDelegate methods
    func discoveryManager(_ manager: DiscoveryManager!, didFind device: ConnectableDevice!) {
//        DispatchQueue.main.async {
//        }
            print("onDeviceAdded: \(String(describing: device.friendlyName))")
            self.devices.append(device)
            self.deviceCount = self.devices.count
            print("현재 디바이스 수: \(self.deviceCount)")
    }

    func discoveryManager(_ manager: DiscoveryManager!, didUpdate device: ConnectableDevice!) {
        print("onDeviceUpdated: \(String(describing: device.friendlyName))\(String(describing: device.services)) ")
        if let index = devices.firstIndex(of: device) {
            devices[index] = device
        }
    }

    func discoveryManager(_ manager: DiscoveryManager!, didLose device: ConnectableDevice!) {
        print("onDeviceRemoved: \(String(describing: device.friendlyName))")
        devices.removeAll { $0 == device }
        deviceCount = devices.count
        print("현재 디바이스 수: \(deviceCount)")
    }

    func discoveryManager(_ manager: DiscoveryManager!, discoveryFailed error: Error!) {
        print("onDiscoveryFailed: \(String(describing: error))")
    }
    
    
    
}
