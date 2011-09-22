require_relative 'circuitry/application'
require_relative 'circuitry/parser'
require_relative 'circuitry/simulator'
require_relative 'circuitry/table'

module Circuitry
  extend self

  def []=(name, definition)
    circuits[name] = definition
  end

  def [](name)
    circuits[name]
  end

  private

  def circuits
    @circuits ||= {}
  end
end
