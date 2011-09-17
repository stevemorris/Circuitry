module Circuitry
  module Table
    extend self

    def print(circuit, inputs, outputs, runs)
      title  = circuit + ' Truth Table'
      canvas = Array.new(7)
      cols   = [0]
      inputs.each  { |input|  cols << cols.last + input.length + 3 }
      outputs.each { |output| cols << cols.last + output.length + 3 }

      # Header
      divider = '+' + '-'*(cols.last - 1) + '+'
      canvas[0] = divider
      divider[cols[inputs.count]] = '+'
      canvas[1] = '|' + title.center(cols.last - 1) + '|'
      canvas[2] = divider
      canvas[3] = '|' + 'Inputs'.center(cols[inputs.count] - 1) + '|' +
        'Outputs'.center(cols.last - cols[inputs.count] - 1) + '|'
      canvas[4] = divider
      canvas[5] = '|'
      inputs.each { |input| canvas[5] << ' ' << input << ' ' << '|' }
      outputs.each { |output| canvas[5] << ' ' << output << ' ' << '|' }
      canvas[6] = divider

      # Main table
      runs.each do |row|
        line = '|'
        row[:inputs].each_with_index do |value , i|
          line << value.center(cols[i + 1] - cols[i] - 1) << '|'
        end
        row[:outputs].inject(inputs.count) do |i, value|
          line << value.center(cols[i + 1] - cols[i] - 1) << '|'
          i + 1
        end
        canvas << line
      end
      canvas << divider

      canvas.inject('') { |string, line| string << line << "\n" }
    end
  end
end
