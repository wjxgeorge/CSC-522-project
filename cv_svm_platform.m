%Program for CSC522 course project: Precipitation prediction of
%Northwestern United States
%run after day_data_preprocessing
%10-fold cross validation model selection 
feature_matrix = correlation_matrix;

tloss = zeros(length(lon), length(lat));
[~, ~, d, ~] = size(feature_matrix);
[lo, la, dat] = size(mod_sel_data);

%mypool = parpool(4);
paroptions = statset('UseParallel',true);
svmt = templateSVM('KernelFunction', 'gaussian', 'KKTTolerance', 0.001, 'IterationLimit', 10000);

for m=1:lo
    for n=1:la
        if (~no_detect(m, n))
            %prepare training data (including cv data)
            train_labels = reshape(mod_sel_labels(m, n, :), [length(mod_sel_labels), 1]);
            train_data = [];
            for j=1:(d-1)
                cm = feature_matrix(m, n, j, 2);
                cn = feature_matrix(m, n, j, 3);
                train_data = [train_data; mod_sel_data(cm, cn, :)];
            end
            
            train_data = reshape(train_data, [(d-1), length(mod_sel_data)]);
            train_data = train_data';
            
            svmmd = fitcecoc(train_data, train_labels, 'Learners', svmt, 'Options', paroptions, 'Coding', 'ordinal', 'CrossVal', 'on', 'KFold', 5);
            cl = kfoldLoss(svmmd,'Options', paroptions);
            disp(cl);
            tloss(m, n) = tloss(m, n)+cl;
        end
        
    end
end

%delete mypool
