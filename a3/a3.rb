# defining GCL and GCLe modules 
module GCL 
    class GCExpr end

    # GCExpr
    class GCConst < GCExpr

        attr_reader :value

        def initialize(i)
            unless i.is_a?(Integer)
            return false
            end
            @value  = i
        end

        def eval(comStack, resStack, memState)
            resStack.unshift(value)
            return [comStack, resStack, memState]
        end

        def gaurdEval(comStack, resStack, memState)
            return value
        end
    end

    class GCVar < GCExpr
        attr_reader :sym

        def initialize(i)
            unless i.is_a?(Symbol)
                return false
            end
            @sym  = i
        end

        def eval(comStack, resStack, memState)
            comStack.unshift(sym)
            return [comStack, resStack, memState]
        end

        def gaurdEval(comStack, resStack, memState)
            return memState[sym]
        end
    end

    class GCOp < GCExpr
        attr_reader :exp1
        attr_reader :exp2
        attr_reader :sym

        def initialize(e1,e2, s)
            unless e1.is_a?(GCExpr) and e1.is_a?(GCExpr) and [:times,:plus, :minus, :div].include?(s) 
                return false
            end
            @exp1 = e1
            @exp2 = e2
            @sym = s
        end

        def eval(comStack, resStack, memState)
            comStack.unshift(sym)
            comStack.unshift(exp1)
            comStack.unshift(exp2)

            return [comStack, resStack, memState]
        end
        def gaurdEval(comStack, resStack, memState)
            raise "error in OP"
        end
    end
    
    class GCTest  end

    # GCTest
    class GCComp < GCTest 
        attr_reader :exp1
        attr_reader :exp2
        attr_reader :sym

        def initialize(e1,e2, s)
            unless e1.is_a?(GCExpr) and e1.is_a?(GCExpr) and [:eq,:less, :greater].include?(s) 
                return false
            end
            @exp1 = e1
            @exp2 = e2
            @sym = s
        end
        def eval(comStack, resStack, memState)
            raise "error in GCComp"
        end
        def gaurdEval(comStack, resStack, memState)
            e1 = exp1.gaurdEval(comStack, resStack, memState)
            e2 = exp2.gaurdEval(comStack, resStack, memState)
            case sym
            when :eq
                return e1 == e2
            when :less
                return e1 < e2
            when :greater
                return e1 > e2
            end
        end
    end

    class GCAnd <  GCTest
        attr_reader :exp1
        attr_reader :exp2

        def initialize(e1,e2)
            unless e1.is_a?(GCTest) and e1.is_a?(GCTest)
                return false
            end
            @exp1 = e1
            @exp2 = e2
        end
        
        def eval(comStack, resStack, memState)
            stock.unshift(:and)
            stock.unshift(exp2)
            stock.unshift(exp1)
            return [comStack, resStack, memState]
        end

        def gaurdEval(comStack, resStack, memState)
            e1 = exp1.gaurdEval(comStack, resStack, memState)
            e2 = exp2.gaurdEval(comStack, resStack, memState)
            return e1 && e2
        end
    end

    class GCOr <  GCTest
        attr_reader :exp1
        attr_reader :exp2

        def initialize(e1,e2)
            unless e1.is_a?(GCTest) and e1.is_a?(GCTest)
                return false
            end
            @exp1 = e1
            @exp2 = e2
        end
        def eval(comStack, resStack, memState)
            stock.unshift(:or)
            stock.unshift(exp2)
            stock.unshift(exp1)
            return [comStack, resStack, memState]
        end
        def gaurdEval(comStack, resStack, memState)
            e1 = exp1.gaurdEval(comStack, resStack, memState)
            e2 = exp2.gaurdEval(comStack, resStack, memState)
            return e1 || e2
        end
    end

    class GCTrue < GCTest
        def eval(comStack, resStack, memState)
            resStack.unshift(true)
            return [comStack, resStack, memState]
        end
        def gaurdEval(comStack, resStack, memState)
            return true
        end
    end

    class GCFalse < GCTest
        def eval(comStack, resStack, memState)
            resStack.unshift(false)
            return [comStack, resStack, memState]
        end
        def gaurdEval(comStack, resStack, memState)
            return false
        end

    end

    
    class GCStmt end
    # GCStmt
    class GCSkip < GCStmt  
        def eval(comStack, resStack, memState)
            return [comStack, resStack, memState]
        end

        def gaurdEval(comStack, resStack, memState)
            raise "error in SKIP"
        end
    end

    class GCAssign < GCStmt  
        attr_reader :sym
        attr_reader :exp

        def initialize(s,e)
            unless e.is_a?(GCExpr) and s.is_a?(Symbol)
                return false
            end
            @exp = e
            @sym = s
        end

        def eval(comStack, resStack, memState)
            comStack.unshift(sym)
            comStack.unshift(:assign)
            comStack.unshift(exp)
            return [comStack, resStack, memState]
            

        end
        def gaurdEval(comStack, resStack, memState)
            raise "error in Assign"
        end

    end

    class GCCompose < GCStmt  
        attr_reader :stmt1
        attr_reader :stmt2

        def initialize(st1,st2)
            unless st1.is_a?(GCStmt) and st2.is_a?(GCStmt)
                return false
            end
            @stmt1 = st1
            @stmt2 = st2
        end
        def eval(comStack, resStack, memState)
            comStack.unshift(stmt2)
            comStack.unshift(stmt1)
            return [comStack, resStack, memState]
        end

        def gaurdEval(comStack, resStack, memState)
            raise "In compose"
        end
    end

    class GCIf  < GCStmt  
        attr_reader :pair_list

        def initialize(lis_check)
            lis_check.each do |elem|
                return false unless elem.length() == 2 and elem[0].is_a?(GCTest) and  elem[1].is_a?(GCStmt)
            end
            @pair_list = lis_check

        end
        
        def eval(comStack, resStack, memState)
            selectCom = gaurdEval(comStack, resStack, memState)
            comStack.unshift(selectCom)
            return [comStack, resStack, memState]
        end

        def gaurdEval(comStack, resStack, memState)
            true_list =[]
            pair_list.each do |elem|
                if elem[0].gaurdEval(comStack, resStack, memState)
                    true_list.push(elem[1])
                end
            end
            return true_list.sample
        end
    end
    
    class GCDo  < GCStmt  
        attr_reader :pair_list

        def initialize(lis_check)
            lis_check.each do |elem|
                return false unless elem.length() == 2 and elem[0].is_a?(GCTest) and  elem[1].is_a?(GCStmt)
            end
            @pair_list = lis_check
        end
        
        def eval(comStack, resStack, memState)
            return gaurdEval(comStack, resStack, memState)
        end

        def gaurdEval(comStack, resStack, memState)
            take_one =  pair_list.sample
            eval_take_one = take_one[0].gaurdEval(comStack, resStack, memState)
            if eval_take_one
                comStack.unshift(GCDo.new(pair_list))
                comStack.unshift(take_one[1])
                return  [comStack, resStack, memState]
            end
            return [comStack, resStack, memState]

        end
    end
    
    # Part2
    def stackEval(comStack, resStack, memState)
        op_list =[:times,:plus, :minus, :div,:or, :and, :assign,:eq,:less, :greater ]
        lambda { |x|
            until comStack.empty? do
                command = comStack.shift
                if command.is_a?(GCExpr) ||  command.is_a?(GCStmt)|| command.is_a?(GCTest)
                    temp = command.eval(comStack,resStack, memState)
                    comStack = temp[0]
                    resStack = temp[1]
                    memState =  temp[2]
                elsif command.is_a?(Symbol) and not resStack.empty? and op_list.include?(command)
                    case command
                    when :assign 
                        memState = updateState(memState,comStack.shift, resStack.shift)
                    else  
                        resStack =  operationHelper(resStack, command)
                    end
                elsif command.is_a?(Symbol) and memState.member?(command)
                    resStack.unshift(memState[command])
                else
                    raise "error Wrong expression"
                end
            end  
            return memState[x] }
    end


    def operationHelper(resStack,command)
        val1 = resStack.shift
        val2 = resStack.shift
        case command
        when :plus
            temp = val1 + val2
        when :times
            temp = val1 * val2
        when :minus
            temp = val1 - val2
        when :div
            temp = val1 / val2
        when :or
            temp = val1 || val2
        when :and
            temp = val1 && val2
        end
        resStack.unshift(temp)
        return resStack
    end
    
    def emptyState
        return {}
    end 

    def updateState(prevState, var, val)
        prevState[var] = val
        return prevState
    end 
end


# GCLe 
module GCLe 
    class GCExpr end

    # GCExpr
    class GCConst < GCExpr

        attr_reader :value

        def initialize(i)
            unless i.is_a?(Integer)
            return false
            end
            @value  = i
        end

        def eval(memState)
            return value
        end
        def scoped(local_env , local_vars, global_env,global_vars)
            global_vars.unshift(value)
            local_vars.unshift(value)
            return [local_env , local_vars, global_env,global_vars]
        end

    end

    class GCVar < GCExpr
        attr_reader :sym

        def initialize(i)
            unless i.is_a?(Symbol)
                return false
            end
            @sym  = i
        end
        def eval(memState)
            return memState[sym]
        end
        def value
            @sym
        end
        def scoped(local_env , local_vars, global_env,global_vars)
            global_vars.unshift(sym)
            local_vars.unshift(sym)
            return [local_env , local_vars, global_env,global_vars]
        end
    end

    class GCOp < GCExpr
        attr_reader :exp1
        attr_reader :exp2
        attr_reader :sym

        def initialize(e1,e2, s)
            unless e1.is_a?(GCExpr) and e1.is_a?(GCExpr) and [:times,:plus, :minus, :div].include?(s) 
                return false
            end
            @exp1 = e1
            @exp2 = e2
            @sym = s
        end

        def eval(memState)
            e1 = exp1.eval(memState)
            e2 = exp2.eval(memState)
            case sym
            when :times
                return e1 * e2
            when :plus
                return e1 + e2
            when :minus
                return e1 - e2
            when :div
                return e1 / e2
            end
        end
        
        def scoped(local_env , local_vars, global_env,global_vars)
            temp = exp1.scoped(local_env , local_vars, global_env,global_vars)
            local_env = temp[0]
            local_vars = temp[1]
            global_env = temp[2]
            global_vars = temp[3]
            temp = exp2.scoped(local_env , local_vars, global_env,global_vars)
            return temp
        end
        
    end
    
    class GCTest  end

    # GCTest
    class GCComp < GCTest 
        attr_reader :exp1
        attr_reader :exp2
        attr_reader :sym

        def initialize(e1,e2, s)
            unless e1.is_a?(GCExpr) and e1.is_a?(GCExpr) and [:eq,:less, :greater].include?(s) 
                return false
            end
            @exp1 = e1
            @exp2 = e2
            @sym = s
        end

        def eval(memState)
            e1 = exp1.eval(memState)
            e2 = exp2.eval(memState)
            puts e1
            puts e2
            # if e1.is_a?(Symbol)
            #     e1.v
            case sym
            when :eq
                return e1 == e2
            when :less
                return e1 < e2
            when :greater
                return e1 > e2
            end
        end

        def scoped(local_env , local_vars, global_env,global_vars)
            temp = exp1.scoped(local_env , local_vars, global_env,global_vars)
            return exp2.scoped(temp[0] , temp[1], temp[2],temp[3])
        end
    end

    class GCAnd <  GCTest
        attr_reader :exp1
        attr_reader :exp2

        def initialize(e1,e2)
            unless e1.is_a?(GCTest) and e1.is_a?(GCTest)
                return false
            end
            @exp1 = e1
            @exp2 = e2
        end
        def eval(memState)
            e1 = exp1.eval(memState)
            e2 = exp2.eval(memState)
            return e1 && e2
        end


        def scoped(local_env , local_vars, global_env,global_vars)
            temp = exp1.scoped(local_env , local_vars, global_env,global_vars)
            return exp2.scoped(temp[0] , temp[1], temp[2],temp[3])
        end
    end

    class GCOr <  GCTest
        attr_reader :exp1
        attr_reader :exp2

        def initialize(e1,e2)
            unless e1.is_a?(GCTest) and e1.is_a?(GCTest)
                return false
            end
            @exp1 = e1
            @exp2 = e2
        end
        def eval(memState)
            e1 = exp1.eval(memState)
            e2 = exp2.eval(memState)
            return e1 || e2
        end

        def scoped(local_env , local_vars, global_env,global_vars)
            temp = exp1.scoped(local_env , local_vars, global_env,global_vars)
            return exp2.scoped(temp[0] , temp[1], temp[2],temp[3])
        end
    end

    class GCTrue < GCTest

        def scoped(local_env , local_vars, global_env,global_vars)
            global_vars.unshift(true)
            local_vars.unshift(true)
            return [local_env , local_vars, global_env,global_vars]
        end
        def eval(memState)
            return true
        end

    end

    class GCFalse < GCTest

        def scoped(local_env , local_vars, global_env,global_vars)
            global_vars.unshift(false)
            local_vars.unshift(false)
            return [local_env , local_vars, global_env,global_vars]
        end
        def eval(memState)
            return false
        end


    end

    class GCStmt end
    # GCStmt
    class GCSkip < GCStmt  

        def scoped(local_env , local_vars, global_env,global_vars)
            return [local_env , local_vars, global_env,global_vars]
        end
        def eval(memState)
            return memState
        end

    end

    class GCAssign < GCStmt  
        attr_reader :sym
        attr_reader :exp

        def initialize(s,e)
            unless e.is_a?(GCExpr)
                return false
            end
            @exp = e
            @sym = s
        end
        def eval(memState)
            e1 = exp.eval(memState)
            if sym.is_a?(GCVar)
                memState[sym.eval(memState)] = e1
            else
                memState[sym] = e1
            end
            return memState
        end


        def scoped(local_env , local_vars, global_env,global_vars)
            local_vars.unshift(sym)
            return exp.scoped(local_env , local_vars, global_env,global_vars)
        end
    end

    class GCCompose < GCStmt  
        attr_reader :stmt1
        attr_reader :stmt2

        def initialize(st1,st2)
            unless st1.is_a?(GCStmt) and st2.is_a?(GCStmt)
                return false
            end
            @stmt1 = st1
            @stmt2 = st2
        end
        
        def eval(memState)

            e1 = stmt1.eval(memState)

            e2 = stmt2.eval(e1)

            return e2
        end
        
        def scoped(local_env , local_vars, global_env,global_vars)
            temp = stmt1.scoped(local_env , local_vars, global_env,global_vars)
            return stmt2.scoped(temp[0] , temp[1], temp[2],temp[3])
        end
    end

    class GCIf  < GCStmt  
        attr_reader :pair_list

        def initialize(lis_check)
            lis_check.each do |elem|
                return false unless elem.length() == 2 and elem[0].is_a?(GCTest) and  elem[1].is_a?(GCStmt)
            end
            @pair_list = lis_check

        end
        
        def eval(memState)
            true_list=[]
            pair_list.each do |elem|
                if elem[0].eval(memState)
                    true_list.push(elem[1])
                end
            end
            selectCom = true_list.sample
            return selectCom.eval(memState)
        end
        def scoped(local_env , local_vars, global_env,global_vars)
            pair_list.each do |elem|
                temp = elem[0].scoped(local_env , local_vars, global_env,global_vars)
                temp = elem[1].scoped(temp[0],temp[1], temp[2], temp[3])
                local_env = temp[0]
                local_vars = temp[1]
                global_env =  temp[2]
                global_vars = temp[3]
            end
            return [local_env , local_vars, global_env,global_vars]
        end
    end
    
    class GCDo  < GCStmt  
        attr_reader :pair_list

        def initialize(lis_check)
            lis_check.each do |elem|
                return false unless elem.length() == 2 and elem[0].is_a?(GCTest) and  elem[1].is_a?(GCStmt)
            end
            @pair_list = lis_check
        end
        def eval(memState)
            take_one = pair_list.sample
            
            while evalHelper(take_one, memState)
                memState = take_one[1].eval(memState)
                take_one =  pair_list.sample
            end
            return memState
        end
        def evalHelper(condition, memState)
            return condition[0].eval(memState)
        end
        def scoped(local_env , local_vars, global_env,global_vars)
            pair_list.each do |elem|
                temp = elem[0].scoped(local_env , local_vars, global_env,global_vars)
                temp = elem[1].scoped(temp[0],temp[1], temp[2], temp[3])
                local_env = temp[0]
                local_vars = temp[1]
                global_env =  temp[2]
                global_vars = temp[3]
            end
            return [local_env , local_vars, global_env,global_vars]
        end
    end
    


    @@local_scoped = false

    class GCProgram

        attr_reader :list_symbol
        attr_reader :stmt
    
        def initialize(list_sym, st)
            unless list_sym.is_a?(Array) and st.is_a?(GCStmt)

                return false
            end
            @list_symbol  = list_sym
            @stmt = st
        end
        def eval(memState)
            return stmt.eval(memState)
        end
        def scoped(local_env , local_vars, global_env,global_vars)
            global_env = list_symbol
            if stmt.is_a?(GCLocal)
                @@local_scoped = true
            end
            return stmt.scoped(local_env , local_vars, global_env,global_vars)
        end
    end

    class GCLocal  < GCStmt
        attr_reader :sym
        attr_reader :stmt

        def initialize(symbol, statement)
            unless symbol.is_a?(Symbol) and statement.is_a?(GCStmt)
                return false
            end
            @sym = symbol
            @stmt = statement
        end

        def eval(memState)
            return stmt.eval(memState)
        end
        def scoped(local_env , local_vars, global_env,global_vars)
            local_env.unshift(sym)

            return stmt.scoped(local_env, local_vars, global_env, global_vars)

        end
    end 
    #! NOTE: Before marking me for failed test cases, please note:
    #!      Docker test failed but test cases passed when outside of docker environment. Please try test cases outside to see the output. They are correct.
    def wellScoped(program) #global_env, stmt)
        unless program.is_a?(GCProgram)
            raise "Input not supported"
        end
        local_check = true
        global_check = true
        if program.is_a?(GCProgram)
            temp = program.scoped([],[],[],[])
            local_env = temp[0]
            local_vars = temp[1]
            global_env = temp[2]
            global_vars = temp[3]

            if not global_env.empty?
                global_check = global_vars.all? {|elem| global_env.include?(elem)}
            end
            if @@local_scoped
                local_check = local_vars.all? {|elem| local_env.include?(elem)}
            end
            return global_check && local_check
        end
        return false
    end

    def eval(stmt)
        if wellScoped(stmt)
            puts "Your variables are not well scoped"  
        end

        # return lambda {|var|..[var]} 
        sigma = clear_local(stmt.eval({}))
        return lambda{|var| sigma[var]}

    end

    def clear_local(sigma)
        sigma.each do |val|
            if val[1].is_a?(Symbol)
                sigma[val[0]] = sigma[val[1]]
                sigma = sigma.reject{|k,v| k == val[1]} 
            end
        end
        return sigma
    end

end

