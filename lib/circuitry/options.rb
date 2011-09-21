require 'optparse'

module Circuitry
  class Options
    attr_reader :path
    attr_reader :circuit

    def initialize(argv)
      @path = '.'
      parse(argv)
      @circuit = argv.first
    end

    private

    def parse(argv)
      OptionParser.new do |opts|  
        opts.banner = "Usage: circuitry -d path circuit"

        opts.on("-d", "--definitions path", String,
          "Path to circuit definitions folder") do |path|
          @path = path
        end

        opts.on("-h", "--help", "Show this message") do
          puts opts
          exit
        end

        begin
          argv = ["-h"] if argv.empty?
          opts.parse!(argv)
        rescue OptionParser::ParseError => e
          STDERR.puts e.message, "\n", opts
          exit(-1)
        end
      end    
    end
  end
end
