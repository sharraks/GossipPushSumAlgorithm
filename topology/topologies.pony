actor Full
    let env: Env

    new create(env': Env) =>
        env = env'

    be test() =>
        env.out.print("Executed!!")