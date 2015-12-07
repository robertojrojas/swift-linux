#!/usr/bin/env swift

/* A generic quicksort function. Shows how to use generics,
   recursion, and functional extensions in Swift.
*/

func quickSort<T: Comparable>(a: [T]) -> [T] {
    if a.isEmpty {
        return a
    }
    else {
        let head = a[0]
        let body = a[1..<a.count]
        return quickSort(body.filter({$0 < head})) + [head] + quickSort(body.filter({$0 >= head}))
    }
}

print(quickSort([3,1,7,9,4,2,8]))
print(quickSort(["goat","arm","toe","dog","bat"]))
