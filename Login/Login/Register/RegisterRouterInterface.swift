//
//  RegisterRouterInterface.swift
//  Login
//
//  Created by jintao on 2019/10/24.
//  Copyright © 2019 jintao. All rights reserved.
//

import UIKit

@_silgen_name("Login://register")
public func RegisterRouterInterface(with params: String) -> UIViewController {
    let registerController = RegisterViewController()
    registerController._title = params
    
    return registerController
}
