

figure('Color','w', 'Menubar','none');
hEditbox = uicontrol('Style','edit', 'Pos',[100,100,60,20], 'String','Matlab');  % start with an invalid string
hMessageLabel = uicontrol('Style','text', 'Pos',[180,100,300,20], 'horizontal','left', 'Foreground','red');

addpath('./fncview');
jEditbox = findjobj(hEditbox)  % single-line editbox so there's need to drill-down the scroll-pane
findobj(hEditbox)
set(jEditbox, 'KeyPressedCallback',{@editboxValidation,hMessageLabel});


% Note how we trick Matlab by using eventData as a struct rather than a Java object
% (i.e., getKeyChar is set here to be a simple struct field, rather than a Java method)
eventData.getKeyChar = '';
editboxValidation(jEditbox,eventData,hMessageLabel)

