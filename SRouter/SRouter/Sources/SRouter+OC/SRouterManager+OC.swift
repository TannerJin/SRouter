//
//  SRouterManager+OC.swift
//  SRouter
//
//  Created by jintao on 2019/11/4.
//  Copyright © 2019 jintao. All rights reserved.
//

import Foundation

public extension SRouterManager {
    
    func ocRouteTo(_ router: String) -> SRouterDefaultOCFunction? {
        let function = self.ocRouteTo(router, routerOCFunctionType: SRouterDefaultOCFunction.SRouterOCFunction.self)
        return SRouterDefaultOCFunction(function)
    }

    func ocRouteTo<T>(_ router: String, routerOCFunctionType functionType: T.Type) -> T? {
        assert(MemoryLayout<T>.size == MemoryLayout<UnsafeRawPointer>.size, "\(T.self) is not @convention(c) Function Type")
               
        if !isFunction(functionType) {
            SRouterLog(router: router, message: "\(functionType) Is Not FunctionType")
            return nil
        }
        
        lock.lock()
        defer {
            lock.unlock()
        }
        
        if let symbol = cacheSymbols[router] {
            let routerFunction = unsafeBitCast(symbol, to: T.self)
            return routerFunction
        }
        
        guard let module = router.components(separatedBy: "://").first,
            let symbol = router.components(separatedBy: "://").last,
            let routerSymbol = SRouteLookupSymbolAtModule(module, symbol: symbol) else { return nil }
        
        cacheSymbols[router] = routerSymbol
        let routerFunction = unsafeBitCast(routerSymbol, to: T.self)
        return routerFunction
    }
}
