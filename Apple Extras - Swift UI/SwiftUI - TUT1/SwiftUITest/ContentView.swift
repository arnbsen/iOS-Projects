//
//  ContentView.swift
//  SwiftUITest
//
//  Created by Arnab Sen on 21/10/19.
//  Copyright © 2019 Arnab Sen. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            MapView()
                .edgesIgnoringSafeArea(.top)
                .frame(height: 300)
            CircleImage()
                .offset(y: -70)
                .padding(.bottom, -130)
            VStack (alignment: .leading) {
                Text("Hello SwiftUI!")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.green)
                HStack {
                    Text("Apple's new UI Toolkit")
                        .font(.subheadline)
                    Spacer()
                    Text("Tryout")
                        .font(.subheadline)
                }
            }
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
