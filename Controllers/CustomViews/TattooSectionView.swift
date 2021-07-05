//
//  TattooSectionView.swift
//  TattoodoAssignment (iOS)
//
//  Created by User on 01.07.2021.
//

import UIKit
import SDWebImage

protocol TappedSharedButtonDelegate: class {
    func shareDidTap()
}

class TattooSectionView: UIView {
    //tattoo section UI elements
    private lazy var tattooImageView = UIImageView()
    private lazy var tattooBottomSectionView = UIView()
    private lazy var shareTattoButton = UIButton()
    private lazy var likeTattoButton = UIButton()
    private lazy var savesLabel = UILabel()
    
    private var isLiked = false
    weak var delegate: TappedSharedButtonDelegate?
    
    var tattooImageURL: URL? = URL(string: "") {
        didSet{
            self.tattooImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            self.tattooImageView.sd_setImage(with: tattooImageURL)
        }
    }
    
    var savesCount: Int = 0 {
        didSet {
            self.savesLabel.text = "\(savesCount) pins"
        }
    }

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
        setupViewLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureViews() {
        tattooBottomSectionView.backgroundColor = .white
        tattooImageView.contentMode = .scaleAspectFill
        tattooImageView.clipsToBounds = true
        
        likeTattoButton.setImage(UIImage(systemName: "heart"), for: .normal)
        likeTattoButton.tintColor = .black
        likeTattoButton.addTarget(self, action: #selector(likeDidTap), for: .allEvents)
        likeTattoButton.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)

        shareTattoButton.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        shareTattoButton.tintColor = .black
        shareTattoButton.addTarget(self, action: #selector(shareDidTap), for: .allEvents)
        shareTattoButton.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        
        savesLabel.textColor = .gray
        savesLabel.font = UIFont.systemFont(ofSize: 14)
    }
    
    private func setupViewLayout() {
        self.addSubview(tattooImageView)
        self.addSubview(tattooBottomSectionView)

        tattooImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tattooImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            tattooImageView.topAnchor.constraint(equalTo: self.topAnchor),
            tattooImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            tattooImageView.heightAnchor.constraint(equalToConstant: Constants.IndentsAndSizes.tattooImageHeight),
            tattooImageView.widthAnchor.constraint(equalTo: self.widthAnchor),
        ])
        
        tattooBottomSectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tattooBottomSectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            tattooBottomSectionView.topAnchor.constraint(equalTo: tattooImageView.bottomAnchor),
            tattooBottomSectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            tattooBottomSectionView.heightAnchor.constraint(equalToConstant: Constants.IndentsAndSizes.tattooShareSectionHeight),
            tattooBottomSectionView.widthAnchor.constraint(equalTo: self.widthAnchor),
            tattooBottomSectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
        ])
        
        tattooBottomSectionViewLayout()
    }
    
    private func tattooBottomSectionViewLayout() {
        tattooBottomSectionView.addSubview(likeTattoButton)
        tattooBottomSectionView.addSubview(shareTattoButton)
        tattooBottomSectionView.addSubview(savesLabel)
        
        likeTattoButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            likeTattoButton.leadingAnchor.constraint(equalTo: tattooBottomSectionView.leadingAnchor, constant: Constants.IndentsAndSizes.spacing10*2),
            likeTattoButton.topAnchor.constraint(equalTo: tattooBottomSectionView.topAnchor, constant: Constants.IndentsAndSizes.spacing10),
            likeTattoButton.heightAnchor.constraint(equalToConstant: Constants.IndentsAndSizes.circleItemsSize),
            likeTattoButton.widthAnchor.constraint(equalToConstant: Constants.IndentsAndSizes.circleItemsSize),
            likeTattoButton.bottomAnchor.constraint(equalTo: tattooBottomSectionView.bottomAnchor, constant: -Constants.IndentsAndSizes.spacing10),
        ])
        
        shareTattoButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            shareTattoButton.trailingAnchor.constraint(equalTo: tattooBottomSectionView.trailingAnchor, constant: -Constants.IndentsAndSizes.spacing10*2),
            shareTattoButton.topAnchor.constraint(equalTo: tattooBottomSectionView.topAnchor, constant: Constants.IndentsAndSizes.spacing10),
            shareTattoButton.heightAnchor.constraint(equalToConstant: Constants.IndentsAndSizes.circleItemsSize),
            shareTattoButton.widthAnchor.constraint(equalToConstant: Constants.IndentsAndSizes.circleItemsSize),
            shareTattoButton.bottomAnchor.constraint(equalTo: tattooBottomSectionView.bottomAnchor, constant: -Constants.IndentsAndSizes.spacing10),
        ])
        
        savesLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            savesLabel.leadingAnchor.constraint(equalTo: likeTattoButton.trailingAnchor, constant: Constants.IndentsAndSizes.spacing10),
            savesLabel.centerYAnchor.constraint(equalTo: likeTattoButton.centerYAnchor),
            savesLabel.heightAnchor.constraint(equalToConstant: Constants.IndentsAndSizes.circleItemsSize/2),
            savesLabel.trailingAnchor.constraint(equalTo: shareTattoButton.leadingAnchor, constant: -Constants.IndentsAndSizes.circleItemsSize),
        ])
    }
    
    // MARK: - Actions

    @objc private func likeDidTap() {
        if !isLiked {
            self.savesLabel.text = "\(savesCount+1) pins"
            isLiked = true
            likeTattoButton.backgroundColor = UIColor.lightGray.withAlphaComponent(0.7)
        } else {
            self.savesLabel.text = "\(savesCount) pins"
            isLiked = false
            likeTattoButton.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        }
    }
    
    @objc private func shareDidTap() {
        delegate?.shareDidTap()
    }
    
    func setButtonsCorners() {
        tattooImageView.roundCorners([.topLeft, .topRight], radius: Constants.IndentsAndSizes.corner)
        tattooBottomSectionView.roundCorners([.bottomLeft, .bottomRight], radius: Constants.IndentsAndSizes.corner)
        likeTattoButton.roundCorners([.allCorners], radius: Constants.IndentsAndSizes.corner)
        shareTattoButton.roundCorners([.allCorners], radius: Constants.IndentsAndSizes.corner)
    }
}
