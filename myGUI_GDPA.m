function varargout=myGUI_GDPA(varargin)
%% Initialization tasks

    fh=figure('Visible','off');
    fileName='configs-matlab1.xlsx';

%% Construct the components

    %Create panels for input and output display
    p1=uipanel(fh,'Units','normalized','Position',[0.1 0.1 0.25 0.65]);
    p2=uipanel(fh,'Units','normalized','Position',[0.4 0.1 0.55 0.8]);
    
    bg=uibuttongroup(fh,'Title','Choose a configuration:','Units','normalized','Position',[0.1 0.79 0.25 0.13]); 
    r1=uicontrol(bg,'Style','radiobutton','String','Configuration 1','Value',0,'Units','normalized','Position',[0.1,0.79 0.25 0.13]);
    r2=uicontrol(bg,'Style','radiobutton','String','Configuration 2','Value',0,'Units','normalized','Position',[0.1,0.5 0.25 0.13]);
    r3=uicontrol(bg,'Style','radiobutton','String','Configuration 3','Value',0,'Units','normalized','Position',[0.1,0.21 0.25 0.13]);
    radioButtons={r1,r2,r3};
    set(bg,'SelectionChangeFcn',{@buttonGroup_SelectionChangeFcn, radioButtons,fileName});
 
    ax=axes('Parent',p2,'Units','normalized','Position',[0.1 0.1 0.6 0.8]);
    grid on
%     
    txtLabel1=uicontrol(p2,'Style','text','String','Estimate','Units','normalized','Position',[0.778 0.8 0.194 0.073]);
    txt1=uicontrol(p2,'Style','text','String','','Units','normalized','Position',[0.778 0.75 0.09 0.06],'backgroundcolor',[1 1 1]);
    txtLabel2=uicontrol(p2,'Style','text','String','Distortion','Units','normalized','Position',[0.778 0.6 0.194 0.073]);
    txt2=uicontrol(p2,'Style','text','String','','Units','normalized','Position',[0.778 0.55 0.194 0.073],'backgroundcolor',[1 1 1]);
    txtLabel3=uicontrol(p2,'Style','text','String','Number of active sensors','Units','normalized','Position',[0.778 0.4 0.194 0.073]);
    txt3=uicontrol(p2,'Style','text','String','','Units','normalized','Position',[0.778 0.35 0.194 0.073],'backgroundcolor',[1 1 1]);
    txtLabel4=uicontrol(p2,'Style','text','String','Total power','Units','normalized','Position',[0.778 0.2 0.194 0.073]);
    txt4=uicontrol(p2,'Style','text','String','','Units','normalized','Position',[0.778 0.15 0.194 0.073],'backgroundcolor',[1 1 1]);
    editBoxes={txt1,txt2,txt3,txt4};
    
    editLabel1=uicontrol(p1,'Style','text','String','Distortion threshold','Units','normalized','Position',[0.0 0.9 0.2 0.073]);
    edit1=uicontrol(p1,'Style','edit','String','','Units','normalized','Position',[0.4 0.9 0.09 0.06]);
    editLabel2=uicontrol(p1,'Style','text','String','Noise','Units','normalized','Position',[0.0 0.5 0.2 0.073]);
    edit2=uicontrol(p1,'Style','edit','String','','Units','normalized','Position',[0.4 0.5 0.09 0.06]);
    editLabel3=uicontrol(p1,'Style','text','String','Noise variance','Units','normalized','Position',[0.0 0.3 0.2 0.073]);
    edit3=uicontrol(p1,'Style','edit','String','','Units','normalized','Position',[0.4 0.3 0.09 0.06]);
    editLabel4=uicontrol(p1,'Style','text','String','Path-loss component','Units','normalized','Position',[0.0 0.1 0.2 0.073]);
    edit4=uicontrol(p1,'Style','edit','String','','Units','normalized','Position',[0.4 0.1 0.09 0.06]);
    
    pb1 = uicontrol(p1,'Style','pushbutton','String','Run simulation','Position',[50 20 60 40]);
%% Initialization tasks

    
    %initialize to configuration 1 which is selected by default
    initialConfigPlot(fileName,1);
     
    set(fh,'Visible','on');
    
%% Callbacks

%% Utitilty functions

    

end