//
//  DetailHeaderView.swift
//  TattoodoAssignment (iOS)
//
//  Created by User on 02.07.2021.
//

import UIKit

protocol DetaiHeaderViewDelegate: class {
    func shareDidTap()
}

class DetailHeaderView: UICollectionViewCell {
    
    lazy var tattooSectionView = TattooSectionView()
    lazy var artistSectionView = ArtistSectionView()
    
    weak var delegate: DetaiHeaderViewDelegate?

    var tattooImageURL: URL? = URL(string: "") {
        didSet{
            tattooSectionView.tattooImageURL = tattooImageURL
        }
    }
    
    var savesCount: Int = 0 {
        didSet {
            tattooSectionView.savesCount = savesCount
        }
    }
    
    var artistImageURL: URL? = URL(string: "") {
        didSet{
            artistSectionView.artistImageURL = artistImageURL
        }
    }
    
    var artistName: String = "" {
        didSet {
            artistSectionView.artistName = artistName
        }
    }
    
    var artistDescription: String = "" {
        didSet {
            artistSectionView.artistDescription = artistDescription
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        self.backgroundColor = .clear
        self.tattooSectionView.delegate = self
    }
    
    private func setupLayout() {
        self.addSubview(tattooSectionView)
        self.addSubview(artistSectionView)
        
        tattooSectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tattooSectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            tattooSectionView.topAnchor.constraint(equalTo: self.topAnchor),
            tattooSectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            tattooSectionView.widthAnchor.constraint(equalTo: self.widthAnchor),
            tattooSectionView.bottomAnchor.constraint(equalTo: artistSectionView.topAnchor, constant: -Constants.IndentsAndSizes.spacing15),
        ])
        
        artistSectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            artistSectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            artistSectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            artistSectionView.widthAnchor.constraint(equalTo: self.widthAnchor),
            artistSectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -Constants.IndentsAndSizes.spacing15),
        ])
    }
}

extension DetailHeaderView: TappedSharedButtonDelegate {
    func shareDidTap() {
        delegate?.shareDidTap()
    }
}
