//
//  TestViewController.swift
//  User
//
//  Created by jintao on 2019/10/31.
//  Copyright © 2019 jintao. All rights reserved.
//

import Base
import UIKit

class OtherViewController: UIViewController {
    
    var _title: String?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self._title = "Other 🚀🚀🚀"
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        super.viewDidLoad()
        self.title = _title
        self.view.backgroundColor = .yellow
    }
}
