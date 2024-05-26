//
//  DiscoveryDeviceTest.swift
//  connectSwift
//
//  Created by BonghuiJo on 5/26/24.
//

import Foundation
import Combine

class DiscoveryManager: NSObject, ObservableObject, NetServiceBrowserDelegate, NetServiceDelegate {
    static let shared = DiscoveryManager()

    private let serviceBrowser = NetServiceBrowser()
    @Published var services = [NetService]()

    private override init() {
        super.init()
        serviceBrowser.delegate = self
    }

    func startDiscovery() {
        services.removeAll()
        serviceBrowser.searchForServices(ofType: "_http._tcp.", inDomain: "")
        print("Discovery started")
    }

    func stopDiscovery() {
        serviceBrowser.stop()
        print("Discovery stopped")
    }

    // NetServiceBrowserDelegate methods
    func netServiceBrowser(_ browser: NetServiceBrowser, didFind service: NetService, moreComing: Bool) {
        services.append(service)
        service.delegate = self
        service.resolve(withTimeout: 5.0)
    }

    func netServiceBrowser(_ browser: NetServiceBrowser, didRemove service: NetService, moreComing: Bool) {
        if let index = services.firstIndex(of: service) {
            services.remove(at: index)
        }
    }

    // NetServiceDelegate methods
    func netServiceDidResolveAddress(_ sender: NetService) {
        if let hostName = sender.hostName {
            print("Resolved service: \(hostName)")
            objectWillChange.send() // UI 업데이트 트리거
        }
    }

    func netService(_ sender: NetService, didNotResolve errorDict: [String : NSNumber]) {
        print("Failed to resolve service: \(sender), error: \(errorDict)")
    }
}
