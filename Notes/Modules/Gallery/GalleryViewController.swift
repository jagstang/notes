//
//  GalleryViewController.swift
//  Notes
//
//  Created by Jag Stang on 20/07/2019.
//  Copyright © 2019 JagStang. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class GalleryViewController: UICollectionViewController {
    
    var presenter: GalleryPresenterProtocol!
    
    var images = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewDidLoad()
    }
}

extension GalleryViewController: GalleryViewProtocol {
    
    func setupViews() {
        self.title = "Галерея"
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(tapAdd))
        navigationItem.rightBarButtonItem = add
        
        initCollectionView()
    }
    
    func showImages(_ images: [UIImage]) {
        self.images = images
        collectionView.reloadData()
    }
    
    func addImage(_ image: UIImage) {
        images.append(image)
        collectionView.reloadData()
    }
    
    private func initCollectionView() {
        collectionView.backgroundColor = .white

        collectionView.register(GalleryViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.register(UINib(nibName: "GalleryViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    @objc func tapAdd() {
        presenter.didTapAddImage()
    }
}

// Mark: - collectionview data source
extension GalleryViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! GalleryViewCell
        
        cell.imageView.image = images[indexPath.row]
        
        return cell
    }
}

// Mark: - collectionview delegate
extension GalleryViewController: UICollectionViewDelegateFlowLayout {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.didSelect(path: indexPath, in: images)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        var count: CGFloat = 4
        if UIDevice.current.orientation.isLandscape {
            count = 6
        }

        return CGSize(width: width / count - 1, height: width / count - 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
}
