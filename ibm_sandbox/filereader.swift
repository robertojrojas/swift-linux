#!/usr/bin/env swift

/* Opens up its own source code and prints it to the
   console. Shows how file input can be done in swift
*/


#if os(OSX) || os(iOS) || os(watchOS) || os(tvOS)
    import Darwin
#else
    import Glibc
#endif

import Foundation

let stream = fopen(Process.arguments.count > 1 ? Process.arguments[1]: Process.arguments[0], "r")

var s = ""
while (true) {
    let c = fgetc(stream)
    if c == -1 {
        break
    }
    s = String(Character(UnicodeScalar(UInt32(c))))
    print(s, terminator:"")
    
}
