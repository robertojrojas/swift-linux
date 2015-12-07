/* Writes and executes a script in Swift that echos
   the arguments passed in. Shows how to execute scripts
   in Swift and how to read arguments.
*/

#if os(OSX) || os(iOS) || os(watchOS) || os(tvOS)
    import Darwin
#else
    import Glibc
#endif

system("touch script.swift")
let stream = fopen("script.swift", "r+")
let program = "#!/usr/bin/swift \n print(\"Process.arguments gave args:\")\nfor s in Process.arguments {print(s)}"
fwrite(program,1,program.characters.count,stream)

fclose(stream)
system("chmod +x script.swift")
system("./script.swift -- first second")
