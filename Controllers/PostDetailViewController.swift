//
//  PostDetailViewController.swift
//  TattoodoAssignment (iOS)
//
//  Created by User on 27.06.2021.
//

import UIKit
import SDWebImage

// MARK: - PostDetailViewUpdater
protocol PostDetailViewUpdater: class {
    func updateActivityIndicator(isLoading: Bool)
    func showDetails(of post: PostDetail)
}

class PostDetailViewController: UIViewController {
    
    private lazy var scrollView = UIScrollView()
    
    //tattoo section
    private lazy var tattooImageView = UIImageView()
    private lazy var tattooBottomSectionView = UIView()
    private lazy var shareTattoButton = UIButton()
    private lazy var likeTattoButton = UIButton()
    private lazy var savesLabel = UILabel()
    
    //artist section
    private lazy var artistImageView = UIImageView()
    private lazy var artistStackView = UIStackView()
    private lazy var artistLabel = UILabel()
    
    //related posts section
    private lazy var descriptionLabel = UILabel()
    
    
    private var activityIndicator = UIActivityIndicatorView(style: .medium)
    private let tattooImageHeight: CGFloat = 460
    private let tattooShareSectionHeight: CGFloat = 60
    private let circleItemsSize: CGFloat = 40

    var postId: Int?
    var viewModel: PostDetailViewModel = PostDetailViewModel(networkManager: NetworkManager())
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
        viewModel.delegate = self
        viewModel.getPost(id: postId ?? 0)
        setupLayout()
        setupViews()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tattooImageView.roundCorners([.topLeft, .topRight], radius: 20)
        tattooBottomSectionView.roundCorners([.bottomLeft, .bottomRight], radius: 20)
        likeTattoButton.roundCorners([.allCorners], radius: 20)
        shareTattoButton.roundCorners([.allCorners], radius: 20)
    }
    
    // MARK: - setup vc
    
    private func setupLayout() {
        view.addSubview(scrollView)
        scrollView.addSubview(tattooImageView)
        scrollView.addSubview(tattooBottomSectionView)
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
        ])
        
        tattooBottomSectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tattooBottomSectionView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            tattooBottomSectionView.topAnchor.constraint(equalTo: tattooImageView.bottomAnchor),
            tattooBottomSectionView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            tattooBottomSectionView.heightAnchor.constraint(equalToConstant: tattooShareSectionHeight),
            tattooBottomSectionView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            tattooBottomSectionView.bottomAnchor.constraint(equalTo: artistImageView.topAnchor, constant: -10),
        ])
        
        artistImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            artistImageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            artistImageView.widthAnchor.constraint(equalToConstant: circleItemsSize),
            artistImageView.heightAnchor.constraint(equalToConstant: circleItemsSize),
        ])
        
        artistStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            artistStackView.leadingAnchor.constraint(equalTo: artistImageView.trailingAnchor, constant: 10),
            artistStackView.topAnchor.constraint(equalTo: artistImageView.topAnchor),
            artistStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            artistStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -16),
        ])
        
        tattooBottomSectionViewLayout()
    }
    
    private func tattooBottomSectionViewLayout() {
        tattooBottomSectionView.addSubview(likeTattoButton)
        tattooBottomSectionView.addSubview(shareTattoButton)
        tattooBottomSectionView.addSubview(savesLabel)
        
        likeTattoButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            likeTattoButton.leadingAnchor.constraint(equalTo: tattooBottomSectionView.leadingAnchor, constant: 20),
            likeTattoButton.topAnchor.constraint(equalTo: tattooBottomSectionView.topAnchor, constant: 10),
            likeTattoButton.heightAnchor.constraint(equalToConstant: circleItemsSize),
            likeTattoButton.widthAnchor.constraint(equalToConstant: circleItemsSize),
            likeTattoButton.bottomAnchor.constraint(equalTo: tattooBottomSectionView.bottomAnchor, constant: -10),
        ])
        
        shareTattoButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            shareTattoButton.trailingAnchor.constraint(equalTo: tattooBottomSectionView.trailingAnchor, constant: -20),
            shareTattoButton.topAnchor.constraint(equalTo: tattooBottomSectionView.topAnchor, constant: 10),
            shareTattoButton.heightAnchor.constraint(equalToConstant: circleItemsSize),
            shareTattoButton.widthAnchor.constraint(equalToConstant: circleItemsSize),
            shareTattoButton.bottomAnchor.constraint(equalTo: tattooBottomSectionView.bottomAnchor, constant: -10),
        ])
        
        savesLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            savesLabel.leadingAnchor.constraint(equalTo: likeTattoButton.trailingAnchor, constant: 10),
            savesLabel.centerYAnchor.constraint(equalTo: likeTattoButton.centerYAnchor),
            savesLabel.heightAnchor.constraint(equalToConstant: circleItemsSize/2),
            savesLabel.trailingAnchor.constraint(equalTo: shareTattoButton.leadingAnchor, constant: -circleItemsSize),
        ])
    }
    
    private func setupViews() {
        title = "Post Details"
        view.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .black
        
        scrollView.backgroundColor = .gray
        tattooBottomSectionView.backgroundColor = .white
        
        likeTattoButton.setImage(UIImage(systemName: "heart"), for: .normal)
        likeTattoButton.tintColor = .black
        likeTattoButton.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)

        shareTattoButton.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        shareTattoButton.tintColor = .black
        shareTattoButton.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        
        savesLabel.textColor = .gray
        savesLabel.font = UIFont.systemFont(ofSize: 14)
        savesLabel.text = "1492 saves"

        artistImageView.layer.cornerRadius = circleItemsSize / 2
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
        DispatchQueue.main.async {
            if let imageUrl = URL(string: post.image.url) {
                self.tattooImageView.sd_setImage(with: imageUrl)
            }
            
            self.artistLabel.text = post.artist.name
            self.descriptionLabel.text = post.description
            
            if let artistImageUrl = URL(string: post.artist.imageUrl) {
                self.artistImageView.sd_setImage(with: artistImageUrl)
            }
        }
    }
}
