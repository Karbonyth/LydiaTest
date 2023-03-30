//
//  User.swift
//  LydiaExercice
//
//  Created by Stephen Sement on 25/03/2023.
//

import UIKit

class User {
    let name: UserName
    let gender: Gender
    let picture: UserPicture
    let birthInfo: BirthInfo
    let contactInfo: ContactInfo
    
    // MARK: Init from Codable Model
    init(from model: UserCodable) {
        self.name = UserName(first: model.name.first,
                             last: model.name.last,
                             title: model.name.title)
        self.gender = Gender(rawValue: model.gender) ?? .Unknown
        self.picture = UserPicture(url: model.picture.large)
        self.birthInfo = BirthInfo(date: model.dob.date,
                                   age: model.dob.age)
        self.contactInfo = ContactInfo(homePhone: model.phone,
                                       mobilePhone: model.cell)
    }
    
    // MARK: Init from raw values
    init(name: User.UserName,
         gender: User.Gender,
         picture: User.UserPicture,
         birthInfo: User.BirthInfo,
         contactInfo: User.ContactInfo) {
        self.name = name
        self.picture = picture
        self.birthInfo = birthInfo
        self.gender = gender
        self.contactInfo = contactInfo
    }
    
    func fetchImage() async {
        guard self.picture.image == nil else { return }
        
        let url = self.picture.url
        if let url = URL(string: url),
           let (data, _) = try? await URLSession.shared.data(from: url),
           let image = UIImage(data: data) {
            DispatchQueue.main.async {
                self.picture.setImage(with: image)
            }
        }
    }

}

extension User {
    
    enum Gender: String {
        case male = "male"
        case female = "female"
        case Unknown = "unknown"
        
        var localized: String {
            switch self {
            case .male:
                return "Male"
            case .female:
                return "Female"
            case .Unknown:
                return "Unknown"
            }
        }
    }
    
    struct UserName {
        let first: String
        let last: String
        let title: String
        
        func fullname(withTitle: Bool = false) -> String {
            return "\(withTitle ? title : "") \(first) \(last)"
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
        
        init(date: Date?, age: Int) {
            self.date = date
            self.age = age
        }
        
        func getFormattedDate() -> String? {
            guard let birthDate = date else { return nil }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .long
            dateFormatter.timeStyle = .none
            
            return dateFormatter.string(from: birthDate)
        }
    }
    
    struct ContactInfo {
        let homePhone: String
        let mobilePhone: String
    }
    
}
