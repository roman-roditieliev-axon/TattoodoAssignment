//
//  BaseViewController.swift
//  TattoodoAssignment (iOS)
//
//  Created by User on 29.06.2021.
//

import UIKit

class BaseViewController: UIViewController {
    let customFlowLayout = PinterestLayout()
    var refreshControl: UIRefreshControl!
    var activityIndicator = UIActivityIndicatorView(style: .medium)

    func setupRefreshControl() {
        self.refreshControl = UIRefreshControl()
        self.refreshControl.tintColor = .gray
        self.refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
    }
    
    @objc func refreshData() {
    }
    
    func calculateHeightOfCollectionItem(imageWidth: CGFloat, imageHeight: CGFloat) -> CGFloat {
        let collectionViewWidth = self.customFlowLayout.collectionView?.frame.width ?? 0
        let cellWidth = (collectionViewWidth-customFlowLayout.cellPadding*2)/CGFloat(customFlowLayout.numberOfColumns)
        let coeficient = cellWidth/imageWidth
        let heightOfCell = imageHeight*coeficient
        return heightOfCell
    }
}
