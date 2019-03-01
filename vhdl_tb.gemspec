require_relative './lib/version'

Gem::Specification.new do |s|
  s.name        = 'vhdl_tb'
  s.version     = VHDL_TB::VERSION
  s.date        = Time.now.strftime('%F')
  s.summary     = "VHDL Testbench generator"
  s.description = "A simple testbench generator for VHDL"
  s.authors     = ["Jean-Christophe Le Lann"]
  s.email       = 'jean-christophe.le_lann@ensta-bretagne.fr'
  s.files       = [
                   "bin/vhdl_tb",
                   "lib/version.rb",
                   "lib/token.rb",
                   "lib/generic_lexer.rb",
                   "lib/generic_parser.rb",
                   "lib/lexer.rb",
                   "lib/parser.rb",
                   "lib/ast.rb",
                   "lib/compiler.rb",
                   "lib/template.tb.vhd",
                   "tests/circuit.vhd"
                  ]
  s.executables << 'vhdl_tb'
  s.executables << 'tbgen'
  s.homepage    = 'http://rubygems.org/gems/vhdl_tb'
  s.license       = 'MIT'
end
