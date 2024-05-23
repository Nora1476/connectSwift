//
//  webOSTVService.swift
//  connectSwift
//
//  Created by BonghuiJo on 5/23/24.
//

import Foundation
import ConnectSDK


class WebOSTVService:NSObject, ConnectableDeviceDelegate{
    private var device: ConnectableDevice?
    private var webOSService: WebOSTVService?
    
    func initialize(device: ConnectableDevice){

    }
    
    func connectableDeviceReady(_ device: ConnectableDevice!) {
        print("Device is ready")
        <#code#>
    }
    
    func connectableDeviceDisconnected(_ device: ConnectableDevice!, withError error: (any Error)!) {
        print("Device disconnected: \(String(describing: error))")
        <#code#>
    }
}


