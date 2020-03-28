module VHDL

    class Root
      attr_accessor :design_units
      def initialize design_units=[]
        @design_units=design_units
      end

      def << e
        @design_units << e
      end
    end

    Entity=Struct.new(:name,:generics,:ports)
    Generic=Struct.new(:name,:type,:init)
    Input=Struct.new(:name,:type)
    Output=Struct.new(:name,:type)
    Architecture=Struct.new(:name,:entity)

    Identifier=Struct.new(:tok) do
      def to_s
        self.tok.to_s
      end
    end

    IntLit=Struct.new(:tok) do
      def to_s
        "#{self.tok}"
      end
    end

    VectorType=Struct.new(:name,:lhs,:dir,:rhs) do
      def to_s
        "#{self.name}(#{self.lhs} #{self.dir} #{self.rhs})"
      end
    end


    Binary=Struct.new(:lhs,:op,:rhs) do
      def to_s
        "#{self.lhs} #{self.op} #{self.rhs}"
      end
    end

    class FuncCall
      attr_accessor :name,:actual_args
      def initialize name=nil,args=[]
        @name,@args=name,args
      end
    end

    class Timed
      attr_accessor :lhs,:rhs
      def initialize lhs,rhs
        @lhs,@rhs=lhs,rhs
      end
    end
end
