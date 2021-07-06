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
    func reload()
}

class PostDetailViewController: BaseViewController {

    //related posts section UI elements
    private lazy var relatedSectionView = UIView()
    private lazy var relatedCollectionView = TattooCollectionView()
    private lazy var relatedBackgroundView = UIView()
    
    //Properties
    var postId: Int?
    var viewModel: PostDetailViewModel = PostDetailViewModel(networkManager: NetworkManager())
    private var headerHeight: CGFloat = Constants.IndentsAndSizes.headerHeight
    private let navigationTitle = "Post Details"
    private let headerView = "DetailHeaderView"
    private let shareTitle = "Share current tattoo"

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
        self.loadVC()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        relatedSectionView.roundCorners([.topLeft, .topRight], radius: Constants.IndentsAndSizes.corner)
    }
    
    // MARK: - setup Layout
    
    private func setupMainLayout() {
        view.addSubview(relatedSectionView)
        
        relatedSectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            relatedSectionView.topAnchor.constraint(equalTo: view.topAnchor),
            relatedSectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            relatedSectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            relatedSectionView.widthAnchor.constraint(equalTo: view.widthAnchor),
            relatedSectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])

        setupRelatedCollectionViewLayout()
    }
    
    private func setupRelatedCollectionViewLayout() {
        relatedSectionView.addSubview(relatedCollectionView)
    
        relatedCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            relatedCollectionView.topAnchor.constraint(equalTo: relatedSectionView.topAnchor, constant: Constants.IndentsAndSizes.spacing10),
            relatedCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            relatedCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            relatedCollectionView.bottomAnchor.constraint(equalTo: relatedSectionView.bottomAnchor, constant: Constants.IndentsAndSizes.spacing10),
        ])
    }
    
    // MARK: - setup views

    private func setupRelatedCollectionView() {
        relatedCollectionView.register(DetailHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader , withReuseIdentifier: headerView)
        relatedCollectionView.dataSource = self
        relatedCollectionView.delegate = self
        relatedCollectionView.backgroundColor = .lightGray
        relatedCollectionView.collectionViewLayout = customFlowLayout
        if let layout = self.relatedCollectionView.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
            layout.headerReferenceSize = CGSize(width: self.relatedCollectionView.frame.size.width, height: headerHeight)
        }
    }
    
    private func setupViews() {
        title = navigationTitle
        view.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .black
    }
    
    private func setupHeaderView(indexPath: IndexPath, kind: String) -> DetailHeaderView{
        let header = relatedCollectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                     withReuseIdentifier:
                                                                        headerView,
                                                                     for: indexPath) as! DetailHeaderView
        header.delegate = self

        if let post = viewModel.getPost() {
            if let imageUrl = URL(string: post.image.url) {
                header.tattooImageURL = imageUrl
            }
            header.savesCount = post.counts.pins
            let artistImageUrl = URL(string: post.artist?.imageUrl ?? "")
            header.artistImageURL = artistImageUrl
            header.artistName = post.artist?.name ?? ""
            header.artistDescription = post.description
            headerHeight = Constants.IndentsAndSizes.tattooImageHeight + Constants.IndentsAndSizes.tattooShareSectionHeight + (Constants.IndentsAndSizes.spacing10) + (Constants.IndentsAndSizes.spacing15*2) + header.artistSectionView.setupArtistHeightConstraint(post: post)
            if let layout = self.relatedCollectionView.collectionViewLayout as? PinterestLayout {
                layout.headerReferenceSize = CGSize(width: self.relatedCollectionView.frame.size.width, height: headerHeight)
            }
        }

        header.tattooSectionView.setButtonsCorners()
        header.artistSectionView.roundCorners(.allCorners, radius: Constants.IndentsAndSizes.corner)

        return header
    }
    
     override func setupRefreshControl() {
        super.setupRefreshControl()
        self.relatedCollectionView.alwaysBounceVertical = true
        self.relatedCollectionView.addSubview(refreshControl)
    }
    
    // MARK: - Actions

    @objc override func refreshData() {
        super.refreshData()
        guard let postID = self.postId else { return }
        viewModel.getPostsHandlePagination(id: postID)
    }
    
    private func stopRefresher() {
        self.refreshControl.endRefreshing()
    }
    
    private func loadVC() {
        setupRelatedCollectionView()
        setupRefreshControl()
        if let postID = postId {
            viewModel.downloadPost(id: postID)
            viewModel.getPostsHandlePagination(id: postID)
        }
        setupMainLayout()
        setupViews()
    }
    
    private func scrollToTopCollectionView(indexPath: IndexPath) {
        if let attributes = relatedCollectionView.layoutAttributesForSupplementaryElement(ofKind: UICollectionView.elementKindSectionHeader, at: indexPath) {
            var offsetY = attributes.frame.origin.y - relatedCollectionView.contentInset.top
            offsetY -= relatedCollectionView.safeAreaInsets.top
            relatedCollectionView.setContentOffset(CGPoint(x: 0, y: offsetY), animated: false)
        }
    }
}

// MARK: - PostDetailViewController PostDetailViewUpdater

extension PostDetailViewController: PostDetailViewUpdater {
    func reload() {
        DispatchQueue.main.async {
            self.relatedCollectionView.collectionViewLayout.invalidateLayout()
            self.relatedCollectionView.reloadData()
            self.relatedCollectionView.layoutIfNeeded()
            self.stopRefresher()
        }
    }
    
    func updateActivityIndicator(isLoading: Bool) {
        DispatchQueue.main.async {
            isLoading ? self.activityIndicator.startAnimating() : self.activityIndicator.stopAnimating()
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
        cell.contentView.layer.cornerRadius = Constants.IndentsAndSizes.corner
        return cell
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard scrollView.contentSize.height > scrollView.frame.size.height, scrollView.isScrolledToTheBottom(offset: relatedCollectionView.bounds.height) else { return }
        viewModel.didScrollToBottom(id: self.postId ?? 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.postId = viewModel.getRelatedPosts()[indexPath.row].id
        self.loadVC()
        self.scrollToTopCollectionView(indexPath: indexPath)
        self.relatedCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        return setupHeaderView(indexPath: indexPath, kind: kind)
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

// MARK: - PostDetailViewController  DetaiHeaderViewDelegate

extension PostDetailViewController: DetaiHeaderViewDelegate {
    func shareDidTap() {
        if let url = URL(string: viewModel.getPost()?.shareUrl ?? "") {
            let vc = UIActivityViewController(activityItems: [shareTitle, url], applicationActivities: [])
            self.present(vc, animated: true, completion: nil)
        }
    }
}

// MARK: - PostDetailViewController  UICollectionViewDelegateFlowLayout

extension PostDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: headerHeight)
    }
}
