function fill = CCWM(data, no_detect,miss_val,correl_matrix, lat_i, lon_i, date_i, k, d)
%CCWM 此处显示有关此函数的摘要
%   purpose:    spatial interpolation using Coefficient of Correlation
%               Weighting Method (IDVM), currently for filling in missing
%               value of precipitation data.
%               This funtion only calculates the missing value, it does not
%               detect the missing value.
%               This function only calculates the missing value for 1 data
%               cell.
%               This function will use at most d-closest data point to
%               calculate the missing value, in terms of correlation.
%   parameters: data - original data containing missing value
%               no_detect - indicate which data cell is not included in the
%                           study.
%               miss_val - the value indicates that the current data cell
%                          has missing value
%               correl_matrix - calculated by d_correlation()
%               lat_i - the index in latitude of the target data cell with
%                       missing value
%               lon_i - the index in longitude of the target data cell with
%                       missing value
%               date_i - the index in date of the target data cell with
%                        missing value
%               k - friction distance (1.0~6.0) usually 2
%               d - d-closest data used in IDVM
%                   must be the same as in d_distance
%   output:     fill - the calculated value to fill in the missing value
    
    %initialize vectors for storing correlation and corresponding
    %precipitation value
    d_correl = [];
    d_value = [];
    
    [~,~,ud,~] = size(correl_matrix(lon_i, lat_i, :, 1));
    %disp(ud);
    
    %check if the target data at the specified date is missing
    %discard if it is missing
    for p=2:ud
        i = correl_matrix(lon_i, lat_i, p, 2);
        j = correl_matrix(lon_i, lat_i, p, 3);
        
        if ((abs(data(i, j, date_i)-miss_val)> 0.001))
            d_correl = [d_correl; correl_matrix(lon_i, lat_i, p, 1)];
            d_value = [d_value; data(i, j, date_i)];
        end
        
        if (length(d_correl)>=d)
           break; 
        end
        
    end
    
    values = d_value.*(d_correl.^k);
    
    fill = sum(values)/sum(d_correl);
    
end

