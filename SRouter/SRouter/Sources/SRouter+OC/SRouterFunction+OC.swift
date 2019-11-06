//
//  SRouterFunction+OC.swift
//  SRouter
//
//  Created by jintao on 2019/11/4.
//  Copyright © 2019 jintao. All rights reserved.
//

import Foundation

@dynamicCallable
public struct SRouterDefaultOCFunction {
    // OBJC_EXPORT => extern c
    public typealias SRouterOCFunction = @convention(c) (_ input: NSDictionary) -> NSDictionary?
        
    internal var function: SRouterOCFunction
    
    public init?(_ function: SRouterOCFunction?) {
        guard let _function = function else {
            return nil
        }
        self.function = _function
    }

    @discardableResult
    public func dynamicallyCall(withKeywordArguments args: KeyValuePairs<String, Any>) -> NSDictionary? {
        var params = [String: Any]()
        args.forEach({ params[$0.key] = $0.value })
        return function(params as NSDictionary)
    }
}
