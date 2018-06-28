function VD = removeSeedFromVD(VD, sk)
% function VD = removeSeedFromVD(VD, sk)

% Algorithm described in 
% Discrete Voronoi Diagrams and the SKIZ Operator: A Dynamic Algorithm
% R. E. Sequeira and F. J. Preteux
% IEEE Transactions on pattern analysis and machine intelligence
% Vol. 18, No 10, October 1997

%
% $Id: removeSeedFromVD.m,v 1.5 2012/04/16 16:54:28 patrick Exp $
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

% check whether seed sk is in the list of seeds
if isempty(find(VD.Sk==sk)),
  s = sprintf('Error: cannot remove seed %d\n', sk);
	s = [s sprintf('not in the list of seeds Sk = ')];
	s = [s sprintf('%d ', VD.Sk)];
	error(s);
end

% increment time
k = VD.k+1;

if 0
s1 = sprintf('*** Remove seed %d (%d,%d) at k=%d ***', ...
	sk, VD.Sx(sk), VD.Sy(sk), k);
s2 = sprintf('%s', char('*'*ones(length(s1),1)));
fprintf(1,'\n%s\n%s\n%s\n', s2, s1, s2);
end


if 0
% find out which point in W are in C(s*, N_k(s*) = R(s*) U \partial R(s*)
tic
inC = isXinC([VD.x(:), VD.y(:)], [], sk, VD.Nk{sk}, VD);
iin = find(inC);
toc
fprintf('length(W) = %d length(C(%d,N(%d)) = %d\n', ...
	length(inC), sk, sk, length(iin))
end

% find out closure of Voronoi Region associated to seed s* = k
if 0
tic
end
[ii, jj, ij] = getVRclosure(VD, sk, VD.Nk{sk});
if 0
toc
end
if 0
fprintf('length(W) = %d length(C(%d,N(%d)) = %d\n', ...
	length(VD.Vk.lambda), sk, sk, length(ij))
end

if 0 & ~isempty(find(sort(iin) ~= sort(ij)))
  find(sort(iin) ~= sort(ij))
	pause
else
  iin = ij;
end

if 0
subplot(211)
W =zeros(size(VD.x));
W(iin) = 1;
imagesc(W),
axis xy
hold on
for i = VD.Sk',
  if i ~= sk,
  plot(VD.Sx(i), VD.Sy(i), 'xk', 'MarkerSize',5)
  text(VD.Sx(i), VD.Sy(i),num2str(i),'verticalalignment','bottom');
	end
end
plot(VD.Sx(sk), VD.Sy(sk), 'ok', 'MarkerSize',5)
text(VD.Sx(sk), VD.Sy(sk),num2str(sk),'verticalalignment','bottom');
hold off

subplot(212)
W =zeros(size(VD.x));
W(ij) = 1;
imagesc(W),
axis xy
hold on
for i = VD.Sk',
  if i ~= sk,
  plot(VD.Sx(i), VD.Sy(i), 'xk', 'MarkerSize',5)
  text(VD.Sx(i), VD.Sy(i),num2str(i),'verticalalignment','bottom');
	end
end
plot(VD.Sx(sk), VD.Sy(sk), 'ok', 'MarkerSize',5)
text(VD.Sx(sk), VD.Sy(sk),num2str(sk),'verticalalignment','bottom');
hold off

%pause
end

% V_k[i,j].\lambda = s*
i1 = find(VD.Vk.lambda(iin) == sk & VD.Vk.v(iin) == 0);

% V_k[i,j].v = 1 ((i,j) in K_{k})
i2 = find(VD.Vk.v(iin) == 1);

if 0
fprintf(1,'length(i1) = %d, length(i2) = %d, length(i1^i2) = %d\n', ...
	length(i1), length(i2), length(intersect(i1,i2)));
end

% mu = min( d^2(p, s), s in N_k(s*), p in C(s*, N_k(s*)
mu = Inf*ones(size(iin));
for s = VD.Nk{sk}', % s in N_k(s*)
  mu  = min(mu, (VD.x(iin)-VD.Sx(s)).^2+(VD.y(iin)-VD.Sy(s)).^2);
end

if 0
subplot(212)
W =zeros(size(VD.x));
W(iin) = mu;
imagesc(W),
axis xy
hold on
for i = VD.Sk',
  if i ~= sk,
    plot(VD.Sx(i), VD.Sy(i), 'xk', 'MarkerSize',5)
	  text(VD.Sx(i), VD.Sy(i),num2str(i),'verticalalignment','bottom');
	end
end
plot(VD.Sx(sk), VD.Sy(sk), 'ok', 'MarkerSize',5)
text(VD.Sx(sk), VD.Sy(sk),num2str(sk),'verticalalignment','bottom');
hold off
%pause
end

cardA = zeros(size(iin));
for s = VD.Nk{sk}', % s in N_k(s*)

  A = ((VD.x(iin)-VD.Sx(s)).^2+(VD.y(iin)-VD.Sy(s)).^2 == mu);
	cardA = cardA + (A==1);

  if 0
	W =zeros(size(VD.x));
	W(iin) = A;
	imagesc(W)
	axis xy
	drawnow
	end

  % for p ~in C(s*, N_k(s*) 
  % V_{k+1}[i,j] = V_k[i,j] 
	% nothing to be done

  % case 1 in Eq. 3.3
  % V_{k+1}[i,j] = (s, 0), if A = {s}
	VD.Vk.lambda(iin(A==1 & cardA==1)) = s;
	VD.Vk.v(iin(A==1 & cardA==1)) = 0;

  % case 2 in Eq. 3.3
  % V_{k+1}[i,j] = (s, 1), exists s in A, otherwise
	VD.Vk.lambda(iin(A==1 & cardA>1)) = s;
	VD.Vk.v(iin(A==1 & cardA>1)) = 1;
end


if 0
% Update list of neighbours N_k to N_{k+1}
tic
VD = updateNeighboursLists(VD, sk);
toc
% Update seed list
VD.Sk(find(VD.Sk == sk)) = [];
% Update time
VD.k = k;
else
% Update seed list
%VD.Sk(find(VD.Sk == sk)) = [];
% Update time
VD.k = k;

if 0, tic, end
VD = updateNeighboursListsFromVoronoin(VD,'remove',sk);
if 0, toc, end
end

%printVD(1, VD);
%checkVD(VD);
if exist('VD1');
  printVD(1, VD1);
  checkVD(VD1);
  %pause
end

function VD = updateNeighboursLists(VD, k)

% Update N_{k+1}(s_k) where necessary, 
% i.e. only for s in N_{k+1}(s*)
is = 1;
for s = VD.Nk{k}', % s in N_k(s*)
  % N'(s) = N_k(s)\{s*}
	Np{is} = setdiff(VD.Nk{s}, k);
	fprintf(1,'N\''(%d) = ', s); printSet(1,Np{is}); fprintf(1,'\n');
  for r = setdiff(VD.Nk{k}, [VD.Nk{s}; s])', % r in N_k(s*)\{N_k(s),s}
	  % A = (N_k(s) U N_k(s*))\{s,s*}
	  A = setdiff(union(VD.Nk{s}, VD.Nk{k}), [s k]);
		fprintf(1,'A = (N(%d) U N(%d)) \\ {%d,%d} = ',s,k,s,k);
		printSet(1, A); fprintf(1,'\n');
		% u in A\{r}
		u = setdiff(A, [r s]);
		% should be X(s, r, u) in C(s, A) 
		% but X(r, s, u) in C(s, A) is equivalent
		rsu = [r*ones(size(u)), s*ones(size(u)), u];
		X = getEquidistantPoint(VD, rsu);
		inCA = isXinC(X, rsu, s, A, VD);
		for i=1:length(u),
		  fprintf(1,'(%10f,%10f) = X(%2d,%2d,%2d) ', X(i,1:2),s,r,u(i));
			if inCA(i), fprintf(1,' in C(%d, A)\n',s);
			else, fprintf(1,'~in C(%d, A)\n',s); end
		end
		if ~isempty(find(inCA)),
		  Np{is} = [Np{is}(:); r];
			fprintf(1,'N\''(%d) = ',s); printSet(1,Np{is}); fprintf(1,'\n');
		end
  end
	fprintf(1,'%s> N%d(%d) = ', char('-'*ones(1,33)), k, s);
	printSet(1,Np{is}); fprintf(1,'\n');
	VD.Nk{s} = Np{is}(:);
	is = is+1;
end

% Update results
is = 1;
for s = VD.Nk{k}',
	VD.Nk{s} = Np{is}(:);
	is = is+1;
end

