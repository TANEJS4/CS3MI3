class Expr
    def initialize(val = nil, exp1 = nil, exp2 =nil, method= nil)
        @val = val
        @exp1 = exp1
        @exp2 = exp2
        @method =  method
    end

    def val
        @val
    end

    def exp1
        @exp1
    end

    def exp2
        @exp2
    end

    def method
        @method
    end

    def interpret()
        case self.val != nil
            when true
                self.val
            when false
                num1 = self.exp1.interpret
                if self.exp2 != nil
                    num2 = self.exp2.interpret
                end
                case self.method
                    when "neg"
                        -1 * num
                    when "abs"
                        num.abs
                    when "plus"
                        num1 + num2
                    when "minus"
                        num1 - num2
                    when "times"
                        num1 * num2
                    when "exp"
                        num1 ** num2
                end
        end
    end
end 

def construct_const(val)
    return Expr.new(val = val, exp1 = nil, exp2 = nil)
end

def construct_neg(exp1)
    return Expr.new(val = nil, exp1 = exp1, exp2 = nil,  method = "neg")
end

def construct_abs(exp1)
    return Expr.new(val = nil, exp1 = exp1, exp2 = nil,  method = "abs")
end

def construct_plus(exp1, exp2)
    return Expr.new(val = nil, exp1 = exp1, exp2 = exp2,  method = "plus")
end

def construct_minus(exp1, exp2)
    return Expr.new(val = nil, exp1 = exp1, exp2 = exp2,  method = "minus")
end
def construct_exp(exp1, exp2)
    return Expr.new(val = nil, exp1 = exp1, exp2 = exp2,  method = "exp")
end
def construct_times(exp1, exp2)
    return Expr.new(val = nil, exp1 = exp1, exp2 = exp2,  method = "times")
end
