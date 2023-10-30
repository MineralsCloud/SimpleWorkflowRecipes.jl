module SimpleWorkflowRecipes

using EasyJobsBase: JobStatus, PENDING, RUNNING, SUCCEEDED, FAILED, getstatus
using Graphs: edges
using GraphRecipes: GraphPlot, get_source_destiny_weight, get_adjacency_list
using LayeredLayouts: Zarate, solve_positions
using RecipesBase: @userplot, @recipe, @series
using SimpleWorkflows: Workflow, indexin

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
    root := :bottom
    curves --> false
    nodeshape --> :ellipse
    nodesize --> 0.2
    nodecolor --> map(getcolor ∘ getstatus, eachjob(workflow))
    names --> map(Base.Fix2(findjob, workflow), eachjob(workflow))
    fontsize --> 9
    method --> :spring
    return GraphPlot(get_source_destiny_weight(get_adjacency_list(workflow.graph)))
end

@recipe function f(::Type{<:Workflow}, workflow::Workflow)
    framestyle --> :none
    grid --> false
    legend --> false
    label --> ""
    guide --> ""
    nodes_x, nodes_y, paths = solve_positions(Zarate(), workflow.graph)
    for edge in edges(workflow.graph)
        edge_x, edge_y = paths[edge]
        @series begin
            seriestype --> :path
            linewidth --> 2
            edge_x, edge_y
        end
    end
    for (job, (x, y)) in zip(workflow, zip(nodes_x, nodes_y))
        @series begin
            seriestype --> :scatter
            markershape --> :circle
            markersize --> 10
            color --> getcolor(getstatus(job))
            Base.vect(x), Base.vect(y)
        end
    end
end

end
