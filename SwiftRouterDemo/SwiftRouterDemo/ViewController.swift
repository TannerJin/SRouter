//
//  ViewController.swift
//  SwiftRouterDemo
//
//  Created by jintao on 2019/10/23.
//  Copyright © 2019 jintao. All rights reserved.
//

import SRouter
import UIKit
import Base

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "SRouter"
        
        // Log
        SRouterManager.openLog()
        
        // 404 test
        SRouterManager.default.registeredDefultNotFoundHandler { router in
            print("\(router) Error: 404")
        }
        
        SRouterManager.default.routeAndHandleNotFound("Login.404-Test")
    }

    @IBAction func LoginClick(_ sender: UIButton) {
        guard let naviController = self.navigationController else { return }
        SRouterManager.default.routeTo("Login.login")?(navi: naviController, title: "登录 🚀🚀🚀")
    }
    
    @IBAction func RegisterClick(_ sender: UIButton) {
        typealias RegisteredRouterSILFunctionType = @convention(thin) (_ input: String) -> UIViewController
        
        if let registeredController = SRouterManager.default.routeTo("Login.registered", routerSILFunctionType: RegisteredRouterSILFunctionType.self)?("注册") {
             self.present(UINavigationController(rootViewController: registeredController), animated: true, completion: nil)
        }
    }
    
    
    @IBAction func actionClick(_ sender: UIButton) {
        SRouterManager.default.routeTo("Login.loginActionTestDefault(Swift.Dictionary<Swift.String, Any>) -> Swift.Optional<Swift.Dictionary<Swift.String, Any>>")?(param1: "hello", param2: 996)
        
        if let action = SRouterManager.default.routeTo("Login.LoginActionTest1() -> ()", routerSILFunctionType: (@convention(thin) ()->()).self) {
            action()
        }
        
        if let action2 = SRouterManager.default.routeTo("Login.LoginActionTest2(Swift.Int) -> ()", routerSILFunctionType: (@convention(thin) (Int)->()).self) {
            action2(2)
        }
        
        if let action3 = SRouterManager.default.routeTo("Login.LoginActionTest3(a: Swift.Int) -> ()", routerSILFunctionType: (@convention(thin) (Int)->()).self) {
            action3(3)
        }
        
        if let action4 = SRouterManager.default.routeTo("Login.LoginActionTest4(a: Swift.Int) -> Swift.Int", routerSILFunctionType: (@convention(thin) (Int)->Int).self) {
            let result = action4(4)
            print(result)
        }
        
        if let action5 = SRouterManager.default.routeTo("Login.LoginActionTest5(a: Swift.Int, _: __C.CGRect) -> ()", routerSILFunctionType: (@convention(thin) (Int, CGRect)->()).self) {
            action5(5, CGRect(origin: .zero, size: CGSize(width: 100, height: 100)))
        }
        
        if let action6 = SRouterManager.default.routeTo("Login.LoginActionTest6(a: Swift.Int, b: __C.CGRect) -> ()", routerSILFunctionType: (@convention(thin) (Int, CGRect)->()).self) {
            action6(6, CGRect(origin: .zero, size: CGSize(width: 100, height: 100)))
        }

        if let action7 = SRouterManager.default.routeTo("Login.LoginActionTest7(a: Swift.Int, b: __C.UIViewController) -> ()", routerSILFunctionType: (@convention(thin) (Int, UIViewController)->()).self) {
            action7(7, self)
        }
        
        if let action8 = SRouterManager.default.routeTo("Login.LoginActionTest8(a: Swift.Int, b: Swift.String, c: Base.BaseModel) -> ()", routerSILFunctionType: (@convention(thin) (Int, String, BaseModel)->()).self) {
            action8(8, "Action8", BaseModel(_name: "Tanner.Jin"))
        }
        
        if let action9 = SRouterManager.default.routeTo("Login.LoginActionTest9(a: Swift.Int, b: Swift.String, _: Base.BaseModel) -> Base.BaseModel", routerSILFunctionType: (@convention(thin) (Int, String, BaseModel)->BaseModel).self) {
            let newModel = action9(9, "Action9", BaseModel(_name: "Tanner.Jin"))
            print(newModel.name, "\n")
        }
        
        if let action10 = SRouterManager.default.routeTo("Login.LoginActionTest10(a: Swift.Int, _: Swift.String, _: Base.BaseModel) -> (Base.BaseModel, Swift.Double)", routerSILFunctionType: (@convention(thin) (Int, String, BaseModel) -> (BaseModel, Double)).self) {
            let result = action10(10, "Action10", BaseModel(_name: "Tanner.Jin"))
            print(result.0.name, result.1)
        }
    }
}
