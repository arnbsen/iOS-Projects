//
//  Gallery.swift
//  Image-Gallery
//
//  Created by Arnab Sen on 04/02/19.
//  Copyright © 2019 Arnab Sen. All rights reserved.
//

import Foundation
struct Gallery: Codable {

    var imageURLs = [URL]()
    var isDeleted = false
    
    var json : Data? {
        return try? JSONEncoder().encode(self)
    }
    
    init?(json: Data) {
        if let newValue = try? JSONDecoder().decode(Gallery.self, from: json) {
            self = newValue
        } else {
            return nil
        }
    }
    init() {
        
    }
}
