% get the RGB image of the graph
function graph = getGraphImg(figure)
    reducePadding();
    graph_struct = getframe(figure);
    graph = graph_struct.cdata;
end

