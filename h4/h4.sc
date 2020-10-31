sealed trait Stream[+A]
case object SNil extends Stream[Nothing]
case class Cons[A](a: A, f: Unit => Stream[A]) extends Stream[A]

// part1
def filter[A](f:(A) => Boolean, in: => Stream[A]): Stream[A] = in match {
    case SNil => SNil
    case Cons(p, s) => f(p) match {
        case true => Cons(p, _ => filter(f, s()))
        case false => filter(f, s())
    }
}

//Part2
def zip[A,B](st1: => Stream[A],st2: => Stream[B]): Stream[(A,B)] =  (st1, st2) match {
    case (_, SNil) => SNil
    case (SNil, _) => SNil
    case (Cons(x, f), Cons(y, g)) => Cons((x, y), _ => zip(f(), g()))
}

def merge[A](st1: => Stream[A],st2: => Stream[A]): Stream[A] =  { 
    mergehelpr(st1, st2)
}
def mergehelpr[A](st1: => Stream[A],st2: => Stream[A]): Stream[A] = st1 match {
    case  SNil => SNil
    case Cons(x, f) => Cons(x, _ => mergehelpr(st2, f() ))
} 

// Part 3
def all[A](f:(A) => Boolean, st: => Stream[A]): Boolean = st match {
    case SNil => SNil
    case Cons(x, g) => f(x) match {
        case true => all(f, g())
        case false => false
    }
}

def exists[A](f:(A) => Boolean, st: => Stream[A]): Boolean = st match {
    case SNil => true
    case Cons(x, g) => f(x) match {
        case true => true 
        case false => exists(f, g())
    }
}

//Part 4 - Bonus 
def zipSafe[A,B](st1: => Stream[A],st2: => Stream[B]): Stream[(A,B)] =  (st1, st2) match {
    case (SNil, SNil) => SNil
    case (Cons(x, f), SNil) =>  Cons((x, _), _ => zipSafe(f(), st2))
    case (SNil,Cons(x, f)) =>  Cons((x, _), _ => zipSafe(st1,f()))
    case (Cons(x, f), Cons(y, g)) => Cons((x, y), _ => zipSafe(f(), g()))
}

def mergeSafe[A,B](st1: => Stream[A],st2: => Stream[B]): Stream[(A,B)] = {
    mergeSafehelpr(st1,st2)
}

def mergeSafehelpr[A](st1: => Stream[A],st2: => Stream[A]): Stream[A] = st1 match {
    case  SNil => SNil
    case Cons(x, f) => Cons(x, _ => mergehelpr(st2, f() ))
} 

// Given 
def take[A](n: Int, s: => Stream[A]): List[A] = s match {
    case SNil => Nil
    case Cons(a, f) => n match {
        case n if n > 0 => a :: take(n-1, f())
        case _ => Nil
    }
}