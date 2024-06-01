//
//  DevicePickerView.swift
//  connectSwift
//
//  Created by BonghuiJo on 6/1/24.
//

import SwiftUI
import ConnectSDK


struct DevicePickerView: UIViewControllerRepresentable {
    @ObservedObject var devicePickerManager: DevicePickerManager
    
    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        DispatchQueue.main.async {
            if let picker = DiscoveryManager.shared().devicePicker() { //DevicePicker 인스턴스를 가져옵
                picker.delegate = devicePickerManager //DevicePicker의 델리게이트 DevicePickerManager로 설정
                picker.show(viewController)
            }
        }
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}
