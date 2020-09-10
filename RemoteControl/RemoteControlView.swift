//
//  ContentView.swift
//  RemoteControl
//
//  Created by Jean-Francois Demers on 2020-09-08.
//  Copyright © 2020 Jean-Francois Demers. All rights reserved.
//

import SwiftUI

struct RemoteControlView: View {
    @State var axisController1 = TwoAxisController()
    @State var axisController2 = TwoAxisController()
    
    var body: some View {
        HStack {
            TwoAxisControl(controller: axisController1)
                .padding(.leading, 30)
            Spacer()
            TwoAxisControl(controller: axisController2)
                .padding(.trailing, 30)
        }
    }
}

struct RemoteControlView_Previews: PreviewProvider {
    static var previews: some View {
        RemoteControlView().previewLayout(.device)
    }
}
