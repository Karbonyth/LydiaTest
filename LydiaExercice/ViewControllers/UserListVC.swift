//
//  UserListVC.swift
//  LydiaExercice
//
//  Created by Stephen Sement on 25/03/2023.
//

import UIKit

class UserListVC: UIViewController {
    
    private var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(UserCell.self, forCellWithReuseIdentifier: UserCell.reuseIdentifier)
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "FooterView")
        collectionView.backgroundColor = .primaryBackground
        return collectionView
    }()
    
    private var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "searchBarPlaceholder".localized
        searchController.searchBar.sizeToFit()
        return searchController
    }()

    private let errorView: ErrorView = {
        let view = ErrorView()
        view.backgroundColor = .primaryBackground
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let refreshControl = UIRefreshControl()
    private var userListViewModel = UserListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "mainScreenTitle".localized
        navigationController?.navigationBar.prefersLargeTitles = true
        userListViewModel.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
        searchController.searchBar.delegate = self

        setupUI()
        setupNavigationBarMenu()
        setupRefreshControl()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        userListViewModel.fetchUsers(fetchType: .initial)
        if userListViewModel.getUserCount() < 20 {
            userListViewModel.fetchUsers(fetchType: .fetch(newBatch: true))
        }
    }
    
    private func setupUI() {
        view.backgroundColor = .primaryBackground
        
        view.addSubview(collectionView)
        collectionView.edgesToSuperview(with: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16))
        
        view.addSubview(errorView)
        errorView.edgesToSuperview()
        errorView.refreshButton.addTarget(self, action: #selector(refreshData), for: .touchUpInside)

        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }
    
    private func setupNavigationBarMenu() {
        let deleteAction = UIAction(title: "dataPurgeButtonTitle".localized, image: UIImage(systemName: "trash"), attributes: .destructive) { [weak self] _ in
            self?.userListViewModel.purgeData()
        }

        let menu = UIMenu(title: "", children: [deleteAction])
        let menuButton = UIBarButtonItem(title: "More", image: UIImage(systemName: "ellipsis"), primaryAction: nil, menu: menu)
        navigationItem.rightBarButtonItem = menuButton
    }
    
    private func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        collectionView.alwaysBounceVertical = true
        collectionView.refreshControl = refreshControl
    }
    
    private func updateFooterViewSize() {
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.collectionViewLayout.invalidateLayout()
        }
    }
    
    private func showErrorView(with message: String) {
        errorView.errorMessageLabel.text = message
        errorView.isHidden = false
    }
    
    private func hideErrorView() {
        errorView.isHidden = true
    }
    
    @objc private func refreshData() {
        userListViewModel.purgeData()
    }
}

extension UserListVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "FooterView", for: indexPath)
            let activityIndicator = UIActivityIndicatorView(style: .medium)
            activityIndicator.startAnimating()
            activityIndicator.translatesAutoresizingMaskIntoConstraints = false
            footerView.addSubview(activityIndicator)

            NSLayoutConstraint.activate([
                activityIndicator.centerXAnchor.constraint(equalTo: footerView.centerXAnchor),
                activityIndicator.centerYAnchor.constraint(equalTo: footerView.centerYAnchor)
            ])

            return footerView
        }
        return UICollectionReusableView()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return userListViewModel.isFetchingUsers ? CGSize(width: collectionView.bounds.size.width, height: 50) : CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == userListViewModel.getUserCount() - 1 && !userListViewModel.isFetchingUsers {
            userListViewModel.fetchUsers(fetchType: .fetch(newBatch: false))
        }
    }


    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 100, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        userListViewModel.getUserCount(filteredBy: searchController.searchBar.text ?? "")
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserCell.reuseIdentifier, for: indexPath) as? UserCell

        let user = userListViewModel.getUser(at: indexPath.row)
        cell?.configure(with: user)

        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let userDetailsVC = UserDetailsVC()
        userDetailsVC.user = userListViewModel.getUser(at: indexPath.row)
        let navigationController = UINavigationController(rootViewController: userDetailsVC)
        navigationController.modalPresentationStyle = .pageSheet
        navigationController.navigationBar.prefersLargeTitles = true
        present(navigationController, animated: true, completion: nil)
    }
    
}

extension UserListVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        userListViewModel.setSearchFilter(with: searchText)
        collectionView.reloadSections(IndexSet(integer: 0))
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        userListViewModel.setSearchFilter(with: "")
        searchBar.resignFirstResponder()
        collectionView.reloadSections(IndexSet(integer: 0))
    }
}

extension UserListVC: UserListDelegate {
    
    func willStartFetchingUsers() {
        updateFooterViewSize()
    }
    
    func didFetchUsers(updateType: UserListUpdateType) {
        switch updateType {
        case .initial:() /// Loaded before the collection appears so no reload necessary, but here in case we need to do some other stuff, who knows
        case .fetch:
            DispatchQueue.main.async { [weak self] in
                self?.hideErrorView()
                self?.collectionView.reloadSections(IndexSet(integer: 0))
                self?.collectionView.refreshControl?.endRefreshing()
            }
        }
    }
    
    func didFailFetchingUsers(with error: Error) {
        DispatchQueue.main.async { [weak self] in
            self?.updateFooterViewSize()
            self?.showErrorView(with: error.localizedDescription)
            self?.refreshControl.endRefreshing()
        }
    }
    
    func didPurgeUsers() {
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadSections(IndexSet(integer: 0))
            self?.userListViewModel.fetchUsers(fetchType: .fetch(newBatch: true))
        }
    }
    
}
