import scala.collection.mutable.LinkedHashMap
import scala.math.pow
import scala.math.abs
sealed trait VarExpr
case class Abs(x: VarExpr) extends VarExpr
case class Plus(leftVal: VarExpr, rightVal: VarExpr) extends VarExpr
case class Minus(leftVal: VarExpr, rightVal: VarExpr) extends VarExpr
case class Const(v: Int) extends VarExpr
case class Exp(v: VarExpr, p: VarExpr) extends VarExpr
case class Neg(x: VarExpr) extends VarExpr
case class Times(leftVal: VarExpr, rightVal: VarExpr) extends VarExpr
case class Subst(v: VarExpr, s: Symbol, e: VarExpr) extends VarExpr
case class Var(s: Symbol) extends VarExpr

def interpretVarExpr(e: VarExpr): Int = {
    var lh = new LinkedHashMap[Int, VarExpr]()
    def linkedHm(e: VarExpr) : Int = {
        e match {
            case Subst(v, s, e) => {
                lh+=(s.hashCode -> e)
                linkedHm(v)
            }
            case Abs(x) => linkedHm(x)
            case Plus(l, r) => {
                linkedHm(l)
                linkedHm(r)
            }
            case Minus(l, r) => {
                linkedHm(l)
                linkedHm(r)
            }
            case Exp(l, r) => {
                linkedHm(l)
                linkedHm(r)
            }
            case Times(l, r) => {
                linkedHm(l)
                linkedHm(r)
            }
            case Neg(v) => {
                linkedHm(v)
            }
            case _ => 0
        }
    }
    linkedHm(e)
    def helper(e: VarExpr) : Int = {
        e match { 
            case Const(x) => x
            case Var(v) => {
                val index = lh(v.hashCode)
                helper(index)

            }
            case Subst(val1, sym, val2) => {
                helper(val1)

            }
            case Plus(l, r) => {
                (l, r) match { 
                    case (Const(val1), Const(val2) ) => val1 + val2
                    case (val1, val2) => (helper(val1) ,helper(val2)) match {
                        case (valT1, valT2) => valT1 + valT2
                    }
                }
            }
            case Minus(l, r) => {
                (l, r) match { 
                    case (Const(val1), Const(val2) ) => val1 - val2
                    case (val1, val2) => (helper(val1) ,helper(val2)) match {
                        case (valT1, valT2) => valT1 - valT2
                    }
                }
            }
            case Exp(l, r) => {
                (l, r) match { 
                    case (Const(val1), Const(val2) ) => pow(val1 , val2).intValue
                    case (val1, val2) => (helper(val1) ,helper(val2)) match {
                        case (valT1, valT2) => pow(valT1 , valT2).intValue
                    }
                }
            }
            case Abs(x) => {
                x match {
                    case Const(val1) => val1.abs
                    case val1 => helper(val1) match {
                        case val2 => val2.abs
                    }
                }
            }
            case Times(l, r) => {
                (l, r) match { 
                    case (Const(val1), Const(val2) ) => val1 * val2
                    case (val1, val2) => (helper(val1) ,helper(val2)) match {
                        case (valT1, valT2) => valT1 * valT2
                    }
                }
            }
            case Neg(x) => {
                x match {
                    case Const(val1) => -1 * val1
                    case val1 => helper(val1) match {
                        case val2 => -1 * val2
                    }
                }
            }

            case _ => 0
        }
    }
    helper(e)
}
