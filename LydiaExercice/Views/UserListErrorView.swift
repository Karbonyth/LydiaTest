//
//  UserListErrorView.swift
//  LydiaExercice
//
//  Created by Stephen Sement on 29/03/2023.
//

import UIKit

class ErrorView: UIView {
    
    let errorMessageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let refreshButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configuration = UIButton.Configuration.filled()
        button.configuration?.title = "tryAgainButtonTitle".localized
        button.configuration?.baseForegroundColor = .primaryText
        button.configuration?.image = UIImage(systemName: "arrow.clockwise")
        button.configuration?.imagePadding = 8
        button.configuration?.imagePlacement = .bottom
        button.configuration?.contentInsets = NSDirectionalEdgeInsets(top: 8,
                                                                      leading: 16,
                                                                      bottom: 8,
                                                                      trailing: 16)
        button.configuration?.baseBackgroundColor = .secondaryBackground
        button.configuration?.cornerStyle = .large
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(errorMessageLabel)
        addSubview(refreshButton)
        
        NSLayoutConstraint.activate([
            errorMessageLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            errorMessageLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            errorMessageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            errorMessageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            refreshButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            refreshButton.topAnchor.constraint(equalTo: errorMessageLabel.bottomAnchor, constant: 32)
        ])
    }
}
