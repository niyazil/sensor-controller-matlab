%reads temperature measurements from sensorReadings.xls and performs fusion
%to get estimate

fileName='sensorReadings.xls';

% x=xlsread(fileName,'B2:B8');

%x=[42.75	33.5	33.25	36	38.75	34.75	39]'; %configuration 1 at minute 2
%x=[54.5	48.25	44.5	45.75	46	49	46.25]'; %configuration 1 at minute 25
%x=[50.25	48.25	41	42.5	42.75	49	42.25]'; %configuration 1 at minute 50
%x=[28	26.75	30	26.25	38.75	31	31.5]'; %configuration 2 at minute 2
%x=[31.75	29.75	41	29.25	50	38	42.25]'; %configuration 2 at minute 16
x=[46.25	29.75	26.25	29.25	28	34.75	28.5]'; %configuration 3 at minute 16
%x=[66.5	37.25	26.25	36	31.75	45.75	31.5]'; %configuration 3 at minute 16
x=x(indices);
theta=Rthetax_Alg'*inv(Rx_Alg)*x;