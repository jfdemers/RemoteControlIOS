//
//  MainView.swift
//  RemoteControl
//
//  Created by Jean-Francois Demers on 2020-09-10.
//  Copyright © 2020 Jean-Francois Demers. All rights reserved.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        NavigationView {
            SelectDeviceView()
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
