%ELPI_import
%[ELPI_data, ELPI_params, ELPI_properties] = ELPI_import('test.dat');

function [ELPI_data, ELPI_params, ELPI_properties] = ELPI_sampler_import(filename)

%filename = 'jordan_test.dat';

[file,path] = uigetfile('*.dat');
if isequal(file,0)
   disp('User selected Cancel');
else
   disp(['User selected ', fullfile(path,file)]);
end
filename = fullfile(path,file);
%check if file exists
[fid, msg] = fopen(filename);
if fid < 0
    error('Failed to open file "%s" because "%s"', filename, msg);
end
fclose(fid);
clear fid msg;

%%GET ELPI+ device parameters
ELPI_params_raw = readmatrix(filename,"Delimiter",",","OutputType","string","Range",'1:42');
ELPI_values = extractAfter(ELPI_params_raw(:,1),"=");
ELPI_values = str2double(ELPI_values);

ELPI_params.name = "Thismachine";

ELPI_params.FlowRate = ELPI_values(11,1);
%ELPI_params.FlowRate = 9.71;

ELPI_params.DiffLossFit = ELPI_values(15,1);
ELPI_params.FilterLow = ELPI_values(16,1);
ELPI_params.FilterCal = ELPI_values(17,1);
ELPI_params.Density = ELPI_values(31,1);
ELPI_params.Density = ELPI_values(31,1);

ELPI_params.Dilution = ELPI_values(35,1);
ELPI_params.D50values = ELPI_values(12,1);
ELPI_params.D50values(1,2:15) = str2double(ELPI_params_raw(12,2:15));
ELPI_params.Pressure = ELPI_values(13,1);
ELPI_params.Pressure(1,2:15) = str2double(ELPI_params_raw(13,2:15));
ELPI_params.ResTime = ELPI_values(14,1);
ELPI_params.ResTime(1,2:15) = str2double(ELPI_params_raw(14,2:15));
ELPI_params.DiffLossFit = ELPI_values(15,1);
ELPI_params.DiffLossFit(1,2:15) = str2double(ELPI_params_raw(15,2:15));
ELPI_params.Limit1 = ELPI_values(24,1);
ELPI_params.Mult1 = str2double(ELPI_params_raw(24,2));
ELPI_params.Exp1 = str2double(ELPI_params_raw(24,3));
ELPI_params.Limit2 = str2double(ELPI_params_raw(24,4));
ELPI_params.Mult2 = str2double(ELPI_params_raw(24,5));
ELPI_params.Exp2 = str2double(ELPI_params_raw(24,6));
ELPI_params.Mult3 = str2double(ELPI_params_raw(24,7));
ELPI_params.Exp3 = str2double(ELPI_params_raw(24,8));

%%get data
ELPI_data = readmatrix(filename,"Delimiter",",","OutputType","string","Range",43);
extracted_datetimes = extractAfter(ELPI_data(:,1),11);
time = datetime(extracted_datetimes);

%get numerical data only
numerical_data = str2double(ELPI_data(:,[3:16,18:33,35:48,50:50,53:58,60:74,76:79]));

%get row names
varNames = readmatrix(filename,"Delimiter",",","Range","40:40","OutputType","string");
varNames = varNames';

%correct for duplicate row names in .dat file
varNames(1,1) = 'time';
varNames(61,1) = "Stage1a";
varNames(62,1) = "Stage2a";
varNames(63,1) = "Stage3a";
varNames(64,1) = "Stage4a";
varNames(65,1) = "Stage5a";
varNames(66,1) = "Stage6a";
varNames(67,1) = "Stage7a";
varNames(68,1) = "Stage8a";
varNames(69,1) = "Stage9a";
varNames(70,1) = "Stage10a";
varNames(71,1) = "Stage11a";
varNames(72,1) = "Stage12a";
varNames(73,1) = "Stage13a";
varNames(74,1) = "Stage14a";

t_numeric = array2table(numerical_data,"VariableNames",varNames([3:16,18:33,35:48,50:50,53:58,60:74,76:79],1));
t_numeric.time = time;

ELPI_data = t_numeric;

%populate aerodynamic d%0 values
%Dp_a =
results(1,:) = ELPI_params.D50values;

%using test data from ELPI+ manual to validate calculation:
validate = false;
if validate == true
    ELPI_params.FlowRate = 9.71;
    ELPI_params.Density = 1.5;
    results(1,:) = [0.0089,0.0160,0.0300,0.0540,0.0940,0.1540,0.2540,0.3800,0.6,0.94,1.62,2.46,3.64,5.34,10];
end

% calculate cunnignham's slip correction factor for aerodynamic diameter
% C_Ca =
results(2,:) = 1+(2./(76.*results(1,:))).*(6.32+2.01.*exp(-0.1095.*76.*results(1,:)));

% calculate geometric mean of each channel
% Di_a =
for i = 1:14
    results(3,i) = sqrt(results(1,i).*results(1,i+1));
end

%calculate stokes diameters
% Dp_s & Cc_s =
for i = 1:15
    [results(4,i), results(5,i)] = calc_stokes(results(1,i),results(2,i),ELPI_params.Density);
end

% calculate geometric mean of each channel
%Di_s =
for i = 1:14
    results(6,i) = sqrt(results(4,i).*results(4,i+1));
end
%assume aerodynamic diameter
% Di =
results(7,:) = results(3,:);

%calculate dlogDp multiplier vectors, assuming aerodynamic
for i = 1:14
    results(8,i) = log10(results(1,i+1)./results(1,i));
end

%calculate conversion factor X
for i= 1:14
    if results(6,i) < ELPI_params.Limit1
        results(9,i) = ELPI_params.Mult1*results(6,i)^(ELPI_params.Exp1)*(ELPI_params.FlowRate/10);

    elseif results(7,i) < ELPI_params.Limit2
        results(9,i) = ELPI_params.Mult2*results(6,i)^(ELPI_params.Exp2)*(ELPI_params.FlowRate/10);

    else
        results(9,i) = ELPI_params.Mult3*results(6,i)^(ELPI_params.Exp3)*(ELPI_params.FlowRate/10);
    end
end

idx0 = x(:,20) < 2;
idx0.Properties.VariableNames(1) = "TF";
idx1 = x(:,21) < 2;
idx1.Properties.VariableNames(1) = "TF";
idx_fin = idx1(:,1) & idx0(:,1);
x_fin = x()
%%now do the calculations from conversion vectors

%trime stage 15 values to make life easier in matlab
results(:,15) = [];

X = results(9,1:14);
dlogDp = results(8,1:14);
Dilution = ELPI_params.Dilution;
Di =  results(7,1:14);
Density = ELPI_params.Density;

% number_dlog =
results(10,:) = 1./X.*1./dlogDp.*Dilution;
% diameter_dlog =
results(11,:) = 1./X.*Di.*1./dlogDp*Dilution;
% area_dlog =
results(12,:) = 1./X.*Di.^2.*pi.*1./dlogDp.*Dilution;
%volume_dlog =
results(13,:) = 1./X.*Di.^2.*pi.*(1/6).*1./dlogDp.*Dilution;
%mass_dlog =
results(14,:) = 1./X.*Di.^2.*pi.*(1/6).*1./dlogDp.*Dilution.*Density.*0.001;

% number =
results(15,:) = 1./X.*Dilution;
% diameter =
results(16,:) = 1./X.*Di.*Dilution;
% area =
results(17,:) = 1./X.*Di.^2.*pi.*Dilution;
%volume =
results(18,:) = 1./X.*Di.^2.*pi.*(1/6).*Dilution;
%mass =
results(19,:) = 1./X.*Di.^2.*pi.*(1/6).*Dilution.*Density.*0.001;

ELPI_properties = array2table(results);
results_rowNames = {'Dp_a','Cc_a','Di_a','Dp_s','Cc_s','Di_s','Di','dlogDp','X','number_dlog','diameter_dlog','area_dlog','volume_dlog','mass_dlog','number','diameter','area','volume','mass'};
results_colNames = {'1','2','3','4','5','6','7','8','9','10','11','12','13','14'};
ELPI_properties.Properties.RowNames = results_rowNames;
ELPI_properties.Properties.VariableNames = results_colNames;

%%split by input bits


end