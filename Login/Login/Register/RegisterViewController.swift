//
//  RegisteredViewController.swift
//  Login
//
//  Created by jintao on 2019/10/24.
//  Copyright © 2019 jintao. All rights reserved.
//

import UIKit

class RegisteredViewController: UIViewController {
    
    var _title: String?
    
    init(title: String) {
        super.init(nibName: nil, bundle: nil)
        self._title = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = _title
        self.view.backgroundColor = .green
    }
}
