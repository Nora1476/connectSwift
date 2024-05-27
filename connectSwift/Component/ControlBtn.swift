//
//  ControlBtn.swift
//  connectSwift
//
//  Created by BonghuiJo on 5/27/24.
//

import SwiftUI

struct ControlBtn: View {
    var body: some View {
        VStack {
            Text("Control Buttons")
            Button(action: {
            }) {
                Text("Volume Up")
            }
        }
        .navigationTitle("Control")
    }
}

#Preview {
    ControlBtn()
}
