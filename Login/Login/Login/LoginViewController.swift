//
//  LoginViewController.swift
//  Login
//
//  Created by jintao on 2019/10/23.
//  Copyright © 2019 jintao. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    var _title: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = _title
        self.view.backgroundColor = .white
        // Do any additional setup after loading the view.
    }
}
