//
//  UserDetailsVC.swift
//  LydiaExercice
//
//  Created by Karbonyth on 26/03/2023.
//

import UIKit

class UserDetailsVC: UIViewController {
    
    var user: User?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = user?.name
        view.backgroundColor = .primaryBackground
    }

}
