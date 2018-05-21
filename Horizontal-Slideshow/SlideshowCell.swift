//
//  SlideshowCell.swift
//  Horizontal-Slideshow
//
//  Created by Ben Bejster on 5/20/18.
//  Copyright © 2018 Ben Bejster. All rights reserved.
//

import UIKit

class SlideshowCell: UICollectionViewCell {
    
    static let ID = "SLIDESHOW_CELL_ID"
    
    private let colors: [UIColor] = [.red, .green, .blue, .yellow, .purple, .lightGray, .orange, .cyan, .gray]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupCell()
    }
    
    private func setupCell() {
        let num = Int(arc4random_uniform(UInt32(colors.count)))
        backgroundColor = colors[num]
        
        layer.cornerRadius = 10
    }
}
