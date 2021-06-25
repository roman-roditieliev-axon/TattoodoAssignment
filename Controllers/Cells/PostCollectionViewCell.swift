//
//  postCollectionViewCell.swift
//  TattoodoAssignment (iOS)
//
//  Created by User on 25.06.2021.
//

import UIKit

class PostCollectionViewCell: UICollectionViewCell {

    let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(imageView)
        imageView.backgroundColor = .red
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
        imageView.layer.cornerRadius = 20
    }
    
    func setupCell(post: PostList) {
        
    }
}
