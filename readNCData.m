%Program for CSC522 course project: Precipitation prediction of
%Northwestern United States
%Read data from 'pnwrain.50km.daily.4994.nc'

%read data vectors
lat = ncread('pnwrain.50km.daily.4994.nc', 'lat');
lon = ncread('pnwrain.50km.daily.4994.nc', 'lon');
time = ncread('pnwrain.50km.daily.4994.nc', 'time');
data = ncread('pnwrain.50km.daily.4994.nc', 'data');

%check for missing value or not included within detection
miss_val = ncreadatt('pnwrain.50km.daily.4994.nc', 'data', 'missing_value');

%unpack data
add_offset = ncreadatt('pnwrain.50km.daily.4994.nc', 'data', 'add_offset');
scale_factor = ncreadatt('pnwrain.50km.daily.4994.nc', 'data', 'scale_factor');
%data = ((double(data))./scale_factor);

miss_val = double(miss_val)*0.1;
check = (abs(data-miss_val)< 0.001);

%check_miss- value 16801:   never included, can be ignored
%            non-0 value:   with missing value, need to take care
check_miss = sum(check, 3);

%no_detect- 1:  never included, ingore
%           0:  should not be ignored
%for Spatial Interpolation Test
%row 16 col 9 missed 14847 times, currently treated as never
%              detected.
no_detect = (check_miss >= 14846);

%for prediction test
%no_detect = (check_miss == 16801);



