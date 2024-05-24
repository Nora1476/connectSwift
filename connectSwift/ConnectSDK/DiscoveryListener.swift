//
//  DiscoveryListener.swift
//  connectSwift
//
//  Created by BonghuiJo on 5/24/24.
//

import Foundation
import ConnectSDK
class DiscoveryListener: NSObject, ObservableObject, DiscoveryManagerDelegate {
    private var discoveryManager: DiscoveryManager?
    
    override init() {
        super.init()
        initialize()
    }
    
    func initialize() {
        discoveryManager = DiscoveryManager.shared()
        discoveryManager?.delegate = self
        discoveryManager?.pairingLevel = DeviceServicePairingLevelOn
    }
    
    func startScan() {
        discoveryManager?.startDiscovery()
        print("디바이스 스캔 시작")
    }
    
    // DiscoveryManagerDelegate methods
    func discoveryManager(_ manager: DiscoveryManager!, didFind device: ConnectableDevice!) {
        print("onDeviceAdded: \(String(describing: device))")
    }
    func discoveryManager(_ manager: DiscoveryManager!, didUpdate device: ConnectableDevice!) {
        print("onDeviceUpdated: \(String(describing: device))")
    }
    func discoveryManager(_ manager: DiscoveryManager!, didLose device: ConnectableDevice!) {
        print("onDeviceRemoved: \(String(describing: device))")
    }
    func discoveryManager(_ manager: DiscoveryManager!, discoveryFailed error: Error!) {
        print("onDiscoveryFailed: \(String(describing: error))")
    }
}
