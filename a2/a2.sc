// Importing required packages
import $file.a2_ulterm, a2_ulterm._
import scala.collection.mutable.ListBuffer

//Given custom type
sealed trait STType
case object STNat extends STType {
    override def toString() = "nat"
}
case object STBool extends STType {
    override def toString() = "bool"
}
// Functions have a domain type and a codomain type.
case class STFun(dom: STType, codom: STType) extends STType {
    override def toString() = "(" + dom.toString + ") -> (" + codom.toString + ")"
}

// Part 1
sealed trait STTerm
case class STVar(index: Int) extends STTerm
case class STApp(t1: STTerm , t2: STTerm) extends STTerm
case class STAbs(ty: STType, t: STTerm) extends STTerm
case class STSuc(t: STTerm) extends STTerm 
case object STTrue extends STTerm
case object STFalse extends STTerm
case object STZero extends STTerm
case class STIsZero(t: STTerm) extends STTerm 
case class STTest(b: STTerm, t1: STTerm, t2: STTerm) extends STTerm 

// Part 2
def typecheck(exp: STTerm): Boolean =  {

    var env =  new ListBuffer[STType]()
    def typeOf(exp: STTerm,  envList: ListBuffer[STType] ) : Option[STType] = exp match {

        case STVar(i) => envList.lift(i)
        case STZero => Some(STNat)
        case STTrue => Some(STBool)
        case STFalse => Some(STBool)
        case STIsZero(t) => t match {
            case t => typeOf(t, envList) match {
                case Some(STNat) => Some(STBool)
                case _ => None
            }
        }
        case STSuc(t) => if (typeOf(t,envList ) == Some(STNat)) Some(STNat) else None
        
        case STTest(b, t1, t2) => {
            var exp1 = typeOf(t1, envList)
            var exp2 = typeOf(t2, envList)
            if (typeOf(b, envList) == Some(STBool)){
                if (exp1 == exp2 && b == STTrue) {
                    Some(STBool)
                } else if (exp1 != exp2 && b == STFalse) {
                    Some(STBool)
                } else {
                    None
                }
            } else {
                None
            }
        }
        case STAbs(t, exp) => {
            t +=: envList   
            val value = typeOf(exp, envList)
            value match {
                    case Some(codom) => Some(STFun(t, codom))
                    case _ => None
                }
        }
        case STApp(t1, t2) => {
            val val_A = typeOf(t2, envList) 
            val val_B = typeOf(t1, envList) 

            (val_A, val_B) match {
                case (Some(a), Some(STFun(b, c))) => if (a != b) return None
                
            }
            val_B match {
                case  Some(STFun(dom, codom) )=> Some(codom) 
                case _ => None
            }
        }
        case _ => None
    }
    if (None == typeOf(exp, env)) return false else return true 
}

// Part 3
def eraseTypes(exp: STTerm):  ULTerm = exp match {

    case STVar(i) => ULVar(i)
    case STFalse =>  ULAbs(ULAbs(ULVar(0)))
    case STTrue =>  ULAbs(ULAbs(ULVar(1)))
    case STZero => ULAbs(ULAbs(ULVar(0)))
    case STAbs(t, exp) => ULAbs(eraseTypes(exp))
    case STApp(t1, t2) =>  {
        val  exp1 = eraseTypes(t1)
        val  exp2 = eraseTypes(t2)
        ULApp(exp1, exp2)
    }
    case STSuc(t) =>  {
        val term = eraseTypes(t)
        ULApp( ULAbs(ULAbs(ULAbs( ULApp( ULVar(1),ULApp( ULApp(ULVar(2),ULVar(1)),ULVar(0)))))),term)
    }
    case STIsZero(exp) => exp match {
        case STZero => ULAbs(ULAbs(ULVar(1)))
        case _ => ULAbs(ULAbs(ULVar(0)))
    }
    case STTest(b, exp1, exp2) => {
        var bool = eraseTypes(b)
        var val_A =  eraseTypes(exp1)
        var val_B =  eraseTypes(exp2)  
        ULApp(ULApp(ULApp(ULAbs(ULAbs(ULAbs(ULApp(ULApp(ULVar(2), ULVar(1)), ULVar(0))))), bool), val_B), val_B)
    }
    case _ => throw new RuntimeException("Invalid expression")

}
