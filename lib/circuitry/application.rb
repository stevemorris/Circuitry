require 'optparse'

module Circuitry
  module Application
    extend self

    def run(argv)
      opts = Options.new(argv)
      Dir.glob("#{opts.path}/*.rb") { |file| require file }

      simulator = Circuitry::Simulator.new(opts.circuit)
      simulator.simulate
      puts simulator.print
    end

    class Options
      attr_reader :path
      attr_reader :circuit

      def initialize(argv)
        @path = '.'
        parse_opts(argv)
        @circuit = argv.first
      end

      private

      def parse_opts(argv)
        OptionParser.new do |opts|  
          opts.banner = "Usage: circuitry circuit -d path"

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
end
