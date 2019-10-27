//
//  CustomRouter.swift
//  Base
//
//  Created by jintao on 2019/10/24.
//  Copyright © 2019 jintao. All rights reserved.
//

import Foundation

@dynamicCallable
public struct SRouter {
    public typealias SRouterBlock = @convention(thin) (_ input: [String: Any]) -> [String: Any]?
        
    internal var block: SRouterBlock
    
    public init(_ block: @escaping SRouterBlock) {
        self.block = block
    }

    @discardableResult
    public func dynamicallyCall(withKeywordArguments args: KeyValuePairs<String, Any>) -> [String: Any]? {
        var params = [String: Any]()
        args.forEach({ params[$0.key] = $0.value })
        return block(params)
    }
}
