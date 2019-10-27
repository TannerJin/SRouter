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

typealias DIYRouterBlock = @convention(thin) (_ input: String) -> UIViewController?

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 404 test
        SRouterManager.default.registerDefultNotFoundHander {
            print("SRouter Error: 404")
        }
        SRouterManager.default.routeTo("404-Test", sRouterType: DIYRouterBlock.self, notFoundHandle: nil)
    }

    @IBAction func LoginClick(_ sender: UIButton) {
        guard let naviController = self.navigationController else { return }
        SRouterManager.default.routeTo("Login://login")?(navi: naviController, title: "登录🚀🚀🚀")
    }
    
    @IBAction func RegisterClick(_ sender: UIButton) {
        if let registerController = SRouterManager.default.routeTo("Login://register", sRouterType: DIYRouterBlock.self)?("注册🚀🚀🚀") {
             self.present(UINavigationController(rootViewController: registerController), animated: true, completion: nil)
        }
    }
}

