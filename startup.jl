atreplinit() do repl
    try
        @eval using Revise
        @async Revise.wait_steal_repl_backend()
    catch
    end

    function workspace()
        atexit() do
            run(`$(Base.julia_cmd())`)
        end
        exit()
    end
end
