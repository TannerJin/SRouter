//
//  StubRouterManager.swift
//  SwiftStubRouter
//
//  Created by jintao on 2019/10/23.
//  Copyright © 2019 jintao. All rights reserved.
//

import Foundation
import MachO

func SRouteFindSymbolAtModule(_ moduleName: String, symbol: String) -> UnsafeRawPointer? {
    for i in 0..<_dyld_image_count() {
        if String(cString: _dyld_get_image_name(i)).components(separatedBy: "/").last == moduleName {
            if let pointer = SRouteFindExportedCSymbol(symbol, imageIndex: i) {
                return pointer
            }
            return SRouteFindExportedSwiftSymbol(symbol, image: _dyld_get_image_header(i), imageSlide: _dyld_get_image_vmaddr_slide(i))
        }
    }
    SRouterLog(router: symbol, message: "\(moduleName) Module Not Found")
    return nil
}

// O(_symbol.count) Tree
private func SRouteFindExportedCSymbol(_ cSymbol: String, imageIndex: UInt32) -> UnsafeRawPointer? {
    if let handle = dlopen(_dyld_get_image_name(imageIndex), RTLD_NOW), let pointer = dlsym(handle, cSymbol) {
        return UnsafeRawPointer(pointer)
    }
    return nil
}

private func SRouteFindExportedSwiftSymbol(_ swiftSymbol: String, image: UnsafePointer<mach_header>, imageSlide slide: Int) -> UnsafeRawPointer? {    
    let linkeditName = SEG_LINKEDIT.data(using: String.Encoding.utf8)!.map({ $0 })
    var linkeditCmd: UnsafeMutablePointer<segment_command_64>!
    var dynamicLoadInfoCmd: UnsafeMutablePointer<dyld_info_command>!
    
    var cur_cmd = UnsafeMutableRawPointer(mutating: image).advanced(by: MemoryLayout<mach_header_64>.size).assumingMemoryBound(to: segment_command_64.self)
    
    for _ in 0..<image.pointee.ncmds {
        if cur_cmd.pointee.cmd == LC_SEGMENT_64 {
            if  cur_cmd.pointee.segname.0 == linkeditName[0] &&
                cur_cmd.pointee.segname.1 == linkeditName[1] &&
                cur_cmd.pointee.segname.2 == linkeditName[2] &&
                cur_cmd.pointee.segname.3 == linkeditName[3] &&
                cur_cmd.pointee.segname.4 == linkeditName[4] &&
                cur_cmd.pointee.segname.5 == linkeditName[5] &&
                cur_cmd.pointee.segname.6 == linkeditName[6] &&
                cur_cmd.pointee.segname.7 == linkeditName[7] &&
                cur_cmd.pointee.segname.8 == linkeditName[8] &&
                cur_cmd.pointee.segname.9 == linkeditName[9]
            {
                linkeditCmd = cur_cmd
            }
        } else if cur_cmd.pointee.cmd == LC_DYLD_INFO_ONLY || cur_cmd.pointee.cmd == LC_DYLD_INFO {
            dynamicLoadInfoCmd = cur_cmd.withMemoryRebound(to: dyld_info_command.self, capacity: 1, { $0 })
        }
        
        let cur_cmd_size = Int(cur_cmd.pointee.cmdsize)
        let _cur_cmd = cur_cmd.withMemoryRebound(to: Int8.self, capacity: 1, { $0 }).advanced(by: cur_cmd_size)
        cur_cmd = _cur_cmd.withMemoryRebound(to: segment_command_64.self, capacity: 1, { $0 })
    }
    
    if linkeditCmd == nil || dynamicLoadInfoCmd == nil {
        return nil
    }
    
    let linkeditBase = slide + Int(linkeditCmd.pointee.vmaddr) - Int(linkeditCmd.pointee.fileoff)
    guard let exportedInfo = UnsafeMutableRawPointer(bitPattern: linkeditBase + Int(dynamicLoadInfoCmd.pointee.export_off))?.assumingMemoryBound(to: UInt8.self) else { return nil }
    let exportedInfoSize = Int(dynamicLoadInfoCmd.pointee.export_size)
    
    /// http://www.itkeyword.com/doc/143214251714949x965/uleb128p1-sleb128-uleb128
    func read_uleb128(p: inout UnsafeMutablePointer<UInt8>, end: UnsafeMutablePointer<UInt8>) -> UInt64 {
        var result: UInt64 = 0
        var bit = 0
        var read_next = true
        
        repeat {
            if p == end {
                assert(false, "malformed uleb128")
            }
            let slice = UInt64(p.pointee & 0x7f)
            if bit > 63 {
                assert(false, "uleb128 too big for uint64")
            } else {
                result |= (slice << bit)
                bit += 7
            }
            read_next = (p.pointee & 0x80) != 0  // = 128
            p += 1
        } while (read_next)
        
        return result
    }
    
    // trieWalk ExportedSymbol Trie (深度先序遍历)
    
    func trieWalk(start: UnsafeMutablePointer<UInt8>, end: UnsafeMutablePointer<UInt8>, currentLocation location: UnsafeMutablePointer<UInt8>, currentSymbol: String) -> UnsafeMutablePointer<UInt8>? {
        var p = location
        
        while p <= end {
            // 1. terminalSize
            var terminalSize = UInt64(p.pointee)
            p += 1
            if terminalSize > 127 {
                p -= 1
                terminalSize = read_uleb128(p: &p, end: end)
            }
            if terminalSize != 0 {
                // debug SwiftSymbol, print all exported Symbol and you can find symbolName
//                 print(swift_demangle(currentSymbol))
                return swift_demangle(currentSymbol) == swiftSymbol ? p : nil
            }
            
            // 2. children
            let children = p.advanced(by: Int(terminalSize))
            if children > end {
                // end
                return nil
            }
            let childrenCount = children.pointee
            p = children + 1
            
            // 3. nodes
            for _ in 0..<childrenCount {
                let nodeLabel = p.withMemoryRebound(to: CChar.self, capacity: 1, { $0 })
                
                // node offset
                while p.pointee != 0 {  // != "\0"
                    p += 1
                }
                p += 1  // = "\0"
                let nodeOffset = Int(read_uleb128(p: &p, end: end))
                
                // node
                if let partOfSymbol = String(cString: nodeLabel, encoding: .utf8) {    // end with c '\0'
                    let _currentSymbol = currentSymbol + partOfSymbol
//                    print(partOfSymbol, _currentSymbol, nodeOffset)    // for debug
                    if nodeOffset != 0 && (start + nodeOffset <= end) {
                        if let symbolLocation = trieWalk(start: start, end: end, currentLocation: start.advanced(by: nodeOffset), currentSymbol: _currentSymbol) {
                            return symbolLocation
                        }
                    }
                }
            }
        }
        return nil
    }
    
    let start = exportedInfo
    let end = exportedInfo + exportedInfoSize
         
    if var swiftSymbolLocation = trieWalk(start: start, end: end, currentLocation: start, currentSymbol: "") {
        let flags = read_uleb128(p: &swiftSymbolLocation, end: end)

        let returnSwiftSymbolAddress = { () -> UnsafeRawPointer in
            let machO = image.withMemoryRebound(to: Int8.self, capacity: 1, { $0 })
            let swiftSymbolAddress = machO.advanced(by: Int(read_uleb128(p: &swiftSymbolLocation, end: end)))
            return UnsafeRawPointer(swiftSymbolAddress)
        }
        
        switch flags & UInt64(EXPORT_SYMBOL_FLAGS_KIND_MASK) {
        case UInt64(EXPORT_SYMBOL_FLAGS_KIND_REGULAR):
            return returnSwiftSymbolAddress()
        case UInt64(EXPORT_SYMBOL_FLAGS_KIND_THREAD_LOCAL):
            if (flags & UInt64(EXPORT_SYMBOL_FLAGS_STUB_AND_RESOLVER) != 0) {
                return nil
            }
            return returnSwiftSymbolAddress()
        case UInt64(EXPORT_SYMBOL_FLAGS_KIND_ABSOLUTE):
            if (flags & UInt64(EXPORT_SYMBOL_FLAGS_STUB_AND_RESOLVER) != 0) {
                return nil
            }
            return UnsafeRawPointer(bitPattern: UInt(read_uleb128(p: &swiftSymbolLocation, end: end)))
        default:
            break
        }
    }
    
    return nil
}



// O(n)  list
@available(*, deprecated, message: "Release IPA will Strip Some Swift Symbols at SymbolTable")
func SRouteFindSymbolAtSymbolTable(_ symbol: String, image: UnsafePointer<mach_header>, imageSlide slide: Int) -> UnsafeRawPointer? {
    let linkeditName = SEG_LINKEDIT.data(using: String.Encoding.utf8)!.map({ $0 })
    var linkeditCmd: UnsafeMutablePointer<segment_command_64>!
    var symtabCmd: UnsafeMutablePointer<symtab_command>!
    
    var cur_cmd = UnsafeRawPointer(image).advanced(by: MemoryLayout<mach_header_64>.size)
    var _cur_cmd = UnsafeMutablePointer<segment_command_64>(OpaquePointer(cur_cmd))
    
    for _ in 0..<image.pointee.ncmds {
        if _cur_cmd.pointee.cmd == LC_SEGMENT_64 {
            if  _cur_cmd.pointee.segname.0 == linkeditName[0] &&
                _cur_cmd.pointee.segname.1 == linkeditName[1] &&
                _cur_cmd.pointee.segname.2 == linkeditName[2] &&
                _cur_cmd.pointee.segname.3 == linkeditName[3] &&
                _cur_cmd.pointee.segname.4 == linkeditName[4] &&
                _cur_cmd.pointee.segname.5 == linkeditName[5] &&
                _cur_cmd.pointee.segname.6 == linkeditName[6] &&
                _cur_cmd.pointee.segname.7 == linkeditName[7] &&
                _cur_cmd.pointee.segname.8 == linkeditName[8] &&
                _cur_cmd.pointee.segname.9 == linkeditName[9]
            {
                linkeditCmd = _cur_cmd
            }
        } else if _cur_cmd.pointee.cmd == LC_SYMTAB {
            symtabCmd = UnsafeMutablePointer<symtab_command>(OpaquePointer(_cur_cmd))
        }
        
        cur_cmd = cur_cmd.advanced(by: Int(_cur_cmd.pointee.cmdsize))
        _cur_cmd = UnsafeMutablePointer<segment_command_64>(OpaquePointer(cur_cmd))
    }
    
    if linkeditCmd == nil || symtabCmd == nil {
        return nil
    }
    
    let linkedBase = slide + Int(linkeditCmd.pointee.vmaddr) - Int(linkeditCmd.pointee.fileoff)
    
    guard let symtab = UnsafeMutablePointer<nlist_64>(bitPattern: linkedBase + Int(symtabCmd.pointee.symoff)),
        let strtab =  UnsafeMutablePointer<UInt8>(bitPattern: linkedBase + Int(symtabCmd.pointee.stroff)) else {
            return nil
    }
    
    for i in 0..<symtabCmd.pointee.nsyms {
        let curSymbol = symtab.advanced(by: Int(i))
        let curSymbolStrOff = curSymbol.pointee.n_un.n_strx
        let curSymbolStr = strtab.advanced(by: Int(curSymbolStrOff))
        
        let cSymbol = String(cString: curSymbolStr.advanced(by: 1))  // _symbol
        let swiftSymbol = swift_demangle(cSymbol)
                
        if cSymbol == symbol || swiftSymbol == symbol,
            (Int32(curSymbol.pointee.n_type) & N_TYPE) == N_SECT && (Int32(curSymbol.pointee.n_type) & N_STAB == 0) {  // dyld
            
            return UnsafeRawPointer(bitPattern: slide + Int(curSymbol.pointee.n_value))
        }
        
        // debug symbol
        if SRouterLogOn, ![cSymbol, swiftSymbol].contains(symbol) {
            let name = symbol.components(separatedBy: "(").first
            let cName = cSymbol.components(separatedBy: "(").first
            let swiftName = swiftSymbol?.components(separatedBy: "(").first
            
            if name == cName || name == swiftName {
                let symbolLog = "c_symbol = \(cSymbol), swift_symbol = \(swiftSymbol ?? "nil")"
                SRouterLog(router: symbol, message: symbolLog)
            }
        }
    }
    
    SRouterLog(router: symbol, message: "Symbol Table Not Found \(symbol)")
    return nil
}
