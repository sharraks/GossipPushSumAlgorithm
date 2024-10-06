use "package:./topology"

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
    | "full" => env.out.print("first")
    | "3d" => env.out.print("Second")
    | "line" => env.out.print("third")
    | "imp3d" => env.out.print("fourth")
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