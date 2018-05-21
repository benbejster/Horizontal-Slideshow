//
//  UIView.swift
//  Horizontal-Slideshow
//
//  Created by Ben Bejster on 5/20/18.
//  Copyright © 2018 Ben Bejster. All rights reserved.
//

import UIKit

// MARK: Extension on UIView that simplifies the addConstraintsWithVisualFormat functionality

extension UIView {
    
    func addConstraintsWithVisualFormat(format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
}
