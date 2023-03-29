//
//  String+Extension.swift
//  LydiaExercice
//
//  Created by Karbonyth on 29/03/2023.
//

import Foundation

extension String {

    var localized: String {
        return NSLocalizedString(self, comment: "\(self)_comment")
      }

}
