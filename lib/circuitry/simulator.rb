module Circuitry
  class Simulator
    def initialize(circuit)
      unless Object.const_defined?(circuit)
        raise ArgumentError, "#{circuit} circuit not defined. See README."
      end

      @circuit = circuit

      @inputs, @outputs, @wires = Parser.parse(circuit)
    end

    def simulate
      @runs = []

      0.upto(2**@inputs.count - 1) do |n|
        input_values = sprintf("%0#{@inputs.count}b", n).split('')
        @inputs.each_with_index do |input, i|
          @wires[input] = input_values[i]
        end

        output_values = @outputs.collect do |output|
          solve_output(output) ? '1' : '0'
        end

        @runs << { inputs: input_values, outputs: output_values }
      end
    end

    def print(printer = Table)
      printer.print(@circuit, @inputs, @outputs, @runs)
    end

    private

    def solve_output(from)
      return from == '1' if %w(1 0).include?(from)

      to = @wires[from]

      if to.class == Array
        case from.split('.')[-2].split('#')[0]
          when 'AND' then solve_output(to[0]) & solve_output(to[1])
          when 'OR'  then solve_output(to[0]) | solve_output(to[1])
          when 'XOR' then solve_output(to[0]) ^ solve_output(to[1])
          when 'NOT' then !solve_output(to[0])
        end
      else
        solve_output(to)
      end
    end
  end
end