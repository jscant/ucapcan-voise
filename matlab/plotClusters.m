function params = plotClusters(CVD, params)
    figure;
    load(strcat(params.oDir, "/clusters.txt"))
    axis equal;
    pbaspect([1 1 1]);
    activeX = CVD.Sx(CVD.Sk);
    activeY = CVD.Sy(CVD.Sk);
    xlim([0, CVD.nc])
    ylim([0, CVD.nr])
    Wop = (sopToWop(CVD, clusters));
    [WLS, SLS] = getVDOp(CVD, params.W, 4);

    cluster_count = max(clusters(:)) + 1;
    colormap(spring(cluster_count));

    x = params.x;
    y = params.y;
    imagesc(x, y, Wop);
    hold on
    W = CVD.W;
    n = W.xM - W.xm;
    m = W.yM - W.ym;
    sx = (max(params.x) - min(params.x)) / (n);
    sy = (max(params.y) - min(params.y)) / (m);
    Sy = CVD.Sy(CVD.Sk);

    set(gca, 'YDir', 'normal')
    [vx, vy] = voronoi(CVD.Sx(CVD.Sk), Sy);
    plot((vx - W.xm)*sx+min(params.x), (vy - W.ym)*sy+min(params.y), ...
        '-k', 'LineWidth', 0.5)
    hold off
    axis square;
    %    c = colorbar;
    %    c.Ticks = [];
    %    c.TickLabels = c.Ticks;
    %title("Clustering: " + "$\bar{s}($" + num2str(cluster_count) +...
    %    "$) = 0.52$", 'Interpreter' ,'latex');
    title("Clustering:" +"$k = $" +num2str(cluster_count), ...
        'Interpreter', 'latex');
    xlabel(sprintf('x [%s]', params.pixelUnit{1}))
    ylabel(sprintf('y [%s]', params.pixelUnit{2}))
    dpi = strcat('-r', num2str(params.dpi));
    print([params.oDir, 'clusters'], '-depsc', dpi);
end