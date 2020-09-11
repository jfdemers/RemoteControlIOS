//
//  Device.swift
//  RemoteControl
//
//  Created by Jean-Francois Demers on 2020-09-10.
//  Copyright © 2020 Jean-Francois Demers. All rights reserved.
//

import Foundation
import CoreBluetooth

enum DeviceStatus {
    case unknown
    case connecting
    case discoveringServices
    case discoveringCharacteristics
    case error
    case ready
}

enum Service: String {
    case controlledDevice = "4b541423-23b7-48e7-8a4c-a00ef3c23c7b"
}

enum DeviceCharacteristic: String {
    case axis1 = "e9047fc4-b82f-490c-9732-9089231ad245"
    case axis2 = "31e7f1fc-ac15-4004-8e2f-6de012658ff9"
    case battery = "206027d7-f0b5-4645-94f9-91e8f40324c4"
    case log = "0ea15bc2-78c0-4812-9eea-73378fd09455"
}

class Device: NSObject, CBPeripheralDelegate, Identifiable, ObservableObject {
    @Published var status: DeviceStatus = .unknown
    
    var peripheral: CBPeripheral
    
    var ID: String {
        return peripheral.identifier.uuidString
    }
    
    private var axis1Characteristic: CBCharacteristic?
    private var axis2Characteristic: CBCharacteristic?
    private var batteryCharacteristic: CBCharacteristic?
    private var logCharacteristic: CBCharacteristic?
    
    init(peripheral: CBPeripheral) {
        self.peripheral = peripheral
        super.init()
        
        peripheral.delegate = self
    }
    
    func setAxis1(x: Int8, y: Int8) {
        if let c = axis1Characteristic {
            writeForAxis(c, x: x, y: y)
        }
    }
    
    func setAxis2(x: Int8, y: Int8) {
        if let c = axis2Characteristic {
            writeForAxis(c, x: x, y: y)
        }
    }
    
    private func writeForAxis(_ axis: CBCharacteristic, x: Int8, y: Int8) {
        let tmpArray: [Int8] = [x , y]
        tmpArray.withUnsafeBufferPointer { b in
            let data = Data(buffer: b)
            peripheral.writeValue(data, for: axis, type: .withoutResponse)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if error == nil {
            if let services = peripheral.services {
                for service in services {
                    print("Discovered service with UUID: \(service.uuid.uuidString)")
                    if service.uuid.uuidString.uppercased() == Service.controlledDevice.rawValue.uppercased() {
                        peripheral.discoverCharacteristics(nil, for: service)
                        status = .discoveringCharacteristics
                        return
                    }
                }
            }
        }
        
        status = .error
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let characteristics = service.characteristics {
            for c in characteristics {
                print("Discovered characteristic with UUID: \(c.uuid)")
                
                switch c.uuid.uuidString.uppercased() {
                case DeviceCharacteristic.axis1.rawValue.uppercased():
                    axis1Characteristic = c
                    break
                    
                case DeviceCharacteristic.axis2.rawValue.uppercased():
                    axis2Characteristic = c
                    break
                    
                case DeviceCharacteristic.battery.rawValue.uppercased():
                    batteryCharacteristic = c
                    break
                    
                case DeviceCharacteristic.log.rawValue.uppercased():
                    logCharacteristic = c
                    break
                    
                default:
                    break
                }
            }
        }
        
        status = .ready
    }
}
