use "random"
use "time"

class Randomize
    
    var randomFactor : I64 = 1
    
    fun ref randn(numNodes: I64) : USize =>

        let a = Time.now()
        let b = Time.now()

        var c: I64 = ((b._2 - a._2) * (Rand.next().i64())) * randomFactor

        c = c % numNodes

        c.usize()
