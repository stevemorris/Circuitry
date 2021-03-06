# Full Adder circuit: see http://en.wikipedia.org/wiki/Adder_(electronics)
Circuitry["FullAdder"] = {
  'A'       => ['XOR#1.A', 'AND#2.A'],
  'B'       => ['XOR#1.B', 'AND#2.B'],
  'XOR#1.Q' => ['XOR#2.A', 'AND#1.A'],
  'Cin'     => ['XOR#2.B', 'AND#1.B'],
  'XOR#2.Q' => 'S',
  'AND#1.Q' => 'OR#1.A',
  'AND#2.Q' => 'OR#1.B',
  'OR#1.Q'  => 'Cout'
}

# 2-Bit Adder circuit incorporating two Full Adder circuits
Circuitry["TwoBitAdder"] = {
  'Cin'              => 'FullAdder#1.Cin',
  'A1'               => 'FullAdder#1.A',
  'B1'               => 'FullAdder#1.B',
  'A2'               => 'FullAdder#2.A',
  'B2'               => 'FullAdder#2.B',
  'FullAdder#1.S'    => 'S1',
  'FullAdder#1.Cout' => 'FullAdder#2.Cin',
  'FullAdder#2.S'    => 'S2',
  'FullAdder#2.Cout' => 'Cout'
}

# The simple_circuits sample from http://puzzlenode.com/puzzles/18
Circuitry["Simple"] = {
  'A1'     => 'OR#1.A',
  'B1'     => 'OR#1.B',
  'OR#1.Q' => 'Q1',

  'A2'      => 'AND#1.A',
  'B2'      => 'AND#1.B',
  'C2'      => 'NOT#1.A',
  'AND#1.Q' => 'XOR#1.A',
  'NOT#1.Q' => 'XOR#1.B',
  'XOR#1.Q' => 'Q2',
  
  'A3'      => 'OR#2.A',
  'B3'      => 'OR#2.B',
  'C3'      => 'XOR#2.A',
  'D3'      => 'XOR#2.B',
  'OR#2.Q'  => 'XOR#3.A',
  'XOR#2.Q' => 'XOR#3.B',
  'XOR#3.Q' => 'Q3'
}
