# Digital Logic Simulator

In this solution I enable the user to define modular circuits in an
external file (circuits.data). See the notes below for a description
of the circuit definition format. A user can build-up complex circuits
from basic logic gates and from previous user-defined circuits.

Rather than rendering the layout of the circuit, I opted to provide
another useful way to explore and debug a circuit: a truth table.
Given any circuit, this program outputs an ASCII table of all possible
inputs to the circuit and their corresponding outputs. Since the
program automatically simulates the circuits with all possible inputs,
there's no need for the user to specify inputs.

Searching the web, I didn't have much success finding truth tables
except for simple circuits. Hopefully this program fills a need for
simulating more complex circuits and building their complete truth tables.

## Running the Program

    ruby circuits.rb <circuitname>
example:
<pre>ruby circuits.rb FullAdder</pre>
    
note: the circuits.data file must be in the same directory as the circuits.rb file

## Notes

The user defines all circuit data in the circuits.data file, except for
the built-in logic gates AND, OR, XOR, and NOT. The program is invoked
with the name of one of these circuits. Circuits can include other
circuits, so modular circuits of increasing complexity can be built-up.
The circuit.data file includes a 2-bit Adder built from two Full Adders,
but circuits of three or more levels are possible as well.

Below is an example of a circuit definition (included in circuits.data):

    FullAdder = {
      'A'       => ['XOR#1.A', 'AND#2.A'],
      'B'       => ['XOR#1.B', 'AND#2.B'],
      'XOR#1.Q' => ['XOR#2.A', 'AND#1.A'],
      'Cin'     => ['XOR#2.B', 'AND#1.B'],
      'XOR#2.Q' => 'S',
      'AND#1.Q' => 'OR#1.A',
      'AND#2.Q' => 'OR#1.B',
      'OR#1.Q'  => 'Cout'
    }

The circuit has a name (FullAdder in this example) with no spaces or
special characters, followed by an equal signs and an opening curly
brace. The circuit definition next includes several lines, separated
by commas, that represent the wiring of the circuit. Each line has
a wire input on the left, then an equals sign and greater than sign,
and then one or more wire outputs on the right (if there's more than
one output, they must be separated by commas and enclosed in brackets).
All wire inputs and outputs must be enclosed in quotes. The format of
most inputs and outputs is:
<pre>&lt;circuitname&gt;#&lt;id&gt;.&lt;lead&gt;</pre>
The circuitname is another user-defined circuit or one of the gates
AND, OR, XOR, NOT. The id is a unique identifier to distinguish one
circuit from another of the same name. Id's only need to be unique
within a single circuit definition. The lead is the name of the input
or output for the named circuit. Inputs and outputs that don't have
pound signs and periods are the external interface for this circuit
(in this example the inputs A, B, Cin and the outputs S, Cout). Each
must be uniquely named within a circuit definition. A closing curly
brace ends the circuit definition.
