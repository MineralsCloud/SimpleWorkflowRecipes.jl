module SimpleWorkflowRecipes

using EasyJobsBase: JobStatus, PENDING, RUNNING, SUCCEEDED, FAILED, getstatus
using GraphRecipes: GraphPlot, get_source_destiny_weight, get_adjacency_list
using RecipesBase: @userplot, @recipe
using SimpleWorkflows: eachjob

function getcolor(status::JobStatus)
    if status == PENDING
        :deepskyblue
    elseif status == RUNNING
        :gold
    elseif status == SUCCEEDED
        :chartreuse3
    elseif status == FAILED
        :red3
    else
        throw(ArgumentError("unknown job status `$status`!"))
    end
end

@userplot WorkflowPlot
@recipe function f(plot::WorkflowPlot)
    workflow = plot.args[end]
    curvature_scalar --> 0.01
    root := :bottom
    nodeshape --> :ellipse
    nodesize --> 0.2
    nodecolor --> map(getcolor ∘ getstatus, eachjob(workflow))
    names --> map(job -> getfield(job, :name), eachjob(workflow))
    fontsize --> 9
    method --> :spring
    return GraphPlot(get_source_destiny_weight(get_adjacency_list(workflow.graph)))
end

end
