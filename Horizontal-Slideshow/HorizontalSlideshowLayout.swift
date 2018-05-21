//
//  HorizontalSlideshowLayout.swift
//  Horizontal-Slideshow
//
//  Created by Ben Bejster on 5/20/18.
//  Copyright © 2018 Ben Bejster. All rights reserved.
//

import UIKit

// MARK: Layout Delegate - gives user control over size, yOffset, and spacing of cells
protocol HorizontalSlideshowDelegate {
    func collectionView(heightForItemsIn collectionView: UICollectionView) -> CGFloat?
}


struct CustomLayoutConstants {
    static let featuredY: CGFloat = 16
    static let standardY: CGFloat = 64
    static let differenceY: CGFloat = 48
    static let spacingBetweenCells: CGFloat = 24
}

class HorizontalSlideshowLayout: UICollectionViewFlowLayout {
    
    var delegate: HorizontalSlideshowDelegate?
    
    //The amount a user has to scroll in order to change featured cell
    var dragOffset: CGFloat {
        get {
            return self.width + CustomLayoutConstants.spacingBetweenCells
        }
    }
    
    var cache = [UICollectionViewLayoutAttributes]()
    
    var featuredItemIndex: Int {
        get {
            return max(0, Int(collectionView!.contentOffset.x / dragOffset))
        }
    }
    
    //Returns a number between 0 and 1 that indicates how close the next cell is to becoming the featured cell
    var nextItemPercentageOffset: CGFloat {
        get {
            return (collectionView!.contentOffset.x / dragOffset) - CGFloat(featuredItemIndex)
        }
    }
    
    //Screen width -> Used to calculate size of cell and content size of collection view interior
    var screenWidth: CGFloat {
        get {
            return collectionView!.bounds.width
        }
    }
    
    var width: CGFloat {
        get {
            return screenWidth - CGFloat(4 * CustomLayoutConstants.spacingBetweenCells)
        }
    }
    
    var height: CGFloat {
        get {
            return delegate?.collectionView(heightForItemsIn: collectionView!) ?? width
        }
    }
    
    var numberOfItems: Int {
        get {
            return collectionView!.numberOfItems(inSection: 0)
        }
    }
    
    var distanceBetweenOffsetsX: CGFloat {
        get {
            return CustomLayoutConstants.spacingBetweenCells + width
        }
    }
    
    internal func getRelativeCellXOffset(atIndex index: Int) -> CGFloat {
        return (CustomLayoutConstants.spacingBetweenCells * CGFloat(2 + index)) + (width * CGFloat(index)) - 2 * CustomLayoutConstants.spacingBetweenCells
    }
    
    private func createYPos(atIndex index: Int) -> CGFloat {
        
        let relativeXOffset = getRelativeCellXOffset(atIndex: index)
        let currentXOffset = collectionView!.contentOffset.x
        
        let percentageFromRelativeOffset = (relativeXOffset - currentXOffset) / distanceBetweenOffsetsX
        
        let differenceInY = CustomLayoutConstants.differenceY
        let featuredY = CustomLayoutConstants.featuredY
        return featuredY + (differenceInY * CGFloat(abs(percentageFromRelativeOffset)))
        
    }
    
    var currentOffSet: CGFloat = 0
    var previousOffSet: CGFloat = 0
    
    static let spacingBetweenCells: CGFloat = 30
    
    // MARK: UICollectionViewLayout
    override var collectionViewContentSize: CGSize {
        get {
            let width: CGFloat = (self.width * CGFloat(numberOfItems)) + (CustomLayoutConstants.spacingBetweenCells * CGFloat(3 + numberOfItems))
            
            
            let cellHeight = delegate?.collectionView(heightForItemsIn: collectionView!) ?? self.width
            let standardY = CustomLayoutConstants.standardY
            let featuredY = CustomLayoutConstants.featuredY
            return CGSize(width: max(width, screenWidth), height: standardY + featuredY + cellHeight)
        }
    }
    
    override var sectionInset: UIEdgeInsets {
        get {
            return UIEdgeInsets(top: 16, left: 16, bottom: 0, right: 16)
        }
        set {
            
        }
    }
    
    override func prepare() {
        cache.removeAll(keepingCapacity: false)
        
        var frame = CGRect.zero
        var x: CGFloat
        var y: CGFloat
        
        for item in 0..<numberOfItems {
            let indexPath = IndexPath(item: item, section: 0)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.zIndex = item
            
            x = (CustomLayoutConstants.spacingBetweenCells * CGFloat(2 + item)) + (width * CGFloat(item))
            y = createYPos(atIndex: item)
            
            frame = CGRect(x: x, y: y, width: width, height: height)
            attributes.frame = frame
            cache.append(attributes)
        }
        
        
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        for attibutes in cache {
            if attibutes.frame.intersects(rect) {
                layoutAttributes.append(attibutes)
            }
        }
        return layoutAttributes
    }
    
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        let itemIndex = round(proposedContentOffset.x / dragOffset)
        let featuredY = CustomLayoutConstants.featuredY
        
        let x = (CustomLayoutConstants.spacingBetweenCells * CGFloat(itemIndex)) + (width * CGFloat(itemIndex))
        
        return CGPoint(x: x, y: featuredY)
    }
    
    
    @objc private func getFeaturedIndex() {
        print("FEATURED ITEM INDEX: ", featuredItemIndex)
        print("PERCENTAGE OFFSET: ", nextItemPercentageOffset, "%")
        print("---------------------")
    }
}

