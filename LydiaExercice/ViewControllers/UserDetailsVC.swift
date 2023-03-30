//
//  UserDetailsVC.swift
//  LydiaExercice
//
//  Created by Stephen Sement on 26/03/2023.
//

import UIKit

class UserDetailsVC: UIViewController {
    
    var user: User?
    
    private let profilePicture: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 75 /// Half the height/width
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = UIColor.secondaryBackground.cgColor
        return imageView
    }()
    
    private let generalInfoStackView: UserDetailsBoxView = {
        let view = UserDetailsBoxView(type: .general)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let genderLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let fullNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let birthInfoStackView: UserDetailsBoxView = {
        let view = UserDetailsBoxView(type: .birthInfo)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let birthDateLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let ageLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let contactInfoStackView: UserDetailsBoxView = {
        let view = UserDetailsBoxView(type: .contactInfo)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let homeNumberLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let mobileNumberLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = user?.name.fullname() ?? "(userName)"
        view.backgroundColor = .primaryBackground
        
        populateUI()
        layoutUI()
    }

    func populateUI() {
        profilePicture.image = user?.picture.image

        fullNameLabel.text = "\(user?.name.fullname(withTitle: true) ?? "nil")"
        genderLabel.text = "\(user?.gender.localized ?? "nil")".localized
        
        birthDateLabel.text = "\(user?.birthInfo.getFormattedDate() ?? "nil")"
        ageLabel.text = "\(String(user?.birthInfo.age ?? -1)) " + "ageUnit".localized
        
        homeNumberLabel.text = "\(user?.contactInfo.homePhone ?? "nil")"
        mobileNumberLabel.text = "\(user?.contactInfo.mobilePhone ?? "nil")"
    }
    
    func layoutUI() {
        view.addSubview(profilePicture)
        view.addSubview(generalInfoStackView)
        view.addSubview(birthInfoStackView)
        view.addSubview(contactInfoStackView)
        
        generalInfoStackView.addArrangedSubview(fullNameLabel)
        generalInfoStackView.addArrangedSubview(genderLabel)
        birthInfoStackView.addArrangedSubview(birthDateLabel)
        birthInfoStackView.addArrangedSubview(ageLabel)
        contactInfoStackView.addArrangedSubview(homeNumberLabel)
        contactInfoStackView.addArrangedSubview(mobileNumberLabel)
        
        NSLayoutConstraint.activate([
            profilePicture.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profilePicture.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            profilePicture.heightAnchor.constraint(equalToConstant: 150),
            profilePicture.widthAnchor.constraint(equalToConstant: 150),
            
            generalInfoStackView.topAnchor.constraint(equalTo: profilePicture.bottomAnchor, constant: 64),
            generalInfoStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            birthInfoStackView.topAnchor.constraint(equalTo: generalInfoStackView.bottomAnchor, constant: 16),
            birthInfoStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            
            contactInfoStackView.topAnchor.constraint(equalTo: birthInfoStackView.bottomAnchor, constant: 16),
            contactInfoStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

    }
}
