%reads temperature measurements from sensorReadings.xls and performs fusion
%to get estimate

fileName='sensorReadings.xls';

% x=xlsread(fileName,'B2:B8');

x=[31.75	29.75	41	29.25	50	38	42.25]'; %configuration 2 at minute 16

theta=Rthetax'*inv(Rx)*x;