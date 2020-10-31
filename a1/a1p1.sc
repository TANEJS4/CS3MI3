import scala.math.pow
import scala.math.abs

sealed trait Expr
case class Abs(x: Expr) extends Expr
case class Plus(leftVal: Expr, rightVal: Expr) extends Expr
case class Exp(v: Expr, p: Expr) extends Expr
case class Minus(leftVal: Expr, rightVal: Expr) extends Expr
case class Times(leftVal: Expr, rightVal: Expr) extends Expr
case class Neg(v: Expr) extends Expr
case class Const(v: Int) extends Expr


def interpretExpr(e: Expr):Int = e match {
    case Plus(l,r) =>  interpretExpr(l) + interpretExpr(r)
    case Exp(v,p) =>  pow(interpretExpr(v) , interpretExpr(p)).intValue
    case Minus(l,r) =>  interpretExpr(l) - interpretExpr(r)
    case Abs(x) => interpretExpr(x).abs 
    case Times(x, y) => interpretExpr(x) * interpretExpr(y)
    case Neg(x) => - interpretExpr(x) 
    case Const(x) => x 
}