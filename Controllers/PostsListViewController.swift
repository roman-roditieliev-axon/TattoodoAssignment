//
//  PostsListViewController.swift
//  TattoodoAssignment (iOS)
//
//  Created by User on 24.06.2021.
//

import UIKit

protocol MainViewUpdater: class {
    func updateActivityIndicator(isLoading: Bool)
    func reload()
}

class PostsListViewController: BaseViewController {
    
    private var mainCoordinator: MainCoordinator!
    private let postsCollectionView = TattooCollectionView()
    private let navigationTitle = "Tattoo List"

    var viewModel: PostsListViewModel = PostsListViewModel(networkManager: NetworkManager())
    
    // MARK: - Init
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainCoordinator = MainCoordinator()
        viewModel.delegate = self
        viewModel.getPostsHandlePagination()
        setupNavigationBar()
        setupRefreshControl()
        setupLayout()
        setupViews()
    }
    
    // MARK: - setup vc
    
    private func setupNavigationBar() {
        self.title = navigationTitle
        self.navigationController?.navigationBar.barTintColor = .lightGray
        let leftButton = UIBarButtonItem(image: Constants.Images.home, style: .plain, target: self, action: #selector(leftNavigationButtonAction))
        let rightButton = UIBarButtonItem(image: Constants.Images.info, style: .plain, target: self, action:  #selector(rightNavigationButtonAction))
        leftButton.tintColor = .black
        rightButton.tintColor = .black

        self.navigationItem.rightBarButtonItem  = rightButton
        self.navigationItem.leftBarButtonItem  = leftButton
    }
    
     override func setupRefreshControl() {
        super.setupRefreshControl()
        self.postsCollectionView.alwaysBounceVertical = true
        self.postsCollectionView.addSubview(refreshControl)
    }

    private func setupLayout() {
        view.addSubview(postsCollectionView)
        
        postsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            postsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            postsCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            postsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            postsCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        postsCollectionView.dataSource = self
        postsCollectionView.delegate = self
        postsCollectionView.collectionViewLayout = customFlowLayout
        if let layout = self.postsCollectionView.collectionViewLayout as? PinterestLayout {
          layout.delegate = self
        }
    }
    
    // MARK: - Actions
    
    @objc private func leftNavigationButtonAction() {
        print("left button did tap")
        self.postsCollectionView.setContentOffset(.zero, animated: true)
    }
    
    @objc private func rightNavigationButtonAction() {
        print("right button did tap")
    }
    
    @objc override func refreshData() {
        super.refreshData()
        viewModel.getPostsHandlePagination()
    }
    
    private func stopRefresher() {
        self.refreshControl.endRefreshing()
    }
}

// MARK: - PostsListViewController + MainViewUpdater

extension PostsListViewController: MainViewUpdater {
    func updateActivityIndicator(isLoading: Bool) {
        DispatchQueue.main.async {
            isLoading ? self.activityIndicator.startAnimating() : self.activityIndicator.stopAnimating()
        }
    }
    
    func reload() {
        DispatchQueue.main.async {
            self.postsCollectionView.reloadData()
            self.stopRefresher()
        }
    }
}

// MARK: - PostsListViewController UICollectionViewDataSource, UICollectionViewDelegate

extension PostsListViewController : UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getNumberOfPosts()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: postsCollectionView.postCellReuseIdentifier, for: indexPath) as! PostCollectionViewCell
        cell.setupCell(stringUrl: viewModel.getPost(at: indexPath).data.image.url)
        cell.contentView.layer.cornerRadius = Constants.IndentsAndSizes.corner
        return cell
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard scrollView.contentSize.height > scrollView.frame.size.height, scrollView.isScrolledToTheBottom(offset: postsCollectionView.bounds.height) else { return }
        viewModel.didScrollToBottom()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailCoordinator = DetailCoordinator(sourceViewController: self)
        detailCoordinator.postId = viewModel.getPost(at: indexPath).data.id
        self.mainCoordinator.addChildCoordinator(detailCoordinator) 
    }
}

// MARK: - PostsListViewController  PinterestLayoutDelegate

extension PostsListViewController: PinterestLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView,
        heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat {
        let heightOfCell = calculateHeightOfCollectionItem(imageWidth: CGFloat(viewModel.getPost(at: indexPath).data.image.width), imageHeight: CGFloat(viewModel.getPost(at: indexPath).data.image.height))
        return heightOfCell
    }
}

