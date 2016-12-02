d = [2, 4, 6, 8, 10];

%k=2
m2 = [3.1847, 2.7404, 2.8589, 2.8918, 2.9539];

%k=3
m3 = [3.1853, 2.7409, 2.8163, 2.8393, 2.8731];

%k=4
m4 = [3.1866, 2.7472, 2.7948, 2.8100, 2.8276];

%k=5
m5 = [3.1882, 2.7571, 2.7870, 2.7996, 2.8056];

cm = [2.8673, 2.7587, 2.8310, 2.9365, 3.0168];

figure; hold on;
set(gca,'fontsize',20);
xlabel('d');
ylabel('mean RMSE');
l2 = plot(d, m3, 'b-o', 'LineWidth', 2);
M2 = 'IDVM k=3';
l3 = plot(d, m4, 'g-o', 'LineWidth', 2);
M3 = 'IDVM k=4';
l4 = plot(d, m5, 'k-o', 'LineWidth', 2);
M4 = 'IDVM k=5';
l5 = plot(d, cm, 'c-o', 'LineWidth', 2);
M5 = 'CCWM';
l1 = plot(d, m2, 'r-o', 'LineWidth', 2);
M1 = 'IDVM k=2';

label = legend([l1;l2;l3;l4;l5], M1,M2,M3,M4,M5);
set(label, 'position', [0 0 0.2 0.2]);
set(label, 'fontsize', 15);

