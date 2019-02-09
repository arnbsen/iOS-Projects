//
//  GalleryCollectionViewController.swift
//  Image-Gallery
//
//  Created by Arnab Sen on 06/02/19.
//  Copyright © 2019 Arnab Sen. All rights reserved.
//

import UIKit

class GalleryCollectionViewController: UIViewController, UICollectionViewDelegate, UIDropInteractionDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate, UICollectionViewDragDelegate, UICollectionViewDropDelegate {
    
    
    
    
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
            collectionView.dropDelegate = self
            collectionView.dragDelegate = self
            collectionView.allowsMultipleSelection = false
            let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlepinchEvent(sender:)))
            collectionView.addGestureRecognizer(pinchGesture)
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
            gvc.imageView.image = nil
        }
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //MARK: Pinch configuration
    
    @objc private func handlepinchEvent(sender: UIPinchGestureRecognizer) {
        if sender.state == .changed {
            scaleFactor = CGFloat(sender.scale)
            collectionView.collectionViewLayout.invalidateLayout()
        } else if sender.state == .ended {
            currentCellSize = CGSize(width: currentCellSize.width * scaleFactor, height: currentCellSize.height * scaleFactor)
            scaleFactor = 1.0
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout:
        UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let size = collectionView.cellForItem(at: indexPath)?.bounds.size {
            if size.width > collectionView.bounds.width {
                currentCellSize = CGSize(width: collectionView.bounds.width, height: collectionView.bounds.width)
                return currentCellSize
            } else if size.width < 100 {
                currentCellSize = CGSize(width: 100, height: 100)
                return currentCellSize
            } else {
                return CGSize(width: currentCellSize.width * scaleFactor, height: currentCellSize.height * scaleFactor)
            }
        } else {
            return currentCellSize
        }
        
    }
    
    
    //MARK: Configuration of Flow Layout
    
    var flowLayout: UICollectionViewFlowLayout? {
        return collectionView?.collectionViewLayout as? UICollectionViewFlowLayout
    }
    
    var scaleFactor : CGFloat = 1.0
    var currentCellSize = CGSize(width: 100, height: 100)
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1.0, left: 1.0, bottom: 1.0, right: 1.0)
    }
    
    
    
    //MARK: Configuration of the drop Interaction
    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: NSURL.self) && session.canLoadObjects(ofClass: UIImage.self) || session.canLoadObjects(ofClass: UIImage.self)
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        return (session.localDragSession?.localContext as? UICollectionView) != nil ? UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath) :
            UICollectionViewDropProposal(operation: .copy, intent: .insertAtDestinationIndexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        for item in coordinator.items {
            let destinationIndex = coordinator.destinationIndexPath ?? IndexPath(item: 0, section: 0)
                if let sourceIndex = item.sourceIndexPath {
                    collectionView.performBatchUpdates({
                        let url = gallery.imageURLs.remove(at: sourceIndex.item)
                        gallery.imageURLs.insert(url, at: destinationIndex.item)
                        collectionView.deleteItems(at: [sourceIndex])
                        collectionView.insertItems(at: [destinationIndex])
                        
                    }, completion: { (_) in
                        let image = item.dragItem.localObject as? UIImage
                        (collectionView.cellForItem(at: destinationIndex) as? GalleryCollectionViewCell)?.imageView.image = image
                    })
                    coordinator.drop(item.dragItem, toItemAt: destinationIndex)
                    //refreshImages()
                   
                } else {
                    let placeHolderContext = coordinator.drop(
                        item.dragItem,
                        to: UICollectionViewDropPlaceholder(
                            insertionIndexPath: destinationIndex,
                            reuseIdentifier: "Placeholder Cell"))
                    item.dragItem.itemProvider.loadObject(ofClass: NSURL.self) { (provider, error) in
                        DispatchQueue.main.async { [weak self] in
                            if let url = provider as? URL {
                                placeHolderContext.commitInsertion(dataSourceUpdates: { (indexPath) in
                                    self?.gallery?.imageURLs.insert(url, at: indexPath.item)
                                    self?.loadNewImage(with: url, at: indexPath)
                                })
                            } else {
                                placeHolderContext.deletePlaceholder()
                            }
                        }
                    }
                    
                }
            }
    }
    
    private func loadNewImage(with url: URL, at indexPath: IndexPath) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            if let data = try? Data(contentsOf: url.imageURL) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        if let gvc = self?.collectionView.cellForItem(at: indexPath) as? GalleryCollectionViewCell {
                            image.draw(in: gvc.bounds)
                            gvc.imageView.image = image
                        }
                    }
                }
            }
        }
    }
    
    
    
    
    //MARK: Drag interaction
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        session.localContext = collectionView
        if let im = (collectionView.cellForItem(at: indexPath) as? GalleryCollectionViewCell)?.imageView.image {
            let dragItem = UIDragItem(itemProvider: NSItemProvider(object: im))
            dragItem.localObject = im
            return [dragItem]
        } else {
            return []
        }
        
    }
    
    //MARK: Global update
    func reloadImages () {
        for item in gallery.imageURLs.indices {
            let indexPath = IndexPath(row: item, section: 0)
            loadNewImage(with: gallery.imageURLs[item], at: indexPath)
        }
    }
}
