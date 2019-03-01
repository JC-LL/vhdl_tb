require 'erb'
require 'pp'
require 'optparse'

require_relative 'ast'
require_relative 'parser'
require_relative 'version'

module VHDL_TB

  TestBench=Struct.new(:name)

 class Compiler

   def initialize
     #puts __dir__
     banner
     @engine=ERB.new(IO.read "#{__dir__}/template.tb.vhd")
     @parser=Parser.new
   end

   def banner
     #puts "-- "+"="*30
     puts "==> VHDL testbench generator #{VERSION} <=="
     #puts "-- "+"="*30
   end

   def analyze_options args
     args << "-h" if args.empty?

     opt_parser = OptionParser.new do |opts|
       opts.banner = "Usage: vhdl_tb (or tbgen) <filename>"

       opts.on("-v", "--version", "Prints version") do |n|
         puts VERSION
         abort
       end

       opts.on("-h", "--help", "Prints this help") do
         puts "Generates testbench in VHDL, from a given file containing an Entity-Architecture couple."
         puts
         puts opts
         abort
       end
     end

     begin
       opt_parser.parse!(args)
       @args=args

     rescue Exception => e
       puts e
       #puts e.backtrace
       exit
     end
   end

   def generate entity_filename=@args.first
     @symtable=[]
     @symtable << "clk"
     @symtable << "reset_n"
     @symtable << "sreset"
     begin
       analyze(entity_filename)
       tb_txt=@engine.result(binding)
       tb_filename="#{@tb.name}.vhd"
       File.open(tb_filename,'w'){|f| f.puts tb_txt}
       puts "testbench generated : #{tb_filename}"
     rescue Exception => e
       puts e
       abort
     end
   end

   def analyze entity_filename
     puts "analyzing VHDL file : #{entity_filename}"

     root=Parser.new.parse entity_filename

     #puts "parsed #{entity_filename}. Good."
     @entity=root.design_units.find{|du| du.class==Entity}
     puts "entity found        : #{@entity.name} (#{@entity.ports.size} ports)"

     @arch=root.design_units.find{|du| du.is_a? Architecture}
     check
     # prepare ERB through instance variables
     @max_length=@entity.ports.map{|p| p.name.val.size}.max
     @ports=@entity.ports.map{|p| " "*10+"#{e=p.name.val.ljust(@max_length)} => #{e}"}.join(",\n")
     if gs=(@entity.generics)
       generics=gs.map{|g| " "*10+"#{g.name} => #{g.init}"}
       @generics="generic map(\n#{generics.join(",\n")})"
     end
     @tb=TestBench.new(@entity.name.val+"_tb")
   end

   def check
     print "checking".ljust(20)
     errors =[]

     if @entity.ports.size==0
       errors << "0 ports found for #{@entity.name}"
     end

     if @arch.entity.val!=@entity.name.val
       errors << "wrong entity-architecture pair : entity is -->#{@entity.name}<-- vs arch #{@arch.name} of -->#{@arch.entity.name}<--"
     end

     if errors.any?
       puts ": nok"
       puts "\nchecks failed due to the following errors :"
       errors.each{|e| puts "- ERROR : #{e}"}
       raise
     else
       puts ": ok"
     end
   end

  end
end

if $PROGRAM_NAME == __FILE__
  raise "you need to provide a VHDL file that contains the entity to test" if ARGV.size==0
  filename=ARGV[0]
  VHDL_TB.Compiler.new.generate(filename)
end
