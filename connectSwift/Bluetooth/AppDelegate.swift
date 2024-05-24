//
//  AppDelegate.swift
//  connectSwift
//
//  Created by BonghuiJo on 5/23/24.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    var window: NSWindow!
    var bluetoothHIDManager: BluetoothHIDManager!
    var centralManager: CentralManager!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // App 초기화 시 BluetoothHIDManager와 CentralManager 인스턴스를 생성합니다.
        bluetoothHIDManager = BluetoothHIDManager()
        centralManager = CentralManager()

        // 윈도우를 생성하고 초기화합니다.
        window = NSWindow(
            contentRect: NSMakeRect(0, 0, 480, 270),
            styleMask: [.titled, .closable, .resizable, .miniaturizable],
            backing: .buffered,
            defer: false)
        window.center()
        window.title = "Bluetooth HID Example"
        window.makeKeyAndOrderFront(nil)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // App 종료 시 필요한 정리 작업을 수행합니다.
    }
}

