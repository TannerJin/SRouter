//
//  CustomRouter.swift
//  Base
//
//  Created by jintao on 2019/10/24.
//  Copyright © 2019 jintao. All rights reserved.
//

import Foundation

// https://github.com/apple/swift/blob/master/docs/SIL.rst#function-types

@dynamicCallable
public struct SRouterDefaultSILFunction {
    public typealias SRouterSILFunction = @convention(thin) (_ input: [String: Any]) -> [String: Any]?
        
    internal var function: SRouterSILFunction
    
    public init?(_ function: SRouterSILFunction?) {
        guard let _function = function else {
            return nil
        }
        self.function = _function
    }

    @discardableResult
    public func dynamicallyCall(withKeywordArguments args: KeyValuePairs<String, Any>) -> [String: Any]? {
        var params = [String: Any]()
        args.forEach({ params[$0.key] = $0.value })
        return function(params)
    }
}
