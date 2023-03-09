module SimpleWorkflowRecipes

using EasyJobsBase:
    JobStatus, PENDING, RUNNING, SUCCEEDED, FAILED, INTERRUPTED, TIMED_OUT, getstatus
using GraphRecipes: GraphPlot, get_source_destiny_weight, get_adjacency_list
using RecipesBase: @userplot, @recipe

function getcolor(status::JobStatus)
    if status == PENDING
        :deepskyblue
    elseif status == RUNNING
        :gold
    elseif status == SUCCEEDED
        :chartreuse3
    elseif status == FAILED
        :red3
    elseif status == INTERRUPTED
        :hotpink
    elseif status == TIMED_OUT
        :chocolate
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
    nodecolor --> map(getcolor ∘ getstatus, workflow.jobs)
    names --> map(job -> getfield(job, :name), workflow.jobs)
    fontsize --> 9
    method --> :spring
    return GraphPlot(get_source_destiny_weight(get_adjacency_list(workflow.graph)))
end

end
