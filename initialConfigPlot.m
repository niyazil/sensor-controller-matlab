function initialConfigPlot(fileName,sheet)

%read positions
    pos=xlsread(fileName,sheet,'N2:N8');
    numSensorsDeployed=length(pos);

    FC_pos=[21,0];

    %source statistics
    varTheta=60.811325;
    meanTheta=180.59;
    
    %plot current configuration
    sizeOfGrid=40;
    t=linspace(0,2*pi,8);
    t=t(1:end-1); %to remove redundant point
    sensorPos=[pos'.*cos(t);pos'.*sin(t)];
    sourcePos=[0;0];
    FCPos=[25;0];
    
    %create board boundaries
    t=linspace(0,2*pi,100);
    boardPos=[20*cos(t);20*sin(t)];

    cla
    hold on
    grid on
    scatter([-sizeOfGrid 0 sizeOfGrid],[-sizeOfGrid 0 sizeOfGrid],1,'MarkerEdgeColor','w') %Just to get right display
    %axescenter(gca)
    scatter(sensorPos(1,:),sensorPos(2,:),40,'MarkerEdgeColor','b','MarkerFaceColor','b','LineWidth',1)
    scatter(sourcePos(1),sourcePos(2),60,'MarkerEdgeColor','k','MarkerFaceColor','y','LineWidth',1)
    scatter(FCPos(1),FCPos(2),60,'MarkerEdgeColor','k','MarkerFaceColor','g','LineWidth',1)
    plot(boardPos(1,:),boardPos(2,:),'k','LineWidth',1)
    %set(gca,'xminorgrid','on','yminorgrid','on')
    set(gca,'Box','On')
    axis square


end