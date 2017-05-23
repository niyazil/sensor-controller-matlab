% --- Executes when Run simulations is clicked

function runSimulations_Callback(hObject, callbackdata,handlesEdit,handlesRadio,handleInfeasible,handlesDisplay,fileName)
        
        % Get the values of the radio buttons in this group.
		radio1Value = get(handlesRadio{1},'Value');
		radio2Value = get(handlesRadio{2},'Value');
		radio3Value = get(handlesRadio{3},'Value');
        
		% Now do some code that depends on their values.
       
        
        if radio1Value==1
          sheet=1;  
        elseif radio2Value==1
          sheet=2;      
        else
          sheet=3;  
        end

    pos=xlsread(fileName,sheet,'N2:N8');
    numSensorsDeployed=length(pos);

    FC_pos=[21,0];
    feasible=true;

    %source statistics
    varTheta=60.811325;
    meanTheta=180.59;
    
    %max and min powers in linear scale
    Pmax=10^(5/10); %5 dbm to mW
%     Pmin=10^(-40/10); %-40 dbm to mW
    Pactive=23.4; %in mW
    
    %get contents of edit boxes
    Dthres=str2double(get(handlesEdit{1},'String'));
    v=str2double(get(handlesEdit{2},'String'));
    noiseVar=str2double(get(handlesEdit{3},'String'));
    gamma=str2double(get(handlesEdit{4},'String'));
    
    
    [Rthetax,Rx,DpAllOn,Rv,DhAllOn,Rv_prime,v]=config_stats_power_allocation(pos,FC_pos,varTheta,meanTheta,noiseVar,v,gamma,Pmax,fileName,sheet);
      
      

    %minimum distortion when ALL sensors are on
    DistMIN=varTheta+meanTheta^2-Rthetax'*DpAllOn*inv(DpAllOn*Rx*DpAllOn+Rv)*DpAllOn*Rthetax;
    
    if(DistMIN>Dthres)
    feasible=false;
    set(handleInfeasible,'String','Infeasible!','Visible','On');
    refresh
    
    elseif(Dthres>varTheta+meanTheta^2)
    set(handleInfeasible,'String','No need for a sensor network with that threshold!','Visible','On');
        
    else
    set(handleInfeasible,'Visible','Off');
    refresh
    
    %vector to indicate whether sensor has been selected or not- initialized to
%false
selected=false(1,numSensorsDeployed);

%vector to store distortion values as selection occurs
distVal=[varTheta+meanTheta^2 varTheta+meanTheta^2];

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
       DhAllOn_Alg=DhAllOn(subsets(bestComb,:),subsets(bestComb,:));
       Rv_prime_Alg=Rv_prime(subsets(bestComb,:),subsets(bestComb,:));
       
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
      DhAllOn_Alg=DhAllOn(indices,indices);
      Rthetax_Alg=Rthetax(indices);
      Rx_Alg=Rx(indices,indices);
      Rv_Alg=Rv(indices,indices);
      Rv_prime_Alg=Rv_prime(indices,indices);
      
      currentDist=bestDist;
      distVal(k)=currentDist;
  end

  %% Power Allocation
    options=optimoptions(@fmincon,'MaxFunEvals',50000);
    P0=Pmax*ones(1,length(indices)); %to ensure initial point is feasible
    lb=zeros(1,length(indices));
    ub=Pmax*ones(1,length(indices));
    
    [P,fval,exitFlag]=fmincon(@objfun,P0,[],[],[],[],lb,ub,@(P)confun(P,varTheta,meanTheta,DpAllOn_Alg,Rthetax_Alg,Rx_Alg,Rv_Alg,Dthres,Pmax),options)
    
    temp=diag(DpAllOn_Alg/sqrt(Pmax)); %replace Pmax entries with new powers for each sensor
    Dp_Alg=diag(temp'.*sqrt(P));
    temp=diag(DhAllOn_Alg/sqrt(Pmax));
    Dh_Alg=diag(temp'.*sqrt(P));
   
    reducedDist=varTheta+meanTheta^2-Rthetax_Alg'*Dp_Alg*inv(Dp_Alg*Rx_Alg*Dp_Alg+Rv_Alg)*Dp_Alg*Rthetax_Alg;
    totalTransmitPower=fval;
    
    powers_dbm=10*log10(P);
    
    %% Estimation
    
%x=xlsread(fileName,'B2:B8');

%x=[42.75	33.5	33.25	36	38.75	34.75	39]'; %configuration 1 at minute 2
%x=[54.5	48.25	44.5	45.75	46	49	46.25]'; %configuration 1 at minute 25
%x=[50.25	48.25	41	42.5	42.75	49	42.25]'; %configuration 1 at minute 50
%x=[28	26.75	30	26.25	38.75	31	31.5]'; %configuration 2 at minute 2
%x=[31.75	29.75	41	29.25	50	38	42.25]'; %configuration 2 at minute 16
%x=[46.25	29.75	26.25	29.25	28	34.75	28.5]'; %configuration 3 at minute 2
%x=[66.5	37.25	26.25	36	31.75	45.75	31.5]'; %configuration 3 at minute 16

x=[42.75	33.5	33.25	36	38.75	34.75	39;28	26.75	30	26.25	38.75	31	31.5;46.25	29.75	26.25	29.25	28	34.75	28.5];
x=x(sheet,indices)';
v_Alg=v(indices);
theta=Rthetax_Alg'*DhAllOn_Alg*inv(DhAllOn_Alg*Rx_Alg*DhAllOn_Alg+Rv_prime_Alg)*DhAllOn_Alg*x+Rthetax_Alg'*DhAllOn_Alg*inv(DhAllOn_Alg*Rx_Alg*DhAllOn_Alg+Rv_prime_Alg)*v_Alg;
reducedTheta=Rthetax_Alg'*Dh_Alg*inv(Dh_Alg*Rx_Alg*Dh_Alg+Rv_prime_Alg)*Dh_Alg*x+Rthetax_Alg'*Dh_Alg*inv(Dh_Alg*Rx_Alg*Dh_Alg+Rv_prime_Alg)*v_Alg;
    end

  
  %update display
  numActiveSensors=length(indices);
  totalPower=totalTransmitPower+numActiveSensors*Pactive;
    set(handlesDisplay{1},'String',reducedTheta);
    set(handlesDisplay{2},'String',reducedDist);
    set(handlesDisplay{3},'String',length(indices));
    set(handlesDisplay{4},'String',totalPower);
    refresh
    
    
  %plot selection
   sizeOfGrid=40;
    t=linspace(0,2*pi,8);
    t=t(1:end-1); %to remove redundant point
    sensorPos=[pos'.*cos(t);pos'.*sin(t)];
    sourcePos=[0;0];
    FCPos=[25;0];
    
  for i=1:length(indices)
    pause(0.5)
    scatter(sensorPos(1,i),sensorPos(2,i),40,'MarkerEdgeColor','r','MarkerFaceColor','r','LineWidth',0.5)
  end

end