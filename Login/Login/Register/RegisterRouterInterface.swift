//
//  RegisteredRouterInterface.swift
//  Login
//
//  Created by jintao on 2019/10/24.
//  Copyright © 2019 jintao. All rights reserved.
//

import UIKit

@_silgen_name("Login.registered")
public func RegisteredRouterInterface(with param: String) -> UIViewController {
    let registeredController = RegisteredViewController(title: "\(param) 🚀🚀🚀")
    return registeredController
}
