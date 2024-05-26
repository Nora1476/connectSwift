//
//  ContentView.swift
//  connectSwift
//
//  Created by BonghuiJo on 5/20/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var themeSettings: ThemeSettings
    
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
                
                //
                VStack(spacing: 20) {
                    Button(action: {
                        themeSettings.isDarkMode.toggle()
                    }) {
                        Text("Toggle Theme")
                            .padding()
                            .background(themeSettings.isDarkMode ? Color.darkBtn1 : Color.lightBtn1)
                            .cornerRadius(10)
                            .foregroundColor(themeSettings.isDarkMode ? Color.darkIconText : Color.lightIconText)
                    }

                    NeumorphismButton(text: "LT")
                    NeumorphismButton(text: "RT")
                    
                    HStack(spacing:20) {
                        NeumorphismButton(text: "LTS", width: 60,height: 60)
                        NeumorphismButton(text: "RTS", width: 60,height: 60)
                    }
                }
                .padding()
                
            
            }
            .padding()
            .background(themeSettings.isDarkMode ? Color.darkBg.edgesIgnoringSafeArea(.all) : Color.lightBg.edgesIgnoringSafeArea(.all))
            
        }
        
    }
}

#Preview {
    ContentView()
}

