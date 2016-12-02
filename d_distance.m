function distance_matrix = d_distance(data, no_detect,lat,lon,d)
%IDVM_DISTANCE 此处显示有关此函数的摘要
%   purpose:    calculate the distance of d-closest data point to all data
%               cells that are included in this study
%               Currently for IDVM.
%   parameter:  data - original data containing missing value
%               no_detect - indicate which data cell is not included in the
%                           study.
%               lat, lon - vector of latitudes and longitudes
%               d - d-closest data used in IDVM
%   output:     distance_matrix - 16*17*d*3 matrix for each cell
%                                 (distance, longitude index, latitude
%                                 index)
    
    %each entry stores - distance, longitude index, latitude index.
    distance_matrix = zeros(length(lon), length(lat), d+1, 3);
    
    for ci=1:length(lon)
        for cj=1:length(lat)
            if (no_detect(ci, cj))
                continue;
            end
            
            distances = [];
            is = [];
            js = [];
            
            for i=1:length(lon)
                for j=1:length(lat)
                    
                    if (no_detect(i, j)==0)
                        distance = longlatToEarthDst(lat(cj), lon(ci), lat(j), lon(i));
                        distances = [distances, distance];
                        is = [is, i];
                        js = [js, j];
                        [B,I] = sort(distances);
                        is = is(I);
                        js = js(I);
                        if (length(distances)>(d+1))
                            distances = B(1:(d+1));
                            is = is(1:(d+1));
                            js = js(1:(d+1));
                        end
                    end
                end
            end
            
            for p=1:(d+1)
                distance_matrix(ci, cj, p, 1) = distances(p);
                distance_matrix(ci, cj, p, 2) = is(p);
                distance_matrix(ci, cj, p, 3) = js(p);
            end
        end
    end
    
end

