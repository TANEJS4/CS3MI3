/* 
    Author: Shivam Taneja
    File: h1.sc
    Dated: 18.September.2020
*/

// ! Part 1 

trait LeafTree[A]
case class Leaf[A](x: A) extends LeafTree[A]
case class Branch[A](l: LeafTree[A], r: LeafTree[A] ) extends LeafTree[A]

sealed trait BinTree[A]
case class Empty[A]() extends BinTree[A]
case class Node[A]( value: A,left: BinTree[A], right: BinTree[A]) extends BinTree[A]


// ! Part 2
def flatten[A](t: BinTree[A]) : List[A] = t match {
    case Node(value,left, right ) => flatten(left) ::: List(value) ::: flatten(right)
    case Empty() => List()
}

def flatten[A](t: LeafTree[A]) : List[A] = t match {
    case Branch(xs, ys) => flatten(xs) ::: flatten(ys)
    case Leaf(x) => List(x)
}

// ! Part 3 -  Elements of a Tree[Int] in order
def sorted(l: List[Int]) : List[Int] = { 
    if (l.size < 2){
        l
    }
    else {
        val mid = l(l.size /2)
        sorted(l.filter(mid > _))++(l.filter(mid == _)) ++ sorted(l.filter(mid < _))
    }
}

def orderedElem(tree: LeafTree[Int]) : List[Int] = {
    val x = flatten(tree)
    sorted(x)
}
def orderedElem(tree: BinTree[Int]) : List[Int] = {
    val x = flatten(tree)
    sorted(x)
}

// ! Part 4 - Trees which describe structure


trait StructTree[+A, B]
case class StructLeaf[A, B]( value: B) extends StructTree[A, B]
case class StructNode[+A, B]( value: A, left: StructTree[A, B], right: StructTree[A, B]) extends StructTree[A, B]



// ! Part 5 - flatten (BONUS)
def flatten[A, B](t: StructTree[A, B]) : List[Any]= t match {
    case StructNode(value, left, right) =>  flatten(left) ::: List(value) ::: flatten(right)
    case StructLeaf(x) =>  List(x) 
}

