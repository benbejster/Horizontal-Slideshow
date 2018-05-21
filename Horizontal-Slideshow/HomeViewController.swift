//
//  ViewController.swift
//  Horizontal-Slideshow
//
//  Created by Ben Bejster on 5/20/18.
//  Copyright © 2018 Ben Bejster. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    let collectionView: UICollectionView = {
        let layout = HorizontalSlideshowLayout()
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .lightGray
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.decelerationRate = UIScrollViewDecelerationRateFast
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationController()
        setupCollectionView()
        setupView()
    }

    private func setupNavigationController() {
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.backgroundColor = .yellow
        navigationItem.title = "Horizontal Slideshow Layout"
    }
    
    private func setupCollectionView() {
        let layout = collectionView.collectionViewLayout as! HorizontalSlideshowLayout
        layout.delegate = self
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(SlideshowCell.self, forCellWithReuseIdentifier: SlideshowCell.ID)
    }
    
    private func setupView() {
        self.view.addSubview(collectionView)
        self.view.addConstraintsWithVisualFormat(format: "H:|[v0]|", views: collectionView)
        self.view.addConstraintsWithVisualFormat(format: "V:|[v0]|", views: collectionView)
    }

}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SlideshowCell.ID, for: indexPath) as! SlideshowCell
        
        return cell
    }
}

extension HomeViewController: HorizontalSlideshowDelegate {
    func collectionView(heightForItemsIn collectionView: UICollectionView) -> CGFloat? {
        return 275
    }
    
    
}
