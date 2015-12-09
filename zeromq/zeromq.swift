//
//  main.swift
//  swift-zeromq
//
//  Created by roberto rojas on 12/8/15.
//  Copyright © 2015 CocuyoStudio. All rights reserved.
//

import Foundation
import ZeroMQ

#if os(OSX) || os(iOS) || os(watchOS) || os(tvOS)
    import Darwin
#else
    import Glibc
#endif

let MAX_BYTES = 255
let LISTEN_ADDR = "tcp://127.0.0.1:5555"

func createSocket() -> UnsafeMutablePointer<Void> {

    let context:UnsafeMutablePointer<Void>   = zmq_ctx_new()
    let socket_connection = zmq_socket (context, ZMQ_REP)
    return socket_connection
}

func readMessage(socket_connection: UnsafeMutablePointer<Void>) -> String {

    let buffer = UnsafeMutablePointer<UInt8>.alloc(MAX_BYTES)
    let nbytes = Int(zmq_recv(socket_connection, buffer, MAX_BYTES, 0))

    var message = ""
    for i in 0..<nbytes {
        message += String(UnicodeScalar((buffer+i).memory))
    }
    buffer.dealloc(MAX_BYTES)
    return message
}


func runServer() {

    let responder = createSocket() 
    let rc = zmq_bind (responder, LISTEN_ADDR)
    assert(rc == 0)
    print("Server listening on \(LISTEN_ADDR)")
    let messagePrefix = "World "

    var idx = 0
    while(true) {
        let message = readMessage(responder)
        print("Received \(message)")
        sleep(1)
        let messageToClient = messagePrefix + String(idx)
        idx += 1
        zmq_send (responder, messageToClient, messageToClient.characters.count, 0)
    }
    
}

func runClient() {
    
    let context:UnsafeMutablePointer<Void>   = zmq_ctx_new()
    let requester = zmq_socket (context, ZMQ_REQ)
    zmq_connect (requester, LISTEN_ADDR)
    let messagePrefix = "Hello "
    
    for idx in 0..<10 {
        let messageToSend = messagePrefix + String(idx)
        zmq_send (requester, messageToSend, messageToSend.characters.count, 0)
        let message = readMessage(requester)
        print("Received \(message)")
        
    }
    zmq_close(requester)
    zmq_ctx_destroy(context)
    
}

func main(){
    
    if Process.arguments.count > 1 {
        runClient()
    } else {
        runServer()
    }

}

main()

