module SimpleWorkflowRecipes

using GraphRecipes: GraphPlot, get_source_destiny_weight, get_adjacency_list
using RecipesBase: @userplot, @recipe

@userplot WorkflowPlot
@recipe function f(plot::WorkflowPlot)
    workflow = plot.args[end]
    curvature_scalar --> 0.01
    root := :bottom
    nodeshape --> :ellipse
    nodesize --> 0.2
    names --> map(job -> getfield(job, :name), workflow.jobs)
    fontsize --> 9
    method --> :spring
    return GraphPlot(get_source_destiny_weight(get_adjacency_list(workflow.graph)))
end

end
