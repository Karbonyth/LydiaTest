//
//  UserCell.swift
//  LydiaExercice
//
//  Created by Karbonyth on 25/03/2023.
//

import UIKit

class UserCell: UICollectionViewCell {
    static let reuseIdentifier = "UserCell"
    
    private let imageLoaderView: ImageLoaderView = {
        let view = ImageLoaderView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()
    
    private let nameLabelBackgroundView: UIView = {
           let view = UIView()
           view.backgroundColor = UIColor.secondaryBackground.withAlphaComponent(0.7)
           view.translatesAutoresizingMaskIntoConstraints = false
           return view
       }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        //label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textAlignment = .center
        label.textColor = .primaryText
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        contentView.addSubview(imageLoaderView)
        contentView.addSubview(nameLabelBackgroundView)
        nameLabelBackgroundView.addSubview(nameLabel)
        
        imageLoaderView.edgesToSuperview()
        
        NSLayoutConstraint.activate([
            nameLabelBackgroundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nameLabelBackgroundView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            nameLabelBackgroundView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            nameLabel.leadingAnchor.constraint(equalTo: nameLabelBackgroundView.leadingAnchor, constant: 4),
            nameLabel.trailingAnchor.constraint(equalTo: nameLabelBackgroundView.trailingAnchor, constant: -4),
            nameLabel.bottomAnchor.constraint(equalTo: nameLabelBackgroundView.bottomAnchor, constant: -4),
            nameLabel.topAnchor.constraint(equalTo: nameLabelBackgroundView.topAnchor, constant: 4)
        ])
    }
    
    func configure(with user: User) {
        contentView.layer.cornerRadius = 16
        contentView.clipsToBounds = true
        self.imageLoaderView.setSize(CGSize(width: 100, height: 150))
        nameLabel.text = user.name.first
        imageLoaderView.showActivityIndicator()
        
//        if let picture = user.picture.thumbnail {
//            imageLoaderView.showImage(picture)
//        } else {
//            Task {
//                await user.fetchImage(type: .large)
//                if let image = user.picture.large {
//                    DispatchQueue.main.async { [weak self] in
//                        self?.imageLoaderView.showImage(image)
//                    }
//                }
//            }
//        }
    }
    
}
