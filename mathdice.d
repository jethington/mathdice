import std.stdio;
import std.string;
import std.conv;
import std.random;
import std.algorithm;

// ex arguments: 1d12 5d6
// assuming there is only one scoring dice
void main(string[] args) {
  int target = uniform(1, to!int(split(args[1], 'd')[1]) + 1);
  int numberOfDice = to!int(split(args[2], 'd')[0]);
  int sides = to!int(split(args[2], 'd')[1]);
  
  int rolls[];
  for (int i = 0; i < numberOfDice; i++) {
    rolls ~= uniform(1, sides+1);
  }
  
  writeln("Target: ", target);
  writeln("Rolls: ", rolls);
  writeln();
  
  int[][] solutions;
  bruteforce(solutions, [], rolls, target);
  if (solutions.length == 0) {
    writeln("No solution.");
  }
  else {
    sort!("a.length > b.length")(solutions);
    writeln(solutions[0]);
  }
}
  
void bruteforce(ref int[][] solutions, int[] possibleSolution, int[] rolls, int target) {
  if (rolls.length == 0) {  
    if (reduce!((a,b) => a + b)(0, possibleSolution) == target) { // there is probably an easier way to sum an array, but oh well
      solutions ~= possibleSolution;
    }
  }
  else {
    int[] plus = possibleSolution ~ rolls[0];
    bruteforce(solutions, plus, rolls[1..$], target);
    int[] skip = possibleSolution;
    bruteforce(solutions, skip, rolls[1..$], target);
    int[] minus = possibleSolution ~ (-rolls[0]);
    bruteforce(solutions, minus, rolls[1..$], target);
  }
}