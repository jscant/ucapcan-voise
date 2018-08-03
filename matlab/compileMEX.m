mex('../cpp/src/mex/sopToWop.cpp',...
    '../cpp/src/mex/grabVD.cpp', ...
    '../cpp/src/vd.cpp', '../cpp/src/getRegion.cpp', '-R2018a', ...
    'COMPTIMFLAGS="-O3"');
return
mex('../cpp/src/mex/addSeedToVDBatch.cpp', '../cpp/src/aux-functions/proposition2.cpp',...
    '../cpp/src/mex/pushVD.cpp', '../cpp/src/mex/grabVD.cpp', ...
    '../cpp/src/skizException.cpp', '../cpp/src/addSeed.cpp', ...
    '../cpp/src/pointInRegion.cpp', '../cpp/src/NSStar.cpp', ...
    '../cpp/src/vd.cpp', '../cpp/src/getRegion.cpp', '-R2018a', ...
    'COMPTIMFLAGS="-O3"');
%return;
mex('../cpp/src/mex/getCentroidSeedBatch.cpp',...
    '../cpp/src/mex/grabVD.cpp', ...
    '../cpp/src/vd.cpp', '../cpp/src/getRegion.cpp', ...
    '../cpp/src/mex/grabW.cpp', '../cpp/src/getCentroid.cpp',...
    '-R2018a', 'COMPTIMFLAGS="-O3"');
%return;
mex('../cpp/src/mex/getVDOp.cpp',...
    '../cpp/src/mex/pushVD.cpp', '../cpp/src/mex/grabVD.cpp', ...
    '../cpp/src/skizException.cpp',...
    '../cpp/src/vd.cpp', '../cpp/src/getRegion.cpp', ...
    '../cpp/src/mex/grabW.cpp', '../cpp/src/aux-functions/metrics.cpp', ...
    '../cpp/src/getOp.cpp',...
    '-R2018a', 'COMPTIMFLAGS="-O3"', 'CXXFLAGS="\$CXXFLAGS -fopenmp"',...
    'LDFLAGS="\$LDFLAGS -fopenmp"');
%return;
mex('../cpp/src/mex/removeSeedFromVDBatch.cpp',...
    '../cpp/src/mex/pushVD.cpp', '../cpp/src/mex/grabVD.cpp', ...
    '../cpp/src/skizException.cpp', '../cpp/src/removeSeed.cpp', ...
    '../cpp/src/pointInRegion.cpp',...
    '../cpp/src/vd.cpp', '../cpp/src/getRegion.cpp', '-R2018a', ...
    'COMPTIMFLAGS="-O3"');
return;
mex('../cpp/src/mex/addSeedToVD.cpp', '../cpp/src/aux-functions/proposition2.cpp',...
    '../cpp/src/mex/pushVD.cpp', '../cpp/src/mex/grabVD.cpp', ...
    '../cpp/src/skizException.cpp', '../cpp/src/addSeed.cpp', ...
    '../cpp/src/pointInRegion.cpp', '../cpp/src/NSStar.cpp', ...
    '../cpp/src/vd.cpp', '../cpp/src/getRegion.cpp', '-R2018a', ...
    'COMPTIMFLAGS="-O3"');
%return;
mex('../cpp/src/mex/removeSeedFromVD.cpp',...
    '../cpp/src/mex/pushVD.cpp', '../cpp/src/mex/grabVD.cpp', ...
    '../cpp/src/skizException.cpp', '../cpp/src/removeSeed.cpp', ...
    '../cpp/src/pointInRegion.cpp',...
    '../cpp/src/vd.cpp', '../cpp/src/getRegion.cpp', '-R2018a', ...
    'COMPTIMFLAGS="-O3"');