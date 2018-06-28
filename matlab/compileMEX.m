mex('addSeedToVDBatch.cpp', 'cpp/pushVD.cpp', 'cpp/grabVD.cpp', 'cpp/aux.cpp',...
    'cpp/skizException.cpp', 'cpp/addSeed.cpp', 'cpp/pointInRegion.cpp',...
    'cpp/NSStar.cpp', 'cpp/vd.cpp', 'cpp/getRegion.cpp', '-R2018a',...
    'COMPTIMFLAGS="-O3"');
%return;
mex('removeSeedFromVDBatch.cpp', 'cpp/pushVD.cpp', 'cpp/grabVD.cpp', 'cpp/aux.cpp',...
    'cpp/skizException.cpp', 'cpp/removeSeed.cpp', 'cpp/pointInRegion.cpp',...
    'cpp/NSStar.cpp', 'cpp/vd.cpp', 'cpp/getRegion.cpp', '-R2018a',...
    '-g', 'COMPTIMFLAGS="-O3, -Wall, -fbounds-check, -fcheck-pointer-bounds, -g3"');
%return;
mex('removeSeedFromVD.cpp', 'cpp/pushVD.cpp', 'cpp/grabVD.cpp', 'cpp/aux.cpp',...
    'cpp/skizException.cpp', 'cpp/removeSeed.cpp', 'cpp/pointInRegion.cpp',...
    'cpp/NSStar.cpp', 'cpp/vd.cpp', 'cpp/getRegion.cpp', '-R2018a',...
    '-g', 'COMPTIMFLAGS="-O3, -Wall, -fbounds-check, -fcheck-pointer-bounds, -g3"');

%return;
mex('addSeedToVD.cpp', 'cpp/pushVD.cpp', 'cpp/grabVD.cpp', 'cpp/aux.cpp',...
    'cpp/skizException.cpp', 'cpp/addSeed.cpp', 'cpp/pointInRegion.cpp',...
    'cpp/NSStar.cpp', 'cpp/vd.cpp', 'cpp/getRegion.cpp', '-R2018a',...
    'COMPTIMFLAGS="-O3"');
