import Foundation
import Crypt

#if os(OSX) || os(iOS) || os(watchOS) || os(tvOS)
    import Darwin
#else
    import Glibc
#endif

/* Generate a (not very) random seed.
You should do it better than this... */
var seed:[CUnsignedLong] = [CUnsignedLong(time(nil)), 0]
seed[1] = CUnsignedLong(getpid()) ^ CUnsignedLong(seed[0] >> 14 & 0x30000)


var salt:[Character] = ["$", "1", "$"]
var seedchars = "./0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"


for i in 0..<8 {
    let idx = Int((seed[i/5] >> CUnsignedLong(i%5)*6) & 0x3f)
    let currentChar: Character = seedchars[seedchars.startIndex.advancedBy(idx)]
    salt.insert(currentChar, atIndex: i+3)
}

let pass = getpass("Password:")
var password = crypt(pass, String(salt))
let int8Ptr = unsafeBitCast(password, UnsafePointer<Int8>.self)
let value = String.fromCString(int8Ptr)
print(value!)
