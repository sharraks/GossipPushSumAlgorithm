use "random"
use "time"
use "collections"
use "package:./RandomNumberGenerator"
use "package:./Workers"


actor FullGossip
    let env: Env
    let msg: String //rumour
    let numNodes: USize
    let workers: Array[GWorker] = []
    

    new create(env': Env, numNodes': USize, msg': String) =>
        env = env'
        msg = msg'
        numNodes = numNodes'

    be buildTopology() =>
        if numNodes <=2 then
            return
        end
       
       for i in Range(0, numNodes) do
            workers.push(GWorker(env,i))
       end

       env.out.print("Created Stack")

        for i in Range(0,numNodes) do
            for j in Range(0, numNodes) do
                if j!=i then
                    try 
                        workers(i)?.addNeighbor(workers(j)?)
                    end
                end
            end
        end

        env.out.print("Created Topology")

    be startProcessing() =>
        if numNodes <=2 then
            return
        end

        env.out.print("Starting communication")
        try
            workers(0)?.receive(msg)
        end

actor LineGossip
    let env: Env
    let msg: String //rumour
    let numNodes: USize
    let workers: Array[GWorker] = []
    

    new create(env': Env, numNodes': USize, msg': String) =>
        env = env'
        msg = msg'
        numNodes = numNodes'


    be buildTopology() =>
        if numNodes <=2 then
            return
        end
       
        for i in Range(0, numNodes) do
             workers.push(GWorker(env,i))
        end

        env.out.print("Created Stack")
        
        try
            workers(0)?.addNeighbor(workers(1)?)
            workers(numNodes-1)?.addNeighbor(workers(numNodes-2)?)
        end

        for i in Range(1,numNodes) do
            for j in Range(i-1,i+2) do
                if j!=i then
                    try 
                        workers(i)?.addNeighbor(workers(j)?)
                    end
                end
            end
        end

        env.out.print("Created Topology")

    be startProcessing() =>
        if numNodes <=2 then
            return
        end

        env.out.print("Starting communication")
        try
            workers(0)?.receive(msg)
        end


actor ThreeDGossip
    let env: Env
    let msg: String //rumour
    let numNodes: USize
    let workers: Array[Array[Array[GWorker]]] = []
    

    new create(env': Env, numNodes': USize, msg': String) =>
        env = env'
        msg = msg'
        numNodes = numNodes'

    fun ref checkCubeRootInteger(num: USize) : USize=>
        var left: USize = 0
        var right: USize = num

        while left <= right do

            var mid: USize = (left + right) / 2
            let result = mid * mid * mid

            if  result <= num then 
                left = mid + 1
            
            else
                right = mid - 1
            end
        end

        if (right * right * right) < num then
           right = right + 1
        end

        right

    be buildTopology() =>
        
       let nearestCubeRoot:USize = checkCubeRootInteger(numNodes)
       let requiredNodes: USize = nearestCubeRoot * nearestCubeRoot * nearestCubeRoot
       var id: USize = 0
       env.out.print("Adjusting the number of nodes according to topology, required nodes: "+requiredNodes.string())

       for i in Range(0,nearestCubeRoot) do
            let tempFrame: Array[Array[GWorker]] = [] 
            for j in Range(0, nearestCubeRoot) do
                let tempInsideFrame:Array[GWorker] = []
                for k in Range(0, nearestCubeRoot) do
                    tempInsideFrame.push(GWorker(env,id))
                    id = id + 1
                end
                tempFrame.push(tempInsideFrame)
            end
            workers.push(tempFrame)
        end
            

       env.out.print("Created Stack")

       for i in Range(0,nearestCubeRoot) do
            for j in Range(0, nearestCubeRoot) do
                for k in Range(0, nearestCubeRoot) do
                        try 
                            if (k+1) < nearestCubeRoot then
                                workers(i)?(j)?(k)?.addNeighbor(workers(i)?(j)?(k+1)?)
                            end
                            if (k-1) >= 0 then
                                workers(i)?(j)?(k)?.addNeighbor(workers(i)?(j)?(k-1)?)
                            end
                            if (j+1) < nearestCubeRoot then
                                workers(i)?(j)?(k)?.addNeighbor(workers(i)?(j+1)?(k)?)
                            end
                            if (j-1) >= 0 then
                                workers(i)?(j)?(k)?.addNeighbor(workers(i)?(j-1)?(k+1)?)
                            end
                            if (i+1) < nearestCubeRoot then
                                workers(i)?(j)?(k)?.addNeighbor(workers(i+1)?(j)?(k)?)
                            end
                            if (i-1) >= 0 then
                                workers(i)?(j)?(k)?.addNeighbor(workers(i-1)?(j)?(k)?)
                            end

                        end
                end
            end
       end

       env.out.print("Created Topology")

    be startProcessing() =>

        env.out.print("Starting communication")
        try
            workers(0)?(0)?(0)?.receive(msg)
        end


actor Imp3DGossip
    let env: Env
    let msg: String //rumour
    let numNodes: USize
    let workers: Array[Array[Array[GWorker]]] = []
    

    new create(env': Env, numNodes': USize, msg': String) =>
        env = env'
        msg = msg'
        numNodes = numNodes'

    fun ref checkCubeRootInteger(num: USize) : USize=>
        var left: USize = 0
        var right: USize = num

        while left <= right do

            var mid: USize = (left + right) / 2
            let result = mid * mid * mid

            if  result <= num then 
                left = mid + 1
            
            else
                right = mid - 1
            end
        end

        if (right * right * right) < num then
           right = right + 1
        end

        right

    be buildTopology() =>
        
       let nearestCubeRoot:USize = checkCubeRootInteger(numNodes)
       let requiredNodes: USize = nearestCubeRoot * nearestCubeRoot * nearestCubeRoot
       var id: USize = 0
       env.out.print("Adjusting the number of nodes according to topology, required nodes: "+requiredNodes.string())

       for i in Range(0,nearestCubeRoot) do
            let tempFrame: Array[Array[GWorker]] = [] 
            for j in Range(0, nearestCubeRoot) do
                let tempInsideFrame:Array[GWorker] = []
                for k in Range(0, nearestCubeRoot) do
                    tempInsideFrame.push(GWorker(env,id))
                    id = id + 1
                end
                tempFrame.push(tempInsideFrame)
            end
            workers.push(tempFrame)
        end
            

       env.out.print("Created Stack")

       for i in Range(0,nearestCubeRoot) do
            for j in Range(0, nearestCubeRoot) do
                for k in Range(0, nearestCubeRoot) do
                        try 
                            if (k+1) < nearestCubeRoot then
                                workers(i)?(j)?(k)?.addNeighbor(workers(i)?(j)?(k+1)?)
                            end
                            if (k-1) >= 0 then
                                workers(i)?(j)?(k)?.addNeighbor(workers(i)?(j)?(k-1)?)
                            end
                            if (j+1) < nearestCubeRoot then
                                workers(i)?(j)?(k)?.addNeighbor(workers(i)?(j+1)?(k)?)
                            end
                            if (j-1) >= 0 then
                                workers(i)?(j)?(k)?.addNeighbor(workers(i)?(j-1)?(k+1)?)
                            end
                            if (i+1) < nearestCubeRoot then
                                workers(i)?(j)?(k)?.addNeighbor(workers(i+1)?(j)?(k)?)
                            end
                            if (i-1) >= 0 then
                                workers(i)?(j)?(k)?.addNeighbor(workers(i-1)?(j)?(k)?)
                            end

                        end
                end
            end
       end

       for i in Range(0,nearestCubeRoot) do
            for j in Range(0, nearestCubeRoot) do
                for k in Range(0, nearestCubeRoot) do
                    let r: USize = Randomize.randn(nearestCubeRoot.i64())
                    let c: USize = Randomize.randn(nearestCubeRoot.i64())
                    let z: USize = Randomize.randn(nearestCubeRoot.i64())
                    try
                        workers(i)?(j)?(k)?.addNeighbor(workers(r)?(c)?(z)?)
                    end     
                end
            end
        end

       env.out.print("Created Topology")

    be startProcessing() =>

        env.out.print("Starting communication")
        try
            workers(0)?(0)?(0)?.receive(msg)
        end

actor FullPushSum
    let env: Env
    let msg: (F64, F64) //rumour
    let numNodes: USize
    let workers: Array[PSWorker] = []
    

    new create(env': Env, numNodes': USize, msg': (F64, F64)) =>
        env = env'
        msg = msg'
        numNodes = numNodes'

    be buildTopology() =>
        if numNodes <=2 then
            return
        end
       
       for i in Range(0, numNodes) do
            workers.push(PSWorker(env,i))
       end

       env.out.print("Created Stack")

        for i in Range(0,numNodes) do
            for j in Range(0, numNodes) do
                if j!=i then
                    try 
                        workers(i)?.addNeighbor(workers(j)?)
                    end
                end
            end
        end

        env.out.print("Created Topology")

    be startProcessing() =>
        if numNodes <=2 then
            return
        end

        env.out.print("Starting communication")
        try
            workers(0)?.receive(msg)
        end


actor LinePushSum
    let env: Env
    let msg: (F64, F64) //rumour
    let numNodes: USize
    let workers: Array[PSWorker] = []
    

    new create(env': Env, numNodes': USize, msg': (F64, F64)) =>
        env = env'
        msg = msg'
        numNodes = numNodes'


    be buildTopology() =>
        if numNodes <=2 then
            return
        end
       
        for i in Range(0, numNodes) do
             workers.push(PSWorker(env,i))
        end

        env.out.print("Created Stack")
        
        try
            workers(0)?.addNeighbor(workers(1)?)
            workers(numNodes-1)?.addNeighbor(workers(numNodes-2)?)
        end

        for i in Range(1,numNodes) do
            for j in Range(i-1,i+2) do
                if j!=i then
                    try 
                        workers(i)?.addNeighbor(workers(j)?)
                    end
                end
            end
        end

        env.out.print("Created Topology")

    be startProcessing() =>
        if numNodes <=2 then
            return
        end

        env.out.print("Starting communication")
        try
            workers(0)?.receive(msg)
        end


actor ThreeDPushSum
    let env: Env
    let msg: (F64, F64) //rumour
    let numNodes: USize
    let workers: Array[Array[Array[PSWorker]]] = []
    

    new create(env': Env, numNodes': USize, msg': (F64, F64)) =>
        env = env'
        msg = msg'
        numNodes = numNodes'

    fun ref checkCubeRootInteger(num: USize) : USize=>
        var left: USize = 0
        var right: USize = num

        while left <= right do

            var mid: USize = (left + right) / 2
            let result = mid * mid * mid

            if  result <= num then 
                left = mid + 1
            
            else
                right = mid - 1
            end
        end

        if (right * right * right) < num then
           right = right + 1
        end

        right

    be buildTopology() =>
        
       let nearestCubeRoot:USize = checkCubeRootInteger(numNodes)
       let requiredNodes: USize = nearestCubeRoot * nearestCubeRoot * nearestCubeRoot
       var id: USize = 0
       env.out.print("Adjusting the number of nodes according to topology, required nodes: "+requiredNodes.string())

       for i in Range(0,nearestCubeRoot) do
            let tempFrame: Array[Array[PSWorker]] = [] 
            for j in Range(0, nearestCubeRoot) do
                let tempInsideFrame:Array[PSWorker] = []
                for k in Range(0, nearestCubeRoot) do
                    tempInsideFrame.push(PSWorker(env,id))
                    id = id + 1
                end
                tempFrame.push(tempInsideFrame)
            end
            workers.push(tempFrame)
        end
            

       env.out.print("Created Stack")

       for i in Range(0,nearestCubeRoot) do
            for j in Range(0, nearestCubeRoot) do
                for k in Range(0, nearestCubeRoot) do
                        try 
                            if (k+1) < nearestCubeRoot then
                                workers(i)?(j)?(k)?.addNeighbor(workers(i)?(j)?(k+1)?)
                            end
                            if (k-1) >= 0 then
                                workers(i)?(j)?(k)?.addNeighbor(workers(i)?(j)?(k-1)?)
                            end
                            if (j+1) < nearestCubeRoot then
                                workers(i)?(j)?(k)?.addNeighbor(workers(i)?(j+1)?(k)?)
                            end
                            if (j-1) >= 0 then
                                workers(i)?(j)?(k)?.addNeighbor(workers(i)?(j-1)?(k+1)?)
                            end
                            if (i+1) < nearestCubeRoot then
                                workers(i)?(j)?(k)?.addNeighbor(workers(i+1)?(j)?(k)?)
                            end
                            if (i-1) >= 0 then
                                workers(i)?(j)?(k)?.addNeighbor(workers(i-1)?(j)?(k)?)
                            end

                        end
                end
            end
       end

       env.out.print("Created Topology")

    be startProcessing() =>

        env.out.print("Starting communication")
        try
            workers(0)?(0)?(0)?.receive(msg)
        end


actor Imp3DPushSum
    let env: Env
    let msg: (F64, F64) //rumour
    let numNodes: USize
    let workers: Array[Array[Array[PSWorker]]] = []
    

    new create(env': Env, numNodes': USize, msg': (F64, F64)) =>
        env = env'
        msg = msg'
        numNodes = numNodes'

    fun ref checkCubeRootInteger(num: USize) : USize=>
        var left: USize = 0
        var right: USize = num

        while left <= right do

            var mid: USize = (left + right) / 2
            let result = mid * mid * mid

            if  result <= num then 
                left = mid + 1
            
            else
                right = mid - 1
            end
        end

        if (right * right * right) < num then
           right = right + 1
        end

        right

    be buildTopology() =>
        
       let nearestCubeRoot:USize = checkCubeRootInteger(numNodes)
       let requiredNodes: USize = nearestCubeRoot * nearestCubeRoot * nearestCubeRoot
       var id: USize = 0
       env.out.print("Adjusting the number of nodes according to topology, required nodes: "+requiredNodes.string())

       for i in Range(0,nearestCubeRoot) do
            let tempFrame: Array[Array[PSWorker]] = [] 
            for j in Range(0, nearestCubeRoot) do
                let tempInsideFrame:Array[PSWorker] = []
                for k in Range(0, nearestCubeRoot) do
                    tempInsideFrame.push(PSWorker(env,id))
                    id = id + 1
                end
                tempFrame.push(tempInsideFrame)
            end
            workers.push(tempFrame)
        end
            

       env.out.print("Created Stack")

       for i in Range(0,nearestCubeRoot) do
            for j in Range(0, nearestCubeRoot) do
                for k in Range(0, nearestCubeRoot) do
                        try 
                            if (k+1) < nearestCubeRoot then
                                workers(i)?(j)?(k)?.addNeighbor(workers(i)?(j)?(k+1)?)
                            end
                            if (k-1) >= 0 then
                                workers(i)?(j)?(k)?.addNeighbor(workers(i)?(j)?(k-1)?)
                            end
                            if (j+1) < nearestCubeRoot then
                                workers(i)?(j)?(k)?.addNeighbor(workers(i)?(j+1)?(k)?)
                            end
                            if (j-1) >= 0 then
                                workers(i)?(j)?(k)?.addNeighbor(workers(i)?(j-1)?(k+1)?)
                            end
                            if (i+1) < nearestCubeRoot then
                                workers(i)?(j)?(k)?.addNeighbor(workers(i+1)?(j)?(k)?)
                            end
                            if (i-1) >= 0 then
                                workers(i)?(j)?(k)?.addNeighbor(workers(i-1)?(j)?(k)?)
                            end

                        end
                end
            end
       end

       for i in Range(0,nearestCubeRoot) do
            for j in Range(0, nearestCubeRoot) do
                for k in Range(0, nearestCubeRoot) do
                    let r: USize = Randomize.randn(nearestCubeRoot.i64())
                    let c: USize = Randomize.randn(nearestCubeRoot.i64())
                    let z: USize = Randomize.randn(nearestCubeRoot.i64())
                    try
                        workers(i)?(j)?(k)?.addNeighbor(workers(r)?(c)?(z)?)
                    end     
                end
            end
        end

       env.out.print("Created Topology")

    be startProcessing() =>

        env.out.print("Starting communication")
        try
            workers(0)?(0)?(0)?.receive(msg)
        end



        

