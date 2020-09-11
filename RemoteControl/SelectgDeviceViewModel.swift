//
//  SelectgDeviceViewModel.swift
//  RemoteControl
//
//  Created by Jean-Francois Demers on 2020-09-11.
//  Copyright © 2020 Jean-Francois Demers. All rights reserved.
//

import Foundation

class DeviceViewModel: ObservableObject {
    var device: Device?
    
    init() {
        
    }
    
    init(device: Device) {
        self.device = device
    }
    
    var name: String {
        if let device = device {
            return device.name
        } else {
            return "Unknown"
        }
    }
    
    func setAxis1(x: Int8, y: Int8) {
        if let device = device {
            
        }
    }
}

class SelectDeviceViewModel: ObservableObject {
    @Published var selectedDevice: Device?
    
    func devices() -> [DeviceViewModel] {
        return BLEController.defaultController.deviceList.map { d in return DeviceViewModel(device: d) }
    }
}
