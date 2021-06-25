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
    private let customFlowLayout = CustomFlowLayout()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        customFlowLayout.sectionInsetReference = .fromContentInset
        customFlowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        customFlowLayout.minimumInteritemSpacing = 10
        customFlowLayout.minimumLineSpacing = 10
        customFlowLayout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        customFlowLayout.headerReferenceSize = CGSize(width: 0, height: 40)
        postsCollectionView.collectionViewLayout = customFlowLayout
        postsCollectionView.contentInsetAdjustmentBehavior = .always
    }
    
    // MARK: - Actions
    @objc private func leftNavigationButtonAction() {
        
    }
    
    @objc private func rightNavigationButtonAction() {
        
    }
}

// MARK: - PostsListViewController + MainViewUpdater

extension PostsListViewController: MainViewUpdater {
    func updateActivityIndicator(isLoading: Bool) {
        isLoading ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
    }
    
    func reload() {
        postsCollectionView.reloadData()
    }
}

// MARK: - PostsListViewController UICollectionViewDataSource

extension PostsListViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
}

// MARK: - PostsListViewController  UICollectionViewDelegate

extension PostsListViewController : UICollectionViewDelegate {
    
}

