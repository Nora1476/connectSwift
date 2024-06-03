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
    @Published var isScanning: Bool = false

    override init() {
        super.init()
        setupLocationManager()
        initialize()
    }
    
    //위치 권한
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
        discoveryManager = DiscoveryManager.shared()
        discoveryManager?.pairingLevel = DeviceServicePairingLevelOn
        discoveryManager?.delegate = self

        print("discoveryManager 초기화")
    }
    
    func startScan() {
        guard !isScanning else { return }
        self.isScanning = true
        
        discoveryManager?.stopDiscovery()
        discoveryManager?.startDiscovery()
        print("디바이스 스캔 시작")
        
        DispatchQueue.main.async{
            self.devices.removeAll()
        }
    }
    
    func stopScan() {
        discoveryManager?.stopDiscovery()
        self.isScanning = false
        
        print("디바이스 스캔 중지")
    }

    func connectToDevice(_ device: ConnectableDevice) {
        stopScan()
        webOSTVService.initialize(device: device)
    }
    
    func disconnectFromDevice(_ device: ConnectableDevice) {
        DispatchQueue.main.async {
            self.devices.removeAll { $0 == device }
            self.deviceCount = self.devices.count
            self.discoveryManager?.deviceStore.removeAll()
            print("disconnectFromDevice 디바이스 연결 해제: \(String(describing: device.friendlyName))")
        }
    }

    // DiscoveryManagerDelegate methods
    func discoveryManager(_ manager: DiscoveryManager!, didFind device: ConnectableDevice!) {
        DispatchQueue.main.async {
            guard !self.devices.contains(device) else { return }//중복방지
            print("onDeviceAdded: \(String(describing: device.friendlyName))")
            self.devices.append(device)
            self.deviceCount = self.devices.count
            print("현재 디바이스 수: \(self.deviceCount)")
        }
    }
    func discoveryManager(_ manager: DiscoveryManager!, didUpdate device: ConnectableDevice!) {
        DispatchQueue.main.async {
            print("onDeviceUpdated: \(String(describing: device.friendlyName)) \(String(describing: device.services))")
            if let index = self.devices.firstIndex(of: device) {
                self.devices[index] = device
            }
        }
    }
    func discoveryManager(_ manager: DiscoveryManager!, didLose device: ConnectableDevice!) {
        DispatchQueue.main.async {
            print("onDeviceRemoved: \(String(describing: device.friendlyName))")
            self.devices.removeAll { $0 == device }
            self.deviceCount = self.devices.count
            print("현재 디바이스 수: \(self.deviceCount)")
        }
    }
    func discoveryManager(_ manager: DiscoveryManager!, discoveryFailed error: Error!) {
        DispatchQueue.main.async {
            print("onDiscoveryFailed: \(String(describing: error))")
            self.isScanning = false // 스캔 실패 시
        }
    }
}
