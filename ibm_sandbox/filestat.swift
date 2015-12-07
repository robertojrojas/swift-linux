#!/usr/bin/env swift

/* Prints out the size of /bin/bash. Shows how
   Glibc functions can be used in Swift.
*/

#if os(OSX) || os(iOS) || os(watchOS) || os(tvOS)
import Darwin
#else
import Glibc
#endif

var stat_struct = stat()
let filename = "/bin/bash"

stat(filename, &stat_struct);

print("\(filename) is \(stat_struct.st_size) bytes")
