//
//  Document.swift
//  PersistentImageGallery
//
//  Created by Arnab Sen on 09/03/19.
//  Copyright © 2019 Arnab Sen. All rights reserved.
//

import UIKit

class GalleryDocument: UIDocument {
    
    var gallery: Gallery?
    
    override func contents(forType typeName: String) throws -> Any {
        // Encode your document with an instance of NSData or NSFileWrapper
        return gallery?.json ?? Data()
    }
    
    override func load(fromContents contents: Any, ofType typeName: String?) throws {
        // Load your document from contents
        if let json = try? Data(contentsOf: fileURL) {
            gallery = Gallery(json: json)
        }
    }
    override func fileAttributesToWrite(to url: URL, for saveOperation: UIDocument.SaveOperation) throws -> [AnyHashable : Any] {
       let attributes = try super.fileAttributesToWrite(to: url, for: saveOperation)
        return attributes
    }
}

