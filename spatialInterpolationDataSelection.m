function combinedData = spatialInterpolationDataSelection(data, no_detect, miss_val)
%SPATIALINTERPOLATIONDATASELECTION 此处显示有关此函数的摘要
%   purpose:    Select data based on data without missing data.
%               In order to conduct training and testing of spatial
%               interpolation for the missing data.
%   parameters: data - the original data containing missing value
%               no_detect - the logical matrix indicating whether the data
%                           cell is included in the study or not
%               miss_val - the value indicates that the current data cell
%                          has missing value
%   output:     combinedData - the indices of data without missing values, 
%                              disregards the temporal connection between
%                              each date.
    
    [lg, lt, dt] = size(data);
    combinedData = [];
    
    for i=1:dt
        count_miss = 0;
        
        for j=1:lg
            for p=1:lt
                %disp(abs(data(j, p, i)-miss_val)< 0.001);
                if ((abs(data(j, p, i)-miss_val)< 0.001) && (no_detect(j,p)~=1))
                    count_miss = count_miss+1;
                end
            end
        end
        
        if (count_miss == 0)
           combinedData = [combinedData; i]; 
        end
        
    end
    
end

