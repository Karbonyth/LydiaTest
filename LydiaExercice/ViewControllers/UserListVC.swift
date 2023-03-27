//
//  UserListVC.swift
//  LydiaExercice
//
//  Created by Karbonyth on 25/03/2023.
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

        return collectionView
    }()

    private var userListViewModel = UserListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Les gens quoi"
        navigationController?.navigationBar.prefersLargeTitles = true
        userListViewModel.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
        setupUI()
        userListViewModel.fetchUsers()
    }
    
    private func setupUI() {
        view.backgroundColor = .primaryBackground
        view.addSubview(collectionView)
        collectionView.edgesToSuperview(with: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16))
        collectionView.backgroundColor = .primaryBackground
    }
    
    private func updateFooterViewSize() {
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.collectionViewLayout.invalidateLayout()
        }
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
        if indexPath.row == userListViewModel.users.count - 1 && !userListViewModel.isFetchingUsers {
            userListViewModel.fetchUsers()
        }
    }


    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 100, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        userListViewModel.users.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserCell.reuseIdentifier, for: indexPath) as? UserCell

        let user = userListViewModel.users[indexPath.row]
        cell?.configure(with: user)

        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let userDetailsVC = UserDetailsVC()
        userDetailsVC.user = userListViewModel.users[indexPath.row]
        let navigationController = UINavigationController(rootViewController: userDetailsVC)
        navigationController.modalPresentationStyle = .pageSheet
        navigationController.navigationBar.prefersLargeTitles = true
        present(navigationController, animated: true, completion: nil)
    }
    
}

extension UserListVC: UserListDelegate {
    
    func willStartFetchingUsers() {
        updateFooterViewSize()
    }
    
    func didFinishFetchingUsers() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let startIndex = self.userListViewModel.users.count - self.userListViewModel.fetchedUsersCount
            let endIndex = startIndex + self.userListViewModel.fetchedUsersCount - 1
            let indexPaths = (startIndex...endIndex).map { IndexPath(row: $0, section: 0) }

            self.collectionView.performBatchUpdates({
                self.collectionView.insertItems(at: indexPaths)
            }, completion: nil)
            self.updateFooterViewSize()
        }
    }
    
    func didFailFetchingUsers(with error: Error) {
        print("goddamnit \(error)")
        DispatchQueue.main.async { [weak self] in
            self?.updateFooterViewSize()
        }
    }
    
    
}
