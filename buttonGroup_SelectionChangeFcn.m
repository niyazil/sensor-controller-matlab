% --- Executes when selected object is changed in uipanel1.
function buttonGroup_SelectionChangeFcn(hObject, callbackdata, handles,fileName)
% hObject    handle to the selected object in uipanel1 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
	
		% Get the values of the radio buttons in this group.
		radio1Value = get(handles{1},'Value');
		radio2Value = get(handles{2},'Value');
		radio3Value = get(handles{3},'Value');
        
		% Now do some code that depends on their values.
       
        
        if radio1Value==1
          sheet=1;  
        elseif radio2Value==1
          sheet=2;      
        else
          sheet=3;  
        end
        
        initialConfigPlot(fileName,sheet);
		
end