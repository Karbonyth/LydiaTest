//
//  User+Entity.swift
//  LydiaExercice
//
//  Created by Stephen Sement on 28/03/2023.
//

import UIKit

extension User {

    convenience init(from entity: UserEntity) {
        let name = UserName(first: entity.name?.first ?? "",
                            last: entity.name?.last ?? "",
                            title: entity.name?.title ?? "")
        
        let gender = Gender(rawValue: entity.gender ?? "") ?? .Unknown
        
        let picture = UserPicture(url: entity.picture?.url ?? "")
        if let data = entity.picture?.image,
           let image = UIImage(data: data) {
            picture.setImage(with: image)
        }
        
        let birthInfo = BirthInfo(date: entity.birthInfo?.date ?? nil,
                                  age: Int(entity.birthInfo?.age ?? 0))
        
        let contactInfo = ContactInfo(homePhone: entity.contactInfo?.homePhone ?? "",
                                      mobilePhone: entity.contactInfo?.mobilePhone ?? "")
        
        self.init(name: name, gender: gender, picture: picture, birthInfo: birthInfo, contactInfo: contactInfo)
    }

}
