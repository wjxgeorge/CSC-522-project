%Program for CSC522 course project: Precipitation prediction of
%Northwestern United States
%run after day_data_preprocessing
%10-fold cross validation model selection 
feature_matrix = correlation_matrix;
edges = [0, 0.1, 1, 2.5, 10, 25, 50, 100, 400];

SSE = zeros(length(lon), length(lat));
accur = zeros(length(lon), length(lat));
[~, ~, d, ~] = size(feature_matrix);
[lo, la, dat] = size(mod_sel_data);

for i=1:10
   cv_set = (cv_index == i);
   train_set = ~cv_set;
   
   train_data = mod_sel_data(:, :, train_set);
   train_reg = mod_sel_reg(:, :, train_set);
   
   cv_data = mod_sel_data(:, :, cv_set);
   cv_reg = mod_sel_data(:, :, cv_set);
   cv_labels = mod_sel_labels(:, :, cv_set);
   
   for m=1:lo
        for n=1:la
            if (~no_detect(m, n))
                %preparing training data and cv data for each cell
                cur_train_reg = reshape(train_reg(m, n, :), [sum(train_set), 1]);
                cur_cv_labels = reshape(cv_labels(m, n, :), [sum(cv_set), 1]);
                cur_cv_reg = reshape(cv_reg(m, n, :), [sum(cv_set), 1]);
                cur_train_data = [];
                cur_cv_data = [];
                for j=1:(d-1)
                    cm = feature_matrix(m, n, j, 2);
                    cn = feature_matrix(m, n, j, 3);
                    cur_train_data = [cur_train_data; train_data(cm, cn, :)];
                    cur_cv_data = [cur_cv_data; cv_data(cm, cn, :)];
                end
                
                cur_train_data = reshape(cur_train_data, [(d-1), sum(train_set)]);
                cur_train_data = cur_train_data';
                cur_cv_data = reshape(cur_cv_data, [(d-1), sum(cv_set)]);
                cur_cv_data = cur_cv_data';
                
                LRMD = fitlm(cur_train_data, cur_train_reg);
                for p=1:length(cur_cv_data)
                    prd = predict(LRMD, cur_cv_data(p, :));
                    pl = discretize(prd, edges);
                    if (prd < 0)
                        pl = 0;
                    end

                    if (isnan(cur_cv_labels(p)))
                        disp([m, n, p]);
                    end
                    SSE(m, n) = SSE(m, n) + (cur_cv_reg(p) - prd)^2;
                    
                    if (pl == cur_cv_labels(p))
                        accur(m, n) = accur(m, n) + 1;
                    end
                end
                
            end
        end
   end
   
end

MSE = SSE./length(mod_sel_data);
RMSE = sqrt(MSE);
mean_RMSE = meanRMSE(RMSE, no_detect);


