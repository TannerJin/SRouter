//
//  SRouterViewControllerMetata.swift
//  SwiftStubRouter
//
//  Created by jintao on 2019/10/31.
//  Copyright © 2019 jintao. All rights reserved.
//

import MachO
import UIKit

@dynamicCallable
public class SRouterViewControllerMetadata<T> {
    
    internal var controller: String
    
    internal var initMethodParams: [(key: String, type: String)] = []
    
    init(_ controller: String) {
        self.controller = controller
    }
    
    @discardableResult
    public func dynamicallyCall(withKeywordArguments args: KeyValuePairs<String, Any>) -> T? {
        for i in args {
            if let type = "\(type(of: i.value))".components(separatedBy: ".").first {
                initMethodParams.append((i.key, type))
            } else {
                return nil
            }
        }
        
        if let initFunction = analysisSymbol() {
            return unsafeBitCast(initFunction, to: T.self)
        }
        return nil
    }
    
    private func analysisSymbol() -> UnsafeRawPointer? {
        let moduleName = controller.components(separatedBy: ".").first
        
        for i in 0..<_dyld_image_count() {
            if String(cString: _dyld_get_image_name(i)).components(separatedBy: "/").last == moduleName {
                return SRouteLookupSymbol(image: _dyld_get_image_header(i), imageSlide: _dyld_get_image_vmaddr_slide(i), compare: {
                    if let symbol = swift_demangle($0) {
                        return compareSymbol(symbol)
                    }
                    return false
                })
            }
        }
        return nil
    }
    
    private func compareSymbol(_ symbol: String) -> Bool {
        if !symbol.contains(controller + ".__allocating_init") || !symbol.contains("-> \(controller)") {
            return false
        }
        
        // (Swift.String, param1: Swift.Int)
        guard var start = symbol.firstIndex(of: "("),
            let end = symbol.firstIndex(of: ")") else { return false }
        
        start = symbol.index(start, offsetBy: 1)
        let subSymbol = String(symbol[start ..< end])
        
        var params = [(key: String, type: String)]()
        for param in subSymbol.components(separatedBy: ", ") {
            if !param.contains(":") { // _ key: Swift.String
                if let type = param.components(separatedBy: ".").last {  // Swift.String
                    params.append(("", type))
                } else {
                    return false
                }
            } else {
                let keyAndType = param.components(separatedBy: ":") // key: Swift.String
                if let key = keyAndType.first, let type = keyAndType.last?.components(separatedBy: ".").last {
                    params.append((key == "_" ? "":key, type)) // TODO: Swift.Optinal<Swift.Dictionary<Swift.String, Any>>
                } else {
                    return false
                }
            }
        }
        
        if params.count != initMethodParams.count { return false }
        
        for i in zip(params, initMethodParams) {
            if i.0.key != i.1.key || i.0.type != i.1.type {
                return false
            }
        }
        
        return true
    }
}
