//
//  webOSTVService.swift
//  connectSwift
//
//  Created by BonghuiJo on 5/23/24.
//

import Foundation
import ConnectSDK

class WebOSTVService: NSObject, ObservableObject, ConnectableDeviceDelegate, DeviceServiceDelegate {
    @Published var connectionStatus: String = ""
    private var mDevice: ConnectableDevice?
    
    func initialize(device: ConnectableDevice) {
        mDevice = device
        mDevice?.setPairingType(DeviceServicePairingTypeNone) 
        mDevice?.delegate = self
        mDevice?.connect()
    }
    
    // ConnectableDeviceDelegate methods
    func connectableDeviceReady(_ device: ConnectableDevice!) {
        connectionStatus = "Connected to \(device.friendlyName ?? "Unknown Device")"
        print(connectionStatus)
    }

    func connectableDeviceDisconnected(_ device: ConnectableDevice!, withError error: Error!) {
        connectionStatus = "Disconnected from \(device.friendlyName ?? "Unknown Device"): \(error.localizedDescription)"
        print(connectionStatus)
    }

    func connectableDevice(_ device: ConnectableDevice!, capabilitiesAdded added: [Any]!, removed: [Any]!) {
        print("Capabilities changed for \(device.friendlyName ?? "Unknown Device")")
    }

    // DeviceServiceDelegate methods (새로 추가됨)
    func deviceServiceConnectionRequired(_ service: DeviceService!) {
        print("Connection required for service: \(service.serviceDescription?.serviceId ?? "Unknown Service ID")")
    }

    func deviceServiceConnectionSuccess(_ service: DeviceService!) {
        connectionStatus = "Connected to \(service.serviceDescription?.friendlyName ?? "Unknown Device")"
        print(connectionStatus)
    }

    func deviceService(_ service: DeviceService!, capabilitiesAdded added: [Any]!, removed: [Any]!) {
        print("Capabilities changed for service: \(service.serviceDescription?.friendlyName ?? "Unknown Device")")
    }

    private func deviceService(_ service: DeviceService!, connectedWithError error: Error!) {
        if let error = error {
            connectionStatus = "Disconnected with error: \(error.localizedDescription)"
            print(connectionStatus)
        } else {
            connectionStatus = "Disconnected"
            print(connectionStatus)
        }
    }

    func deviceService(_ service: DeviceService!, didFailConnectWithError error: Error!) {
        connectionStatus = "Connection failed with error: \(error.localizedDescription)"
        print(connectionStatus)
    }

    func deviceService(_ service: DeviceService!, pairingRequiredOf pairingType: DeviceServicePairingType, withData pairingData: Any!) {
        print("Pairing required for service: \(service.serviceDescription?.friendlyName ?? "Unknown Device")")
    }

    func deviceServicePairingSuccess(_ service: DeviceService!) {
        connectionStatus = "Pairing success for service: \(service.serviceDescription?.friendlyName ?? "Unknown Device")"
        print(connectionStatus)
    }

    func deviceService(_ service: DeviceService!, pairingFailedWithError error: Error!) {
        connectionStatus = "Pairing failed with error: \(error.localizedDescription)"
        print(connectionStatus)
    }
}
