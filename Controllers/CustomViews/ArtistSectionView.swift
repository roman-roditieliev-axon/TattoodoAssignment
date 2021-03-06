//
//  ArtistSectionView.swift
//  TattoodoAssignment (iOS)
//
//  Created by User on 01.07.2021.
//

import UIKit
import SDWebImage

class ArtistSectionView: UIView {

    //artist section UI elements
    var artistStackView = UIStackView()
    private lazy var artistSectionView = UIView()
    private lazy var artistImageView = UIImageView()
    private lazy var artistLabel = UILabel()
    private lazy var descriptionLabel = UILabel()
    
    //properties
    private var artistStackViewHeightConstraint: NSLayoutConstraint?
    
    var artistImageURL: URL? = URL(string: "") {
        didSet{
            if let url = artistImageURL {
                self.artistImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
                self.artistImageView.sd_setImage(with: url)
            } else {
                self.artistImageView.image = Constants.Images.avatar
                self.artistImageView.tintColor = .black
            }
        }
    }
    
    var artistName: String = "" {
        didSet {
            self.artistLabel.text = artistName
        }
    }
    
    var artistDescription: String = "" {
        didSet {
            self.descriptionLabel.text = artistDescription
        }
    }

    //init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
        setupMainViewLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - setup views

    private func configureViews() {
        artistSectionView.backgroundColor = .white
        
        artistStackView.distribution = .fill
        artistStackView.axis = .vertical
        artistStackView.spacing = 5
        
        artistImageView.layer.cornerRadius = Constants.IndentsAndSizes.circleItemsSize / 2
        artistImageView.clipsToBounds = true
        
        artistLabel.font = .systemFont(ofSize: 14, weight: .bold)
        artistLabel.textColor = .black

        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = .systemFont(ofSize: 16)
        descriptionLabel.textColor = .black
    }
    
    // MARK: - setup Layout

    private func setupMainViewLayout() {
        self.addSubview(artistSectionView)

        artistSectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            artistSectionView.topAnchor.constraint(equalTo: self.topAnchor),
            artistSectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            artistSectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            artistSectionView.widthAnchor.constraint(equalTo: self.widthAnchor),
            artistSectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
        
        setupArtistSectionViewLayout()
    }
    
    private func setupArtistSectionViewLayout() {
        artistSectionView.addSubview(artistImageView)
        artistSectionView.addSubview(artistStackView)
        
        artistStackView.addArrangedSubview(artistLabel)
        artistStackView.addArrangedSubview(descriptionLabel)
        
        artistImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            artistImageView.topAnchor.constraint(equalTo: artistSectionView.topAnchor, constant: Constants.IndentsAndSizes.spacing10),
            artistImageView.leadingAnchor.constraint(equalTo: artistSectionView.leadingAnchor, constant: Constants.IndentsAndSizes.spacing15),
            artistImageView.widthAnchor.constraint(equalToConstant: Constants.IndentsAndSizes.circleItemsSize),
            artistImageView.heightAnchor.constraint(equalToConstant: Constants.IndentsAndSizes.circleItemsSize),
        ])
        
        artistStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            artistStackView.leadingAnchor.constraint(equalTo: artistImageView.trailingAnchor, constant: Constants.IndentsAndSizes.spacing10),
            artistStackView.topAnchor.constraint(equalTo: artistImageView.topAnchor),
            artistStackView.trailingAnchor.constraint(equalTo: artistSectionView.trailingAnchor, constant: -Constants.IndentsAndSizes.spacing15),
            artistStackView.bottomAnchor.constraint(equalTo: artistSectionView.bottomAnchor, constant: -Constants.IndentsAndSizes.spacing10),
        ])
    }
    
    func setupArtistHeightConstraint(post: PostDetail?) -> CGFloat {
        let heightOfDescription = post?.description.height(withConstrainedWidth: self.artistStackView.frame.width, font: .systemFont(ofSize: 16)) ?? 0
        var height: CGFloat = 0

        if heightOfDescription <= Constants.IndentsAndSizes.spacing15*2 {
            height = Constants.IndentsAndSizes.artistDescriptionHeight
        } else {
            height = heightOfDescription+Constants.IndentsAndSizes.circleItemsSize
        }

        self.artistStackViewHeightConstraint = NSLayoutConstraint(item: self.artistStackView, attribute: .height, relatedBy: .lessThanOrEqual, toItem: nil, attribute: .height, multiplier: 1, constant: height)
        self.layoutIfNeeded()
        return height
    }
    
}
