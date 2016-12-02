function complete_data = fill_missing_value(data, no_detect, miss_val, lat, lon)
%FILL_MISSING_VALUE 此处显示有关此函数的摘要
%   purpose:    Filling missing value currently using IDVM with k=2 and d=4
%   parameters: data - original data containing missing value
%               no_detect - indicate which data cell is not included in the
%                           study.
%               miss_val - the value indicates that the current data cell
%                          has missing value
%               lat, lon - vector of latitudes and longitudes
    
    %reserve 2*d candidate for each geometric location in case of
    %candidates also being missing
    distance_matrix = d_distance(data,no_detect,lat,lon,16);
    [lo, la, dates] = size(data);
    complete_data = data;
    
    for d=1:dates
        for m=1:lo
            for n=1:la
                if (~no_detect(m, n) && abs(data(m, n, d)-miss_val)< 0.001)
                    complete_data(m, n, d) = IDVM(data, no_detect, miss_val, distance_matrix, n, m, d, 2, 4);
                end
            end
        end
    end
    
end

