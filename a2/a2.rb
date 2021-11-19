load 'a2_ulterm.rb'  
class STType end

  class STNat < STType
    # Comparison and printing methods
    def ==(type); type.is_a?(STNat) end
    def to_s; "nat" end
  end

  class STBool < STType
    # Comparison and printing methods
    def ==(type); type.is_a?(STBool) end
    def to_s; "bool" end
  end

  # Functions have a domain type and a codomain type.
  class STFun < STType
    attr_reader :dom
    attr_reader :codom
    
    def initialize(dom, codom)
      unless dom.is_a?(STType) && dom.is_a?(STType)
        throw "Constructing a type out of non-types"
      end
      @dom = dom; @codom = codom
    end

    # Comparison and printing methods
    def checkDom(type)
      @dom ==  type
    end
    def checkCoDom(type)
      @codom ==  type
    end
    def ==(type); type.is_a?(STFun) && type.dom == @dom && type.codom == @codom end 
    def to_s; "(" + dom.to_s + ") -> (" + codom.to_s + ")" end
  end


class STTerm end

  class STVar < STTerm
    attr_reader :index

    def initialize(i)
      unless i.is_a?(Integer)
        return false
      end
      @index  = i
    end
    
    def ==(r); r.is_a?(STVar) && r.index == @index end

    def typecheck
      not typeOf().nil? 
    end
    def typeOf(environemnt=Array.new)
      environemnt[index]
    end

    def eraseTypes
      res = eraseHelper()
      if res.nil?  
        raise Exception.new "Wrong experession"
      else
        res
      end
    end
    def eraseHelper
      ULVar.new(index)
    end

  end

  class STTrue < STTerm

    def boolValue?; true end 

    def typecheck
      not typeOf().nil? 
    end
    def typeOf(environemnt=Array.new)
      STBool.new
    end
    def ==(r); r.is_a?(STTrue)  end
    def eraseTypes
      res = eraseHelper()
      if res.nil?  
        raise Exception.new "Wrong experession"
      else
        res
      end
    end
    def eraseHelper
      ULAbs.new(ULAbs.new(ULVar.new(1)))
    end
  end

  class STFalse < STTerm
 
    def boolValue?; false end 
    def typecheck
      not typeOf().nil? 
    end
    def typeOf(environemnt=Array.new)
      STBool.new
    end

    def eraseTypes
      res = eraseHelper()
      if res.nil?  
        raise Exception.new "Wrong experession"
      else
        res
      end
    end
    def eraseHelper
      ULAbs.new(ULAbs.new(ULVar.new(0)))
    end

    def ==(r); r.is_a?(STFalse)  end

  end

  class STZero < STTerm
    

    def isBool?; false end 

    def typecheck
      not typeOf().nil? 
    end
    def typeOf(environemnt=Array.new)
      STNat.new
    end

    def eraseTypes
      res = eraseHelper()
      if res.nil?  
        raise Exception.new "Wrong experession"
      else
        res
      end
    end
    def eraseHelper
      ULAbs.new(ULAbs.new(ULVar.new(0)))
    end

    def ==(r); r.is_a?(STZero)  end
    
  end

  class STSuc < STTerm
    attr_reader :exp
    def initialize(i)
      unless i.is_a?(STTerm) 
        return false
      end
      @exp = i
    end
    def to_s
      "Suc (" + @exp.to_s + ")" 
    end

    def typecheck
      not typeOf().nil? 
    end
    def typeOf(environemnt=Array.new)
      val =  exp.typeOf(environemnt)
      if val.is_a?(STNat)
        return STNat.new
      else
        return nil
      end
    end
    
    def eraseTypes
      res = eraseHelper()
      if res.nil?  
        raise Exception.new "Wrong experession"
      else
        res
      end
    end
    def eraseHelper
      val = exp.eraseHelper()
      nat_Check = exp.is_a?(STNat)
      if  not val.nil? &&  nat_Check
        ULApp.new(ULAbs.new(ULAbs.new(ULAbs.new(ULApp.new(ULVar.new(1),ULApp.new(ULApp.new(ULVar.new(2),ULVar.new(1)),ULVar.new(0)))))), val)
      else
        nil
      end
    end 
  end

  class STAbs < STTerm
    attr_reader :type
    attr_reader :exp

    def initialize(t, e)
      unless t.is_a?(STType) && e.is_a?(STTerm)
        return false
      end
      @type = t
      @exp = e
    end
    def typecheck
      envList= Array.new 
      not typeOf(envList).nil? 

    end
    def typeOf(environemnt=Array.new)
      environemnt.unshift(type) # adds in begining 
      val =  exp.typeOf(environemnt)

      if val.is_a?(STType)         
        return STFun.new(type, val)
      else
        return nil
      end
    end

    def eraseTypes
      res = eraseHelper()
      if res.nil?  
        raise Exception.new "Wrong experession"
      else
        res
      end
    end
    def eraseHelper
      envList= Array.new 

      val = exp.eraseHelper()
      val_check = exp.typeOf(envList)

      if not val.nil? && val_check.is_a?(STType)
        ULAbs.new(val)
      else
        nil
      end
    end 
  end

  class STIsZero < STTerm
    attr_reader :exp
    def initialize(i)
      unless i.is_a?(STTerm) 
        return false
      end
      @exp = i
    end

    def typecheck
      not typeOf().nil? 
    end
    def typeOf(environemnt=Array.new)

      if exp.is_a?(STZero)
        return STNat.new
      else
        return nil
      end
    end
    def eraseTypes
      res = eraseHelper()
      if res.nil?  
        raise Exception.new "Wrong experession"
      else
        res
      end
    end
    def eraseHelper
      if exp.is_a?(STZero)
        ULAbs.new(ULAbs.new(ULVar.new(1)))
      else
        ULAbs.new(ULAbs.new(ULVar.new(0)))
      end
    end 
  end

  class STApp < STTerm
    attr_reader :t1
    attr_reader :t2
    
    def initialize(exp1, exp2)
      unless exp1.is_a?(STTerm) && exp2.is_a?(STTerm)
        return false
      end
      @t1 = exp1 
      @t2 = exp2
    end
    def typecheck
      not typeOf().nil? 
    end
    def typeOf(environemnt=Array.new)
      val_A  = @t2.typeOf(environemnt)
      val_B  = @t1.typeOf(environemnt)
      if val_B.is_a?(STFun) 
        if val_B.dom != val_A 
          return nil
        end
        return val_B.codom
      else
        return nil
      end
    end

    def eraseTypes
      res = eraseHelper()
      if res.nil?  
        raise Exception.new "Wrong experession"
      else
        res
      end
    end
    def eraseHelper
      val_A = t1.eraseHelper()
      val_B = t2.eraseHelper()
      if not (val_B.nil? && val_B.nil?)
        ULApp.new(val_A,val_B)
      else
        nil
      end
    end 
  end
  
  class STTest < STTerm
    attr_reader :b
    attr_reader :t1
    attr_reader :t2
    
    def initialize(bool, exp1, exp2)
      unless exp1.is_a?(STTerm) && exp2.is_a?(STTerm) && bool.is_a?(STTerm)
        return false
      end
      @b =  bool
      @t1 = exp1 
      @t2 = exp2
    end
    def typecheck
      not typeOf().nil? 
    end
    def typeOf(environemnt=Array.new)
      val_A  = @t1.typeOf(environemnt)
      val_B  = @t2.typeOf(environemnt)
      check_bool = @b.typeOf(environemnt)
      if check_bool.is_a?(STBool)
        if val_A == val_B && @b.boolValue?
          STBool.new
        elsif  val_A != val_B && @b.boolValue? == false
          STBool.new
        else
          nil
        end
      end
    end

    def eraseTypes
      res = eraseHelper()
      if res.nil?  
        raise Exception.new "Wrong experession"
      else
        res
      end
    end
    def eraseHelper
      bool =  b.eraseHelper()
      val_A = t1.eraseHelper()
      val_B = t2.eraseHelper()
      if  not (bool.nil? && val_B.nil? && val_B.nil?)
        ULApp.new(ULApp.new(ULApp.new(ULAbs.new(ULAbs.new(ULAbs.new(ULApp.new(ULApp.new(ULVar.new(2), ULVar.new(1)), ULVar.new(0))))), bool), val_A), val_B)
      else
        nil
      end
    end
  end
