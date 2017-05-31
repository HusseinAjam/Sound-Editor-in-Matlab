function varargout = edit(varargin)
% EDIT MATLAB code for edit.fig
%      EDIT, by itself, creates a new EDIT or raises the existing
%      singleton*.
%
%      H = EDIT returns the handle to a new EDIT or the handle to
%      the existing singleton*.
%
%      EDIT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EDIT.M with the given input arguments.
%
%      EDIT('Property','Value',...) creates a new EDIT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before edit_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to edit_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help edit

% Last Modified by GUIDE v2.5 28-Dec-2015 20:46:44

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @edit_OpeningFcn, ...
                   'gui_OutputFcn',  @edit_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before edit is made visible.
function edit_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to edit (see VARARGIN)

% Choose default command line output for edit
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

 

global movingSnd;
snd=movingSnd;

global movingFs;
FS=movingFs;

TotalTime = length(snd) ./ FS ; % in seconds

set(handles.StartFrom, 'min', 0);
set(handles.StartFrom, 'max', TotalTime);
set(handles.StartFrom,'Value',0);
set(handles.EndIn, 'min', 0);
set(handles.EndIn, 'min', 0);
set(handles.EndIn, 'max', TotalTime);


handles.edit_snd =snd;
handles.edit_FS =FS;
guidata(hObject, handles);

plot(snd);

% UIWAIT makes edit wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = edit_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;





% --- Executes during object creation, after setting all properties.
function edit_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function start_from_Callback(hObject, eventdata, handles)
% hObject    handle to start_from (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of start_from as text
%        str2double(get(hObject,'String')) returns contents of start_from as a double_times


% --- Executes during object creation, after setting all properties.
function start_from_CreateFcn(hObject, eventdata, handles)
% hObject    handle to start_from (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function end_in_Callback(hObject, eventdata, handles)
% hObject    handle to end_in (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of end_in as text
%        str2double(get(hObject,'String')) returns contents of end_in as a double_times


% --- Executes during object creation, after setting all properties.
function end_in_CreateFcn(hObject, eventdata, handles)
% hObject    handle to end_in (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in crop.
function crop_Callback(hObject, eventdata, handles)
% hObject    handle to crop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
snd=handles.edit_snd;
FS=handles.edit_FS;
start=get(handles.StartFrom,'Value');
last=get(handles.EndIn, 'Value');

after_crop=snd(start* FS : last * FS, :);

%sound(after_crop, FS);

TotalTime = length(after_crop) ./ FS ; % in seconds
 
set(handles.StartFrom, 'min', 0);
set(handles.StartFrom, 'max', TotalTime);
set(handles.StartFrom,'Value',0);
set(handles.EndIn, 'min', 0);
set(handles.EndIn, 'min', 0);
set(handles.EndIn, 'max', TotalTime);


handles.edit_snd =after_crop;
handles.edit_FS =FS;
guidata(hObject, handles);

plot(snd);

  


 


% --- Executes on button press in speed_up.
function speed_up_Callback(hObject, eventdata, handles)
% hObject    handle to speed_up (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

snd=handles.edit_snd;
FS=handles.edit_FS;

start=get(handles.StartFrom,'Value')
start= start+0.01;

last=get(handles.EndIn, 'Value');

TotalTime = length(snd) ./ FS ; % in seconds

temp1= snd(1 :start * FS, :);   % from the begining to the first changed second.
temp2= snd(start * FS : last * FS , :); % the part which supposed to have speed change.
temp3= snd(last * FS : TotalTime * FS, :); %the last changed second to the end of the file

 
checker= get(handles.groupOne,'SelectedObject');
choise = get(checker,'String');

if strcmp(choise,'Double Times')
  temp2= downsample(temp2,2);
else if strcmp(choise,'Triple Times')
  temp2= downsample(temp2,3);
    else
        temp2= downsample(temp2,1);
    end 
end


y3 = [temp1 ;temp2;temp3 ]; % collect the final virsion 

handles.edit_snd =y3;
guidata(hObject, handles);

TotalTime = length(y3) ./ FS ; % changing the total time accourding to the length of the new sounf file
 
set(handles.StartFrom, 'min', 0);
set(handles.StartFrom, 'max', TotalTime);
set(handles.StartFrom,'Value',0);
set(handles.EndIn, 'min', 0);
set(handles.EndIn, 'max', TotalTime);
set(handles.EndIn,'Value',0);


plot(y3);


%sound(y3,FS);
     
 


% --- Executes on button press in speed_down.
function speed_down_Callback(hObject, eventdata, handles)
% hObject    handle to speed_down (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

snd=handles.edit_snd;
FS=handles.edit_FS;

start=get(handles.StartFrom,'Value');
start = start + 0.01;
last=get(handles.EndIn, 'Value');


TotalTime = length(snd) ./ FS ; % in seconds

temp1= snd(1 :start * FS, :);   % from the begining to the first changed second.
temp2= snd(start * FS : last * FS , :); % the part which supposed to have speed change.
temp3= snd(last * FS : TotalTime * FS, :); %the last changed second to the end of the file

 
checker= get(handles.groupTwo,'SelectedObject');
choise = get(checker,'String');

if strcmp(choise,'0.5 Time')
  temp2= upsample(temp2,2);
else if strcmp(choise,'0.25 Time')
  temp2= upsample(temp2,3);
    else
  temp2= upsample(temp2,1);
    end 
end


y3 = [temp1 ;temp2;temp3 ]; % collect the final virsion 

handles.edit_snd =y3;
guidata(hObject, handles);

TotalTime = length(y3) ./ FS ; % changing the total time accourding to the length of the new sounf file
 

set(handles.StartFrom, 'min', 0);
set(handles.StartFrom, 'max', TotalTime);
set(handles.StartFrom,'Value',0);
set(handles.EndIn, 'min', 0);
set(handles.EndIn,'Value',0);
set(handles.EndIn, 'max', TotalTime);

plot(y3);

%sound(y3,FS);







% --- Executes on button press in finish.
function finish_Callback(hObject, eventdata, handles)
% hObject    handle to finish (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%set (handles.finish, 'UserData', handles.edit_snd);   % store the audio details in this button just to be able to retrive the  details in the other file "edit"
%sound(handles.edit_snd, handles.edit_FS);

global movingSnd;
movingSnd= handles.edit_snd;

global movingFs;
movingFs=handles.edit_FS;

global firstbutton;    % the left side audio comming (we have two audios places at the main GUI file)
global editCheckerButton1;

global secondbutton;    % the right side audio comming (we have two audios places at the main GUI file)
global editCheckerButton2;

if (firstbutton == 1)

editCheckerButton1=1;
editCheckerButton2=0;
end

if (secondbutton == 1)
editCheckerButton2=1;
editCheckerButton1=0;
end

close;
final;


% --- Executes on button press in cancel.
function cancel_Callback(hObject, eventdata, handles)
% hObject    handle to cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close;
final;



% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



% --- Executes during object creation, after setting all properties.
function edit_play_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_play (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2


% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu8.
function popupmenu8_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu8 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu8


% --- Executes during object creation, after setting all properties.
function popupmenu8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in normal_down.
function normal_down_Callback(hObject, eventdata, handles)
% hObject    handle to normal_down (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of normal_down


% --- Executes on button press in first_down.
function first_down_Callback(hObject, eventdata, handles)
% hObject    handle to first_down (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of first_down


% --- Executes on button press in second_down.
function second_down_Callback(hObject, eventdata, handles)
% hObject    handle to second_down (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of second_down


% --- Executes on button press in normal_up.
function normal_up_Callback(hObject, eventdata, handles)
% hObject    handle to normal_up (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of normal_up


% --- Executes on button press in double_times.
function double_times_Callback(hObject, eventdata, handles)
% hObject    handle to double_times (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of double_times


% --- Executes on button press in triple_times.
function triple_times_Callback(hObject, eventdata, handles)
% hObject    handle to triple_times (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of triple_times


% --- Executes on slider movement.
function StartFrom_Callback(hObject, eventdata, handles)
% hObject    handle to StartFrom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

myVal=get(hObject,'Value');
valInTimeFormat=sec2hms(myVal);
set(handles.StartPointTimer,'String',valInTimeFormat);
set(handles.EndPointTimer,'String',valInTimeFormat);

set(handles.EndIn, 'min', myVal);
set(handles.EndIn,'Value',myVal);


% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function StartFrom_CreateFcn(hObject, eventdata, handles)
% hObject    handle to StartFrom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function EndIn_Callback(hObject, eventdata, handles)
% hObject    handle to EndIn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
myVal=get(hObject,'Value');
valInTimeFormat=sec2hms(myVal);
set(handles.EndPointTimer,'String',valInTimeFormat);

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function EndIn_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EndIn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in filter.
function filter_Callback(hObject, eventdata, handles)
% hObject    handle to filter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)





% --- Executes on button press in Reverse.
function Reverse_Callback(hObject, eventdata, handles)
% hObject    handle to Reverse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

snd=handles.edit_snd;
FS=handles.edit_FS;

start=get(handles.StartFrom,'Value')
start= start+0.01;

TotalTime = length(snd) ./ FS ; % in seconds
last=get(handles.EndIn, 'Value');

temp1= snd(1 :start * FS, :);   % from the begining to the first changed second.
temp2= snd(start * FS : last * FS , :); % the part which supposed to be reverced.
temp3= snd(last * FS : TotalTime * FS, :); %from the last changed second to the end of the file

rev = flipud(temp2); %Reverce the selected part 

y3 = [temp1 ;rev;temp3 ]; % Re combine all parts together with the changed one inside

plot(y3); % Update the figure with new signal
handles.edit_snd =y3;
guidata(hObject, handles);
