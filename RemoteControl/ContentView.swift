//
//  ContentView.swift
//  RemoteControl
//
//  Created by Jean-Francois Demers on 2020-09-08.
//  Copyright © 2020 Jean-Francois Demers. All rights reserved.
//

import SwiftUI

let CIRCLE_WIDTH: CGFloat = 128;
let HALF_CIRCLE_WIDTH: CGFloat = CIRCLE_WIDTH / 2;

struct RemoteControl: View {
    var body: some View {
        HStack {
            TwoAxisControl()
                .padding(.leading, 30)
            Spacer()
            TwoAxisControl()
                .padding(.trailing, 30)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RemoteControl().previewLayout(.device)
    }
}
