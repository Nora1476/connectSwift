//
//  Bluetooth.swift
//  connectSwift
//
//  Created by BonghuiJo on 5/21/24.
//

import SwiftUI

struct BluetoothView: View {

    var body: some View {
        VStack {
            HStack {
                Text("Bluetooth VIew")
                    .font(.largeTitle)
                    .padding()
                Spacer()
            }
            Spacer()

        }
        .navigationTitle("Second View")
    }
}

#Preview {
    ConnectSdkView()
}
