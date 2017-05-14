%This runs the GDPA algorithm for a particular configuration and source
%statistics. It outputs an excel file that specifies beacon SIDs along with
%corresponding on/off statuses, to be read by the sensor controller app component in order
%to control the beacons

clear all

feasible=true;
fileName='configs-matlab.xlsx';


%prompt user for configuration number
sheet=input('Enter the configuration number:');

%read positions
pos=xlsread(fileName,sheet,'N2:N8');
numSensorsDeployed=length(pos);

%source statistics
varTheta=60.811325;
meanTheta=180.59;

%distortion constraint
Dthres=19;

%run function to return Rthetax and Rx based on configuration
[Rthetax, Rx]=config_stats(pos,varTheta, meanTheta,fileName,sheet);

%minimum distortion when ALL sensors are on
DistMIN=varTheta+meanTheta^2-Rthetax'*inv(Rx)*Rthetax;

%best estimate
% x=xlsread(fileName,'B2:B8');

%x=[50.25	44.5	41	42.5	46	45.75	46.25]'; %configuration 2 at minute 16]'; %configuration 1 at minute 16
%x=[31.75	29.75	41	29.25	50	38	42.25]'; %configuration 2 at minute 16
x=[66.5	37.25	26.25	36	31.75	45.75	31.5]'; %configuration 3 at minute 16
bestTheta=Rthetax'*inv(Rx)*x;

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
       Rx_Alg=Rx(subsets(bestComb,:),subsets(bestComb,:));
       
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
      selected(bestIndex)=true;
      k=k+1;
      
      Rthetax_Alg=Rthetax(indices);
      Rx_Alg=Rx(indices,indices);
      
      currentDist=bestDist;
      distVal(k)=currentDist;
  end
  
  %write power allocation to excel sheet
  
    filename = 'C:\Users\Zumerjud\Desktop\Dropbox\power1.xls';
    sheet = 1;
    xlRange1 = 'A1';
    xlRange2 = 'B1';
    
    powers=zeros(1,7)';
    SIDS = {'7159F19768D2A171';'A127870322513F6A';'FBB44C2E84AB40E3';'582A8CF7C8193BFA';'46532D736FC97E89';'8E453771B5785ED8';'994C2A3D97C3972D'}; %beacon 1,2,3,4,5,6,7
    powers(indices)=5; %max power is 5 dbm
    notSelected=setdiff(1:7,indices);
    powers(notSelected)=-40; %minimum power is -40 dbm
   
    xlswrite(filename,SIDS,sheet,xlRange1)
    xlswrite(filename,powers,sheet,xlRange2)
     
end