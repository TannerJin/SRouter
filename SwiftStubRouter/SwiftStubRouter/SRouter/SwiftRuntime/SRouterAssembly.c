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
    #if defined(__arm64__) || defined(__aarch64__)
    __asm__ volatile (
         "str x20, [x0]\n"
    );
    #elif defined(__ARM_ARCH_7A__) || defined(__ARM_ARCH_7S__)

    #elif defined(__x86_64__)
    __asm__ volatile (
       "movq %r13, (%rdi)\n"
    );
    #endif
}

__attribute__ ((noinline))
void setSelfRegister(void* _self) {
    #if defined(__arm64__) || defined(__aarch64__)
    __asm__ volatile (
       "ldr x20, [x0]\n"
    );
    #elif defined(__ARM_ARCH_7A__) || defined(__ARM_ARCH_7S__)

    #elif defined(__x86_64__)
    __asm__ volatile (
          "movq (%rdi), %r13\n"
    );
    #endif
}
