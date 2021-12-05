//
//  CircleImage.swift
//  SwiftUITest
//
//  Created by Arnab Sen on 21/10/19.
//  Copyright © 2019 Arnab Sen. All rights reserved.
//

import SwiftUI

struct CircleImage: View {
    var image: Image
    var body: some View {
        image
        .clipShape(Circle())
        .overlay(
            Circle().stroke(Color.gray, lineWidth: 1)
        )
        .shadow(radius: 10)
    }
}

struct CircleImage_Previews: PreviewProvider {
    static var previews: some View {
        CircleImage(image: Image("icon_test"))
    }
}
