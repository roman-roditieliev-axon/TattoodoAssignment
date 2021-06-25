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

class PostsListViewController: UIViewController {
    
    private var activityIndicator = UIActivityIndicatorView(style: .medium)
    private let postsCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    private let customFlowLayout = PinterestLayout()
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
        viewModel.delegate = self
        viewModel.getPosts()
        if let layout = postsCollectionView.collectionViewLayout as? PinterestLayout {
          layout.delegate = self
        }
        
        setupNavigationBar()
        setupLayout()
        setupViews()
    }
    
    // MARK: - setup vc
    private func setupNavigationBar() {
        self.title = "Tattoo List"
        self.navigationController?.navigationBar.barTintColor = .lightGray
        let leftButton = UIBarButtonItem(image: UIImage(systemName: "house"), style: .plain, target: self, action: #selector(leftNavigationButtonAction))
        let rightButton = UIBarButtonItem(image: UIImage(systemName: "info.circle"), style: .plain, target: self, action:  #selector(rightNavigationButtonAction))
        leftButton.tintColor = .black
        rightButton.tintColor = .black

        self.navigationItem.rightBarButtonItem  = rightButton
        self.navigationItem.leftBarButtonItem  = leftButton
    }

    private func setupLayout() {
        view.addSubview(postsCollectionView)
        view.addSubview(activityIndicator)
        
        postsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            postsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            postsCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            postsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            postsCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            activityIndicator.topAnchor.constraint(equalTo: view.topAnchor),
            activityIndicator.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            activityIndicator.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        
        postsCollectionView.dataSource = self
        postsCollectionView.delegate = self
        postsCollectionView.delaysContentTouches = false
        postsCollectionView.backgroundColor = .white
        postsCollectionView.collectionViewLayout = customFlowLayout
        postsCollectionView.contentInsetAdjustmentBehavior = .always
        postsCollectionView.register(PostCollectionViewCell.self, forCellWithReuseIdentifier: "PostCollectionViewCell")
    }
    
    // MARK: - Actions
    @objc private func leftNavigationButtonAction() {
        print("left button did tap")
    }
    
    @objc private func rightNavigationButtonAction() {
        print("right button did tap")
    }
}

// MARK: - PostsListViewController + MainViewUpdater

extension PostsListViewController: MainViewUpdater {
    func updateActivityIndicator(isLoading: Bool) {
        isLoading ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
    }
    
    func reload() {
        DispatchQueue.main.async {
            self.postsCollectionView.reloadData()
        }
    }
}

// MARK: - PostsListViewController UICollectionViewDataSource

extension PostsListViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfPosts()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostCollectionViewCell", for: indexPath) as! PostCollectionViewCell
        cell.setupCell(post: viewModel.post(at: indexPath))
        cell.contentView.layer.cornerRadius = 20
        return cell
    }
}

// MARK: - PostsListViewController  UICollectionViewDelegate

extension PostsListViewController : UICollectionViewDelegate {
    
}


// MARK: - PostsListViewController  PinterestLayoutDelegate

extension PostsListViewController: PinterestLayoutDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat {
        return 200
    }
}

