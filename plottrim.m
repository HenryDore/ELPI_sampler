idx0 = x(:,20) < 2;
idx0.Properties.VariableNames(1) = "TF";
idx1 = x(:,21) < 2;
idx1.Properties.VariableNames(1) = "TF";

% 00 = mode 0
idx_m0 = idx0(:,1) & idx1(:,1);
% 01 = mode 1
idx_m1 = ~idx0(:,1) & idx1(:,1);
% 10 = mode 2
idx_m2 = idx0(:,1) & ~idx1(:,1);
% 11 = mode 3
idx_m3 = ~idx0(:,1) & ~idx1(:,1);


idx_m1_del = idx_m1;
n_del = 3;
for i = 2:1:size(idx_m1,1)
if idx_m1{i,1} ~= idx_m1{i-1,1}
    if idx_m1{i,1} == true
    % false to true, delete next n_del data points
    idx_m1_del{i:i+n_del,1} = false;
    else
    % true to false, delete previous n_del data points 
    idx_m1_del{i-n_del:i,1} = false;
    end
end
end


idx_m2_del = idx_m2;
for i = 2:1:size(idx_m2,1)
if idx_m2{i,1} ~= idx_m2{i-1,1}
    if idx_m2{i,1} == true
    % false to true, delete next n_del data points
    idx_m2_del{i:i+n_del,1} = false;
    else
    % true to false, delete previous n_del data points 
    idx_m2_del{i-n_del:i,1} = false;
    end
end
end


idx_m3_del = idx_m3;
for i = 2:1:size(idx_m3,1)
if idx_m3{i,1} ~= idx_m3{i-1,1}
    if idx_m3{i,1} == true
    % false to true, delete next n_del data points
    idx_m3_del{i:i+n_del,1} = false;
    else
    % true to false, delete previous n_del data points 
    idx_m3_del{i-n_del:i,1} = false;
    end
end
end


idx_m0_del = idx_m0;
for i = 2:1:size(idx_m0,1)
if idx_m0{i,1} ~= idx_m0{i-1,1}
    if idx_m0{i,1} == true
    % false to true, delete next n_del data points
    idx_m0_del{i:i+n_del,1} = false;
    else
    % true to false, delete previous n_del data points 
    idx_m0_del{i-n_del:i,1} = false;
    end
end
end

% 
% figure;
% hold on;
% plot(idx_m1.TF)
% plot(idx_m1_del.TF)


m1 = x(idx_m1_del.TF,:);
m2 = x(idx_m2_del.TF,:);
m3 = x(idx_m3_del.TF,:);
m0 = x(idx_m0_del.TF,:);

% figure;
% hold on
% plot(m1.time,m1.PM10);
% plot(m2.time,m2.PM10);
% plot(m3.time,m3.PM10);
% title('PM10')
% legend('internal','filter outlet','external');

figure;
hold on
plot(m1.time,m1.PM1);
plot(m2.time,m2.PM1);
plot(m3.time,m3.PM1);
title('PM1')
legend('internal','filter outlet','external');


figure;
hold on
plot(m1.time,m1.("PM2.5"));
plot(m2.time,m2.("PM2.5"));
plot(m3.time,m3.("PM2.5"));
title('PM2.5')
legend('internal','filter outlet','external');

figure;
hold on
plot(m1.time,m1.("PM10"));
plot(m2.time,m2.("PM10"));
plot(m3.time,m3.("PM10"));
title('PM10')
legend('internal','filter outlet','external');

% 
% figure;
% hold on
% plot(m1.time,m1.("PN2.5"));
% plot(m2.time,m2.("PN2.5"));
% plot(m3.time,m3.("PN2.5"));
% title('PN1')
% legend('internal','filter outlet','external');


figure;
hold on
plot(MAm1.time,MAm1.pm25);
plot(MAm2.time,MAm2.pm25);
plot(MAm3.time,MAm3.pm25);
title('PM2.5')
legend('internal','filter outlet','external');