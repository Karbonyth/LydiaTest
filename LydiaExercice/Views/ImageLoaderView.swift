//
//  ImageLoaderView.swift
//  LydiaExercice
//
//  Created by Stephen Sement on 25/03/2023.
//

import UIKit

class ImageLoaderView: UIView {

    private let imageView = UIImageView()
    private let activityIndicator = UIActivityIndicatorView(style: .large)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupSubviews() {
        addSubview(imageView)
        addSubview(activityIndicator)
        
        imageView.contentMode = .scaleAspectFill
        imageView.isHidden = true
        activityIndicator.isHidden = true
    }

    private func setupLayout() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),

            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
    }
    
    func setSize(_ size: CGSize) {
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: size.width),
            heightAnchor.constraint(equalToConstant: size.height)
        ])
    }

    func showActivityIndicator() {
        activityIndicator.startAnimating()
        imageView.image = nil
        imageView.isHidden = true
        activityIndicator.isHidden = false
    }
    
    func stopActivityIndicator() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }

    func showImage(_ image: UIImage) {
        stopActivityIndicator()
        imageView.isHidden = false
        imageView.image = image
    }
}
