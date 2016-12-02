function chi2_matrix = d_chi2(data, no_detect,full_data,d)
%D_CORRELATION 此处显示有关此函数的摘要
%   purpose:    calculate the correlation of d-closest data point to all data
%               cells that are included in this study
%               Currently for CCWM.
%   parameter:  data - original data containing missing value
%               no_detect - indicate which data cell is not included in the
%                           study.
%               full_data - indexes of data entry without missing value.
%                           (in terms of date)
%               d - d-closest data used in IDVM
%   output:     correl_matrix - 16*17*d*3 matrix for each cell
%                                 (correlation, longitude index, latitude
%                                 index)
    
    %each entry stores - correlation, longitude index, latitude index.
    [lo, la, dts] = size(data);
    chi2_matrix = zeros(lo, la, d+1, 3);
    
    
    for ci=1:lo
        for cj=1:la
            if (no_detect(ci, cj))
                continue;
            end
            
            chi2s = [];
            is = [];
            js = [];
            
            for i=1:lo
                for j=1:la
                    
                    if (no_detect(i, j)==0)
                        [tb1, chi2, p] = crosstab(reshape(data(ci, cj, full_data), [length(full_data), 1]), reshape(data(i, j, full_data), [length(full_data), 1]));
                        chi2s = [chi2s, chi2];
                        is = [is, i];
                        js = [js, j];
                        [B,I] = sort(chi2s, 'descend');
                        is = is(I);
                        js = js(I);
                        if (length(chi2s)>(d+1))
                            chi2s = B(1:(d+1));
                            is = is(1:(d+1));
                            js = js(1:(d+1));
                        end
                    end
                end
            end
            
            for p=1:(d+1)
                chi2_matrix(ci, cj, p, 1) = chi2s(p);
                chi2_matrix(ci, cj, p, 2) = is(p);
                chi2_matrix(ci, cj, p, 3) = js(p);
            end
        end
    end
    
end