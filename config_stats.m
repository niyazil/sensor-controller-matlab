function [Rthetax, Rx]=config_stats(pos,varTheta, meanTheta,fileName,sheet)

%create map of the beacon distances from the source with associated
%correlation coefficient
distances={4, 5, 6.5, 7, 8, 9, 10.5, 11.5, 13};
%correlations={0.87861134,0.870124269, 0.763726186, 0.865185936, 0.612602021, 0.583427047, 0.666666639, 0.612602021, 0.612602021};
y = @(x)(-0.8395133 + 1.978441*exp(-0.03142192*x));
correlations={y(4),y(5), y(6.5), y(7), y(8), y(9), y(10.5), y(11.5), y(13)};
correlMap=containers.Map(distances, correlations);

%Model 1(see Issues, Discoveries and Insights entry for 4/18/2017

%get source correlations for each beacon for this configuration
rhox1=correlMap(pos(1)); 
rhox2=correlMap(pos(2)); 
rhox3=correlMap(pos(3)); 
rhox4=correlMap(pos(4)); 
rhox5=correlMap(pos(5)); 
rhox6=correlMap(pos(6)); 
rhox7=correlMap(pos(7));


%read sample means for this configuration
meanx=xlsread(fileName,sheet,'B1:B7');


%read sample variances for this configuration
varx= xlsread(fileName,sheet,'D1:D7');

Rthetax=[rhox1*sqrt(varx(1)*varTheta)+meanx(1)*meanTheta;
         rhox2*sqrt(varx(2)*varTheta)+meanx(2)*meanTheta;
         rhox3*sqrt(varx(3)*varTheta)+meanx(3)*meanTheta;
         rhox4*sqrt(varx(4)*varTheta)+meanx(4)*meanTheta;
         rhox5*sqrt(varx(5)*varTheta)+meanx(5)*meanTheta;
         rhox6*sqrt(varx(6)*varTheta)+meanx(6)*meanTheta;
         rhox7*sqrt(varx(7)*varTheta)+meanx(7)*meanTheta];
    
%read correlation matrix for this configuration and create Rx

    correlMat=xlsread(fileName,sheet,'F3:L9');
    
    Rx=[varx(1)+meanx(1)^2 correlMat(1,2)*sqrt(varx(1)*varx(2))+meanx(1)*meanx(2) correlMat(1,3)*sqrt(varx(1)*varx(3))+meanx(1)*meanx(3) correlMat(1,4)*sqrt(varx(1)*varx(4))+meanx(1)*meanx(4) correlMat(1,5)*sqrt(varx(1)*varx(5))+meanx(1)*meanx(5) correlMat(1,6)*sqrt(varx(1)*varx(6))+meanx(1)*meanx(6) correlMat(1,7)*sqrt(varx(1)*varx(7))+meanx(1)*meanx(7);
        correlMat(2,1)*sqrt(varx(1)*varx(2))+meanx(1)*meanx(2)	varx(2)+meanx(2)^2	correlMat(2,3)*sqrt(varx(2)*varx(3))+meanx(2)*meanx(3)	correlMat(2,4)*sqrt(varx(2)*varx(4))+meanx(2)*meanx(4)	correlMat(2,5)*sqrt(varx(2)*varx(5))+meanx(2)*meanx(5)	correlMat(2,6)*sqrt(varx(2)*varx(6))+meanx(2)*meanx(6) correlMat(2,7)*sqrt(varx(2)*varx(7))+meanx(2)*meanx(7);
        correlMat(3,1)*sqrt(varx(3)*varx(1))+meanx(3)*meanx(1)	correlMat(3,2)*sqrt(varx(3)*varx(2))+meanx(3)*meanx(2)	varx(3)+meanx(3)^2 correlMat(3,4)*sqrt(varx(3)*varx(4))+meanx(3)*meanx(4) correlMat(3,5)*sqrt(varx(3)*varx(5))+meanx(3)*meanx(5) correlMat(3,6)*sqrt(varx(3)*varx(6))+meanx(3)*meanx(6) correlMat(3,7)*sqrt(varx(3)*varx(7))+meanx(3)*meanx(7);
        correlMat(4,1)*sqrt(varx(4)*varx(1))+meanx(4)*meanx(1)	correlMat(4,2)*sqrt(varx(4)*varx(2))+meanx(4)*meanx(2)	correlMat(4,3)*sqrt(varx(4)*varx(3))+meanx(4)*meanx(3)	varx(4)+meanx(4)^2 correlMat(4,5)*sqrt(varx(4)*varx(5))+meanx(4)*meanx(5) correlMat(4,6)*sqrt(varx(4)*varx(6))+meanx(4)*meanx(6) correlMat(4,7)*sqrt(varx(4)*varx(7))+meanx(4)*meanx(7);
        correlMat(5,1)*sqrt(varx(5)*varx(1))+meanx(5)*meanx(1)	correlMat(5,2)*sqrt(varx(5)*varx(2))+meanx(5)*meanx(2)	correlMat(5,3)*sqrt(varx(5)*varx(3))+meanx(5)*meanx(3)	correlMat(5,4)*sqrt(varx(5)*varx(4))+meanx(5)*meanx(4)	varx(5)+meanx(5)^2 correlMat(5,6)*sqrt(varx(5)*varx(6))+meanx(5)*meanx(6) correlMat(5,7)*sqrt(varx(5)*varx(7))+meanx(5)*meanx(7);
        correlMat(6,1)*sqrt(varx(6)*varx(1))+meanx(6)*meanx(1)	correlMat(6,2)*sqrt(varx(6)*varx(2))+meanx(6)*meanx(2)	correlMat(6,3)*sqrt(varx(6)*varx(3))+meanx(6)*meanx(3)	correlMat(6,4)*sqrt(varx(6)*varx(4))+meanx(6)*meanx(4)	correlMat(6,5)*sqrt(varx(6)*varx(5))+meanx(6)*meanx(5)	varx(6)+meanx(6)^2 correlMat(6,7)*sqrt(varx(6)*varx(7))+meanx(6)*meanx(7);
        correlMat(7,1)*sqrt(varx(7)*varx(1))+meanx(7)*meanx(1)	correlMat(7,2)*sqrt(varx(7)*varx(2))+meanx(7)*meanx(2)	correlMat(7,3)*sqrt(varx(7)*varx(3))+meanx(7)*meanx(3)	correlMat(7,4)*sqrt(varx(7)*varx(4))+meanx(7)*meanx(4)	correlMat(7,5)*sqrt(varx(7)*varx(5))+meanx(7)*meanx(5) correlMat(7,6)*sqrt(varx(7)*varx(6))+meanx(7)*meanx(6)	varx(7)+meanx(7)^2];

end






