//
//  DevicePicker.swift
//  connectSwift
//
//  Created by BonghuiJo on 5/24/24.
//

import Foundation
import ConnectSDK
import CoreLocation
import NetworkExtension

class DevicePickerManager : NSObject, ObservableObject, CLLocationManagerDelegate, DevicePickerDelegate, ConnectableDeviceDelegate, DiscoveryManagerDelegate {
    
    // ConnectableDevice 객체의 상태 변화를 알리기 위한 Published 속성
    @Published var connectedDevice: ConnectableDevice?
    @Published var showError = false
    @Published var errorMessage = ""
    
    private var locationManager: CLLocationManager!
    private var discoveryManager: DiscoveryManager
    private var devicePicker: DevicePicker?
    
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
    
    override init() {
        self.discoveryManager = DiscoveryManager.shared()
        super.init()
        
        // DiscoveryManager의 대리자를 self로 설정
        self.discoveryManager.delegate = self
    }
    
    // 장치 검색을 시작하는 메서드
       func startDiscovery() {
           devicePicker = DevicePicker()
           // 적절한 UIWindowScene을 찾아서 거기서 윈도우를 가져옴
           if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first?.rootViewController {
               devicePicker?.show(rootViewController)
               print("검색 시작")
           } else {
               print("No available window scene found.")
           }
       }
    
    // 장치 선택 시
    func devicePicker(_ picker: DevicePicker!, didSelect device: ConnectableDevice!) {
        self.connectedDevice = device
        self.connectedDevice?.delegate = self
        self.connectedDevice?.connect()
    }
    
    // 장치가 준비되었을 때
    func connectableDeviceReady(_ device: ConnectableDevice!) {
        DispatchQueue.main.async {
            self.connectedDevice = device
        }
    }
    
    // 메서드: 장치가 연결이 해제되었을 때
    func connectableDeviceDisconnected(_ device: ConnectableDevice!, withError error: Error!) {
        DispatchQueue.main.async {
            self.connectedDevice = nil
            self.showError = true
            self.errorMessage = "Device disconnected: \(error.localizedDescription)"
        }
    }
    
    //장치의 기능이 변경되었을 때
    func connectableDevice(_ device: ConnectableDevice!, capabilitiesAdded added: [Any]!, removed: [Any]!) {
        // 기능 변경 처리
    }
    
    //메서드: 장치와의 페어링이 성공했을 때
    func connectableDevice(_ device: ConnectableDevice!, pairSuccess pairingType: Any!) {
        // 페어링 성공 처리
    }
    
    // 장치와의 페어링이 실패했을 때
    func connectableDevice(_ device: ConnectableDevice!, pairFailed error: Error!) {
        DispatchQueue.main.async {
            self.showError = true
            self.errorMessage = "Pairing failed: \(error.localizedDescription)"
        }
    }
    
    // 장치 연결을 해제하는 메서드
    func disconnectDevice() {
        connectedDevice?.disconnect()
        connectedDevice = nil
    }
}
