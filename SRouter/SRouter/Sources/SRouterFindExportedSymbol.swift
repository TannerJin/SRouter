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
            if let pointer = SRouteFindSymbolAtExportedSymbol(symbol, imageIndex: i) {
                return pointer
            }
            return SRouteFindSymbolAtSymbolTable(symbol, image: _dyld_get_image_header(i), imageSlide: _dyld_get_image_vmaddr_slide(i))
        }
    }
    SRouterLog(router: symbol, message: "\(moduleName) Module Not Found")
    return nil
}

// O(log(n)) Tree
private func SRouteFindSymbolAtExportedSymbol(_ symbol: String, imageIndex: UInt32) -> UnsafeRawPointer? {
    if let handle = dlopen(_dyld_get_image_name(imageIndex), RTLD_NOW), let pointer = dlsym(handle, symbol) {
        return UnsafeRawPointer(pointer)
    }
    SRouterLog(router: symbol, message: "ExportInfo Not Found \(symbol)")
    return nil
}

// O(n)  list
func SRouteFindSymbolAtSymbolTable(_ symbol: String, image: UnsafePointer<mach_header>, imageSlide slide: Int) -> UnsafeRawPointer? {
    let linkeditName = SEG_LINKEDIT.data(using: String.Encoding.utf8)!.map({ $0 })
    var linkeditCmd: UnsafeMutablePointer<segment_command_64>!
    var symtabCmd: UnsafeMutablePointer<symtab_command>!
    
    var cur_cmd = UnsafeRawPointer(image).advanced(by: MemoryLayout<mach_header_64>.size)
    var _cur_cmd = UnsafeMutablePointer<segment_command_64>(OpaquePointer(cur_cmd))
    
    for _ in 0..<image.pointee.ncmds {
        if _cur_cmd.pointee.cmd == LC_SEGMENT_64 {
            if  _cur_cmd.pointee.segname.0 == linkeditName[0],
                _cur_cmd.pointee.segname.1 == linkeditName[1],
                _cur_cmd.pointee.segname.2 == linkeditName[2],
                _cur_cmd.pointee.segname.3 == linkeditName[3],
                _cur_cmd.pointee.segname.4 == linkeditName[4],
                _cur_cmd.pointee.segname.5 == linkeditName[5],
                _cur_cmd.pointee.segname.6 == linkeditName[6],
                _cur_cmd.pointee.segname.7 == linkeditName[7],
                _cur_cmd.pointee.segname.8 == linkeditName[8],
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
        let _curSymbolStr = String(cString: curSymbolStr.advanced(by: 1))  // _symbol
        
        if _curSymbolStr == symbol {
            return UnsafeRawPointer(bitPattern: slide + Int(curSymbol.pointee.n_value))
        }
    }
    
    SRouterLog(router: symbol, message: "Symbol Table Not Found \(symbol)")
    return nil
}
