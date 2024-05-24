//
//  webOSTVService.swift
//  connectSwift
//
//  Created by BonghuiJo on 5/23/24.
//

import Foundation
import ConnectSDK


class WebOSTVService:NSObject{
    private var mDevice: ConnectableDevice?
    private var webOSService: WebOSTVService?
    
    func initialize(device: ConnectableDevice){
        mDevice = device
        device.setPairingType(DeviceServicePairingTypeNone)
    }
    
    
    
    
}



