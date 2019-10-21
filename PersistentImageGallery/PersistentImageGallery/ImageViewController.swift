//
//  ImageViewController.swift
//  Image-Gallery
//
//  Created by Arnab Sen on 10/02/19.
//  Copyright © 2019 Arnab Sen. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController, UIScrollViewDelegate {

    var url : URL? {
        didSet {
            imageView.image = nil
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        loadImage()
    }

    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.minimumZoomScale = 0.04
            scrollView.maximumZoomScale = 1.0
            scrollView.delegate = self
            scrollView.addSubview(imageView)
        }
    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }

    var imageView = UIImageView()

    private func loadImage () {
        if let im_url = url {
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                if let data = try? Data(contentsOf: im_url) {
                    if let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self?.imageView.image = image
                            self?.imageView.sizeToFit()
                            self?.scrollView?.contentSize = image.size
                            self?.scrollView.zoomScale = 2.0
                        }
                    }
                }
            }
        }
    }
}
