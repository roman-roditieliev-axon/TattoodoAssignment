//
//  PostDetailViewController.swift
//  TattoodoAssignment (iOS)
//
//  Created by User on 27.06.2021.
//

import UIKit
import SDWebImage

private let tattooImageHeight: CGFloat = 450
private let artistImageSize: CGFloat = 40

// MARK: - PostDetailViewUpdater
protocol PostDetailViewUpdater: class {
    func updateActivityIndicator(isLoading: Bool)
    func showDetails(of post: PostDetail)
}

class PostDetailViewController: UIViewController {
    private lazy var scrollView = UIScrollView()
    private(set) lazy var tattooImageView = UIImageView()
    private lazy var artistImageView = UIImageView()
    private lazy var artistStackView = UIStackView()
    private lazy var artistLabel = UILabel()
    private lazy var descriptionLabel = UILabel()
    private var activityIndicator = UIActivityIndicatorView(style: .medium)

    
    // MARK: - Init
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        setupViews()
    }
    
    // MARK: - setup vc
    
    private func setupLayout() {
        view.addSubview(scrollView)
        scrollView.addSubview(tattooImageView)
        scrollView.addSubview(artistImageView)
        scrollView.addSubview(artistStackView)
        
        artistStackView.addArrangedSubview(artistLabel)
        artistStackView.addArrangedSubview(descriptionLabel)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        tattooImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tattooImageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            tattooImageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            tattooImageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            tattooImageView.heightAnchor.constraint(equalToConstant: tattooImageHeight),
            tattooImageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            tattooImageView.bottomAnchor.constraint(equalTo: artistImageView.topAnchor, constant: -10),
        ])
        
        artistImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            artistImageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            artistImageView.widthAnchor.constraint(equalToConstant: artistImageSize),
            artistImageView.heightAnchor.constraint(equalToConstant: artistImageSize),
        ])
        
        artistStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            artistStackView.leadingAnchor.constraint(equalTo: artistImageView.trailingAnchor, constant: 10),
            artistStackView.topAnchor.constraint(equalTo: artistImageView.topAnchor),
            artistStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            artistStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -16),
        ])
    }
    
    private func setupViews() {
        title = "Post Details"
        view.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .black

        artistImageView.layer.cornerRadius = artistImageSize / 2
        artistImageView.clipsToBounds = true
        artistImageView.sd_imageTransition = .fade
        
        artistLabel.font = .systemFont(ofSize: 14, weight: .bold)
        
        artistStackView.axis = .vertical
        artistStackView.spacing = 3
        
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = .systemFont(ofSize: 16)
        
        tattooImageView.contentMode = .scaleAspectFill
        tattooImageView.clipsToBounds = true
    }
}

// MARK: - PostDetailViewController PostDetailViewUpdater

extension PostDetailViewController: PostDetailViewUpdater {
    func updateActivityIndicator(isLoading: Bool) {
        DispatchQueue.main.async {
            isLoading ? self.activityIndicator.startAnimating() : self.activityIndicator.stopAnimating()
        }
    }
    
    func showDetails(of post: PostDetail) {
        if let imageUrl = URL(string: post.image.url) {
            tattooImageView.sd_setImage(with: imageUrl)
        }
        
        artistLabel.text = post.artist.name
        descriptionLabel.text = post.description
        
        if let artistImageUrl = URL(string: post.artist.imageUrl) {
            artistImageView.sd_setImage(with: artistImageUrl)
        }
    }
}
