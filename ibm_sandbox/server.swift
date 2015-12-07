/* Creates a server that is bound to a socket to listen for incoming
   connections. Also creates a client which sends a "Hello world"
   message to server. Shows how servers can be made in Swift.
*/

#if os(OSX) || os(iOS) || os(watchOS) || os(tvOS)
    import Darwin
#else
    import Glibc
#endif

func make_socket (port:UInt16) -> Int32
{
    var name = sockaddr_in()
    
    // Create the socket
    let sock = socket (PF_INET, 1, 0)
    if sock < 0 {
        perror ("socket")
        exit (EXIT_FAILURE)
    }
	
	// Make the address reusable for multiple runs
	var on: Int32 = 1
	setsockopt(sock, SOL_SOCKET, SO_REUSEADDR, &on, socklen_t(sizeof(Int32)))
	
    // Give the socket a name
    name.sin_family = sa_family_t(AF_INET)
    name.sin_port = UInt16(port).bigEndian
	
	// INADDR_ANY which equals 0
    name.sin_addr.s_addr = in_addr_t(0)

	var bindAddr = sockaddr()
	memcpy(&bindAddr, &name, Int(sizeof(sockaddr_in)))
	let addrSize: socklen_t = socklen_t(sizeof(sockaddr_in))
	
	// Bind name to socket
	if bind(sock, &bindAddr, addrSize) < 0 {
		perror("bind")
		exit(EXIT_FAILURE)
	}
	
    return sock
}

func read_from_client (filedes: Int32) -> Int
{
    let buffer = UnsafeMutablePointer<UInt8>.alloc(255)
    
    let nbytes = read (filedes, buffer, 255)
    if nbytes < 0 {
        // Read error
        perror ("read")
        exit (EXIT_FAILURE)
    }
    else if (nbytes == 0) {
        // End-of-file
        buffer.dealloc(255)
        return -1;
    }
    else {
        // Data read
        var message = ""
        for i in 0..<nbytes {
            message += String(UnicodeScalar((buffer+i).memory))
        }
        print ( "Server: got message: " + message)
        buffer.dealloc(255)
        return 0
    }
}

#if os(Linux)
	
	/// Replacement for FD_ZERO macro
	
	func fdZero(inout set: fd_set) {
		set.__fds_bits = (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
	}
	
	
	/// Replacement for FD_SET macro
	
	func fdSet(fd: Int32, inout set: fd_set) {
		let intOffset = Int(fd / 16)
		let bitOffset: Int = Int(fd % 16)
		let mask: Int = 1 << bitOffset
		switch intOffset {
		case 0: set.__fds_bits.0 = set.__fds_bits.0 | mask
		case 1: set.__fds_bits.1 = set.__fds_bits.1 | mask
		case 2: set.__fds_bits.2 = set.__fds_bits.2 | mask
		case 3: set.__fds_bits.3 = set.__fds_bits.3 | mask
		case 4: set.__fds_bits.4 = set.__fds_bits.4 | mask
		case 5: set.__fds_bits.5 = set.__fds_bits.5 | mask
		case 6: set.__fds_bits.6 = set.__fds_bits.6 | mask
		case 7: set.__fds_bits.7 = set.__fds_bits.7 | mask
		case 8: set.__fds_bits.8 = set.__fds_bits.8 | mask
		case 9: set.__fds_bits.9 = set.__fds_bits.9 | mask
		case 10: set.__fds_bits.10 = set.__fds_bits.10 | mask
		case 11: set.__fds_bits.11 = set.__fds_bits.11 | mask
		case 12: set.__fds_bits.12 = set.__fds_bits.12 | mask
		case 13: set.__fds_bits.13 = set.__fds_bits.13 | mask
		case 14: set.__fds_bits.14 = set.__fds_bits.14 | mask
		case 15: set.__fds_bits.15 = set.__fds_bits.15 | mask
		default: break
		}
	}
	
	
	/// Replacement for FD_CLR macro
	
	func fdClr(fd: Int32, inout set: fd_set) {
		let intOffset = Int(fd / 16)
		let bitOffset: Int = Int(fd % 16)
		let mask: Int = ~(1 << bitOffset)
		switch intOffset {
		case 0: set.__fds_bits.0 = set.__fds_bits.0 & mask
		case 1: set.__fds_bits.1 = set.__fds_bits.1 & mask
		case 2: set.__fds_bits.2 = set.__fds_bits.2 & mask
		case 3: set.__fds_bits.3 = set.__fds_bits.3 & mask
		case 4: set.__fds_bits.4 = set.__fds_bits.4 & mask
		case 5: set.__fds_bits.5 = set.__fds_bits.5 & mask
		case 6: set.__fds_bits.6 = set.__fds_bits.6 & mask
		case 7: set.__fds_bits.7 = set.__fds_bits.7 & mask
		case 8: set.__fds_bits.8 = set.__fds_bits.8 & mask
		case 9: set.__fds_bits.9 = set.__fds_bits.9 & mask
		case 10: set.__fds_bits.10 = set.__fds_bits.10 & mask
		case 11: set.__fds_bits.11 = set.__fds_bits.11 & mask
		case 12: set.__fds_bits.12 = set.__fds_bits.12 & mask
		case 13: set.__fds_bits.13 = set.__fds_bits.13 & mask
		case 14: set.__fds_bits.14 = set.__fds_bits.14 & mask
		case 15: set.__fds_bits.15 = set.__fds_bits.15 & mask
		default: break
		}
	}
	
	
	/// Replacement for FD_ISSET macro
	
	func fdIsSet(fd: Int32, inout set: fd_set) -> Bool {
		let intOffset = Int(fd / 16)
		let bitOffset = Int(fd % 16)
		let mask: Int = 1 << bitOffset
		switch intOffset {
		case 0: return set.__fds_bits.0 & mask != 0
		case 1: return set.__fds_bits.1 & mask != 0
		case 2: return set.__fds_bits.2 & mask != 0
		case 3: return set.__fds_bits.3 & mask != 0
		case 4: return set.__fds_bits.4 & mask != 0
		case 5: return set.__fds_bits.5 & mask != 0
		case 6: return set.__fds_bits.6 & mask != 0
		case 7: return set.__fds_bits.7 & mask != 0
		case 8: return set.__fds_bits.8 & mask != 0
		case 9: return set.__fds_bits.9 & mask != 0
		case 10: return set.__fds_bits.10 & mask != 0
		case 11: return set.__fds_bits.11 & mask != 0
		case 12: return set.__fds_bits.12 & mask != 0
		case 13: return set.__fds_bits.13 & mask != 0
		case 14: return set.__fds_bits.14 & mask != 0
		case 15: return set.__fds_bits.15 & mask != 0
		default: return false
		}
		
	}
	
#else
	
	/// Replacement for FD_ZERO macro
	
	func fdZero(inout set: fd_set) {
		set.fds_bits = (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
	}
	
	
	/// Replacement for FD_SET macro
	
	func fdSet(fd: Int32, inout set: fd_set) {
		let intOffset = Int(fd / 32)
		let bitOffset = fd % 32
		let mask = 1 << bitOffset
		switch intOffset {
		case 0: set.fds_bits.0 = set.fds_bits.0 | mask
		case 1: set.fds_bits.1 = set.fds_bits.1 | mask
		case 2: set.fds_bits.2 = set.fds_bits.2 | mask
		case 3: set.fds_bits.3 = set.fds_bits.3 | mask
		case 4: set.fds_bits.4 = set.fds_bits.4 | mask
		case 5: set.fds_bits.5 = set.fds_bits.5 | mask
		case 6: set.fds_bits.6 = set.fds_bits.6 | mask
		case 7: set.fds_bits.7 = set.fds_bits.7 | mask
		case 8: set.fds_bits.8 = set.fds_bits.8 | mask
		case 9: set.fds_bits.9 = set.fds_bits.9 | mask
		case 10: set.fds_bits.10 = set.fds_bits.10 | mask
		case 11: set.fds_bits.11 = set.fds_bits.11 | mask
		case 12: set.fds_bits.12 = set.fds_bits.12 | mask
		case 13: set.fds_bits.13 = set.fds_bits.13 | mask
		case 14: set.fds_bits.14 = set.fds_bits.14 | mask
		case 15: set.fds_bits.15 = set.fds_bits.15 | mask
		case 16: set.fds_bits.16 = set.fds_bits.16 | mask
		case 17: set.fds_bits.17 = set.fds_bits.17 | mask
		case 18: set.fds_bits.18 = set.fds_bits.18 | mask
		case 19: set.fds_bits.19 = set.fds_bits.19 | mask
		case 20: set.fds_bits.20 = set.fds_bits.20 | mask
		case 21: set.fds_bits.21 = set.fds_bits.21 | mask
		case 22: set.fds_bits.22 = set.fds_bits.22 | mask
		case 23: set.fds_bits.23 = set.fds_bits.23 | mask
		case 24: set.fds_bits.24 = set.fds_bits.24 | mask
		case 25: set.fds_bits.25 = set.fds_bits.25 | mask
		case 26: set.fds_bits.26 = set.fds_bits.26 | mask
		case 27: set.fds_bits.27 = set.fds_bits.27 | mask
		case 28: set.fds_bits.28 = set.fds_bits.28 | mask
		case 29: set.fds_bits.29 = set.fds_bits.29 | mask
		case 30: set.fds_bits.30 = set.fds_bits.30 | mask
		case 31: set.fds_bits.31 = set.fds_bits.31 | mask
		default: break
		}
	}
	
	
	/// Replacement for FD_CLR macro
	
	func fdClr(fd: Int32, inout set: fd_set) {
		let intOffset = Int(fd / 32)
		let bitOffset = fd % 32
		let mask = ~(1 << bitOffset)
		switch intOffset {
		case 0: set.fds_bits.0 = set.fds_bits.0 & mask
		case 1: set.fds_bits.1 = set.fds_bits.1 & mask
		case 2: set.fds_bits.2 = set.fds_bits.2 & mask
		case 3: set.fds_bits.3 = set.fds_bits.3 & mask
		case 4: set.fds_bits.4 = set.fds_bits.4 & mask
		case 5: set.fds_bits.5 = set.fds_bits.5 & mask
		case 6: set.fds_bits.6 = set.fds_bits.6 & mask
		case 7: set.fds_bits.7 = set.fds_bits.7 & mask
		case 8: set.fds_bits.8 = set.fds_bits.8 & mask
		case 9: set.fds_bits.9 = set.fds_bits.9 & mask
		case 10: set.fds_bits.10 = set.fds_bits.10 & mask
		case 11: set.fds_bits.11 = set.fds_bits.11 & mask
		case 12: set.fds_bits.12 = set.fds_bits.12 & mask
		case 13: set.fds_bits.13 = set.fds_bits.13 & mask
		case 14: set.fds_bits.14 = set.fds_bits.14 & mask
		case 15: set.fds_bits.15 = set.fds_bits.15 & mask
		case 16: set.fds_bits.16 = set.fds_bits.16 & mask
		case 17: set.fds_bits.17 = set.fds_bits.17 & mask
		case 18: set.fds_bits.18 = set.fds_bits.18 & mask
		case 19: set.fds_bits.19 = set.fds_bits.19 & mask
		case 20: set.fds_bits.20 = set.fds_bits.20 & mask
		case 21: set.fds_bits.21 = set.fds_bits.21 & mask
		case 22: set.fds_bits.22 = set.fds_bits.22 & mask
		case 23: set.fds_bits.23 = set.fds_bits.23 & mask
		case 24: set.fds_bits.24 = set.fds_bits.24 & mask
		case 25: set.fds_bits.25 = set.fds_bits.25 & mask
		case 26: set.fds_bits.26 = set.fds_bits.26 & mask
		case 27: set.fds_bits.27 = set.fds_bits.27 & mask
		case 28: set.fds_bits.28 = set.fds_bits.28 & mask
		case 29: set.fds_bits.29 = set.fds_bits.29 & mask
		case 30: set.fds_bits.30 = set.fds_bits.30 & mask
		case 31: set.fds_bits.31 = set.fds_bits.31 & mask
		default: break
		}
	}
	
	
	/// Replacement for FD_ISSET macro
	
	func fdIsSet(fd: Int32, inout set: fd_set) -> Bool {
		let intOffset = Int(fd / 32)
		let bitOffset = fd % 32
		let mask = 1 << bitOffset
		switch intOffset {
		case 0: return set.fds_bits.0 & mask != 0
		case 1: return set.fds_bits.1 & mask != 0
		case 2: return set.fds_bits.2 & mask != 0
		case 3: return set.fds_bits.3 & mask != 0
		case 4: return set.fds_bits.4 & mask != 0
		case 5: return set.fds_bits.5 & mask != 0
		case 6: return set.fds_bits.6 & mask != 0
		case 7: return set.fds_bits.7 & mask != 0
		case 8: return set.fds_bits.8 & mask != 0
		case 9: return set.fds_bits.9 & mask != 0
		case 10: return set.fds_bits.10 & mask != 0
		case 11: return set.fds_bits.11 & mask != 0
		case 12: return set.fds_bits.12 & mask != 0
		case 13: return set.fds_bits.13 & mask != 0
		case 14: return set.fds_bits.14 & mask != 0
		case 15: return set.fds_bits.15 & mask != 0
		case 16: return set.fds_bits.16 & mask != 0
		case 17: return set.fds_bits.17 & mask != 0
		case 18: return set.fds_bits.18 & mask != 0
		case 19: return set.fds_bits.19 & mask != 0
		case 20: return set.fds_bits.20 & mask != 0
		case 21: return set.fds_bits.21 & mask != 0
		case 22: return set.fds_bits.22 & mask != 0
		case 23: return set.fds_bits.23 & mask != 0
		case 24: return set.fds_bits.24 & mask != 0
		case 25: return set.fds_bits.25 & mask != 0
		case 26: return set.fds_bits.26 & mask != 0
		case 27: return set.fds_bits.27 & mask != 0
		case 28: return set.fds_bits.28 & mask != 0
		case 29: return set.fds_bits.29 & mask != 0
		case 30: return set.fds_bits.30 & mask != 0
		case 31: return set.fds_bits.31 & mask != 0
		default: return false
		}
		
	}
	
#endif

// Create server socket
let s = make_socket(10800)
// Listen on socket with queue of 1
listen(s,1)

// Create client file
system("touch client.swift")
// Open writer to client file
let stream = fopen("client.swift", "r+")
// Client code: creates socket and sends message to port 10800 (the server)
let program = "#if os(OSX) || os(iOS) || os(watchOS) || os(tvOS)\n import Darwin\n #else\n import Glibc\n#endif\n func make_socket (port:UInt16) -> Int32 { \n" +
    "var name = sockaddr_in() \n let sock = socket (PF_INET, 1, 0) \n" +
    "name.sin_family = sa_family_t(AF_INET) \n name.sin_port = UInt16(port).bigEndian \n" +
    "name.sin_addr.s_addr = in_addr_t(0) \n withUnsafePointer(&name) { unsafePointer in \n" +
    "bind (sock, UnsafePointer.init( unsafePointer), UInt32(Int(sizeof (sockaddr_in)))) \n" +
    "} \n return sock } \n" +
    "let s2 = make_socket(49152) \n var name = sockaddr_in() \n" +
    "name.sin_family = sa_family_t(AF_INET) \n name.sin_port = UInt16(10800).bigEndian \n" +
    "name.sin_addr.s_addr = in_addr_t(0)  \n withUnsafePointer(&name) { unsafePointer in \n" +
    "connect(s2,UnsafePointer.init( unsafePointer),UInt32(Int(sizeof (sockaddr_in)))) \n" +
    "let message = \"Hello World\" \n write(s2,message,message.characters.count) \n" +
"close(s2) \n }"
fwrite(program,1,program.characters.count,stream)
fclose(stream)

// starts REPL to run client code
system("swift client.swift")

var active_fd_set = fd_set()

// Initialize the set of active sockets
fdSet(s, set: &active_fd_set)

#if !os(Linux)
let FD_SETSIZE = Int32(1024)    // On OS X, FD_SETSIZE is 1024
#endif

var clientname = sockaddr_in ()
var t = 0
while t == 0 {
    
    // Block until input arrives on one or more active sockets
    var read_fd_set = active_fd_set;
    select (FD_SETSIZE, &read_fd_set, nil, nil, nil)
    // Service all the sockets with input pending
    for i in 0..<FD_SETSIZE {
        if fdIsSet(i,set: &read_fd_set) {
            if i == s {
                // Connection request on original socket
                var size = sizeof (sockaddr_in)
                // Accept request and assign socket
                withUnsafeMutablePointers(&clientname,&size) { up1, up2 in
                    var new = accept (s,
                        UnsafeMutablePointer(up1),
                        UnsafeMutablePointer(up2))
                    print("Server: connect from host " + String(inet_ntoa (clientname.sin_addr)) + ", port " + String(UInt16(clientname.sin_port).bigEndian))
                    fdSet (new, set: &active_fd_set)
                }
                
            }
            else {
                // Data arriving on an already-connected socket
                if read_from_client (i) < 0 {
                    // Read complete, close socket
                    close (i)
                    fdClr (i, set: &active_fd_set)
                    t = 1
                }
            }
        }
    }
}
