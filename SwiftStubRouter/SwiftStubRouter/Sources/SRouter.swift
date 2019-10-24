//
//  CustomRouter.swift
//  Base
//
//  Created by jintao on 2019/10/24.
//  Copyright © 2019 jintao. All rights reserved.
//

import Foundation

public protocol SRouterProtocol {
    associatedtype SRouterBlockType
    
    init(_ block: SRouterBlockType)
}

@dynamicCallable
public struct SRouter: SRouterProtocol {
    public typealias SRouterBlock = @convention(thin) (_ input: [String: Any]) -> [String: Any]?
    
    public typealias SRouterBlockType = SRouterBlock
    
    internal var block: SRouterBlockType
    
    public init(_ block: @escaping SRouterBlockType) {
        self.block = block
    }

    @discardableResult
    public func dynamicallyCall(withKeywordArguments args: KeyValuePairs<String, Any>) -> [String: Any]? {
        var params = [String: Any]()
        args.forEach({ params[$0.key] = $0.value })
        return block(params)
    }
}
