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

    //related posts section UI elements
    private lazy var relatedSectionView = UIView()
    private let relatedCollectionView = TattooCollectionView()
    
    //Properties
    var postId: Int?
    var viewModel: PostDetailViewModel = PostDetailViewModel(networkManager: NetworkManager())
    private var isLiked = false

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
//        self.artistSectionView.setupArtistHeightConstraint(post: viewModel.getPost())
//        tattooSectionView.roundCorners([.allCorners], radius: Constants.IndentsAndSizes.corner)
//        tattooSectionView.setButtonsCorners()
        relatedSectionView.roundCorners([.allCorners], radius: Constants.IndentsAndSizes.corner)
//        artistSectionView.roundCorners([.allCorners], radius: Constants.IndentsAndSizes.corner)
    }
    
    // MARK: - setup Layout
    
    private func setupMainScrollViewLayout() {
        view.addSubview(relatedSectionView)
        
        relatedSectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            relatedSectionView.topAnchor.constraint(equalTo: view.topAnchor),
            relatedSectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            relatedSectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            relatedSectionView.widthAnchor.constraint(equalTo: view.widthAnchor),
            relatedSectionView.heightAnchor.constraint(equalToConstant: Constants.IndentsAndSizes.relatedViewHeight),
            relatedSectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])

        setupRelatedSectionViewLayout()
    }
    
    //3rd section
    private func setupRelatedSectionViewLayout() {
        relatedSectionView.addSubview(relatedCollectionView)
    
        relatedCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            relatedCollectionView.topAnchor.constraint(equalTo: relatedSectionView.topAnchor, constant: Constants.IndentsAndSizes.spacing10),
            relatedCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            relatedCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            relatedCollectionView.bottomAnchor.constraint(equalTo: relatedSectionView.bottomAnchor, constant: -Constants.IndentsAndSizes.spacing10),
        ])
    }
    
    // MARK: - setup views

    private func setupRelatedCollectionView() {
        relatedCollectionView.register(DetailHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader , withReuseIdentifier: "DetailHeaderView")
        relatedCollectionView.dataSource = self
        relatedCollectionView.delegate = self
        relatedCollectionView.backgroundColor = .lightGray
        relatedCollectionView.collectionViewLayout = customFlowLayout
        if let layout = self.relatedCollectionView.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
            layout.headerReferenceSize = CGSize(width: self.relatedCollectionView.frame.size.width, height: 610)
        }
    }
    
    private func setupViews() {
        title = "Post Details"
        view.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .black
//        scrollView.backgroundColor = .gray
//        artistSectionView.backgroundColor = .white
//        artistSectionView.alpha = 1
    }
    
     override func setupRefreshControl() {
        super.setupRefreshControl()
        self.relatedCollectionView.alwaysBounceVertical = true
        self.relatedCollectionView.addSubview(refreshControl)
    }
    
    // MARK: - Actions

    @objc override func refreshData() {
        super.refreshData()
        viewModel.getPostsHandlePagination(id: self.postId ?? 0)
    }
    
    private func stopRefresher() {
        self.refreshControl.endRefreshing()
    }
    
    private func loadVC() {
//        artistSectionView.alpha = 0
        setupRelatedCollectionView()
        setupRefreshControl()
        viewModel.delegate = self
        viewModel.downloadPost(id: postId ?? 0)
        viewModel.getPostsHandlePagination(id: postId ?? 0)
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
        relatedCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                     withReuseIdentifier:
                                                                        "DetailHeaderView",
                                                                     for: indexPath) as! DetailHeaderView
        header.delegate = self
        header.tattooSectionView.setButtonsCorners()
        header.artistSectionView.roundCorners(.allCorners, radius: Constants.IndentsAndSizes.corner)

        if let post = viewModel.getPost() {
            if let imageUrl = URL(string: post.image.url) {
                header.tattooImageURL = imageUrl
            }
            header.savesCount = post.counts.pins
            header.artistName = post.artist?.name ?? ""
            header.artistDescription = post.description
            
            let artistImageUrl = URL(string: post.artist?.imageUrl ?? "")
            header.artistImageURL = artistImageUrl
            header.artistName = viewModel.getPost()?.artist?.name ?? ""
            header.artistDescription = viewModel.getPost()?.description ?? ""
        }
        return header
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

// MARK: - PostDetailViewController  PinterestLayoutDelegate

extension PostDetailViewController: DetaiHeaderViewDelegate {
    func shareDidTap() {
        let string = "Share current tattoo"
        if let url = URL(string: viewModel.getPost()?.shareUrl ?? "") {
            let vc = UIActivityViewController(activityItems: [string, url], applicationActivities: [])
            self.present(vc, animated: true, completion: nil)
        }
    }
}

extension PostDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 610) //add your height here
    }
}
