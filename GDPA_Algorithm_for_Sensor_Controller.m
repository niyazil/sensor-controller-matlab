%This runs the GDPA algorithm for a particular configuration and source
%statistics. It outputs an excel file that specifies beacon SIDs along with
%corresponding on/off statuses, to be read by the sensor controller app component in order
%to control the beacons

feasible=true;

%an array of the current configuration's beacon positioning from the source
pos=[6.5 6.5 6.5 6.5 6.5 6.5]';
numSensorsDeployed=length(pos);

%source statistics

% %population variance
% varTheta=1033.792525;

%sample variance
varTheta=60.811325;

meanTheta=180.59;

%distortion constraint
Dthres=19;

%run function to return Rthetax and Rx based on configuration
[Rthetax, Rx]=config_stats(pos,varTheta, meanTheta);

% %remove beacons
% Rthetax=Rthetax(1:(end-1));
% Rx=Rx(1:(end-1),1:(end-1));


%minimum distortion when ALL sensors are on
DistMIN=varTheta+meanTheta^2-Rthetax'*inv(Rx)*Rthetax;

%estimate when all sensors on
x=[50.25	44.5	41	42.5	46	46.25]'; %measurements at minute 16
theta=Rthetax'*inv(Rx)*x;





%% selection
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
   
       temp_Rthetax_Alg=Rthetax(subsets(comb,:));
       temp_Rx_Alg=Rx(subsets(comb,:),subsets(comb,:));
      
       %calculate distortion for this pair and store it in the pairDist
       %vector
       pairDist(comb)=varTheta+meanTheta^2-temp_Rthetax_Alg'*inv(temp_Rx_Alg)*temp_Rthetax_Alg; 
       
   end
   
        [bestDist bestComb]=min(pairDist);
        selected(subsets(bestComb,:))=true; %has been selected
        indices=subsets(bestComb,:); %store indices of selected sensors in the vector indices
       
      
        %create matrices
        
    
       Rthetax_Alg=Rthetax(subsets(bestComb,:));
       RxAlg=Rx(subsets(bestComb,:),subsets(bestComb,:));
       
  k=3; %cuz here we chose 2 sensors not just one
  distVal(k)=bestDist;
  
  currentDist=bestDist;
  while(currentDist>Dthres && k<=numSensorsDeployed)
      bestDist=Inf;
      for i=1:numSensorsDeployed
          if ~selected(i)
               temp_Rthetax_Alg=Rthetax([indices,i]);
               temp_Rx_Alg=Rx([indices,i],[indices,i]);
               
               tempDist=varTheta+meanTheta^2-temp_Rthetax_Alg'*inv(temp_Rx_Alg)*temp_Rthetax_Alg; 
               if tempDist<bestDist
                   bestDist=tempDist;
                   bestIndex=i;
               end
          end
      end
      indices(k)=bestIndex;
      distVal(k)=bestDist;
      selected(bestIndex)=true;
      k=k+1;
      
      Rthetax_Alg=Rthetax(indices);
      Rx_Alg=Rx(indices,indices);
      
      currentDist=bestDist;
  end
  
  
end