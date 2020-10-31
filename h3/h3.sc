/* 
    Author: Shivam Taneja
    File: h3.sc
    Dated: 01.October.2020
*/
def isPrime(num: Int): Boolean = {
    def helper(curr: Int, modN: Int): Boolean = {
        if (curr == 2) true
        else if (modN <= 1) false
        else if (modN == 2) true
        else if (curr % modN == 0) false
        else (helper(curr, modN - 1))
    }
    helper(num, num - 1)
}

def isPalindrome[A](l: List[A]): Boolean = {
    l match {
        case Nil => true
        case List(x) => true
        case l => (l.head == l.last && isPalindrome(l.tail.init))
    }
}

def digitList(num: Int): List[Int] = {
    def helper(num: Int): List[Int] = {
        val curr = num / 10
        val modN = num % 10
        
        if (curr == 0) List(modN)
        else List(modN) ::: helper(curr)

    }
    helper(num)
}

def primePalindrome(num: Int): Boolean = {
    isPrime(num) && isPalindrome(digitList(num))
}