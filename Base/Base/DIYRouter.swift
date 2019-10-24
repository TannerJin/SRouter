//
//  DIYRouter.swift
//  Base
//
//  Created by jintao on 2019/10/25.
//  Copyright © 2019 jintao. All rights reserved.
//

import SwiftStubRouter
import UIKit

public struct DIYRouter: SRouterProtocol {
    public typealias DIYRouterBlock = @convention(thin) (_ input: String) -> UIViewController?

    public var `do`: DIYRouterBlock
    
    public init(_ block: @escaping DIYRouterBlock) {
        self.do = block
    }
}
