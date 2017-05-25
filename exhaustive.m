%This script exhaustively finds the smallest set of sensors that together
%meet the distortion constraint. This is for comparison against GDPA in
%high beta regimes and where the number of activated sensors is at least 2


function [exhaustiveDist, exhaustiveSet]=exhaustive(varTheta, meanTheta, Dthres, Rthetax, Rx, numSensorsDeployed)

feasible=true;

%minimum distortion when ALL sensors are on
DistMIN=varTheta+meanTheta^2-Rthetax'*inv(Rx)*Rthetax;


%% Selection
if(DistMIN>Dthres)
    feasible=false;
    display('Infeasible!')
elseif(Dthres>varTheta+meanTheta^2)
    display('No need for a sensor network with that threshold!')
else
   %loop through every possible subset of every possible size in ascending order and check if meets threshold
   %size of solution is subset where threshold met
   %search through that subset size for the set that meets threshold with
   %greatest gap
   
   solved=false;
   subsetSize=1;
   while(~solved && subsetSize<=numSensorsDeployed) %varying subset size
       subsets=nchoosek(1:numSensorsDeployed,subsetSize);
       [noOfComb subsetSize]=size(subsets);
       
       minDist=Inf;
       for comb=1:noOfComb
       %construct the arguments for this combination of sensors
       temp_Rthetax_Alg=Rthetax(subsets(comb,:));
       temp_Rx_Alg=Rx(subsets(comb,:),subsets(comb,:));
      
       %calculate distortion for this pair and store it in the tempDist
       %vector
       tempDist=varTheta+meanTheta^2-temp_Rthetax_Alg'*inv(temp_Rx_Alg)*temp_Rthetax_Alg; 
           if (tempDist<=Dthres) 
               
               solved=true; %solved
             
               if(tempDist<minDist)
                   minDist=tempDist;  %finding least distortion within the subset as long as within for loop of solved
                   tempSet=subsets(comb,:);
               end
               
           end
       end
   
      subsetSize=subsetSize+1; 
       
   end
   
   exhaustiveDist=minDist;
   exhaustiveSet=tempSet;
    
end
end