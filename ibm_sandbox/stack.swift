#!/usr/bin/env swift

/* Generic stack implementation. Shows generics
   and mutating functions in Swift.
*/

struct Stack<E> {
    var items = [E]()
    
    mutating func push(item: E) {
        items.append(item)
    }
    
    mutating func pop() -> E {
        return items.removeLast()
    }
}

var stackInts = Stack<Int>()
stackInts.push(1)
stackInts.push(2)
stackInts.push(3)

print("pop: \(stackInts.pop())")