require_relative 'circuitry/parser'
require_relative 'circuitry/table'

module Circuitry
  extend self

  @circuits = {}

  def [](circuit)
    return nil unless const_defined?(circuit)
    @circuits[circuit] ||= const_get(circuit)
  end

  def load_files(folder)
    path = '../circuits/'
    path << folder + '/' unless folder.nil?

    Dir[File.dirname(__FILE__) + '/' + path + '*.rb'].each do |file|
      require_relative path + File.basename(file, File.extname(file))
    end
  end
end
