//
//  LandmarkList.swift
//  SwiftUI-Tut1
//
//  Created by Arnab Sen on 25/10/19.
//  Copyright © 2019 Arnab Sen. All rights reserved.
//

import SwiftUI

struct LandmarkList: View {
    
    @State var showFavoritesOnly = false
    
    var body: some View {
        NavigationView {
            List {
                Toggle(isOn: $showFavoritesOnly) {
                    Text("Show Favorites")
                }
                ForEach(landmarkData) { landmark in
                    if !self.showFavoritesOnly || landmark.isFavorite {
                        NavigationLink(destination: LandmarkDetail(landmark: landmark)) {
                            LandmarkRow(landmark: landmark)
                        }
                    }
                }
            }
            .navigationBarTitle(Text("Landmarks"))
        }
    
        
    }
}

struct LandmarkList_Previews: PreviewProvider {
    static var previews: some View {
        LandmarkList()
    }
}
