//
//  LoginRouter.swift
//  Login
//
//  Created by jintao on 2019/10/23.
//  Copyright © 2019 jintao. All rights reserved.
//

import UIKit

// SRouterSILFunction
@_silgen_name("Login://login")
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
