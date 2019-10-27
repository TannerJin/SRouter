//
//  CustomRouterManager.swift
//  Base
//
//  Created by jintao on 2019/10/24.
//  Copyright © 2019 jintao. All rights reserved.
//

import Foundation

open class SRouterManager {
    public static let `default` = SRouterManager()

    private var cacheSymbols = [String: UnsafeRawPointer]()
    
    private var lock = SRouterLock()
}


public extension SRouterManager {
    func routeTo(_ router: String) -> SRouter? {
        return self.routeTo(router, sRouterType: SRouter.self)
    }
    
    func routeTo<T: SRouterProtocol>(_ router: String, sRouterType: T.Type) -> T? {
        lock.lock()
        defer {
            lock.unlock()
        }
        if let symbol = cacheSymbols[router] {
            let routerBlock = unsafeBitCast(symbol, to: T.SRouterBlockType.self)
            return T(routerBlock)
        }
        
        guard let module = router.components(separatedBy: "://").first,
            let routerSymbol = stubRouteToModule(module, symbol: router) else { return nil }
        
        cacheSymbols[router] = routerSymbol
        let routerBlock = unsafeBitCast(routerSymbol, to: T.SRouterBlockType.self)
        
        return T(routerBlock)
    }
}
