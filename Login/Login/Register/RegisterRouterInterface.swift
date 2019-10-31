//
//  RegisterRouterInterface.swift
//  Login
//
//  Created by jintao on 2019/10/24.
//  Copyright © 2019 jintao. All rights reserved.
//

import Base
import UIKit

@_silgen_name("Login://register")
public func RegisterRouterInterface(with param: String) -> UIViewController {
    let registerController = RegisterViewController(title: "Register 🚀🚀🚀", model: BaseModel())
    return registerController
}
