//
//  ImagePreviewController.swift
//  Notes
//
//  Created by Jag Stang on 20/07/2019.
//  Copyright © 2019 JagStang. All rights reserved.
//

import UIKit

class ImagePreviewController: UIViewController {

    var presenter: ImagePreviewPresenterProtocol!
    
    @IBOutlet weak var scrollView: UIScrollView!

    var selected: Int?
    var imageViews = [UIImageView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        presenter.viewDidLoad()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        for (index, imageView) in imageViews.enumerated() {
            imageView.frame.size = scrollView.frame.size
            imageView.frame.origin.x = scrollView.frame.width * CGFloat(index)
            imageView.frame.origin.y = 0
        }
        let contentWidth = scrollView.frame.width * CGFloat(imageViews.count)
        scrollView.contentSize = CGSize(width: contentWidth, height: scrollView.frame.height)
        if let selected = selected {
            let offset = scrollView.frame.width * CGFloat(selected)
            scrollView.setContentOffset(CGPoint(x: offset, y: 0), animated: false)
        }
    }
}

extension ImagePreviewController: ImagePreviewViewProtocol {
    func setupViews() {
        scrollView.delegate = self
    }
    
    func showImages(_ images: [UIImage], selectedIndex: Int) {
        for image in images {
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFit
            scrollView.addSubview(imageView)
            imageViews.append(imageView)
        }
        selected = selectedIndex
    }
}

extension ImagePreviewController: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.size.width;
        selected = Int(scrollView.contentOffset.x / pageWidth);
    }
}
