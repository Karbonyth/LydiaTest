//
//  User.swift
//  LydiaExercice
//
//  Created by Karbonyth on 25/03/2023.
//

import UIKit

class User {
    let name: UserName
    let picture: UserPicture
    let birthInfo: BirthInfo
    
    // MARK: Init from Codable Model
    init(from model: UserCodable) {
        self.name = UserName(first: model.name.first,
                             last: model.name.last,
                             title: model.name.title)
        self.picture = UserPicture(url: model.picture.large)
        self.birthInfo = BirthInfo(date: model.dob.date,
                                   age: model.dob.age)
    }
    
    // MARK: Init from raw values
    init(name: User.UserName, picture: User.UserPicture, birthInfo: User.BirthInfo) {
        self.name = name
        self.picture = picture
        self.birthInfo = birthInfo
    }
}

extension User {
    
    struct UserName {
        let first: String
        let last: String
        let title: String
        
        func fullname() -> String {
            return "\(first) \(last)"
        }
    }
    
    class UserPicture {
        private(set) var url: String
        private(set) var image: UIImage? = nil
        
        init(url: String, image: UIImage? = nil) {
            self.url = url
            self.image = image
        }
        
        func setImage(with image: UIImage) {
            self.image = image
        }
    }
    
    struct BirthInfo {
        let date: Date?
        let age: Int
        
        init(date: String, age: Int) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            self.date = dateFormatter.date(from: date)
            self.age = age
        }
    }
    
}
