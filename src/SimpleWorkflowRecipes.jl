module SimpleWorkflowRecipes

using EasyJobsBase: JobStatus, PENDING, RUNNING, SUCCEEDED, FAILED, getstatus
using Graphs: edges
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
@recipe function f(
    plot::WorkflowPlot;
    edgewidth=1,
    edgestrokecolor=:black,
    nodeshape=:circle,
    nodesize=5,
    root=:left,
)
    if root == :right
        # FIXME
    elseif root == :bottom
        permute --> (:x, :y)
    elseif root == :top
        # FIXME
    elseif root == :left
        # do nothing
    else
        throw(ArgumentError("unknown root `$root`!"))
    end
    workflow = only(plot.args)
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
            arrow --> true
            linewidth --> edgewidth
            linecolor --> edgestrokecolor
            edge_x, edge_y
        end
    end
    for (job, (x, y)) in zip(workflow, zip(nodes_x, nodes_y))
        @series begin
            seriestype --> :scatter
            markershape --> nodeshape
            markersize --> nodesize
            markerstrokewidth --> 0
            seriescolor --> getcolor(getstatus(job))
            series_annotations --> string(only(indexin(job, workflow)))
            Base.vect(x), Base.vect(y)
        end
    end
end

end
