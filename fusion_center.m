%reads temperature measurements from sensorReadings.xls and performs fusion
%to get estimate

fileName='sensorReadings.xls';

x=xlsread(fileName,'B2:B8');
theta=Rthetax'*inv(Rx)*x;