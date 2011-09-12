Kernel.load('./circuits.data') # Load user-defined circuits

# The user defines all circuit data in the circuits.data file, except for
# the built-in logic gates AND, OR, XOR, and NOT. The program is invoked
# with the name of one of these circuits. Circuits can include other
# circuits, so modular circuits of increasing complexity can be built-up.
# The circuit.data file includes a 2-bit Adder built from two Full Adders,
# but circuits of three or more levels are possible as well.
#
# Below is an example of a circuit definition (included in circuits.data):
#
# FullAdder = {
#   'A'       => ['XOR#1.A', 'AND#2.A'],
#   'B'       => ['XOR#1.B', 'AND#2.B'],
#   'XOR#1.Q' => ['XOR#2.A', 'AND#1.A'],
#   'Cin'     => ['XOR#2.B', 'AND#1.B'],
#   'XOR#2.Q' => 'S',
#   'AND#1.Q' => 'OR#1.A',
#   'AND#2.Q' => 'OR#1.B',
#   'OR#1.Q'  => 'Cout'
# }
#
# The circuit has a name (FullAdder in this example) with no spaces or
# special characters, followed by an equal signs and an opening curly
# brace. The circuit definition next includes several lines, separated
# by commas, that represent the wiring of the circuit. Each line has
# a wire input on the left, then an equals sign and greater than sign,
# and then one or more wire outputs on the right (if there's more than
# one output, they must be separated by commas and enclosed in brackets).
# All wire inputs and outputs must be enclosed in quotes. The format of
# most inputs and outputs is:
#   <circuitname>#<id>.<lead>
# The circuitname is another user-defined circuit or one of the gates
# AND, OR, XOR, NOT. The id is a unique identifier to distinguish one
# circuit from another of the same name. Id's only need to be unique
# within a single circuit definition. The lead is the name of the input
# or output for the named circuit. Inputs and outputs that don't have
# pound signs and periods are the external interface for this circuit
# (in this example the inputs A, B, Cin and the outputs S, Cout). Each
# must be uniquely named within a circuit definition. A closing curly
# brace ends the circuit definition.

class Circuits
  def initialize(circuit)
    unless Object.const_defined?(circuit)
      raise ArgumentError, "#{circuit} not defined in circuits.data"
    end

    @inputs  = []
    @outputs = []
    @wires   = {}

    # Save the names of the main circuit inputs and outputs
    Object.const_get(circuit).each do |input, output|
      @inputs << input unless input.include?('#')
      @outputs << output unless output.class == Array || output.include?('#')
    end

    # Build the main and referenced circuits
    build_wires(circuit)

    # Add the inputs from the main circuit
    @inputs.each { |input| @wires[input] = nil }

    # Uncomment out the next line to inspect the wires hash
    # @wires.each { |k, v| puts "#{k} => #{v}" }
  end

  # Build and return a truth table of all possible input value combinations
  # and the corresponding output values. To get the output values, set the
  # the input values in the wire hash and call solve_circuits for each output.
  # Save each set of input and output values as a row in the truth table.
  def build_truth_table
    table = []

    0.upto(2**@inputs.count - 1) do |n|
      input_values = sprintf("%0#{@inputs.count}b", n).split('')
      @inputs.each_with_index do |input, i|
        @wires[input] = input_values[i]
      end

      output_values = @outputs.collect do |output|
        solve_circuits(output) ? '1' : '0'
      end

      table << { inputs: input_values, outputs: output_values }
    end

    table
  end

  # Format the specified truth table as an ASCII table, and then output
  # it to the terminal. Use an in-memory canvas to do the formatting.
  # Include the specified title in the formatted table.
  def print_truth_table(table, title)
    canvas = Array.new(7)
    cols   = [0] # Array of character indexes for the column separators
    @inputs.each { |input| cols << cols.last + input.length + 3 }
    @outputs.each { |output| cols << cols.last + output.length + 3 }

    # Format the header section
    divider   = '+' + '-'*(cols.last - 1) + '+'
    canvas[0] = divider
    divider[cols[@inputs.count]] = '+'
    canvas[1] = '|' + title.center(cols.last - 1) + '|'
    canvas[2] = divider
    canvas[3] = '|' + 'Inputs'.center(cols[@inputs.count] - 1) + '|' +
      'Outputs'.center(cols.last - cols[@inputs.count] - 1) + '|'
    canvas[4] = divider
    canvas[5] = '|'
    @inputs.each { |input| canvas[5] << ' ' << input << ' ' << '|' }
    @outputs.each { |output| canvas[5] << ' ' << output << ' ' << '|' }
    canvas[6] = divider

    # Format the rows of input and output values
    table.each do |row|
      line = '|'
      row[:inputs].each_with_index do |value , i|
        line << value.center(cols[i + 1] - cols[i] - 1) << '|'
      end
      row[:outputs].inject(@inputs.count) do |i, value|
        line << value.center(cols[i + 1] - cols[i] - 1) << '|'
        i + 1
      end
      canvas << line
    end

    canvas << divider
    canvas.each { |line| puts line } # Output the formatted table
  end

  private

  # Recursively build up a single large hash of all wires within the main
  # circuit and all the referenced circuits. To make solving the circuits
  # easy, reverse the order of the hash keys and values from the order in
  # the circuits.dat file, i.e. store outputs in the hash keys and their
  # corresponding inputs in the values. Store logic gate inputs (AND, OR,
  # XOR, NOT) in an Array, both to hold multiple inputs and to indicate
  # an operation is needed when solving the circuits. To prevent name
  # collisions with the key/value strings in multi-level circuits, add
  # a prefix to each key/value with the preceding circuit names#ids
  # joined with periods. This results in a unique path to each wire
  # input/ouput in the circuit hierarchy.
  def build_wires(circuit, prefix = '')
    Object.const_get(circuit).each do |input, outputs|
      outputs = [outputs] unless outputs.class == Array

      outputs.each do |output|
        key         = prefix + output
        value       = prefix + input
        @wires[key] = value

        next unless input.include?('#') # Next if no referenced circuit

        circuit = value.split('.')[-2].split('#')[0] # Referenced circuit

        if %w(AND OR XOR NOT).include?(circuit) && value[-1] == 'Q'
          # Add wires for a logic gate output and inputs
          @wires[value] = [value.chop + 'A']
          @wires[value] << value.chop + 'B' unless circuit == 'NOT'
        else
          # Add the referenced circuit with the full prefix
          build_wires(circuit, value.split('.')[0..-2].join('.') + '.')
        end
      end
    end
  end

  # Solve the circuits for a single output by recursively traversing the
  # wires hash. Call this method once for each output on the main circuit
  # to get the output's value, based on the inputs values that were
  # previously stored in the wires hash. Continue the recursion until an
  # input value is found. Whenever a logic gate is found, combine the
  # inputs using the correct logical operation.
  def solve_circuits(from)
    return from == '1' if %w(1 0).include?(from) # Return input as boolean

    to = @wires[from]

    if to.class == Array
      # Combine logic gate inputs
      case from.split('.')[-2].split('#')[0]
        when 'AND' then solve_circuits(to[0]) & solve_circuits(to[1])
        when 'OR'  then solve_circuits(to[0]) | solve_circuits(to[1])
        when 'XOR' then solve_circuits(to[0]) ^ solve_circuits(to[1])
        when 'NOT' then !solve_circuits(to[0])
      end
    else
      # Continue to next wire
      solve_circuits(to)
    end
  end
end

if ARGV.size == 1
  # Using the specified user-defined circuit, initialize the circuits and
  # build a truth table, and then output the truth table.
  circuits = Circuits.new(ARGV[0])
  truth_table = circuits.build_truth_table
  circuits.print_truth_table(truth_table, ARGV[0] + ' Truth Table')
else
  puts 'Usage: ruby circuits.rb [circuitname]'
end
