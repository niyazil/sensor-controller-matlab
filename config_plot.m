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



M(1)=getframe();

%animated selection
for i=1:length(indices)
    pause(0.5)
    scatter(sensorPos(1,i),sensorPos(2,i),40,'MarkerEdgeColor','r','MarkerFaceColor','r','LineWidth',0.5)
    M(i+1)=getframe();
end

% use 1st frame to get dimensions
[h, w, p] = size(M(1).cdata);
hf = figure; 
% resize figure based on frame's w x h, and place at (150, 150)
set(hf,'Position', [150 150 w h]);
axis off
% Place frames at bottom left
movie(hf,M,1,1,[0 0 0 0]);

%save movie
movie2avi(M,'GDPA_selection','Compression','None','fps',1)


