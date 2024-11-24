use "collections"
use "package:../RandomNumberGenerator"


actor GWorker
    var neighbors: Array[GWorker] = []
    let threshold: USize = 10 //arbitrary value, change as per need
    var counter: USize = 0
    let env: Env
    let id: USize
    var msg: String = ""
    var availability: Bool = true
    var nextAvailable: Bool = false

    new create(env': Env, id': USize) =>
        env = env'
        id = id'

    be getAvailability(caller: GWorker) =>
       if availability == true then
            caller.hasNeighbor(true)
       else
            caller.hasNeighbor(false)
       end

    be hasNeighbor(check: Bool) =>
       nextAvailable = check


    be send() =>
        let size: I64 = neighbors.size().i64()
        let rand: USize = Randomize.randn(size)
        try 
            neighbors(rand)?.getAvailability(this)
            if (nextAvailable == true) and (counter < threshold) then
                try
                    neighbors(rand)?.receive(msg)                        
                end        
            else
                send()
            end
        end

    be receive(msg': String) =>

        if counter < threshold then    
            counter = counter + 1
            msg = msg'
            send()

        else
            availability = false
        end


    be addNeighbor(neighbor: GWorker) =>
        neighbors.push(neighbor)
        

actor PSWorker
    var neighbors: Array[PSWorker] = []
    let threshold: USize = 3 //arbitrary value, change as per need
    var counter: USize = 0
    let env: Env
    let id: USize
    var s: F64 
    var w: F64 = 1
    var ratio: F64  = -1
    var availability: Bool = true
    var nextAvailable: Bool = false

    new create(env': Env, id': USize) =>
        env = env'
        id = id'
        s = id'.f64()

    be getAvailability(caller: PSWorker) =>
       if availability == true then
            caller.hasNeighbor(true,id)
       else
            caller.hasNeighbor(false,id)
       end

    be hasNeighbor(check: Bool, id': USize) =>
       if id'!= id then 
            nextAvailable = check 
       else
            nextAvailable = false
       end


    be send() =>
       if counter <= threshold then
            let size: I64 = neighbors.size().i64()
            let rand: USize = Randomize.randn(size)
            let msg: (F64, F64) = (s/2,w/2)

            try 
                neighbors(rand)?.getAvailability(this)
                if nextAvailable == true then
                    try
                        neighbors(rand)?.receive(msg)
                        s = s/2
                        w = w/2                        
                    end        
                else
                    send()
                end
            end
       end

    be receive(msg': (F64, F64)) =>
  
           let s': F64 = msg'._1
           let w': F64 = msg'._2

           if ((s/w) - ratio) < 0.0000000001 then
                if counter == threshold then
                    availability = false
                else
                ratio = s/w
                s = s + s'
                w = w + w'
                counter = counter + 1
                end
           end

           send()

    be addNeighbor(neighbor: PSWorker) =>
        neighbors.push(neighbor)


