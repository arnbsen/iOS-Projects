//
//  DocumentBrowserViewController.swift
//  PersistentImageGallery
//
//  Created by Arnab Sen on 09/03/19.
//  Copyright © 2019 Arnab Sen. All rights reserved.
//

import UIKit


class DocumentBrowserViewController: UIDocumentBrowserViewController, UIDocumentBrowserViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        allowsPickingMultipleItems = false
        template = try? FileManager.default.url(
            for: .applicationSupportDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        ).appendingPathComponent("Untitled.json")
        if template != nil {
            let gallery = Gallery()
            allowsDocumentCreation = FileManager.default.createFile(atPath: template!.path, contents: gallery.json, attributes: nil)
        }
    }
    
    var template: URL?
    // MARK: UIDocumentBrowserViewControllerDelegate
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didRequestDocumentCreationWithHandler importHandler: @escaping (URL?, UIDocumentBrowserViewController.ImportMode) -> Void) {
        importHandler(template, .copy)
        
    }
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didPickDocumentsAt documentURLs: [URL]) {
        guard let sourceURL = documentURLs.first else { return }
        
        // Present the Document View Controller for the first document that was picked.
        // If you support picking multiple items, make sure you handle them all.
        presentDocument(at: sourceURL)
    }
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didImportDocumentAt sourceURL: URL, toDestinationURL destinationURL: URL) {
        // Present the Document View Controller for the new newly created document
        presentDocument(at: destinationURL)
    }
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, failedToImportDocumentAt documentURL: URL, error: Error?) {
        // Make sure to handle the failed import appropriately, e.g., by presenting an error message to the user.
    }
    
    // MARK: Document Presentation
    
    func presentDocument(at documentURL: URL) {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let documentVC = storyBoard.instantiateViewController(withIdentifier: "DocumentVC")
        if let galleryVC = documentVC.contents as? GalleryCollectionViewController {
            galleryVC.document = GalleryDocument(fileURL: documentURL)
        }
        
        present(documentVC, animated: true)
    }
}

