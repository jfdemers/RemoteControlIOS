//
//  BLEController.swift
//  RemoteControl
//
//  Created by Jean-Francois Demers on 2020-09-10.
//  Copyright © 2020 Jean-Francois Demers. All rights reserved.
//

import Foundation
import CoreBluetooth

class BLEController: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    var centralManager: CBCentralManager!
    
    @Published var connectedDevice: Device?
    @Published var devices: [String:Device] = [:]
    @Published var deviceList: [Device] = []
    
    fileprivate var setupDone = false
    
    static var _defaultController = BLEController()
    static var defaultController: BLEController {
        if (!_defaultController.setupDone) {
            _defaultController.setup()
        }
        
        return _defaultController
    }
    
    func setup() {
        centralManager = CBCentralManager(delegate: self, queue: nil)
        setupDone = true
    }
    
    func scanDevices() {
        devices = [:]
        centralManager.scanForPeripherals(withServices: [CBUUID(string: "4b541423-23b7-48e7-8a4c-a00ef3c23c7b")], options: nil)
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == CBManagerState.poweredOn {
            print("BLE powered on")
            scanDevices()
        }
        else {
            print("Something wrong with BLE")
            // Not on, but can have different issues
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        var newDevices = devices
        let newDevice = Device(peripheral: peripheral)
        newDevices[peripheral.identifier.uuidString] = newDevice
        devices = newDevices
        
        var newDeviceList: [Device] = []
        
        for d in devices {
            newDeviceList.append(d.value)
        }
        
        newDeviceList.sort { d1, d2 in
            if let n1 = d1.peripheral.name, let n2 = d2.peripheral.name {
                return n1 < n2
            }
            
            return false
        }
        
        deviceList = newDeviceList
        
        if let pname = peripheral.name {
            print("Found peripheral: \(pname)")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        connectedDevice = devices[peripheral.identifier.uuidString]
        peripheral.discoverServices([CBUUID(string: "4b541423-23b7-48e7-8a4c-a00ef3c23c7b")])
        
        if let device = connectedDevice {
            device.status = .discoveringServices
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        if let device = connectedDevice {
            device.status = .unknown
        }
        
        connectedDevice = nil
    }
    
    func connectToDevice(_ device: Device) {
        centralManager.connect(device.peripheral, options: nil)
        device.status = .connecting
    }
}
