function test
% https://stackoverflow.com/questions/34225729/optimising-the-calculation-of-unique-edges-of-a-voronoi-diagram-in-matlab

tic
test1
toc

tic
test2
toc

function test1

% Create dummy data
nstr    = 1000;         % number of particles
x       = rand(nstr,1);   % particle x coordinates
y       = rand(nstr,1);   % particle y coordinates

% Delaunay triangulation
DT      = delaunayTriangulation(x,y);

% Determine node neighbors of the original nodes
nodneigh    = cell(nstr,1);
numtotneigh = 0;                        % initialise total # of neighbors
bla         = DT.vertexAttachments;     % Get the particle/triangle IDs

% BOTTLENECK 1: Find out which particles/triangles are neighbours
for istr = 1:nstr
    nodneigh{istr} = setdiff(unique(DT.ConnectivityList(bla{istr},:)),istr);
    numtotneigh = numtotneigh+length(nodneigh{istr});
end

% Construct Thiessen polygons by Voronoi tessalation
[voro_V,voro_R] = DT.voronoiDiagram;

% Bookkeeping - create an index of edges with associated voronoi regions
cellsz = cellfun(@size,nodneigh,'uni',false);
cellsz = cell2mat(cellsz);
cellsz = cellsz(:,1);
temp = [1:nstr];
idx([cumsum([1 cellsz(cellsz>0)'])]) = 1;

istr    = temp(cumsum(idx(1:find(idx,1,'last')-1)))'; % Region number
neigh   = vertcat(nodneigh{:});                       % Region neighbours 
neigh_m = mod(neigh,nstr);   

% Make sure neighbourship has not already been evaluated
idx             = neigh_m == 0;
neigh_m(idx,:)  = nstr;

neigh    = vertcat(nodneigh{:});  

% BOTTLENECK 2:
% Determine which edges are common to both central and neighbour regions
edge     = cellfun(@intersect,voro_R(istr),voro_R(neigh),...
                'UniformOutput',false);
edge     = cell2mat(edge);


function test2

 % Create dummy data
nstr    = 1000;         % number of particles
x       = rand(nstr,1);   % particle x coordinates
y       = rand(nstr,1);   % particle y coordinates

% Delaunay triangulation
DT      = delaunayTriangulation(x,y);

 % construct Thiessen polygons by Voronoi tessalation
[voro_V,voro_R] = DT.voronoiDiagram;
dt_ed = DT.edges;
istr = dt_ed(dt_ed(:,1)<=nstr,1);
neigh = dt_ed(dt_ed(:,1)<=nstr,2);

% Determine cross-sectional area and Dtrans of all nodes
neigh_m = mod(neigh,nstr);

% if neigh_m == 0, neigh_m = nstr; end
% if the index of the neighboring streamline is smaller than
% that of the current streamline, the relationship has already
% been evaluated
idx             = neigh_m == 0;
neigh_m(idx,:)  = nstr;

temp_is = nan(numel(istr),40);
temp_ne = nan(numel(istr),40);
edge = nan(numel(istr),2);
for index = 1:numel(istr)
   temp_len1     = length(voro_R{istr(index)});
   temp_len2     = length(voro_R{neigh(index)});
   temp_is(index,1:temp_len1) = voro_R{istr(index)};
   temp_ne(index,1:temp_len2) = voro_R{neigh(index)};
   edge(index,:) = temp_is(index,ismember(temp_is(index,:),temp_ne(index,:)));
end


