module Main

import IO;
import Location;
import lang::java::m3::AST;
import String;
import Set;
import ListRelation;
import List;
import Map;
import lang::java::m3::Core;
import vis::Charts;
import Relation;


private rel[str, Statement] parseMethods(set[Declaration] declarations) {
rel[str, Statement] methodenEnConstructorsSet = {};
visit (declarations) {
case \method(_, name, _, _, impl): methodenEnConstructorsSet += <name, impl>;
case \constructor(name, _, _, impl): methodenEnConstructorsSet += <name, impl>;
}
return(methodenEnConstructorsSet);
}

private int countIfs(Statement statement){
int count = 0;
visit(statement){
    case \if (_,_): count += 1;
    case \if(_,_,_): count += 1;
}
return count;
}


public void exercise9() {
M3 jabber = createM3FromDirectory(|file:///SQM/JabberPoint/|);
set[loc] java_files = files(jabber);
println("9a");
println(size(java_files));
println("9b");
map[loc, int] filesLinecounts = (file: size(readFileLines(file)) | file <- java_files); 
lrel[loc, int] fileCountsList = toList(filesLinecounts);
lrel[loc, int] fileCountsListSorted = sort(fileCountsList, bool(tuple[loc, int] a, tuple[loc, int] b){return a[1] > b[1];});
for (tuple[loc, int] fileLineCount <- fileCountsListSorted) println("<fileLineCount[0]> count: <fileLineCount[1]>");
println("9 extends");
for (<a,b> <- jabber.extends) println("<a> extends <b>");
println("9 visit loops");
set[Declaration] decls = createAstsFromDirectory(|file:///SQM/JabberPoint/|, true);
int numLoops = 0;
visit (decls) {
case \for(_,_,_): numLoops=numLoops+1;
case \for(_,_,_,_): numLoops=numLoops+1;
case \foreach(_,_,_): numLoops=numLoops+1;
}
println("<numLoops> for loops");

println("9c");
set[loc] classesLoaded = classes(jabber);
methoden = { <a,b> | <a,b> <- jabber.containment, a.scheme == "java+class", b.scheme == "java+method" || b.scheme == "java+constructor" };
methodenGemeten = sort({ <a, size(methoden[a])> | a <- domain(methoden) }, bool(tuple[loc, int] a, tuple[loc, int] b){return a[1] > b[1];});
for(<a,b> <- methodenGemeten) println("class <a> : methoden: <b>");

println("9d");
rel[loc, loc] subclasses = invert(jabber.extends);
println(sort({<a, size((subclasses+)[a])> | a <-domain(subclasses)}, bool(tuple[loc, int] a, tuple[loc, int] b){ return a[1] > b[1]; }));

println("9e");
rel[str, Statement] statements = parseMethods(decls);
println(sort({<a,countIfs(b)> | <a, b> <- statements },  bool(tuple[str, int] a, tuple[str, int] b){ return a[1] > b[1]; }));
}
