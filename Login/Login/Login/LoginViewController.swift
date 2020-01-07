//
//  LoginViewController.swift
//  Login
//
//  Created by jintao on 2019/10/23.
//  Copyright © 2019 jintao. All rights reserved.
//

import SRouter
import UIKit

public class LoginViewController: UIViewController {
    
    var _title: String?

    override public func viewDidLoad() {
        super.viewDidLoad()
        self.title = _title
        self.view.backgroundColor = .white
        
        let button = UIButton(frame: CGRect(x: view.frame.width/2-60, y: view.frame.height/2-20, width: 120, height: 40))
        button.setTitle("RouteToOC", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(RouteToOC), for: .touchUpInside)
        view.addSubview(button)
    }
    
    @objc func RouteToOC() {
        SRouterManager.default.ocRouteTo("OCModule://OCControllerInterface")?(loginModuleNavi: navigationController as Any)
    }
}
