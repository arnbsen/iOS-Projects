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
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gallery.imageURLs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Image Cell", for: indexPath)
        if let ivc = cell as? GalleryCollectionViewCell {
            ivc.spinner.isHidden = false
            ivc.imageView.isHidden = true
        }
        return cell
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
            self.gallery.imageURLs.append(urls.first as! URL)
            self.loadNewImage(with: urls.first as! URL)
            self.collectionView.insertItems(at: [IndexPath(row: self.gallery.imageURLs.count - 1, section: 0)])
        }
    }
    
    private func loadNewImage(with url: URL) {
        let session = URLSession(configuration: .default)
        let indexPath = IndexPath(row: self.gallery.imageURLs.count - 1, section: 0)
        let task = session.dataTask(with: url.imageURL) { (data: Data?, response, error) in
            DispatchQueue.main.async { [weak self] in
                if let ivc = self?.collectionView.cellForItem(at: indexPath) as? GalleryCollectionViewCell {
                    ivc.imageView.isHidden = false
                    ivc.imageView.image = UIImage(data: data!)
                    ivc.spinner.isHidden = true
                }
            }
        }
        task.resume()
    }
    
}
