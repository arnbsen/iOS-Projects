//
//  GalleryCollectionViewController.swift
//  Image-Gallery
//
//  Created by Arnab Sen on 06/02/19.
//  Copyright © 2019 Arnab Sen. All rights reserved.
//

import UIKit

class GalleryCollectionViewController: UIViewController, UICollectionViewDelegate, UIDropInteractionDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //MARK: Model Configuration for Collection View
    var gallery : Gallery!
    
    
    //MARK: ViewController LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    
    
    
    //MARK: Collection View DataSource Configuration
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if gallery == nil {
            return 0
        } else {
            return gallery.imageURLs.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Image Cell", for: indexPath)
        if let gvc = cell as? GalleryCollectionViewCell {
            gvc.spinner.isHidden = false
        }
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    @IBOutlet weak var dropZone: UIView! {
        didSet {
            let idi = UIDropInteraction(delegate: self)
            idi.allowsSimultaneousDropSessions = false
            dropZone.addInteraction(idi)
        }
    }
    
    //MARK: Configuration of the drop Interaction
    
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: NSURL.self) && session.canLoadObjects(ofClass: UIImage.self)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        return UIDropProposal(operation: .copy)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        session.loadObjects(ofClass: NSURL.self) { urls in
            if let link = urls[0] as? URL {
            self.collectionView.performBatchUpdates({
                self.gallery.imageURLs.append(link)
                let indexPath = IndexPath(row: self.gallery.imageURLs.count - 1, section: 0)
                self.collectionView.insertItems(at: [indexPath])
                self.loadNewImage(with: link, at: indexPath)
            }, completion: nil)
               
                
            }
        }
    }
    
    private func loadNewImage(with url: URL, at indexPath: IndexPath) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        if let gvc = self?.collectionView.cellForItem(at: indexPath) as? GalleryCollectionViewCell {
                            image.draw(in: gvc.bounds)
                            gvc.imageView.image = image
                            gvc.spinner.isHidden = true
                        }
                    }
                }
            }
        }
    }
    
}
