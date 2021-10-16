push!(LOAD_PATH,"../src/")

using Documenter, MissingsAsFalse

makedocs(
    sitename = "MissingsAsFalse.jl",
    pages = Any[
        "Introduction" => "index.md",
        "API" => "api/api.md"],
    format = Documenter.HTML(
        canonical = "https://pdeffebach.github.io/MissingsAsFalse.jl/stable/"
    ))

deploydocs(
    repo = "github.com/pdeffebach/MissingsAsFalse.jl.git",
    target = "build",
    deps = nothing,
    make = nothing)