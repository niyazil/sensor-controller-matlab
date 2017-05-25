function varargout=myGUI_GDPA(varargin)
%% Initialization tasks
    set(0,'defaultfigurecolor',[0.941 0.941 0.941])
    fh=figure('Visible','off');
    fileName='configs-matlab1.xlsx';

%% Construct the components

    %Create panels for input and output display
    title=uicontrol(fh,'Style','text','String','Sensor Network Simulator','Units','normalized','Position',[0.18 0.85 0.7 0.12],'FontSize',48,'FontName','Cambria','FontWeight','bold','ForegroundColor',[0.1 0 0.3]);
    p1=uipanel(fh,'Units','normalized','Position',[0.1 0.1 0.2 0.45]);
    p2=uipanel(fh,'Units','normalized','Position',[0.35 0.1 0.6 0.74]);
    
    bg=uibuttongroup(fh,'Title','Choose a configuration:','Units','normalized','Position',[0.1 0.58 0.2 0.28],'FontSize',20,'FontName','Cambria'); 
    r1=uicontrol(bg,'Style','radiobutton','String','Configuration 1','Value',0,'Units','normalized','Position',[0.1 0.7 0.6 0.2],'FontSize',14,'FontName','Cambria');
    r2=uicontrol(bg,'Style','radiobutton','String','Configuration 2','Value',0,'Units','normalized','Position',[0.1 0.4 0.6 0.2],'FontSize',14,'FontName','Cambria');
    r3=uicontrol(bg,'Style','radiobutton','String','Configuration 3','Value',0,'Units','normalized','Position',[0.1 0.1 0.6 0.2],'FontSize',14,'FontName','Cambria');
    radioButtons={r1,r2,r3};
    set(bg,'SelectionChangeFcn',{@buttonGroup_SelectionChangeFcn, radioButtons,fileName});
 
    ax=axes('Parent',p2,'Units','normalized','Position',[0.03 0.1 0.6 0.8]);
    grid on
    
    txtLabel1=uicontrol(p2,'Style','text','String','Estimate','Units','normalized','Position',[0.728 0.6 0.09 0.086],'FontSize',14,'FontName','Cambria','HorizontalAlignment','right');
    txt1=uicontrol(p2,'Style','text','String','','Units','normalized','Position',[0.83 0.64 0.1 0.05],'backgroundcolor',[0.662745 0.662745 0.662745],'FontSize',14);
    txtLabel2=uicontrol(p2,'Style','text','String','Distortion','Units','normalized','Position',[0.728 0.5 0.09 0.086],'FontSize',14,'FontName','Cambria','HorizontalAlignment','right');
    txt2=uicontrol(p2,'Style','text','String','','Units','normalized','Position',[0.83 0.54 0.1 0.05],'backgroundcolor',[0.662745 0.662745 0.662745],'FontSize',14);
    txtLabel3=uicontrol(p2,'Style','text','String','Number of active sensors','Units','normalized','Position',[0.59 0.4 0.224 0.086],'FontSize',14,'FontName','Cambria','HorizontalAlignment','right');
    txt3=uicontrol(p2,'Style','text','String','','Units','normalized','Position',[0.83 0.44 0.1 0.05],'backgroundcolor',[0.662745 0.662745 0.662745],'FontSize',14);
    txtLabel4=uicontrol(p2,'Style','text','String','Total power','Units','normalized','Position',[0.67 0.3 0.141 0.086],'FontSize',14,'FontName','Cambria','HorizontalAlignment','right');
    txt4=uicontrol(p2,'Style','text','String','','Units','normalized','Position',[0.83 0.34 0.1 0.05],'backgroundcolor',[0.662745 0.662745 0.662745],'FontSize',14);
    txtLabel5=uicontrol(p2,'Style','text','String','Achievable distortion','Units','normalized','Position',[0.629 0.8 0.19 0.086],'FontSize',14,'FontName','Cambria','HorizontalAlignment','right');
    txt5=uicontrol(p2,'Style','text','String','','Units','normalized','Position',[0.83 0.84 0.1 0.05],'backgroundcolor',[0.662745 0.662745 0.662745],'FontSize',14);
    txtLabel6=uicontrol(p2,'Style','text','String','mW','Units','normalized','Position',[0.938276990185388 0.3402460456941998 0.03666630316248865 0.04839015817223132],'FontSize',14,'FontName','Cambria','HorizontalAlignment','right');
    txtLabel7=uicontrol(p2,'Style','text','String','° C','Units','normalized','Position',[0.9360959651035998 0.6337434094903331 0.02399127589967421 0.05542003514938424],'FontSize',14,'FontName','Cambria','HorizontalAlignment','right');
    
    handlesDisplay={txt1,txt2,txt3,txt4,txt5};
    editLabel1=uicontrol(p1,'Style','text','String','Distortion threshold','Units','normalized','Position',[0.1 0.8 0.6 0.1],'FontSize',14,'FontName','Cambria','HorizontalAlignment','right');
    edit1=uicontrol(p1,'Style','edit','String','','Units','normalized','Position',[0.75 0.83 0.17 0.08],'FontSize',14,'BackgroundColor',[0.839216 0.839216 0.839216]);
    editLabel2=uicontrol(p1,'Style','text','String','Noise','Units','normalized','Position',[0.1 0.65 0.6 0.1],'FontSize',14,'FontName','Cambria','HorizontalAlignment','right');
    edit2=uicontrol(p1,'Style','edit','String','','Units','normalized','Position',[0.75 0.68 0.17 0.08],'FontSize',14,'BackgroundColor',[0.839216 0.839216 0.839216]);
    editLabel3=uicontrol(p1,'Style','text','String','Noise variance','Units','normalized','Position',[0.1 0.5 0.6 0.1],'FontSize',14,'FontName','Cambria','HorizontalAlignment','right');
    edit3=uicontrol(p1,'Style','edit','String','','Units','normalized','Position',[0.75 0.53 0.17 0.08],'FontSize',14,'BackgroundColor',[0.839216 0.839216 0.839216]);
    editLabel4=uicontrol(p1,'Style','text','String','Path-loss exponent','Units','normalized','Position',[0.1 0.35 0.6 0.1],'FontSize',14,'FontName','Cambria','HorizontalAlignment','right');
    edit4=uicontrol(p1,'Style','edit','String','','Units','normalized','Position',[0.75 0.38 0.17 0.08],'FontSize',14,'BackgroundColor',[0.839216 0.839216 0.839216]);
    
    
    editBoxes={edit1,edit2,edit3,edit4};
    txtInfeasible=uicontrol(p1,'Style','text','String','Infeasible!','Units','normalized','Position',[0.2 0.068 0.6 0.1],'ForegroundColor','Red','FontSize',14,'Visible','off');     
    pb1 = uicontrol(p1,'Style','pushbutton','String','Run Simulation','Units','normalized','Position',[0.25 0.2 0.6 0.1],'FontSize',18,'FontName','Cambria','Callback',{@runSimulations_Callback,editBoxes,radioButtons,txtInfeasible,handlesDisplay,fileName});
    
%% Initialization tasks

    
    %initialize to configuration 1 which is selected by default
    initialConfigPlot(fileName,1);
     
    set(fh,'Visible','on');
    
%% Callbacks

%% Utitilty functions

    

end