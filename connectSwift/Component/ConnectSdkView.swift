//
//  connectSDK.swift
//  connectSwift
//
//  Created by BonghuiJo on 5/20/24.
//

import SwiftUI
import ConnectSDK

struct ConnectSdkView: View {
    var webOsService : WebOSTVService?
    var device : ConnectableDevice?

    var body: some View {
        VStack {
            HStack {
                Text("connectSDK Test")
                    .font(.title2)
                    .padding()
                Spacer()
            }
            Spacer()

        }
        .navigationTitle("ConnectSDK View")
    }
}

#Preview {
    ConnectSdkView()
}
