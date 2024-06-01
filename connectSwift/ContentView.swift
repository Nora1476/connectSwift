//
//  ContentView.swift
//  connectSwift
//
//  Created by BonghuiJo on 5/20/24.
//

import SwiftUI
import ConnectSDK

struct ContentView: View {
    //메인화면 버튼
    func mainBtn(text: String)-> some View {
        Text(text)
            .font(.callout)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
    }
   var body: some View {
        NavigationView {
            VStack(alignment:.leading) {
                Text("Conectivity")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.bottom, 20)
                HStack {
                    NavigationLink(destination: ConnectSdkView()) {
                        mainBtn(text: "ConnectSDK")
                    }
                }
                HStack{
                    NavigationLink(destination: BluetoothBle()) {
                        mainBtn(text: "BluetoothBLE")
                    }
                    NavigationLink(destination: BluetoothHid()){
                        mainBtn(text: "BluetoothHID")
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

