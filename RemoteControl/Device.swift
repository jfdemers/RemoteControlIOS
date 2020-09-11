//
//  Device.swift
//  RemoteControl
//
//  Created by Jean-Francois Demers on 2020-09-10.
//  Copyright © 2020 Jean-Francois Demers. All rights reserved.
//

import Foundation
import CoreBluetooth

class Device: NSObject, CBPeripheralDelegate, Identifiable, ObservableObject {
    @Published var serviceDiscovered = false
    @Published var characteristicsDiscovered = false
    
    var peripheral: CBPeripheral
    
    var ID: String {
        return peripheral.identifier.uuidString
    }
    
    init(peripheral: CBPeripheral) {
        self.peripheral = peripheral
        super.init()
        
        peripheral.delegate = self
    }
    
    func setAxis1(x: Int8, y: Int8) {
        
    }
    
    func setAxis2(x: Int8, y: Int8) {
        
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if error == nil {
            serviceDiscovered = true
            
            
        }
    }
}
