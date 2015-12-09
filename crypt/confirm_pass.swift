import Foundation
import Crypt

#if os(OSX) || os(iOS) || os(watchOS) || os(tvOS)
    import Darwin
#else
    import Glibc
#endif

/* run ./run-swift.sh to get the value of pass */
let pass = "<OUTPUT FROM crypt.swift>"

let passwordStr = getpass("Password:")
let password = crypt(passwordStr, pass)
let int8Ptr = unsafeBitCast(password, UnsafePointer<Int8>.self)
let result = String.fromCString(int8Ptr)

//print("pass \(pass)")
//print("result \(result)")

if pass == result {
  print("Access granted.")
} else {
  print("Access denied.")
}