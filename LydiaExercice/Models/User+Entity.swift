//
//  User+Entity.swift
//  LydiaExercice
//
//  Created by Karbonyth on 28/03/2023.
//

import UIKit

extension User {

    convenience init(from entity: UserEntity) {
        let name = UserName(first: entity.name?.first ?? "",
                            last: entity.name?.last ?? "",
                            title: entity.name?.title ?? "")
        
        let picture = UserPicture(url: entity.picture?.url ?? "")
        if let data = entity.picture?.image,
           let image = UIImage(data: data) {
            picture.setImage(with: image)
        }
        
        let birthInfo = BirthInfo(date: entity.birthInfo?.date?.ISO8601Format() ?? "",
                                  age: Int(entity.birthInfo?.age ?? 0))
        
        self.init(name: name, picture: picture, birthInfo: birthInfo)
    }

}
