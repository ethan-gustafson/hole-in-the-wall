def states
    filepath    = File.join(".", "app", "assets", "files", "states.txt")
    read_file   = File.read(filepath)
    array       = read_file.split("\n")

    states = {}

    array.each do |state|
        key           = state.slice(0, state.index("-") - 1)
        value         = state.slice((state.length - 2), state.length)
        states[key] = value
    end
    states
end

states