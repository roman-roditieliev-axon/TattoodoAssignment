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
    func reload()
}

class PostDetailViewController: BaseViewController {
    
    private lazy var scrollView = UIScrollView()
    
    //tattoo section UI elements
    private lazy var tattooImageView = UIImageView()
    private lazy var tattooBottomSectionView = UIView()
    private lazy var shareTattoButton = UIButton()
    private lazy var likeTattoButton = UIButton()
    private lazy var savesLabel = UILabel()
    
    //artist section UI elements
    private lazy var artistSectionView = UIView()
    private lazy var artistImageView = UIImageView()
    private lazy var artistStackView = UIStackView()
    private lazy var artistLabel = UILabel()
    private lazy var descriptionLabel = UILabel()
    
    //related posts section UI elements
    private lazy var relatedSectionView = UIView()
    private let relatedCollectionView = TattooCollectionView()

    //Constants
    private let tattooImageHeight: CGFloat = 450
    private let tattooShareSectionHeight: CGFloat = 60
    private let circleItemsSize: CGFloat = 40
    private let relatedViewHeight: CGFloat = 660
    private let corner: CGFloat = 20
    private let spacing10: CGFloat = 10
    private let spacing15: CGFloat = 15
    
    //Properties
    var postId: Int?
    var viewModel: PostDetailViewModel = PostDetailViewModel(networkManager: NetworkManager())
    private var isLiked = false
    private var artistStackViewHeightConstraint: NSLayoutConstraint?

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
        self.loadVC()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tattooImageView.roundCorners([.topLeft, .topRight], radius: corner)
        tattooBottomSectionView.roundCorners([.bottomLeft, .bottomRight], radius: corner)
        likeTattoButton.roundCorners([.allCorners], radius: corner)
        shareTattoButton.roundCorners([.allCorners], radius: corner)
        relatedSectionView.roundCorners([.allCorners], radius: corner)
        if let post = viewModel.getPost() {
            setupArtistHeightConstraint(post: post)
            self.view.layoutIfNeeded()
        } else {
            artistStackViewHeightConstraint?.constant = circleItemsSize
        }
        artistSectionView.roundCorners([.allCorners], radius: corner)
    }
    
    // MARK: - setup Layout
    
    private func setupMainScrollViewLayout() {
        view.addSubview(scrollView)
        scrollView.addSubview(tattooImageView)
        scrollView.addSubview(tattooBottomSectionView)
        scrollView.addSubview(artistSectionView)
        scrollView.addSubview(relatedSectionView)
        
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
            tattooBottomSectionView.bottomAnchor.constraint(equalTo: artistSectionView.topAnchor, constant: -spacing15),
        ])
        
        artistSectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            artistSectionView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            artistSectionView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            artistSectionView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            artistSectionView.bottomAnchor.constraint(equalTo: relatedSectionView.topAnchor, constant: -spacing15),
        ])
        
        relatedSectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            relatedSectionView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            relatedSectionView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            relatedSectionView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            relatedSectionView.heightAnchor.constraint(equalToConstant: relatedViewHeight),
            relatedSectionView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -spacing15*2),
        ])
        
        tattooBottomSectionViewLayout()
        setupArtistSectionViewLayout()
        setupRelatedSectionViewLayout()
    }
    
    //1st section
    private func tattooBottomSectionViewLayout() {
        tattooBottomSectionView.addSubview(likeTattoButton)
        tattooBottomSectionView.addSubview(shareTattoButton)
        tattooBottomSectionView.addSubview(savesLabel)
        
        likeTattoButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            likeTattoButton.leadingAnchor.constraint(equalTo: tattooBottomSectionView.leadingAnchor, constant: spacing10*2),
            likeTattoButton.topAnchor.constraint(equalTo: tattooBottomSectionView.topAnchor, constant: spacing10),
            likeTattoButton.heightAnchor.constraint(equalToConstant: circleItemsSize),
            likeTattoButton.widthAnchor.constraint(equalToConstant: circleItemsSize),
            likeTattoButton.bottomAnchor.constraint(equalTo: tattooBottomSectionView.bottomAnchor, constant: -spacing10),
        ])
        
        shareTattoButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            shareTattoButton.trailingAnchor.constraint(equalTo: tattooBottomSectionView.trailingAnchor, constant: -spacing10*2),
            shareTattoButton.topAnchor.constraint(equalTo: tattooBottomSectionView.topAnchor, constant: spacing10),
            shareTattoButton.heightAnchor.constraint(equalToConstant: circleItemsSize),
            shareTattoButton.widthAnchor.constraint(equalToConstant: circleItemsSize),
            shareTattoButton.bottomAnchor.constraint(equalTo: tattooBottomSectionView.bottomAnchor, constant: -spacing10),
        ])
        
        savesLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            savesLabel.leadingAnchor.constraint(equalTo: likeTattoButton.trailingAnchor, constant: spacing10),
            savesLabel.centerYAnchor.constraint(equalTo: likeTattoButton.centerYAnchor),
            savesLabel.heightAnchor.constraint(equalToConstant: circleItemsSize/2),
            savesLabel.trailingAnchor.constraint(equalTo: shareTattoButton.leadingAnchor, constant: -circleItemsSize),
        ])
    }
    
    //2nd section
    private func setupArtistSectionViewLayout() {
        artistSectionView.addSubview(artistImageView)
        artistSectionView.addSubview(artistStackView)
        
        artistStackView.addArrangedSubview(artistLabel)
        artistStackView.addArrangedSubview(descriptionLabel)
        
        artistImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            artistImageView.topAnchor.constraint(equalTo: artistSectionView.topAnchor, constant: spacing10),
            artistImageView.leadingAnchor.constraint(equalTo: artistSectionView.leadingAnchor, constant: spacing15),
            artistImageView.widthAnchor.constraint(equalToConstant: circleItemsSize),
            artistImageView.heightAnchor.constraint(equalToConstant: circleItemsSize),
        ])
        
        artistStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            artistStackView.leadingAnchor.constraint(equalTo: artistImageView.trailingAnchor, constant: spacing10),
            artistStackView.topAnchor.constraint(equalTo: artistImageView.topAnchor),
            artistStackView.trailingAnchor.constraint(equalTo: artistSectionView.trailingAnchor, constant: -spacing15),
            artistStackView.bottomAnchor.constraint(equalTo: artistSectionView.bottomAnchor, constant: -spacing10),
        ])
        
        artistLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            artistLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: spacing15)
        ])
    }
    
    private func setupArtistHeightConstraint(post: PostDetail) {
        let heightOfDescription = post.description.height(withConstrainedWidth: self.artistStackView.frame.width, font: .systemFont(ofSize: 16))
        self.artistStackViewHeightConstraint?.isActive = false
        self.artistStackViewHeightConstraint = NSLayoutConstraint(item: self.artistStackView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: heightOfDescription+30)
        self.artistStackViewHeightConstraint?.isActive = true
    }
    
    //3rd section
    private func setupRelatedSectionViewLayout() {
        relatedSectionView.addSubview(relatedCollectionView)
    
        relatedCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            relatedCollectionView.topAnchor.constraint(equalTo: relatedSectionView.topAnchor, constant: spacing10),
            relatedCollectionView.leadingAnchor.constraint(equalTo: artistSectionView.leadingAnchor),
            relatedCollectionView.trailingAnchor.constraint(equalTo: artistSectionView.trailingAnchor),
            relatedCollectionView.bottomAnchor.constraint(equalTo: relatedSectionView.bottomAnchor, constant: -spacing10),
        ])
    }
    
    // MARK: - setup views

    private func setupRelatedCollectionView() {
        relatedCollectionView.dataSource = self
        relatedCollectionView.delegate = self
        relatedCollectionView.collectionViewLayout = customFlowLayout
        if let layout = self.relatedCollectionView.collectionViewLayout as? PinterestLayout {
          layout.delegate = self
        }
    }
    
    private func setupViews() {
        title = "Post Details"
        view.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .black
        scrollView.backgroundColor = .gray
        
        tattooBottomSectionView.backgroundColor = .white
        tattooImageView.contentMode = .scaleToFill
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
        
        artistSectionView.alpha = 0
        artistSectionView.backgroundColor = .white
        
        artistStackView.distribution = .fillProportionally
        artistStackView.axis = .vertical
        artistStackView.spacing = 5
        
        artistImageView.layer.cornerRadius = circleItemsSize / 2
        artistImageView.clipsToBounds = true
        
        artistLabel.font = .systemFont(ofSize: 14, weight: .bold)
        artistLabel.textColor = .black

        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = .systemFont(ofSize: 16)
        descriptionLabel.textColor = .black
        
        relatedSectionView.backgroundColor = .white
        scrollView.alpha = 1
    }
    
     override func setupRefreshControl() {
        super.setupRefreshControl()
        self.relatedCollectionView.alwaysBounceVertical = true
        self.relatedCollectionView.addSubview(refreshControl)
    }
    
    // MARK: - Actions

    @objc private func likeDidTap() {
        if !isLiked {
            self.savesLabel.text = "\(viewModel.getNumberOfPins()+1) pins"
            isLiked = true
            likeTattoButton.backgroundColor = UIColor.lightGray.withAlphaComponent(0.7)
        } else {
            self.savesLabel.text = "\(viewModel.getNumberOfPins()) pins"
            isLiked = false
            likeTattoButton.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        }
    }
    
    @objc private func shareDidTap() {
        let string = "Share current tattoo"
        if let url = URL(string: viewModel.getPost()?.shareUrl ?? "") {
            let vc = UIActivityViewController(activityItems: [string, url], applicationActivities: [])
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    @objc override func refreshData() {
        super.refreshData()
        viewModel.downloadRelatedPosts(id: self.postId ?? 0)
    }
    
    private func stopRefresher() {
        self.refreshControl.endRefreshing()
    }
    
    private func loadVC() {
        artistSectionView.alpha = 0
        setupRelatedCollectionView()
        setupRefreshControl()
        viewModel.delegate = self
        viewModel.downloadPost(id: postId ?? 0)
        viewModel.downloadRelatedPosts(id: postId ?? 0)
        setupMainScrollViewLayout()
        setupViews()
    }
}

// MARK: - PostDetailViewController PostDetailViewUpdater

extension PostDetailViewController: PostDetailViewUpdater {
    func reload() {
        DispatchQueue.main.async {
            self.relatedCollectionView.reloadData()
            self.stopRefresher()
        }
    }
    
    func updateActivityIndicator(isLoading: Bool) {
        DispatchQueue.main.async {
            isLoading ? self.activityIndicator.startAnimating() : self.activityIndicator.stopAnimating()
        }
    }
    
    func showDetails(of post: PostDetail) {
        DispatchQueue.main.async {
            if let imageUrl = URL(string: post.image.url) {
                self.tattooImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
                self.tattooImageView.sd_setImage(with: imageUrl)
            }
            self.savesLabel.text = "\(post.counts.pins) pins"
            self.artistLabel.text = post.artist?.name
            self.descriptionLabel.text = post.description
            
            if let artistImageUrl = URL(string: post.artist?.imageUrl ?? "") {
                self.artistImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
                self.artistImageView.sd_setImage(with: artistImageUrl)
            } else {
                self.artistImageView.image = UIImage(systemName: "person.circle")
                self.artistImageView.tintColor = .black
            }
            
            self.setupArtistHeightConstraint(post: post)
            self.artistSectionView.alpha = 1
        }
    }
}


// MARK: - PostDetailViewController UICollectionViewDataSource, UICollectionViewDelegate
extension PostDetailViewController : UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getNumberOfRelatedPosts()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: relatedCollectionView.postCellReuseIdentifier, for: indexPath) as! PostCollectionViewCell
        cell.setupCell(stringUrl: viewModel.getRelatedPosts()[indexPath.row].image.url)
        cell.contentView.layer.cornerRadius = corner
        return cell
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard scrollView.contentSize.height > scrollView.frame.size.height, scrollView.isScrolledToTheBottom(offset: relatedCollectionView.bounds.height) else { return }
        viewModel.didScrollToBottom(id: self.postId ?? 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.postId = viewModel.getRelatedPosts()[indexPath.row].id
        self.scrollView.alpha = 0
        self.loadVC()
        self.scrollView.setContentOffset(.zero, animated: true)
    }
}

// MARK: - PostDetailViewController  PinterestLayoutDelegate

extension PostDetailViewController: PinterestLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView,
        heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat {
        let heightOfCell = calculateHeightOfCollectionItem(imageWidth: CGFloat(viewModel.getRelatedPosts()[indexPath.row].image.width), imageHeight: CGFloat(viewModel.getRelatedPosts()[indexPath.row].image.height))
        return heightOfCell
    }
}
