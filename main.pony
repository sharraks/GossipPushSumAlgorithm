use "package:./topology"
use "time"

actor Main
  var _env:Env
  var numNodes: USize = 0
  var topology : String = ""
  var algo : String = ""

  new create(env: Env) =>
    
    _env = env

    try  
      numNodes = _env.args(1)?.usize()?
      topology = _env.args(2)?.lower()
      algo = _env.args(3)?.lower()
      if (numNodes == 0) or (topology == "") or (algo == "") then 
        env.out.print("Illegal input")
        options()
        return
      end
      _env.out.print("Your Inputs => numNodes = "+numNodes.string()+", topology = '"+topology+"', alogrithm = '"+algo+"'")
    else
      options()
      return
    end

    match topology
    
    | "full" => 
    if algo == "gossip" then
       let f = FullGossip(_env, numNodes, "Naruto is the OG Anime!!")
       f.buildTopology()
       f.startProcessing()
      
    else
       let f = FullPushSum(_env, numNodes, (0,1))
       f.buildTopology()
       f.startProcessing()
    end
    
    
    | "3d" => 
    if algo == "gossip" then
       let f = ThreeDGossip(_env, numNodes, "Naruto is the OG Anime!!")
       f.buildTopology()
       f.startProcessing()
    else
       let f = ThreeDPushSum(_env, numNodes, (0,1))
       f.buildTopology()
       f.startProcessing()
    end
  
    | "line" => 
    if algo == "gossip" then
       let f = LineGossip(_env, numNodes, "Naruto is the OG Anime!!")
       f.buildTopology()
       f.startProcessing()
    else
       let f = LinePushSum(_env, numNodes, (0,1))
       f.buildTopology()
       f.startProcessing()
    end
    
    | "imp3d" => 
    if algo == "gossip" then
       let f = Imp3DGossip(_env, numNodes, "Naruto is the OG Anime!!")
       f.buildTopology()
       f.startProcessing()
    else
       let f = Imp3DPushSum(_env, numNodes, (0,1)) 
       f.buildTopology()
       f.startProcessing()
    end
    
    else
    env.out.print("Incorrect Input")
    options()
    end

  fun ref options() =>
    _env.out.print(
        """

        Run the program in shell while passing arguments. Ex: Project2 3(N) Line(T) Gossip(A)

        OPTIONS
          N   Number of nodes/actors (Integer)
          T   Topology of nodes/actors (String) [full, 3D, Line, imp3D]
          A   Algorithm to run with the nodes/actors created (String) [Gossip, push-sum]
        """
        )