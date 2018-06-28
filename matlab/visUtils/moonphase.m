function moonphase(epoch)
% function moonphase(epoch)
% 
% epoch: string in format 'yyyy mm dd HH MM SS'

%
% $Id: moonphase.m,v 1.2 2016/08/02 16:40:30 patrick Exp $
%
% Copyright (c) 2015 Patrick Guio <patrick.guio@gmail.com>
% All Rights Reserved.
%
% This program is free software; you can redistribute it and/or modify it
% under the terms of the GNU General Public License as published by the
% Free Software Foundation; either version 3 of the License, or (at your
% option) any later version.
%
% This program is distributed in the hope that it will be useful, but
% WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General
% Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program. If not, see <http://www.gnu.org/licenses/>.

pc = [0,0];
PIXSIZE = 0.5;

if ~exist('epoch', 'var') || isempty(epoch),
  epoch = datestr(now,'yyyy mm dd HH MM SS');
end

if 0
  [ss,se] = computePlanetAxis('moon',epoch);
  if 0,
    orientat=0;
  else
    orientat=se.psi;
  end
else
  % let Spice compute CML and psi and set orientat=psi
	CML=[]; psi=[]; orientat=[];
end

plotPlanetGrid('moon',[],pc,epoch,CML,psi,orientat,PIXSIZE);
