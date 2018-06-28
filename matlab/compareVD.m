function diff_vd = compareVD(vd1, vd2, allowlamdiff)

    diff_vd.same = 1;

    % Comparing Nk
    diff_vd.Nk = {};
    [n, ~] = size(vd1.Nk);
    if size(vd1.Nk) ~= size(vd2.Nk)
        disp("Nk are different sizes!\n");
        diff_vd.same = 0;
    else
        for i=1:n
            [vd1len, ~] = size(vd1.Nk{i, 1});
            [vd2len, ~] = size(vd2.Nk{i, 1});
            if(vd1len ~= vd2len)
                fprintf("Nk(%i): Different size\n", i);
                diff_vd.same = 0;
                continue
            end
            diffNk = sort(vd1.Nk{i, 1}) - sort(vd2.Nk{i, 1});
            if ~isempty(find(diffNk ~= 0))
                fprintf("Nk(%i): Discrepancy in values\n", i);
                diff_vd.same = 0;
            end
            diff_vd.Nk{i, 1} = max(abs(diffNk));
        end
    end
    
    % Comparing k
    diff_vd.k = abs(vd1.k - vd2.k);
    if diff_vd.k ~= 0
        fprintf("Discrepency in k: vd1 is %i, vd2 is %i\n", vd1.k, vd2.k);
        diff_vd.same = 0;
    end
    
    % Comparing Sk
    [vd1len, ~] = size(vd1.Sk);
    [vd2len, ~] = size(vd2.Sk);
    if vd1len ~= vd2len
        fprintf("vd1.Sk different size to vd2.Sk: %i and %i\n", vd1len, vd2len);
        diff_vd.same = 0;
    else
        diffSk = abs(vd1.Sk - vd2.Sk);
        diff_vd.Sk = diffSk;
        if max(diffSk(:)) ~= 0
            fprintf("Discrepency in Sk values\n");
            diff_vd.same = 0;
        end
    end
    
    % Comparing lambda
    vd1lam = vd1.Vk.lambda;
    vd2lam = vd2.Vk.lambda;
    lamdiff = abs(vd1lam - vd2lam);
    diff_vd.Vk.lam = lamdiff;
    [m, n] = size(lamdiff);
    printed = 0;
    if max(lamdiff(:)) ~= 0
        for i=1:m
            for j=1:n
                if lamdiff(i, j) ~= 0
                    vd1l = vd1.Vk.lambda(i, j);
                    vd2l = vd2.Vk.lambda(i, j);
                    vd1dist = (vd1.Sx(vd1l) - j)^2 + (vd1.Sy(vd1l) - i)^2;
                    vd2dist = (vd2.Sx(vd2l) - j)^2 + (vd2.Sy(vd2l) - i)^2;
                    if vd1dist ~= vd2dist
                        fprintf("vd1 dist: %i, vd2 dist: %i\n", vd1dist, vd2dist);
                    end
                    if ~allowlamdiff || vd1dist ~= vd2dist
                        if ~printed
                            fprintf("Discrepency in lambda values:\n");
                            printed = 1;
                        end
                        fprintf("%i, %i. vd1.v: %i, vd2.v: %i\n", i, j,...
                                vd1.Vk.v(i, j), vd1.Vk.v(i, j))
                        diff_vd.same = 0;
                    end
                end
                
            end
        end
    end
    
    % Comparing v
    vd1v = vd1.Vk.v;
    vd2v = vd2.Vk.v;
    vdiff = abs(vd1v - vd2v);
    diff_vd.Vk.v = vdiff;
    [m, n] = size(vdiff);
    if max(vdiff(:)) ~= 0
        fprintf("-------------------\nDiscrepency in v values:\n");
        diff_vd.same = 0;
        for i=1:m
            for j=1:n
                if vdiff(i, j) ~= 0
                    fprintf("%i, %i\n", i, j)
                    diff_vd.same = 0;
                end
            end
        end
    end
    
    % Comparing divSHC
    if (isfield(vd1, 'divSHC') && ~isfield(vd2, 'divSHC')) || ...
            (isfield(vd2, 'divSHC') && ~isfield(vd1, 'divSHC'))
        fprintf("Discrepency in existence of divSHC fields\n")
    elseif isfield(vd1, 'divSHC') && isfield(vd2, 'divSHC')    
        diff_vd.divSHC = {};
        [~, n] = size(vd1.divSHC);
        if size(vd1.divSHC) ~= size(vd2.divSHC)
            disp("divSHC are different sizes!\n");
            diff_vd.same = 0;
        else
            for i=1:n
                [vd1len, ~] = size(vd1.divSHC{1, i});
                [vd2len, ~] = size(vd2.divSHC{1, i});
                if(vd1len ~= vd2len)
                    fprintf("divSHC(%i): Different size\n", i);
                    diff_vd.same = 0;
                    continue
                end
                diffSHC = vd1.divSHC{1, i} - vd2.divSHC{1, i};
                if ~isempty(find(diffSHC ~= 0))
                    fprintf("divSHC(%i): Discrepancy in values\n", i);
                    diff_vd.same = 0;
                end
                diff_vd.divSHC{1, i} = max(abs(diffNk));
            end
        end
    end
    
    % Comparing divHCThreshold
    if (isfield(vd1, 'divHCThreshold') && ~isfield(vd2, 'divHCThreshold')) || ...
            (isfield(vd2, 'divHCThreshold') && ~isfield(vd1, 'divHCThreshold'))
        fprintf("Discrepency in existence of divHCThreshold fields\n")
        diff_vd.same = 0;
    elseif isfield(vd1, 'divHCThreshold') && isfield(vd2, 'divHCThreshold')
        [vd1len, ~] = size(vd1.divHCThreshold);
        [vd2len, ~] = size(vd2.divHCThreshold);
        if vd1len ~= vd2len
            fprintf("vd1.divHCThreshold different size to vd2.divHCThreshold: %i and %i\n", vd1len, vd2len);
            diff_vd.same = 0;
        else
            diffdivHCThreshold = abs(vd1.divHCThreshold - vd2.divHCThreshold);
            diff_vd.divHCThreshold = diffdivHCThreshold;
            if max(diffdivHCThreshold(:)) ~= 0
                fprintf("Discrepency in divHCThreshold values\n");
                diff_vd.same = 0;
            end
        end
    end
        
    % Comparing Smu
    if (isfield(vd1, 'Smu') && ~isfield(vd2, 'Smu')) || ...
            (isfield(vd2, 'Smu') && ~isfield(vd1, 'Smu'))
        fprintf("Discrepency in existence of Smu fields\n")
        diff_vd.same = 0;
    elseif isfield(vd1, 'Smu') && isfield(vd2, 'Smu')
        [vd1len, ~] = size(vd1.Smu);
        [vd2len, ~] = size(vd2.Smu);
        if vd1len ~= vd2len
            fprintf("vd1.Smu different size to vd2.Smu: %i and %i\n", vd1len, vd2len);
            diff_vd.same = 0;
        else
            Smu = abs(vd1.Smu - vd2.Smu);
            diff_vd.Smu = Smu;
            if max(Smu(:)) ~= 0
                fprintf("Discrepency in Smu values\n");
                diff_vd.same = 0;
            end
        end
    end
    
    % Comparing Ssdmu
    if (isfield(vd1, 'Ssdmu') && ~isfield(vd2, 'Ssdmu')) || ...
            (isfield(vd2, 'Ssdmu') && ~isfield(vd1, 'Ssdmu'))
        fprintf("Discrepency in existence of Ssdmu fields\n")
        diff_vd.same = 0;
    elseif isfield(vd1, 'Ssdmu') && isfield(vd2, 'Ssdmu')
        [vd1len, ~] = size(vd1.Ssdmu);
        [vd2len, ~] = size(vd2.Ssdmu);
        if vd1len ~= vd2len
            fprintf("vd1.Ssdmu different size to vd2.Ssdmu: %i and %i\n", vd1len, vd2len);
            diff_vd.same = 0;
        else
            Ssdmu = abs(vd1.Ssdmu - vd2.Ssdmu);
            diff_vd.Smu = Ssdmu;
            if max(Ssdmu(:)) ~= 0
                fprintf("Discrepency in Ssdmu values\n");
                diff_vd.same = 0;
            end
        end
    end
    
end
