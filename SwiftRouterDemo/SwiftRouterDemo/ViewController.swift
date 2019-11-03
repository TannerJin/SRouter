//
//  ViewController.swift
//  SwiftRouterDemo
//
//  Created by jintao on 2019/10/23.
//  Copyright © 2019 jintao. All rights reserved.
//

import SRouter
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
        typealias RegisteredRouterSILFunctionType = @convention(thin) (_ input: String) -> UIViewController
        
        if let registeredController = SRouterManager.default.routeTo("Login://registered", routerSILFunctionType: RegisteredRouterSILFunctionType.self)?("注册 🚀🚀🚀") {
             self.present(UINavigationController(rootViewController: registeredController), animated: true, completion: nil)
        }
    }
    
    @IBAction func UserInfoDidClick(_ sender: UIButton) {
//        if let userInfoController = SRouterManager.initController("User.UserInfoViewController") {
//            self.present(UINavigationController(rootViewController: userInfoController), animated: true, completion: nil)
//        }
        
        self.navigationController?.pushViewController(<#T##viewController: UIViewController##UIViewController#>, animated: <#T##Bool#>)
        SRouterManager.pushRouter("User.OtherViewController", by: self.navigationController, animated: true)
    }
}
