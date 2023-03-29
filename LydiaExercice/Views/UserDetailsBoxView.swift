//
//  UserDetailsBoxView.swift
//  LydiaExercice
//
//  Created by Karbonyth on 29/03/2023.
//

import UIKit

enum UserDetailsBoxType {
    case general
    case birthInfo
    case contactInfo
}

class UserDetailsBoxView: UIView {
    
    private let detailsCategory: UserDetailsBoxType
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let categoryPicture: UIView = {
        let view = UIView()
        view.backgroundColor = .secondaryBackground
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.backgroundColor = .secondaryBackground
        stackView.layer.cornerRadius = 8
        stackView.spacing = 8
        stackView.layoutMargins = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    init(type: UserDetailsBoxType, frame: CGRect = .zero) {
        self.detailsCategory = type
        super.init(frame: frame)
        populateUI()
        layoutUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        categoryPicture.roundCorners(corners: [.topLeft, .topRight], radius: 24)
    }
    
    func addArrangedSubview(_ view: UIView) {
        stackView.addArrangedSubview(view)
    }
    
    private func populateUI() {
        switch detailsCategory {
        case .general:
            imageView.image = UIImage(systemName: "person.fill")
        case .birthInfo:
            imageView.image = UIImage(systemName: "birthday.cake.fill")
        case .contactInfo:
            imageView.image = UIImage(systemName: "phone.fill")
        }
    }
    
    private func layoutUI() {
        addSubview(categoryPicture)
        addSubview(stackView)
        categoryPicture.addSubview(imageView)

        NSLayoutConstraint.activate([
            categoryPicture.centerXAnchor.constraint(equalTo: centerXAnchor),
            categoryPicture.topAnchor.constraint(equalTo: topAnchor),
            categoryPicture.widthAnchor.constraint(equalToConstant: 48),
            categoryPicture.heightAnchor.constraint(equalToConstant: 48),

            imageView.centerXAnchor.constraint(equalTo: categoryPicture.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: categoryPicture.centerYAnchor),
            imageView.widthAnchor.constraint(equalTo: categoryPicture.widthAnchor, multiplier: 0.5),
            imageView.heightAnchor.constraint(equalTo: categoryPicture.heightAnchor, multiplier: 0.5),

            stackView.topAnchor.constraint(equalTo: categoryPicture.bottomAnchor, constant: -2),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

    }
    
}
