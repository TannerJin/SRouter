//
//  SRouterAssembly.c
//  SwiftStubRouter
//
//  Created by jintao on 2019/10/30.
//  Copyright © 2019 jintao. All rights reserved.
//

#include "SRouterAssembly.h"

__attribute__ ((noinline))
void saveSelfRegister(int64_t * _self) {
    __asm__ volatile (
       "movq %r13, (%rdi)\n"
    );
}

__attribute__ ((noinline))
void setSelfRegister(void* _self) {
    __asm__ volatile (
       "movq (%rdi), %r13\n"
    );
}
