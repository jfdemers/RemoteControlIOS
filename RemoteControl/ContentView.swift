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

struct ContentView: View {
    @State private var currentPosition: CGSize = .zero
    
    var drag: some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { value in
                let vectorLength = sqrt(value.translation.width * value.translation.width + value.translation.height * value.translation.height)
                
                if vectorLength > HALF_CIRCLE_WIDTH {
                    self.currentPosition = CGSize(width: value.translation.width * HALF_CIRCLE_WIDTH / vectorLength, height: value.translation.height * HALF_CIRCLE_WIDTH / vectorLength)
                } else {
                    self.currentPosition = CGSize(width: value.translation.width, height: value.translation.height)
                }
        }
        .onEnded { value in
            self.currentPosition = .zero
        }
    }
    
    var body: some View {
        ZStack {
            Circle()
                .frame(width: 128, height: 128)
                .foregroundColor(.gray)
            Circle()
                .frame(width: 40, height: 40)
                .foregroundColor(Color.black)
                .offset(x: self.currentPosition.width, y: self.currentPosition.height)
                .gesture(drag)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().previewLayout(.device)
    }
}
