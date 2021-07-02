//
//  PinterestLayout.swift
//  TattoodoAssignment (iOS)
//
//  Created by User on 25.06.2021.
//

import UIKit

protocol PinterestLayoutDelegate: AnyObject {
    func collectionView(_ collectionView: UICollectionView,
        heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat
}

class PinterestLayout: UICollectionViewFlowLayout {
    weak var delegate: PinterestLayoutDelegate?
    
    let numberOfColumns = 2
    let cellPadding: CGFloat = 8
    
    private var cache: [UICollectionViewLayoutAttributes] = []
    
    private var contentHeight: CGFloat = 0
    
    private var contentWidth: CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }
    
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func prepare() {
        cache = []
        guard cache.isEmpty, let collectionView = collectionView else { return }
        let columnWidth = contentWidth / CGFloat(numberOfColumns)
        var xOffset: [CGFloat] = []
        for column in 0..<numberOfColumns {
            xOffset.append(CGFloat(column) * columnWidth)
        }
        var column = 0
        var yOffset: [CGFloat] = .init(repeating: 0, count: numberOfColumns)
        
        for item in 0..<collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            
            let photoHeight = delegate?.collectionView(
                collectionView,
                heightForPhotoAtIndexPath: indexPath) ?? 180
            let height = cellPadding * 2 + photoHeight
            let frame = CGRect(x: xOffset[column],
                               y: yOffset[column]+self.headerReferenceSize.height,
                               width: columnWidth,
                               height: height)
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
            
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            cache.append(attributes)
            
            contentHeight = max(contentHeight, frame.maxY)
            yOffset[column] = yOffset[column] + height
            
            column = column < (numberOfColumns - 1) ? (column + 1) : 0
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes: [UICollectionViewLayoutAttributes] = []
        if  let attributes = super.layoutAttributesForElements(in: rect) {
            for attr in attributes where attr.representedElementKind == UICollectionView.elementKindSectionHeader {
                if let supplementaryAttributes = layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, at: attr.indexPath) {
                    visibleLayoutAttributes.append(supplementaryAttributes)
                }
            }
        }
        
        for attributes in cache {
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
            }
        }
        
        return visibleLayoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes {
      return cache[indexPath.item]
    }
    
    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if elementKind == UICollectionView.elementKindSectionHeader {
            let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, with: indexPath)
            attributes.frame = CGRect(x: 0, y: 0, width: self.contentWidth, height: 610)
            return attributes
        }
        return nil
    }
}
