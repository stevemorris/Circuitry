module Circuitry
  module Parser
    extend self

    def parse(circuit)
      inputs  = []
      outputs = []

      Object.const_get(circuit).each do |input, output|
        inputs  << input unless input.include?('#')
        outputs << output unless output.class == Array || output.include?('#')
      end

      [inputs, outputs, parse_wires(circuit)]
    end

    private

    def parse_wires(circuit, wires = {}, prefix = '')
      Object.const_get(circuit).each do |input, outputs|
        outputs = [outputs] unless outputs.class == Array

        outputs.each do |output|
          wires[prefix + output] = prefix + input

          next unless input.include?('#')

          newoutput  = prefix + input
          newcircuit = newoutput.split('.')[-2].split('#')[0]

          if %w(AND OR XOR NOT).include?(newcircuit) && newoutput[-1] == 'Q'
            wires[newoutput] = [newoutput.chop + 'A']
            wires[newoutput] << newoutput.chop + 'B' unless newcircuit == 'NOT'
          else
            newprefix = newoutput.split('.')[0..-2].join('.') + '.'
            parse_wires(newcircuit, wires, newprefix)
          end
        end
      end

      wires
    end
  end
end
