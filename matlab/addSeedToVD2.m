function VD = addSeedToVD(VD, S)
% function VD = addSeedToVD(VD, S)

% Algorithm described in 
% Discrete Voronoi Diagrams and the SKIZ Operator: A Dynamic Algorithm
% R. E. Sequeira and F. J. Preteux
% IEEE Transactions on pattern analysis and machine intelligence
% Vol. 18, No 10, October 1997

%
% $Id: addSeedToVD.m,v 1.4 2012/04/16 16:54:27 patrick Exp $
%
% Copyright (c) 2008-2012 Patrick Guio <patrick.guio@gmail.com>
% All Rights Reserved.
%
% This program is free software; you can redistribute it and/or modify it
% under the terms of the GNU General Public License as published by the
% Free Software Foundation; either version 2.  of the License, or (at your
% option) any later version.
%
% This program is distributed in the hope that it will be useful, but
% WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General
% Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program. If not, see <http://www.gnu.org/licenses/>.

% check whether seed S alread exists
if ~isempty(find(S(1)==VD.Sx & S(2)==VD.Sy))
  sk = find(S(1)==VD.Sx & S(2)==VD.Sy);
  s = sprintf('Error: seed s=(%d,%d) already in S(%d)=(%d,%d)', ...
		S(1),S(2), sk, VD.Sx(sk), VD.Sy(sk));
	if 1
	error(s);
	else
	fprintf(1,'%s\n', s);
  return;
	end
end

% increment time
k = VD.k+1;
% seed's index and coordinates s* = k
VD.Sk = [VD.Sk; k];
VD.Sx = [VD.Sx; S(1)];
VD.Sy = [VD.Sy; S(2)];

if 0
s1 = sprintf('*** Add seed %d (%d,%d) at k=%d ***', k, S, k);
s2 = sprintf('%s', char('*'*ones(length(s1),1)));
fprintf(1,'\n%s\n%s\n%s\n', s2, s1, s2);
end

if 0
    % Update list of neighbours N_k to N_{k+1}
    tic
    VD = updateNeighboursLists(VD, k);
    toc
    %pause
else
    if 0
        tic
    end
    VD = updateNeighboursListsFromVoronoin(VD,'add',k);
    if 0
        toc
    end
    %pause
end

% find out closure of Voronoi Region associated to seed s* = k
[ii, jj, ij] = getVRclosure(VD, k, VD.Nk{k});

if 0
    [vx,vy] = voronoi(VD.Sx(VD.Sk), VD.Sy(VD.Sk));
    subplot(211)
    W = zeros(size(VD.x));
    W(ij) = 1;
    imagesc(W)
    axis xy
    hold on
    for i = VD.Sk(1:end-1)',
      plot(VD.Sx(i), VD.Sy(i), 'xk', 'MarkerSize',5)
        text(VD.Sx(i), VD.Sy(i),num2str(i),'verticalalignment','bottom');
    end
    plot(vx,vy,'-k','LineWidth',1)
    plot(VD.Sx(k), VD.Sy(k), 'ok', 'MarkerSize',5)
    text(VD.Sx(k), VD.Sy(k),num2str(k),'verticalalignment','bottom');
    hold off
end

% Update time
VD.k = k;
%printVD(1, VD);
if exist('VD1'),
    VD1.k = k;
    printVD(1, VD1);
    pause
end


% compute distance function

% \mu = d^2(V_{k+1}[i,j].\lambda, p), p=(j,i) in W
mu  = (VD.x(ij)-VD.Sx(VD.Vk.lambda(ij))).^2+(VD.y(ij)-VD.Sy(VD.Vk.lambda(ij))).^2;
% \mu = d^2(s*, p), p=(j,i) in W
mus = (VD.x(ij)-VD.Sx(k)).^2           +(VD.y(ij)-VD.Sy(k)).^2;

% case mu* > mu in Eq. 3.1
% V_{k+1}[i,j] = V_k[i,j]
Vk = VD.Vk;
% case mu* < mu in Eq. 3.1
% V_{k+1}[i,j] = (s*, 0)
iless = find(mus < mu);
Vk.lambda(ij(iless)) = k;
Vk.v(ij(iless)) = 0;
% case mu* == mu in Eq. 3.1
% V_{k+1}[i,j] = (\lambda, 1)
iequal = find(mus == mu);
Vk.v(ij(iequal)) = 1;

VD.Vk = Vk;

if 0
    checkVD(VD);
end

if 0
    subplot(212)
    K = VD.Vk.v; K(VD.Vk.v==1) = -VD.Vk.lambda(VD.Vk.v==1);
    imagesc(VD.Vk.lambda + K);
    axis xy
    hold on
    for i = VD.Sk(1:end-1)',
      plot(VD.Sx(i), VD.Sy(i), 'xk', 'MarkerSize',5)
        text(VD.Sx(i), VD.Sy(i),num2str(i),'verticalalignment','bottom');
    end
    plot(VD.Sx(k), VD.Sy(k), 'ok', 'MarkerSize',5)
    text(VD.Sx(k), VD.Sy(k),num2str(k),'verticalalignment','bottom');
    [vx,vy]=voronoi(VD.Sx(VD.Sk), VD.Sy(VD.Sk));
    plot(vx,vy,'-k','LineWidth',1)
    hold off
    %pause
end


function VD = updateNeighboursLists(VD, k)

% Initialise indices (i,j)  of s* = S(k)
Sj = VD.Sx(k);
Si = VD.Sy(k);
% lambda closest seed to s* (if v=0) or one of the closest (if v=1)
lambda = VD.Vk.lambda(Si, Sj);
% initialise N'(s*) to V_k(s*).lambda
Np = lambda;
fprintf(1,'N\''(%d) = ',k); printSet(1,Np); fprintf(1,'\n');

unboundedEdges = 0;
closedBoundary = false;
Vertices = zeros(0,2);
while ~closedBoundary,
	newlambda = [];
	l = lambda
  % initialise A to N_k(lambda)
  A = VD.Nk{l};
  fprintf(1,'lambda = %d, A = N(%d) = ', l, l); printSet(1, A); fprintf(1,'\n');
	% X(s*,\lambda,s) where s in A = N_k(\lambda)
	s = A(:);
	rsu = [k*ones(size(s)), l*ones(size(s)), s];
  X = getEquidistantPoint(VD, rsu);
  inCA = isXinC(X, rsu, l, A, VD);
	for i=1:length(s),
	  fprintf(1,'(%10f,%10f) = X(%2d,%2d,%2d) ', X(i,1:2),k,l,A(i));
	  if inCA(i), fprintf(1,' in C(%d, A)\n',l); 
	  else, fprintf(1,'~in C(%d, A)\n',l); end
	end
  iin = find(inCA);
	if length(iin) > 2, fprintf(1,'more than 2 points found.\n'); pause, end
	switch length(iin),
    case 0,  % no X in C(\lambda,N_k(\lambda))
      unboundedEdges = unboundedEdges + 1;
			newlambda = Np(1);
      fprintf(1,'case 0: Unbounded edges: %d\n', unboundedEdges);
			%pause
		case 1,
		  if isempty(find(abs(X(iin,1)-Vertices(:,1))<1e4*eps & ...
			          abs(X(iin,2)-Vertices(:,2))<1e4*eps)), % X ~registered
				Vertices = [[Vertices(:,1); X(iin,1)], [Vertices(:,2); X(iin,2)]];
			  newlambda = s(iin); 
				fprintf(1,'case 1\n');
				Np = [Np(:); s(iin)];
				fprintf(1,'N\''(%d) = ',k); printSet(1,Np); fprintf(1,'\n');
			else, % X registered
			  newlambda = Np(1);
				fprintf(1,'case 2\n');
			end
      unboundedEdges = unboundedEdges + 1;
      fprintf(1,'case 1: Unbounded edges: %d\n', unboundedEdges);
			%pause
    case 2,
			if isempty(find(abs(X(iin(1),1)-Vertices(:,1))<1e4*eps & ...
          abs(X(iin(1),2)-Vertices(:,2))<1e4*eps)), % X not registered vertex
				Vertices = [[Vertices(:,1); X(iin(1),1)], [Vertices(:,2); X(iin(1),2)]];
				newlambda = s(iin(1));
				if s(iin(1))~= Np(1), Np = [Np(:); s(iin(1))]; end
			elseif isempty(find(abs(X(iin(2),1)-Vertices(:,1))<1e4*eps & ...
          abs(X(iin(2),2)-Vertices(:,2))<1e4*eps)), % X not registered vertex
				Vertices = [[Vertices(:,1); X(iin(2),1)], [Vertices(:,2); X(iin(2),2)]];
				newlambda = s(iin(2));
				if s(iin(2))~= Np(1), Np = [Np(:); s(iin(2))]; end
			else, % both X already registered vertices
			  unboundedEdges = unboundedEdges + 1;
				newlambda = Np(1);
			end
			fprintf(1,'N\''(%d) = ',k); printSet(1,Np); fprintf(1,'\n');
	end
	if (Np(1)==newlambda & unboundedEdges==2) | ...
	   (Np(1)==newlambda & unboundedEdges==0), % bounded process finished
				closedBoundary = true;
	end
	lambda = newlambda;
end
VD.Nk{k} = Np(:);
clear Np;
fprintf(1,'%s> N%d(%d) = ',char('-'*ones(1,33)),k,k); 
printSet(1,VD.Nk{k}); 
fprintf(1, ' (#V = %d #UE = %d)', size(Vertices,1), unboundedEdges)
fprintf(1,'\n');


% Update N_{k+1}(s_k) where necessary, 
% i.e. only for s in N_{k+1}(s*)
is = 1;
for s = VD.Nk{k}', % s in N_{k+1}(s*)
  % N'(s) = {s*} U N_k(s)\N_{k+1}(s*)
	%[c,i] = setdiff(VD.Nk{s}, VD.Nk{k}); Np{is} = [k; VD.Nk{s}(sort(i))];
	Np{is} = union(k, setdiff(VD.Nk{s}, VD.Nk{k}));
	fprintf(1,'N\''(%d) = ', s); printSet(1,Np{is}); fprintf(1,'\n');
	for r = intersect(VD.Nk{s}, VD.Nk{k})', % r in N_k(s) and r in N_{k+1}(s*)
	  % B = N_k(s) U {s*} (alt. N_k(r) U {s*})
	  B = union(VD.Nk{r}, k);
		fprintf(1,'B = N(%d) U {%d} = ',s,k); printSet(1,B); fprintf(1,'\n');
		u = setdiff(B, [s r]);
	  rsu = [s*ones(size(u)), r*ones(size(u)), u];
    X = getEquidistantPoint(VD, rsu);
		% X(s,r,u), u in N_k(s) U {s*}, in C(s, N_k(s) U {s*}) 
		% (alt. X(s,r,u), u in N_k(r) U {s*}, in C(r, N_k(s) U {s*}))
    inCB = isXinC(X, rsu, r, B, VD);
	  for i=1:length(u),
	    fprintf(1,'(%10f,%10f) = X(%2d,%2d,%2d) ', X(i,1:2),s,r,u(i));
			if inCB(i), fprintf(1,' in C(%d, B)\n',r); 
			else, fprintf(1,'~in C(%d, B)\n',r); end
		end
		if ~isempty(find(inCB)),
		  % r added to N'(s), s added to N'(r)
		  Np{is} = [Np{is}(:); r];
	    fprintf(1,'N\''(%d) = ',s); printSet(1,Np{is}); fprintf(1,'\n');
		end
	end
	fprintf(1,'%s> N%d(%d) = ', char('-'*ones(1,33)), k, s); 
	printSet(1,Np{is}); fprintf(1,'\n');
  VD.Nk{s} = Np{is}(:);
	is = is+1;
end

is = 1;
for s = VD.Nk{k}',
  VD.Nk{s} = Np{is}(:);
	is = is+1;
end


%pause

function ii = findXinVertices(X, Vertices)

if 0
ii = find(abs(X(1,1)-Vertices(:,1))<eps*abs(X(1,1)) & ...
          abs(X(1,2)-Vertices(:,2))<eps*abs(X(1,2)));
else
ii = find(abs(X(1,1)-Vertices(:,1))<1e4*eps & ...
			    abs(X(2,2)-Vertices(:,2))<1e4*eps);
end
