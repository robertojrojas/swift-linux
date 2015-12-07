/* Generic sorted tree implementation. Shows generic
   classes and recursive functions in Swift.
*/

class TreeNode<T: Comparable> {
 
    var val: T?
    var left: TreeNode?
    var right: TreeNode?
     
    //add item based on its value
    func addNode(val: T) {
        
        if (self.val == nil) {
            self.val = val
            print("Added Head")
            return
        }
        
        if (val < self.val) {
            
            if let left = self.left {
              left.addNode(val)
            } else {
                let newLeft = TreeNode()
                newLeft.val = val
                self.left = newLeft
                print("Added Left")
            }
        }

        if (val > self.val) {
            
            if let right = self.right {
                right.addNode(val)
            } else {
                let newRight = TreeNode()
                newRight.val = val
                self.right = newRight
                print("Added Right")
            }   
        }
    }
}

let numbers: Array<Int> = [8, 3, 5, 2, 7, 9, 13, 16, 10, 22]
var root = TreeNode<Int>()

for n in numbers {
    print(n)
    root.addNode(n)
}