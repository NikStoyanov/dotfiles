atreplinit() do repl
    try
        @eval using Revise
        @async Revise.wait_steal_repl_backend()
    catch
    end

    try
        @eval using OhMyREPL
        @eval enable_autocomplete_brackets(false)
    catch e
        @warn "error while importing OhMyREPL" e
    end

    function workspace()
        atexit() do
            run(`$(Base.julia_cmd())`)
        end
        exit()
    end
end
