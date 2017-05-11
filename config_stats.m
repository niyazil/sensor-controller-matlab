function [Rthetax, Rx]=config_stats(pos,varTheta, meanTheta)

%create map of the beacon distances from the source with associated
%correlation coefficient
distances={4, 5, 6.5, 7, 8, 9, 10.5};
correlations={0.87861134,0.870124269, 0.763726186, 0.865185936, 0.612602021, 0.583427047, 0.666666639};
correlMap=containers.Map(distances, correlations);

%Model 1(see Issues, Discoveries and Insights entry for 4/18/2017)
%We have correlation values between 6 beacons when all 6 beacons are 6.5 cm
%from the source
%So we will have Rthetax be 6x3 and having the same entry
%rhothetax3*sigmatheta*sigmax3+mutheta*mux3, where x3 is the observation at
%6.5 cm from the source

rhox3=0.763726186; %assume same for all

%sample variance
varx1=12.60459184;
varx2=30.5705102;
varx3=7.084821429;
varx4=6.534591837;
varx5=4.902653061;
varx7=4.180127551;

meanx1=49.55;
meanx2=45.47;
meanx3=41.225;
meanx4=43.06;
meanx5=44.77;
meanx7=45.415;

Rthetax=[rhox3*sqrt(varx1*varTheta)+meanx1*meanTheta;
         rhox3*sqrt(varx2*varTheta)+meanx2*meanTheta;
         rhox3*sqrt(varx3*varTheta)+meanx3*meanTheta;
         rhox3*sqrt(varx4*varTheta)+meanx4*meanTheta;
         rhox3*sqrt(varx5*varTheta)+meanx5*meanTheta;
         rhox3*sqrt(varx7*varTheta)+meanx7*meanTheta;];

Rx=[varx1+meanx1^2 0.789304143*sqrt(varx1*varx2)+meanx1*meanx2 0.770575386*sqrt(varx1*varx3)+meanx1*meanx3 0.775602549*sqrt(varx1*varx4)+meanx1*meanx4 0.789251447*sqrt(varx1*varx5)+meanx1*meanx5 0.666933189*sqrt(varx1*varx7)+meanx1*meanx7;
0.789304143*sqrt(varx1*varx2)+meanx1*meanx2	varx2+meanx2^2	0.764202902*sqrt(varx2*varx3)+meanx2*meanx3	0.708282813*sqrt(varx2*varx4)+meanx2*meanx4	0.684147334*sqrt(varx2*varx5)+meanx2*meanx5	0.561341848*sqrt(varx2*varx7)+meanx2*meanx7;
0.770575386*sqrt(varx3*varx1)+meanx3*meanx1	0.764202902*sqrt(varx3*varx2)+meanx3*meanx2	varx3+meanx3^2 0.816053949*sqrt(varx3*varx4)+meanx3*meanx4 0.751940919*sqrt(varx3*varx5)+meanx3*meanx5 0.660559491*sqrt(varx3*varx7)+meanx3*meanx7;
0.775602549*sqrt(varx4*varx1)+meanx4*meanx1	0.708282813*sqrt(varx4*varx2)+meanx4*meanx2	0.816053949*sqrt(varx4*varx3)+meanx4*meanx3	varx4+meanx4^2 0.770032732*sqrt(varx4*varx5)+meanx4*meanx5 0.657247877*sqrt(varx4*varx7)+meanx4*meanx7;
0.789251447*sqrt(varx5*varx1)+meanx5*meanx1	0.684147334*sqrt(varx5*varx2)+meanx5*meanx2	0.751940919*sqrt(varx5*varx3)+meanx5*meanx3	0.770032732*sqrt(varx5*varx4)+meanx5*meanx4	varx5+meanx5^2 0.647013829*sqrt(varx5*varx7)+meanx5*meanx7;
0.666933189*sqrt(varx7*varx1)+meanx7*meanx1	0.561341848*sqrt(varx7*varx2)+meanx7*meanx2	0.660559491*sqrt(varx7*varx3)+meanx7*meanx3	0.657247877*sqrt(varx7*varx4)+meanx7*meanx4	0.647013829*sqrt(varx7*varx5)+meanx7*meanx5	varx7+meanx7^2];





end






