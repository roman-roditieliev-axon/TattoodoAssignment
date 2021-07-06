//
//  TattooCollectionView.swift
//  TattoodoAssignment (iOS)
//
//  Created by User on 01.07.2021.
//

import UIKit

class TattooCollectionView: UICollectionView {
    
    let postCellReuseIdentifier = "PostCollectionViewCell"
    
    init() {
        let pinterestLayout = PinterestLayout()
        super.init(frame: .zero, collectionViewLayout: pinterestLayout)
        delaysContentTouches = false
        backgroundColor = .white
        contentInsetAdjustmentBehavior = .always
        register(PostCollectionViewCell.self, forCellWithReuseIdentifier: postCellReuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
