using SimpleWorkflowRecipes
using Documenter

DocMeta.setdocmeta!(SimpleWorkflowRecipes, :DocTestSetup, :(using SimpleWorkflowRecipes); recursive=true)

makedocs(;
    modules=[SimpleWorkflowRecipes],
    authors="singularitti <singularitti@outlook.com> and contributors",
    repo="https://github.com/MineralsCloud/SimpleWorkflowRecipes.jl/blob/{commit}{path}#{line}",
    sitename="SimpleWorkflowRecipes.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://MineralsCloud.github.io/SimpleWorkflowRecipes.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/MineralsCloud/SimpleWorkflowRecipes.jl",
    devbranch="main",
)
