import scala.math.pow
import scala.math.abs
sealed trait MixedExpr
case class Abs(x: MixedExpr) extends MixedExpr
case class Minus(leftVal: MixedExpr, rightVal: MixedExpr) extends MixedExpr
case class Neg(x: MixedExpr) extends MixedExpr
case class Times(leftVal: MixedExpr, rightVal: MixedExpr) extends MixedExpr
case class Plus(leftVal: MixedExpr, rightVal: MixedExpr) extends MixedExpr
case class Exp(v: MixedExpr, p: MixedExpr) extends MixedExpr

case class Band(leftVal: MixedExpr, rightVal: MixedExpr) extends MixedExpr
case class Bnot(v: MixedExpr) extends MixedExpr
case class Bor(leftVal: MixedExpr, rightVal: MixedExpr) extends MixedExpr

case class Const(v: Int) extends MixedExpr
case object TT extends MixedExpr
case object FF extends MixedExpr


def interpretMixedExpr(e: MixedExpr): Option[Either[Int, Boolean]] = e match {
    case Plus(l,r) => {
        (l, r) match {
            case (Const(x),Const(y)) => Some(Left(x + y))
            case (x, y) => (interpretMixedExpr(x) , interpretMixedExpr(y)) match {
                case (Some(val1), Some(val2)) => (val1, val2) match {
                    case (Left(int1), Left(int2)) => Some(Left(int1 + int2))
                    case (_, _) => None
                }
            }
        }
    }
    case Times(l,r) => {
        (l, r) match {
            case (Const(x),Const(y)) => Some(Left(x * y))
            case (x, y) => (interpretMixedExpr(x) , interpretMixedExpr(y)) match {
                case (Some(val1), Some(val2)) => (val1, val2) match {
                    case (Left(int1), Left(int2)) => Some(Left(int1 * int2))
                    case (_, _) => None
                }
            }
        }
    }

    case Minus(l,r) => {
                (l, r) match {
            case (Const(x),Const(y)) => Some(Left(x - y))
            case (x, y) => (interpretMixedExpr(x) , interpretMixedExpr(y)) match {
                case (Some(val1), Some(val2)) => (val1, val2) match {
                    case (Left(int1), Left(int2)) => Some(Left(int1 - int2))
                    case (_, _) => None
                }
            }
        }
    }

    case Exp(v, p) => {
        (v, p) match {
            case (Const(x),Const(y)) => Some(Left(pow(x, y).intValue))
            case (x, y) => (interpretMixedExpr(x) , interpretMixedExpr(y)) match {
                case (Some(val1), Some(val2)) => (val1, val2) match {
                    case (Left(int1), Left(int2)) => Some(Left(pow(int1, int2).intValue))
                    case (_, _) => None
                }
            }
        }
    }

    case Abs(x) => {
        (x) match {
            case Const(x) => Some(Left(x.abs))
            case (x) => interpretMixedExpr(x) match {
                case (Some(val1)) => val1 match {
                    case Left(int1) => Some(Left(int1.abs))
                    case _ => None
                }
            }
        }
    }    
    case Neg(x) => {
        (x) match {
            case Const(x) => Some(Left(-1 * x))
            case (x) => interpretMixedExpr(x) match {
                case (Some(val1)) => val1 match {
                    case Left(int1) => Some(Left(-1 * int1))
                    case _ => None
                }
            }
        }
    }

    case Band(l, r) => {
        (l, r) match {
            case (FF,_) => Some(Right(false))
            case (_,FF) => Some(Right(false))
            case (TT,TT) => Some(Right(true))
            case (val1,val2) => (interpretMixedExpr(val1), interpretMixedExpr(val2)) match {
                case (Some(val1),Some(val2)) => (val1, val2) match {
                    case (Right(bool1),Right(bool2)) => Some(Right(bool1 && bool2))
                    case (_, _) => None
                }
            }
        } 
    }

    case Bor(l, r) => {
        (l, r) match {
            case (TT,_) => Some(Right(true))
            case (_,TT) => Some(Right(true))
            case (FF,FF) => Some(Right(false))
            case (val1,val2) => (interpretMixedExpr(val1), interpretMixedExpr(val2)) match {
                case (Some(val1),Some(val2)) => (val1, val2) match {
                    case (Right(bool1),Right(bool2)) => Some(Right(bool1 || bool2))
                    case (_, _) => None
                }
            }
        } 
    }

    case Bnot(v) => {
        (v) match {
            case (TT) => Some(Right(false))
            case (FF) => Some(Right(true))
            case (val1) => (interpretMixedExpr(val1)) match {
                case (Some(val1)) => (val1) match {
                    case (Right(bool1)) => Some(Right(!bool1))
                    case _ => None
                }
            }
        } 
    }

    case TT => Some(Right(true))
    case FF => Some(Right(false))
    case Const(x) => Some(Left(x))
    case _ => None
}