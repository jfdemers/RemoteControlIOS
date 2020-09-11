//
//  SelectDeviceView.swift
//  RemoteControl
//
//  Created by Jean-Francois Demers on 2020-09-10.
//  Copyright © 2020 Jean-Francois Demers. All rights reserved.
//

import SwiftUI

struct SelectDeviceView: View {
    @ObservedObject var bleController = BLEController.defaultController
    
    var body: some View {
        VStack {
            List {
                ForEach(self.bleController.deviceList) { device in
                    NavigationLink(destination: RemoteControlView()) {
                    if (device.peripheral.name != nil) {
                        Text(device.peripheral.name!)
                    } else {
                        Text("Unknown")
                    }
                    }
                }
            }
        }
    .navigationBarTitle("Device Selection")
    }
}

struct SelectDeviceView_Previews: PreviewProvider {
    static var previews: some View {
        SelectDeviceView()
    }
}
