%plot current configuration
sizeOfGrid=50;
t=linspace(0,2*pi,8);
t=t(1:end-1); %to remove redundant point
sensorPos=[pos'.*cos(t);pos'.*sin(t)];
sourcePos=[0;0];
FCPos=[30;30];

%create board boundaries
t=linspace(0,2*pi,100);
boardPos=[20*cos(t);20*sin(t)];

hold on
scatter([-sizeOfGrid 0 sizeOfGrid],[-sizeOfGrid 0 sizeOfGrid],1,'MarkerEdgeColor','w') %Just to get right display
axescenter(gca)
scatter(sensorPos(1,:),sensorPos(2,:),20,'MarkerEdgeColor','b','MarkerFaceColor','b','LineWidth',1)
scatter(sourcePos(1),sourcePos(2),40,'MarkerEdgeColor','r','MarkerFaceColor','r','LineWidth',1)
scatter(FCPos(1),FCPos(2),50,'MarkerEdgeColor','g','MarkerFaceColor','g','LineWidth',1)
plot(boardPos(1,:),boardPos(2,:),'m')
set(gca,'xminorgrid','on','yminorgrid','on')

