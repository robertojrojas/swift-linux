#!/usr/bin/env swift

/* Writes a "Hello world" program in C++ and Python
   compiling and running both. This shows one of the ways
   Swift can interact with other languages.
*/

#if os(OSX) || os(iOS) || os(watchOS) || os(tvOS)
    import Darwin
#else
    import Glibc
#endif

system("touch a.cpp")
var stream = fopen("a.cpp", "r+")
var program = "#include <iostream>\n using namespace std;\n int main() {\n" +
"cout << \"hello c++\" << endl;\n}"

fwrite(program,1,program.characters.count,stream)
fclose(stream)

system("clang++ a.cpp")
system("./a.out")

system("touch a.py")
stream = fopen("a.py", "r+")
program = "print \"hello python\""

fwrite(program,1,program.characters.count,stream)
fclose(stream)

system("python a.py")