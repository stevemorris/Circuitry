# Circuitry

Circuitry is a digital logic simulator I developed as part of [Ruby Mendicant University's](http://university.rubymendicant.com/) September 2011 session. It's a command line application written in Ruby.

Circuitry enables you to define digital circuits with AND, OR, XOR and NOT gates as well as other circuits you've previously defined. You can build up complex circuits in a modular way. You define your circuits in one or more text files using a Ruby-compatible DSL.

Once you've defined your circuits, you run the Circuitry application to simulate their operation. The application automatically performs multiple simulations, one for every unique combination of input values. It captures the set of output values produced by the circuit(s) for each simulation run. Finally, the application prints a truth table of the results to the console.

## Running the Application

Circuitry requires Ruby 1.9. You run the application from the command line as follows:

    bin/circuitry circuit -d path
  
where *circuit* is the name of the main circuit whose inputs and outputs will be simulated, and where *path* is the path to the circuit definitions folder. The *path* must be preceded by the *-d* option flag.

[Note the *circuit* you specify is the starting circuit for the simulation, but this circuit can reference other circuits in its definition.]  

Below is an example of how to run Circuitry with the sample FullAdder circuit provided in the examples folder:

    bin/circuitry FullAdder -d examples

## Circuit Definition Format

Circuit definitions are stored in one or more text files in the folder specified after the *-d* command line option. The application automatically loads all files in that folder that have a .rb extension.

Each circuit must have a unique name. The format of a circuit definition must follow this structure:

    Circuitry["CircuitName"] = {
      'input1' => 'output1',
      .
      .
      .
      'inputn' => 'outputn'
    }

Each line in the definition must be separated by a comma. A line represents a connection or wire between one named component and another. A connection can have only one input, but can have more than one outputs. Multiple outputs must be separated by commas and enclosed in braces as follows:

    'inputx' => ['outputx1', 'outputx2'],

Each input and output must have a unique name within that circuit definition, and the names must be enclosed in quotation marks. Most input and output names have multiple parts as follows:

    GateOrCircuitName#Id.Lead

- The GateOrCircuitName is one of the predefined logic gates AND, OR, XOR or NOT or the name of another user-defined circuit.
- The Id is a unique identifier (usually a number) to distinguish one circuit from another of the same name. Id's only need to be unique within a single circuit definition. The Id must be preceded by a pound sign.
- The Lead is the name of the input or output for the named circuit or gate. The Lead must be preceded by a period.

A circuit's external inputs and outputs (to the simulator or another circuit) do not include an Id or a Lead.

Below is the sample FullAdder circuit from the file examples/sample_circuits.rb, which is an example of a complete circuit definition:

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

A 2-Bit Adder circuit is composed of two FullAdder circuits. Below is the sample TwoBitAdder circuit from the file examples/sample_circuits.rb, which is an example of a circuit including another circuit:

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
