# coding: utf-8
require_relative 'generic_parser'
require_relative 'ast'
require_relative 'lexer'

module VHDL_TB

  class Parser < GenericParser
    attr_accessor :lexer,:tokens
    attr_accessor :basename,:filename

    def initialize
      #@verbose=true
      @lexer=Lexer.new
    end

    def lex filename
      unless File.exists?(filename)
        raise "ERROR : cannot find file '#{filename}'"
      end
      begin
        str=IO.read(filename).downcase
        tokens=lexer.tokenize(str)
        tokens=tokens.select{|t| t.class==Token} # filters [nil,nil,nil]
        return tokens.reject{|tok| tok.is_a? [:comment,:newline,:space]}
      rescue Exception=>e
        puts "an error occured during LEXICAL analysis. Sorry. Aborting."
        raise
      end
    end

    def parse filename
      @tokens=lex(filename)
      root=Root.new([])
      begin
        consume_to :entity
        root.design_units << entity=parse_entity

        consume_to :architecture
        root.design_units << archi=parse_architecture

      rescue Exception => e
        puts e.backtrace
        puts e
        puts "an error occured during SYNTACTIC analysis (around line #{showNext.pos.first}). Sorry. Aborting."
        raise
      end
      return root
    end

    def consume_to token_kind
      while showNext && showNext.kind!=token_kind
        acceptIt
      end
      if showNext.nil?
        raise "cannot find token '#{token_kind}'"
      end
    end

    def parse_entity
      entity=Entity.new(nil,nil,[])
      expect :entity
      entity.name=expect :identifier
      expect :is
      if showNext.is_a? :generic
        entity.generics=parse_generics
      end
      if showNext.is_a? :port
        entity.ports=parse_ports
      end
      expect :end
      if showNext.is_a? :semicolon
        acceptIt
      end
      return entity
    end

    def parse_generics
      generics=[]
      expect :generic
      expect :lparen
      while showNext.is_not_a? :rparen
        generics << parse_generic
        if showNext.is_a? :semicolon
          acceptIt
        end
      end
      expect :rparen
      expect :semicolon
      generics.flatten!
      generics
    end

    def parse_generic
      ids=[]
      ids << expect(:identifier)
      while showNext.is_a? :comma
        acceptIt
        ids << expect(:identifier)
      end
      expect :colon
      type=parse_type
      if showNext.is_a? :vassign
        acceptIt
        expr=parse_expression
      end
      ids.map{|id| Generic.new(id,type,expr)}
    end

    def parse_ports
      ports=[]
      expect :port
      expect :lparen
      while showNext.is_not_a? :rparen
        ports << parse_io
        if showNext.is_a? :semicolon
          acceptIt
        end
      end
      expect :rparen
      expect :semicolon
      ports.flatten!
      ports
    end

    def parse_io
      ids=[]
      ids << expect(:identifier)
      while showNext.is_a? :comma
        acceptIt
        ids << expect(:identifier)
      end
      expect :colon
      if showNext.is_a? [:in,:out]
        dir=acceptIt
        dir=dir.kind
      end
      type=parse_type
      ids.map{|id| dir==:in ? Input.new(id,type) : Output.new(id,type)}
    end

    def parse_type
      type=Identifier.new
      case showNext.kind
      when :identifier
        type.tok=expect(:identifier)
        if showNext.is_a? :lparen
          acceptIt
          name=type.tok
          type=VectorType.new
          type.name=name
          type.lhs=parse_expression
          if showNext.is_a? [:downto,:to]
            type.dir=acceptIt
          end
          type.rhs=parse_expression
          expect :rparen
        end
      else
        type.tok=acceptIt # natural,...
      end
      type
    end

    def parse_expression
      e1=parse_term
      while showNext.is_a? [:plus,:minus,:times,:div]
        op=acceptIt
        e2=parse_term
        e1=Binary.new(e1,op,e2)
      end
      return e1
    end

    def parse_term
      if showNext.is_a? [:decimal_literal,:identifier]
        case showNext.kind
        when :decimal_literal
          return IntLit.new(acceptIt)
        when :identifier
          return Identifier.new(acceptIt)
        else
          puts "cannot parse term"
        end
      end
    end

    def parse_architecture
      archi=Architecture.new
      expect :architecture
      archi.name=expect(:identifier)
      expect :of
      archi.entity=expect(:identifier)
      archi
    end
  end
end

if $PROGRAM_NAME==__FILE__
  filename=ARGV.first
  parser=VHDL_TB::Parser.new
  parser.parse filename
end
