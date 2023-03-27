//
//  UIView+Extension.swift
//  LydiaExercice
//
//  Created by Karbonyth on 25/03/2023.
//

import UIKit

extension UIView {
    
    func edgesToSuperview(with padding: UIEdgeInsets = .zero) {
        guard let superview = superview else { return }
        topAnchor.constraint(equalTo: superview.topAnchor, constant: padding.top).isActive = true
        leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: padding.left).isActive = true
        trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -padding.right).isActive = true
        bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -padding.bottom).isActive = true
    }
    
}
