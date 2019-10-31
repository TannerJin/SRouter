//
//  UserInfoViewController.swift
//  User
//
//  Created by jintao on 2019/10/30.
//  Copyright © 2019 jintao. All rights reserved.
//

import UIKit

// ⚠️⚠️⚠️
func MustNote() {
    // UIViewController() must be called once at this Target to use SRouterViewController<DefaultInitMethod>
    print(UIViewController())   // UIViewController can be Any-UIViewController
}

public class UserInfoViewController: UIViewController {
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.title = "UserInfo🚀🚀🚀"
        self.view.backgroundColor = .red
    }
}
