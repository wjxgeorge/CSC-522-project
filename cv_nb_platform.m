%Program for CSC522 course project: Precipitation prediction of
%Northwestern United States
%run after day_data_preprocessing
%10-fold cross validation model selection 
feature_matrix = correlation_matrix;
edges = [0, 0.1, 2.5, 10, 25, 50, 100, 400];
%mod_sel_dis_data = discretize(mod_sel_data, edges);

tloss = zeros(length(lon), length(lat));
[~, ~, d, ~] = size(feature_matrix);
[lo, la, dat] = size(mod_sel_data);

%mypool = parpool(4);
paroptions = statset('UseParallel',true);
%nbt = templateNaiveBayes('DistributionNames', 'mvmn');

%train_data = [];
%for i=1:dats
%    tp = mod_sel_data(:, :, i);
%    train_data = [train_data, tp(~no_detect)];
%end
%train_data = train_data';

parfor m=1:lo
    for n=1:la
        if (~no_detect(m, n))
            %prepare training data (including cv data)
            cur_cost_matrix = cost_matrix;
            
            train_labels = reshape(mod_sel_labels(m, n, :), [length(mod_sel_labels), 1]);
            
            lb = [sum(train_labels==1), sum(train_labels==2), sum(train_labels==3), sum(train_labels==4), sum(train_labels==5)];
            
            for i=0:(length(lb)-1)
                tar = length(lb)-i;
                if (lb(tar)==0)
                    cur_cost_matrix(tar, :) = [];
                    cur_cost_matrix(:, tar) = [];
                end
            end
            train_data = [];
            for j=1:(d-1)
                cm = feature_matrix(m, n, j, 2);
                cn = feature_matrix(m, n, j, 3);
                train_data = [train_data; mod_sel_data(cm, cn, :)];
            end
            
            train_data = reshape(train_data, [(d-1), length(mod_sel_data)]);
            %tmp = train_data;
            %train_data = [mean(train_data, 1); max(train_data, [], 1); min(train_data, [], 1); std(train_data, 0, 1)];
            train_data = train_data';
            
            %nbmd = fitcecoc(train_data, train_labels, 'Learners', nbt,'Options', paroptions, 'Coding', 'ordinal', 'CrossVal', 'on', 'KFold', 5);
            nbmd = fitcnb(train_data, train_labels, 'DistributionNames', 'mvmn','Cost', cur_cost_matrix, 'CrossVal', 'on', 'KFold', 5);
            %nbmd = fitcnb(train_data, train_labels, 'OptimizeHyperparameters','auto','HyperparameterOptimizationOptions',struct('AcquisitionFunctionName','expected-improvement-plus'));
            cl = kfoldLoss(nbmd, 'LossFun', 'mincost');
            disp(cl);
            tloss(m, n) = tloss(m, n)+cl;
            
        end
        
    end
end


%delete mypool