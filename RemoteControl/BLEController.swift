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
    @Published var devices: [Device] = []
    
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
        devices = []
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
        if let pname = peripheral.name {
            print("Found peripheral: \(pname)")
            
            var newArray = devices
            newArray.append(Device(peripheral: peripheral))
            devices = newArray
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        connectedDevice = deviceByUUID(peripheral.identifier)
        peripheral.discoverServices([CBUUID(string: "4b541423-23b7-48e7-8a4c-a00ef3c23c7b")])
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        connectedDevice = nil
    }
    
    func connectToDevice(device: Device) {
        centralManager.connect(device.peripheral, options: nil)
    }
    
    private func deviceByUUID(_ id: UUID) -> Device? {
        for d in devices {
            if d.ID == id.uuidString {
                return d
            }
        }
        
        return nil
    }
}
