//
//  TwoAxisControl.swift
//  RemoteControl
//
//  Created by Jean-Francois Demers on 2020-09-09.
//  Copyright © 2020 Jean-Francois Demers. All rights reserved.
//

import SwiftUI

let CIRCLE_DIAMETER: CGFloat = 128;
let CIRCLE_RADIUS: CGFloat = CIRCLE_DIAMETER / 2;

struct TwoAxisControl: View {
    @ObservedObject var controller: TwoAxisController
    
    var drag: some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { value in
                let vectorLength = sqrt(value.translation.width * value.translation.width + value.translation.height * value.translation.height)
                
                if vectorLength > CIRCLE_RADIUS {
                    self.controller.x = Int8((value.translation.width * 127 / vectorLength))
                    self.controller.y = -Int8((value.translation.height * 127 / vectorLength))
                } else {
                    self.controller.x = Int8(value.translation.width / CIRCLE_RADIUS * 127)
                    self.controller.y = -Int8(value.translation.height / CIRCLE_RADIUS * 127)
                }
                
                print("Axis new values: \(self.controller.x); \(self.controller.y)")
        }
        .onEnded { value in
            self.controller.x = 0
            self.controller.y = 0
            
            print("Axis new values: \(self.controller.x); \(self.controller.y)")
        }
    }
    
    var body: some View {
        ZStack {
            Circle()
                .frame(width: CIRCLE_DIAMETER, height: CIRCLE_DIAMETER)
                .foregroundColor(Color(red: 0.8, green: 0.8, blue: 0.8))
            Circle()
                .frame(width: 40, height: 40)
                .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                .offset(x: CGFloat(self.controller.x) / 127.0 * CIRCLE_RADIUS, y: CGFloat(-self.controller.y) / 127.0 * CIRCLE_RADIUS)
                .gesture(drag)
        }
    }
}

struct TwoAxisControl_Previews: PreviewProvider {
    static var previews: some View {
        TwoAxisControl(controller: TwoAxisController())
            .previewLayout(.sizeThatFits)
    }
}
