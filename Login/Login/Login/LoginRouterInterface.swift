//
//  LoginRouter.swift
//  Login
//
//  Created by jintao on 2019/10/23.
//  Copyright © 2019 jintao. All rights reserved.
//

import UIKit

// SRouterSILFunction
@_silgen_name("Login.login")
public func LoginRouterInterface(with params: [String: Any]) -> [String: Any]? {
    guard let navi = params["navi"] as? UINavigationController else {
       return nil
    }
    
    let loginController = LoginViewController()
    if let title = params["title"] as? String {
        loginController._title = title
    }
    navi.pushViewController(loginController, animated: true)
    return nil
}


// MARK: - Examples

@inline(never)
public func LoginActionTest1() {
    print("Hello, LoginActionTest1;")
}

public func LoginActionTest2(_ a: Int) {
    print("Hello, LoginActionTest2; inputValue =", a)
}

public func LoginActionTest3(a: Int) {
    print("Hello, LoginActionTest3; inputValue =", a)
}

public func LoginActionTest4(a: Int) -> Int {
    print("Hello, LoginActionTest4; inputValue =", a)
    return a + 1
}

public func LoginActionTest5(a: Int, _ b: CGRect) {
    print("Hello, LoginActionTest5; inputValue =", a, b)
}

public func LoginActionTest6(a: Int, b: CGRect) {
    print("Hello, LoginActionTest6; inputValue =", a, b)
}

public func LoginActionTest7(a: Int, b: UIViewController) {
    print("Hello, LoginActionTest7; inputValue =", a, b)
}

import Base

public func LoginActionTest8(a: Int, b: String, c: BaseModel) {
    print("Hello, LoginActionTest8; inputValue =", a, b, c.name)
}

public func LoginActionTest9(a: Int, b: String, _ c: BaseModel) -> BaseModel {
    print("Hello, LoginActionTest9; inputValue =", a, b, c.name)
    c.name = "New Name9"
    return c
}

public func LoginActionTest10(a: Int, _ b: String, _ c: BaseModel) -> (BaseModel, Double) {
    print("Hello, LoginActionTest10; inputValue =", a, b, c.name)
    c.name = "New Name10"
    return (c, 10.1)
}
