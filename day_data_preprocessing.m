%Program for CSC522 course project: Precipitation prediction of
%Northwestern United States
%Run after running readNCData
%day based data preprocessing includes:
%   filling missing values
%   discritization of data value to be used as label
%   feature selection (currently not)
%   data division of model selection and performance evaluation (85:15)

%filling missing values
complete_data = fill_missing_value(data, no_detect, miss_val, lat, lon);

%discritization of data value to be used as label
edges = [0, 0.3, 2.5, 10, 100, 400];
%edges = [0, 0.3, 400];
labels = discretize(complete_data, edges);
%complete_data = zscore(complete_data, 0, 3);

[lo, la, dat] = size(complete_data);
for m=1:lo
    for n=1:la
        for p=1:dat
            if (~no_detect(m, n) && isnan(labels(m, n, p)))
                disp([m, n, p, complete_data(m, n, p), data(m, n, p)]);
            end
        end
    end
end

%data division 
reg = complete_data(:, :, 2:(length(complete_data)));
labels = labels(:, :, 2:length(labels));
%label_data = complete_data(:, :, 2:length(complete_data)); %for feature selection
complete_data = complete_data(:, :, 1:(length(complete_data)-1));

mod_sel_data = complete_data(:, :, 1:int64(length(complete_data)*0.85));
mod_sel_reg = reg(:, :, 1:int64(length(reg)*0.85));
mod_sel_labels = labels(:, :, 1:int64(length(labels)*0.85));

test_data = complete_data(:, :, int64(length(complete_data)*0.85 + 1):length(complete_data));
test_labels = labels(:, :, int64(length(labels)*0.85 + 1):length(labels));

%feature selection preprocessing-filter based
d = 5;
full_data = spatialInterpolationDataSelection(data, no_detect, miss_val);
%distance_matrix = d_distance(data, no_detect, lat, lon, d);
correlation_matrix = d_correlation(data, no_detect, full_data, d);
%plcorrel_matrix = d_plcorrelation(complete_data, label_data, no_detect, d);
%chi2_matrix = d_chi2(data, no_detect, full_data, d);

%cost matrix calculation
total = 189*length(labels);
scaler = [sum(sum(sum(labels==1))); sum(sum(sum(labels==2))); sum(sum(sum(labels==3))); sum(sum(sum(labels==4))); sum(sum(sum(labels==5)))]/total;
cost_matrix = [0, 1, 2, 3, 4;
               1, 0, 1, 2, 3;
               2, 1, 0, 1, 2;
               3, 2, 1, 0, 1;
               4, 3, 2, 1, 0];
%cost_matrix = [scaler; scaler;scaler;scaler;scaler];
cost_matrix = abs(bsxfun(@rdivide, cost_matrix, scaler));
%cost_matrix = cost_matrix - min(cost_matrix(:, :));
%cost_matrix = cost_matrix./mean(cost_matrix(:, :));
           
