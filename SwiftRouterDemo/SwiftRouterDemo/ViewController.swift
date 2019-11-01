//
//  ViewController.swift
//  SwiftRouterDemo
//
//  Created by jintao on 2019/10/23.
//  Copyright © 2019 jintao. All rights reserved.
//

import SwiftStubRouter
import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Log
        SRouterManager.openLog()
        
        // 404 test
        SRouterManager.default.registeredDefultNotFoundHandler { router in
            print("\(router) Error: 404")
        }
        
        SRouterManager.default.routeAndHandleNotFound("Login://404-Test")
    }

    @IBAction func LoginClick(_ sender: UIButton) {
        guard let naviController = self.navigationController else { return }
        SRouterManager.default.routeTo("Login://login")?(navi: naviController, title: "登录 🚀🚀🚀")
    }
    
    @IBAction func RegisterClick(_ sender: UIButton) {
        typealias RegisteredRouterBlock = @convention(thin) (_ input: String) -> UIViewController
        
        if let registeredController = SRouterManager.default.routeTo("Login://registered", routerBlockType: RegisteredRouterBlock.self)?("注册 🚀🚀🚀") {
             self.present(UINavigationController(rootViewController: registeredController), animated: true, completion: nil)
        }
    }
    
    @IBAction func UserInfoDidClick(_ sender: UIButton) {
//        if let controller = SRouterManager.initController("User.UserInfoViewController") {
//            self.present(UINavigationController(rootViewController: controller), animated: true, completion: nil)
//        }
        
        if let controller2 = SRouterManager.initNibController("User.OtherViewController", nibName: nil, bundle: nil) {
            self.present(UINavigationController(rootViewController: controller2), animated: true, completion: nil)
        }
    }
    
}
