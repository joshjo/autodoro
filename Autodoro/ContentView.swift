//
//  ContentView.swift
//  Autodoro
//
//  Created by Josue Ttito on 25/03/23.
//

import SwiftUI
import AVKit

struct ContentView: View {
    @State var currentNumber: String = "1"
    
    
    var body: some View {
        VStack {
            Text("Hello, world!")
            Button("Click me") {
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
