#if os(OSX) || os(iOS) || os(watchOS) || os(tvOS)
 import Darwin
 #else
 import Glibc
#endif
 func make_socket (port:UInt16) -> Int32 { 
var name = sockaddr_in() 
 let sock = socket (PF_INET, 1, 0) 
name.sin_family = sa_family_t(AF_INET) 
 name.sin_port = UInt16(port).bigEndian 
name.sin_addr.s_addr = in_addr_t(0) 
 withUnsafePointer(&name) { unsafePointer in 
bind (sock, UnsafePointer.init( unsafePointer), UInt32(Int(sizeof (sockaddr_in)))) 
} 
 return sock } 
let s2 = make_socket(49152) 
 var name = sockaddr_in() 
name.sin_family = sa_family_t(AF_INET) 
 name.sin_port = UInt16(10800).bigEndian 
name.sin_addr.s_addr = in_addr_t(0)  
 withUnsafePointer(&name) { unsafePointer in 
connect(s2,UnsafePointer.init( unsafePointer),UInt32(Int(sizeof (sockaddr_in)))) 
let message = "Hello World" 
 write(s2,message,message.characters.count) 
close(s2) 
 }