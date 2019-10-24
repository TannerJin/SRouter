//
//  ViewController.swift
//  SwiftRouterDemo
//
//  Created by jintao on 2019/10/23.
//  Copyright © 2019 jintao. All rights reserved.
//

import Base
import SwiftStubRouter
import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func LoginClick(_ sender: UIButton) {
        guard let naviController = self.navigationController else { return }
        SRouterManager.default.routeTo("Login://login")?(navi: naviController, title: "登录🚀🚀🚀")
    }
    
    @IBAction func RegisterClick(_ sender: UIButton) {
        if let registerController = SRouterManager.default.routeTo("Login://register", sRouterType: DIYRouter.self)?.do("注册🚀🚀🚀") {
             self.present(UINavigationController(rootViewController: registerController), animated: true, completion: nil)
        }
    }
}

