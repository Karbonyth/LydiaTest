//
//  User.swift
//  LydiaExercice
//
//  Created by Karbonyth on 25/03/2023.
//

import UIKit

class User {
    let name: String
    var picture: UserPicture
    
    
    init(from model: UserCodable) {
        self.name = model.name.first
        self.picture = UserPicture(thumbnailUrl: model.picture.thumbnail,
                                   mediumUrl: model.picture.medium,
                                   largeUrl: model.picture.large)
    }
    
    func fetchImage(type: UserPicture.UserPictureType) async {
        let url: URL?
        
        switch type {
        case .thumbnail:
            url = URL(string: picture.thumbnailUrl)
        case .medium:
            url = URL(string: picture.mediumUrl)
        case .large:
            url = URL(string: picture.largeUrl)
        }
        
        guard let url = url else { return }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    switch type {
                    case .thumbnail:
                        self.picture.thumbnail = image
                    case .medium:
                        self.picture.medium = image
                    case .large:
                        self.picture.large = image
                    }
                }
            }
        } catch {
            print("Error fetching image: \(error)")
        }
    }
}

extension User {
    
    struct UserName {
        let first: String
        let last: String
        let title: String
    }
    
    struct UserPicture {
        
        enum UserPictureType {
            case thumbnail
            case medium
            case large
        }
        
        let thumbnailUrl: String
        let mediumUrl: String
        let largeUrl: String
        var thumbnail: UIImage? = nil
        var medium: UIImage? = nil
        var large: UIImage? = nil
    }
    
}
