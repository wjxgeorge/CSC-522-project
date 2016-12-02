function plcorrel_matrix = d_plcorrelation(data, label_data, no_detect,d)
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
    plcorrel_matrix = zeros(lo, la, d+1, 3);
    
    
    for ci=1:lo
        for cj=1:la
            if (no_detect(ci, cj))
                continue;
            end
            
            correls = [];
            is = [];
            js = [];
            
            for i=1:lo
                for j=1:la
                    
                    if (no_detect(i, j)==0)
                        correl = corrcoef(label_data(ci, cj, :), data(i, j, :));
                        correl = abs(correl(1,2));
                        correls = [correls, correl];
                        is = [is, i];
                        js = [js, j];
                        [B,I] = sort(correls, 'descend');
                        is = is(I);
                        js = js(I);
                        if (length(correls)>(d+1))
                            correls = B(1:(d+1));
                            is = is(1:(d+1));
                            js = js(1:(d+1));
                        end
                    end
                end
            end
            
            for p=1:(d+1)
                plcorrel_matrix(ci, cj, p, 1) = correls(p);
                plcorrel_matrix(ci, cj, p, 2) = is(p);
                plcorrel_matrix(ci, cj, p, 3) = js(p);
            end
        end
    end
    

end

