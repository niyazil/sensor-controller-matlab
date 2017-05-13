%This simulation assumes that the sensor use analog communication (no
%error detection and requests for retransmission). The channels are therefore non-ideal and transmit power
%influences estimate distortion.

%We assume that the non-ideal channel occurs between beacon and tablet
%(the BLE channel), while the channel between tablet and MATLAB (the
%Dropbox wifi channel) remains ideal and is therefore ignored

%Note: Configuration statistics are provided by the
%config_stats_power_allocation function

feasible=true;
fileName='configs-matlab.xlsx';

%prompt user for configuration number
sheet=input('Enter the configuration number:');

%read positions
pos=xlsread(fileName,sheet,'N2:N8');
numSensorsDeployed=length(pos);

FC_pos=[25,0];

%source statistics
varTheta=60.811325;
meanTheta=180.59;

%distortion constraint
Dthres=30000;

%max and min powers in linear scale
Pmax=10^(5/10); %5 dbm to mW
Pmin=10^(-40/10); %-40 dbm to mW

%run function to return Rthetax and Rx based on configuration
[Rthetax,Rx,DpAllOn,Rv]=config_stats_power_allocation(pos,FC_pos,varTheta,meanTheta,Pmax,fileName,sheet);

%minimum distortion when ALL sensors are on
DistMIN=varTheta+meanTheta^2-Rthetax'*DpAllOn*inv(DpAllOn*Rx*DpAllOn+Rv)*DpAllOn*Rthetax;

%% Selection
if(DistMIN>Dthres)
    feasible=false;
else
%vector to indicate whether sensor has been selected or not- initialized to
%false
selected=false(1,numSensorsDeployed);

%vector to store distortion values as selection occurs
distVal=[varTheta varTheta];

%try out two sensor combination cuz initial set needs to be exhaustive
subsetSize=2;
subsets=nchoosek(1:numSensorsDeployed,subsetSize);  %all combinations of sensors taken 'subsetSize' at a time
   [noOfComb subsetSize]=size(subsets);
   pairDist=zeros(1,noOfComb);
   
   for comb=1:noOfComb
       
       %construct the arguments for this combination of sensors
       temp_DpAllOn_Alg=DpAllOn(subsets(comb,:),subsets(comb,:));
       temp_Rthetax_Alg=Rthetax(subsets(comb,:));
       temp_Rx_Alg=Rx(subsets(comb,:),subsets(comb,:));
       temp_Rv_Alg=Rv(subsets(comb,:),subsets(comb,:));
      
       %calculate distortion for this pair and store it in the pairDist
       %vector
       pairDist(comb)=varTheta+meanTheta^2-temp_Rthetax_Alg'*temp_DpAllOn_Alg*inv(temp_DpAllOn_Alg*temp_Rx_Alg*temp_DpAllOn_Alg+temp_Rv_Alg)*temp_DpAllOn_Alg*temp_Rthetax_Alg; 
       
   end
   
       [bestDist bestComb]=min(pairDist);
       selected(subsets(bestComb,:))=true; %has been selected
       indices=subsets(bestComb,:); %store indices of selected sensors in the vector indices
      
       %create matrices
       DpAllOn_Alg=DpAllOn(subsets(bestComb,:),subsets(bestComb,:));
       Rthetax_Alg=Rthetax(subsets(bestComb,:));
       Rx_Alg=Rx(subsets(bestComb,:),subsets(bestComb,:));
       Rv_Alg=Rv(subsets(bestComb,:),subsets(bestComb,:));
       
  k=3; %Because we have already chosen 2 sensors, the count is set to 3
  distVal(k)=bestDist;
  currentDist=bestDist;
  
  while(currentDist>Dthres && k<=numSensorsDeployed)
      bestDist=Inf;
      for i=1:numSensorsDeployed
          if ~selected(i)
               temp_DpAllOn_Alg=DpAllOn([indices,i],[indices,i]);
               temp_Rthetax_Alg=Rthetax([indices,i]);
               temp_Rx_Alg=Rx([indices,i],[indices,i]);
               temp_Rv_Alg=Rv([indices,i],[indices,i]);
               
               tempDist=varTheta+meanTheta^2-temp_Rthetax_Alg'*temp_DpAllOn_Alg*inv(temp_DpAllOn_Alg*temp_Rx_Alg*temp_DpAllOn_Alg+temp_Rv_Alg)*temp_DpAllOn_Alg*temp_Rthetax_Alg; 
               if tempDist<bestDist
                   bestDist=tempDist;
                   bestIndex=i;
               end
          end
      end
      indices(k)=bestIndex;
      selected(bestIndex)=true;
      k=k+1;
      
      DpAllOn_Alg=DpAllOn(indices,indices);
      Rthetax_Alg=Rthetax(indices);
      Rx_Alg=Rx(indices,indices);
      Rv_Alg=Rv(indices,indices);
      
      currentDist=bestDist;
      distVal(k)=currentDist;
  end

  %% Power Allocation
    options=optimoptions(@fmincon,'MaxFunEvals',50000);
    P0=Pmax*ones(1,length(indices)); %to ensure initial point is feasible
    lb=Pmin*ones(1,length(indices));
    ub=Pmax*ones(1,length(indices));
    
    [P,fval]=fmincon(@objfun,P0,[],[],[],[],lb,ub,@(P)confun(P,varTheta,meanTheta,DpAllOn_Alg,Rthetax_Alg,Rx_Alg,Rv_Alg,Dthres,Pmax),options);
    
    temp=diag(DpAllOn_Alg/sqrt(Pmax)); %replace Pmax entries with new powers for each sensor
    Dp_Alg=diag(temp'.*P);
   
    reducedDist=varTheta+meanTheta^2-Rthetax_Alg'*Dp_Alg*inv(Dp_Alg*Rx_Alg*Dp_Alg+Rv_Alg)*Dp_Alg*Rthetax_Alg;
    totalTransmitPower=fval;
    
    powers_dbm=10*log10(P);
    
    %% Estimation
    
end