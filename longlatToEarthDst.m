function dst = longlatToEarthDst( lat1, long1, lat2, long2 )
%LONGLATTOEARCHDST 此处显示有关此函数的摘要
%   purpose: calculate the distance on Earth based on Haversine formula
%   parameters: lat1, lat2 -     latitude of two points
%               long1, long2 -   longitude of two points
%   output:     dst - distance on Earth between two points
    
    %R: Earch radius in km
    R = 6371;
    
    %transform coordinates' unit from degree to radian
    lt1 = deg2rad(lat1);
    lt2 = deg2rad(lat2);
    lg1 = deg2rad(long1);
    lg2 = deg2rad(long2);
    
    dlt = deg2rad(lat2-lat1);
    dlg = deg2rad(long2-long1);
    
    %apply Haversine formula
    a = (sin(dlt/2))^2 + cos(lt1)*cos(lt2)*(sin(dlg/2))^2;
    c = 2*atan2(sqrt(a), sqrt(1-a));
    
    dst = R*c;
    
end

