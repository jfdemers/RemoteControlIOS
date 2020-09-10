//
//  TwoAxisController.swift
//  RemoteControl
//
//  Created by Jean-Francois Demers on 2020-09-09.
//  Copyright © 2020 Jean-Francois Demers. All rights reserved.
//

import Foundation

class TwoAxisController: ObservableObject {    
    @Published var x: Int8 = 0
    @Published var y: Int8 = 0
}
