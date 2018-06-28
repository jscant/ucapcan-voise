clc; clear all; format compact;

new = load('vd_new.mat')
old = load('vd_old.mat')

oldlam = old.VD.Vk.lambda;
newlam = new.VD.Vk.lambda;

diff = oldlam - newlam;
size(find(diff ~= 0))

return;
% new = load('NewArr.mat')
% old = load('OldArr.mat')
% 
% for i=1:39
%     oldlam = old.old_arr(i).Vk.lambda;
%     newlam = new.new_arr(i).Vk.lambda;
%     diff = oldlam - newlam;
%     if ~isempty(find(diff ~= 0))
%         disp("===============");
%         i
%         size(find(diff~=0))
%     end
% end
% disp("Done")
% for i = 1:39
%     oldlam = old.new_arr.VDa.Vk.lambda;
%     newlam = new.VDa.Vk.lambda;
%     difflam = oldlam - newlam;
%     nnz(find(difflam ~= 0))
% end



if 0
    load VDa
    load VDa_new

    lamold = VDa.Vk.lam;
    lamnew = VDa_new.Vk.lam;
    diff = lamold-lamnew;


    mex('addSeedToVD.cpp', '-R2018a');
end

if 0
    nr = 50; nc = 50;
    vd.Vk.v = zeros(nr, nc);
    vd.Vk.lambda = zeros(nr, nc);
    vd.Nk = {[3 2]; [3 1]; [2 1]};
    vd.nc = nc;
    vd.nr = nr;
    vd.k = 3;
    x = [1:nc];
    y = [1:nr];
    vd.Sx = [24 12 1];
    vd.Sy = [9 32 31];
    vd.Sk = [1 2 3];
    [vd.x, vd.y] = meshgrid(x, y);

    xm = 0; xM = nc; ym = 0; yM = nr;
    W.xm = xm; W.xM = xM; W.ym = ym; W.yM = yM;
    vd.W = W;
    S.xm = xm; S.xM = xM; S.ym = ym; S.yM = yM;
    vd.S = S;
end

load("vd_arr_new");
load("vd_arr_old");
for i=50:50
    oldlam = vd_arr_old{i, 1}.Vk.lambda;
    newlam = vd_arr_new{i, 1}.Vk.lambda;
    difflam = oldlam - newlam;
    k = vd_arr_old{i, 1}.k
    nnz(find(difflam ~= 0))
end
return;
res = -ones(256, 3);
for i=1:256
    res(i, 1) = i-1;
    stop = 0;
    for j=1:256
        if oldlam(i, j) == 17 && ~stop
            res(i, 2) = j;
            stop = 1;
        elseif oldlam(i, j) ~= 17 && stop
            res(i, 3) = j;
            break;
        end
    end
end

for i = 1:256
    for j = 1:256
        if difflam(i, j) ~= 0
            disp('lambda: ==================')
            disp(i)
            disp(j)
            disp(vd_arr_old{7, 1}.Vk.lambda(i, j))
            disp(vd_arr_new{7, 1}.Vk.lambda(i, j))
        end
    end
end














return;
vd12_old = load("vd12_old.mat");
vd12_new = load("vd12_new.mat");






return;
difflam = vd12_old.VD.Vk.lambda - vd12_new.VD.Vk.lambda;
diffv = vd12_old.VD.Vk.v - vd12_new.VD.Vk.v;
for i = 1:256
    for j = 1:256
        if difflam(i, j) ~= 0
            disp('lambda: ==================')
            disp(i)
            disp(j)
            disp(vd12_old.VD.Vk.lambda(i, j))
            disp(vd12_new.VD.Vk.lambda(i, j))
        end
        if diffv(i, j) ~= 0
            disp('v: ==================')
            disp(i)
            disp(j)
            disp(vd12_old.VD.Vk.v(i, j))
            disp(vd12_new.VD.Vk.v(i, j))
        end
    end
end
return
    A = [38 10];
for i = 1:10000 
    A = randi([1, nc], 1, 2);
    VD = addSeedToVD(VD, A);

    VD
end