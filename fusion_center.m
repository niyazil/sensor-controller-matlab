%reads temperature measurements from sensorReadings.xls and performs fusion
%to get estimate

fileName='sensorReadings.xls';

% x=xlsread(fileName,'B2:B8');

%x=[50.25	44.5	41	42.5	46	45.75	46.25]'; %configuration 2 at minute 16]'; %configuration 1 at minute 16
%x=[31.75	29.75	41	29.25	50	38	42.25]'; %configuration 2 at minute 16
x=[66.5	37.25	26.25	36	31.75	45.75	31.5]'; %configuration 3 at minute 16
x=x(indices);
theta=Rthetax_Alg'*inv(Rx_Alg)*x;