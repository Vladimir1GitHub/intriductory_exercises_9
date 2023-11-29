module Main

import IO;
import lang::java::m3::Core;
import Set;
import List;


public void exercise9() {
M3 jabber = createM3FromDirectory(|file:///SQM/JabberPoint/|);
set[loc] java_files = files(jabber);
println("9a");
println(size(java_files));
println("9b");
map[loc, int] filesLinecounts = (file: size(readFileLines(file)) | file <- java_files); 
println(filesLinecounts);
}
