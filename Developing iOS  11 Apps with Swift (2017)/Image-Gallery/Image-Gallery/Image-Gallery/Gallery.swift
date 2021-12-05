//
//  Gallery.swift
//  Image-Gallery
//
//  Created by Arnab Sen on 04/02/19.
//  Copyright © 2019 Arnab Sen. All rights reserved.
//

import Foundation
class Gallery {

    var galleryName : String
    var imageURLs = [URL]()
    var isDeleted = false
    
    init(name: String) {
        galleryName = name
    }
}
