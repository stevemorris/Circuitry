module Circuitry
  module Table
    extend self

    def print(circuit, inputs, outputs, runs)
      title   = circuit + ' Truth Table'
      canvas  = []
      columns = get_columns(inputs, outputs)

      canvas << header_section(title, inputs, outputs, columns)
      canvas << rows_section(runs, inputs, columns)
      canvas.join("\n")
    end

    private

    def header_section(title, inputs, outputs, columns)
      lines  = []
      width  = columns.last + 1
      lwidth = columns[inputs.count]

      lines << divider(width, width - 1)
      lines << '|' + title.center(width - 2) + '|'
      lines << divider(width, lwidth)
      lines << '|' + 'Inputs'.center(lwidth - 1) +
               '|' + 'Outputs'.center(width - lwidth - 2) + '|'
      lines << divider(width, lwidth)
      lines << headers(inputs, outputs)
      lines << divider(width, lwidth)
    end

    def rows_section(runs, inputs, columns)
      lines  = []
      width  = columns.last + 1
      lwidth = columns[inputs.count]

      runs.each do |row|
        line = '|'
        row[:inputs].each_with_index do |value , i|
          line << value.center(columns[i + 1] - columns[i] - 1) << '|'
        end
        row[:outputs].inject(inputs.count) do |i, value|
          line << value.center(columns[i + 1] - columns[i] - 1) << '|'
          i + 1
        end
        lines << line
      end
      lines << divider(width, lwidth)
    end

    def divider(width, lwidth)
      line = '+' + '-'*(width - 2) + '+'
      line[lwidth] = '+'
      line
    end

    def headers(inputs, outputs)
      line = '|'
      inputs.each  { |input|  line << ' ' << input  << ' ' << '|' }
      outputs.each { |output| line << ' ' << output << ' ' << '|' }
      line
    end

    def get_columns(inputs, outputs)
      cols = [0]
      inputs.each  { |input|  cols << cols.last + input.length + 3 }
      outputs.each { |output| cols << cols.last + output.length + 3 }
      cols
    end
  end
end
