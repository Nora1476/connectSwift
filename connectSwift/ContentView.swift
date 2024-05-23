//
//  ContentView.swift
//  connectSwift
//
//  Created by BonghuiJo on 5/20/24.
//

import SwiftUI
import ConnectSDK

struct ContentView: View {
    var webOsService : WebOSTVService?
    var device : ConnectableDevice?
    
    var body: some View {
        NavigationView {
            VStack(alignment:.leading) {
                Text("Conectivity")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.bottom, 20)
                HStack {
                    NavigationLink(destination: ConnectSdkView()) {
                        Text("ConnectSDK")
                            .font(.callout)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                HStack{
                    NavigationLink(destination: BluetoothBle()) {
                        Text("BluetoothBLE")
                            .font(.callout)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    NavigationLink(destination: BluetoothHid()){
                        Text("BluetoothHID")
                            .font(.callout)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                Spacer()
            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
}

