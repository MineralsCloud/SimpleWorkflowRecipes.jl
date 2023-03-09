module SimpleWorkflowRecipes

using GraphRecipes: GraphPlot, get_source_destiny_weight, get_adjacency_list
using RecipesBase: @userplot, @recipe

@userplot WorkflowPlot
@recipe function f(plot::WorkflowPlot)
    workflow = plot.args[end]
    return GraphPlot(get_source_destiny_weight(get_adjacency_list(workflow.graph)))
end

end
