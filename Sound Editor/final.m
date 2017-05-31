function varargout = final(varargin)
% FINAL MATLAB code for final.fig
%      FINAL, by itself, creates a new FINAL or raises the existing
%      singleton*.
%
%      H = FINAL returns the handle to a new FINAL or the handle to
%      the existing singleton*.
%
%      FINAL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FINAL.M with the given input arguments.
%
%      FINAL('Property','Value',...) creates a new FINAL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before final_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to final_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help final

% Last Modified by GUIDE v2.5 28-Dec-2015 14:47:04

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @final_OpeningFcn, ...
                   'gui_OutputFcn',  @final_OutputFcn, ...
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


% --- Executes just before final is made visible.
function final_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to final (see VARARGIN)

% Choose default command line output for final
handles.output = hObject;

% create an axes that spans the whole gui
ah = axes('unit', 'normalized', 'position', [0 0 1 1]); 
% import the background image and show it on the axes
bg = imread('background.jpg'); imagesc(bg);
% prevent plotting over the background and turn the axis off
set(ah,'handlevisibility','off','visible','off')
% making sure the background is behind all the other uicontrols
uistack(ah, 'bottom');

set(handles.play1, 'UserData',0); % set initial value means that this button has not pressed yet
set(handles.play2, 'UserData',0);
set(handles.Record1, 'UserData',0);
set(handles.StopRecording1, 'Enable','off');
set(handles.Record2, 'UserData',0);
set(handles.StopRecording2, 'Enable','off');
set(handles.first_edit, 'Enable','off');
set(handles.second_edit, 'Enable','off');
set(handles.first_save, 'Enable','off');
set(handles.second_save, 'Enable','off');
% Update handles structure
guidata(hObject, handles);


% UIWAIT makes final wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = final_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in import1.
function import1_Callback(hObject, eventdata, handles)
% hObject    handle to import1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global editChecker;
editChecker = 0;



[filename1 pathname1]= uigetfile({'*.wav'},'File Selector');
fullpathname1 = strcat (pathname1, filename1);
set (handles.first_edit, 'UserData',fullpathname1);% store the audio details in this button just to be able to retrive the  details in the other file "edit"
%disp(handles.first_edit.UserData);

[snd,FS]=audioread(fullpathname1);
TotalTime = length(snd) ./ FS ; % in seconds
set(handles.slider1, 'min', 0);
set(handles.slider1, 'max', TotalTime+1);
set(handles.slider1,'Value',0);
displayTemp=sec2hms(TotalTime);
set(handles.FullTimeOfWav1,'String',displayTemp);

handles.snd1 =snd;
handles.FS1 =FS;
guidata(hObject, handles);

axes(handles.axes1);
plot(snd);

set(handles.first_edit, 'Enable','on');
set(handles.first_save, 'Enable','off');


% --- Executes on button press in play1.
function play1_Callback(hObject, eventdata, handles)
% hObject    handle to play1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(hObject, 'UserData')==0 && get(handles.play2, 'UserData')==0   % check if there is audio running at the moment or not
  
    set (handles.stop1, 'UserData',0); % while UserData =0 that is mean no body pressed stop1 button
    global editCheckerButton1; % this veriable coming from edit file
    
    if (editCheckerButton1 == 1) % if we are coming from edit
    
    global movingSnd;   % this veriable coming from edit file
    snd =movingSnd;
    global movingFs;    % this veriable coming from edit file
    FS=movingFs;
    
    set(handles.first_save,'Enable','on');
    TotalTime = length(snd) ./ FS ; % in seconds
    set(handles.slider1, 'min', 0);
    set(handles.slider1, 'max', TotalTime+1);
    set(handles.slider1,'Value',0);
    displayTemp=sec2hms(TotalTime);
    set(handles.FullTimeOfWav1,'String',displayTemp)
    handles.snd1 =snd;
    handles.FS1 =FS;
    guidata(hObject, handles);
    axes(handles.axes1);
    plot(snd);
    
    editCheckerButton1 = 0;
    set(handles.first_save, 'Enable','on');


    end
   
     
    snd=handles.snd1;
    FS=handles.FS1;

    startingPoint= get(handles.slider1,'Value');
    if(startingPoint == 0)
    startingPoint=startingPoint+0.0001;
    end
    
    TotalTime = length(snd) ./ FS  ;
    


 if  (startingPoint < TotalTime) 

    temp=snd(startingPoint * FS : length(snd));
    y = audioplayer(temp,FS);
    TotalTime = length(snd) ./ FS ; % in seconds
    play(y);
    set(hObject, 'UserData',1); %  there is audio running at the moment
    
    handles.wav1Stopper =y;         % take value of y in order to be able to stop the file in stop1 button
    guidata(hObject, handles);

   

    time = startingPoint;
    while and(time <= TotalTime, get(handles.stop1, 'UserData')== 0)  % check if any one pressed stop1 button to stop slider1 or the music has finished

        time=time+1;  
        displayTime=sec2hms(time);
        set(handles.timeOfWav1,'String',displayTime);
        set(handles.slider1,'Value',time);
        pause(1); %Wait 1 second

    end
         

     if  get(handles.stop1, 'UserData')== 0  % check if  stop1 button has not clicked but the audio has finished
         %set(handles.slider1, 'Value', TotalTime); 
         %set(handles.timeOfWav1,'String',sec2hms(TotalTime));
         % pause(0.2); %Wait 1 second
         set(handles.timeOfWav1,'String',sec2hms(0));
         set(handles.slider1, 'Value', 0);
         set(hObject, 'UserData',0); % the audio is finished now so you can play it again!
     end
end  % end if
end 

% --- Executes on button press in stop1.
function stop1_Callback(hObject, eventdata, handles)
% hObject    handle to stop1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 stop(handles.wav1Stopper);
 set (hObject, 'UserData',1);  % this means that this button is pressed now!
 set(handles.play1, 'UserData',0);  % this means that there is no audio running at the moment
 
  

% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
myVal=get(hObject,'Value');
valInTimeFormat=sec2hms(myVal);
set(handles.timeOfWav1,'String',valInTimeFormat);

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end




% --- Executes on button press in import2.
function import2_Callback(hObject, eventdata, handles)
% hObject    handle to import2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global editChecker;
editChecker = 0;

[filename2 pathname2]= uigetfile({'*.wav'},'File Selector');
fullpathname2 = strcat (pathname2, filename2);
set (handles.second_edit, 'UserData',fullpathname2);   % store the audio details in this button just to be able to retrive the  details in the other file "edit"
disp(handles.second_edit.UserData);

[snd,FS]=audioread(fullpathname2);
TotalTime = length(snd) ./ FS ; % in seconds
set(handles.slider2, 'min', 0);
set(handles.slider2, 'max', TotalTime+1);
set(handles.slider2,'Value',0);
displayTemp=sec2hms(TotalTime);
set(handles.FullTimeOfWav2,'String',displayTemp);

handles.snd2 =snd;
handles.FS2 =FS;
guidata(hObject, handles);

axes(handles.axes2);
plot(snd);


set(handles.second_save, 'Enable','off');
set(handles.second_edit, 'Enable','on');



% --- Executes on button press in play2.
function play2_Callback(hObject, eventdata, handles)
% hObject    handle to play2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(hObject, 'UserData')==0 && get(handles.play1, 'UserData')==0  % check if there is audio running at the moment or not
  
    set (handles.stop2, 'UserData',0); % while UserData =0 that is mean no body pressed stop1 button
    global editCheckerButton2; % this veriable coming from edit file
    
    if (editCheckerButton2 == 1) % if we are coming from edit
    
    global movingSnd;   % this veriable coming from edit file
    snd =movingSnd;
    global movingFs;    % this veriable coming from edit file
    FS=movingFs;
    
    TotalTime = length(snd) ./ FS ; % in seconds
    set(handles.slider2, 'min', 0);
    set(handles.slider2, 'max', TotalTime+1);
    set(handles.slider2,'Value',0);
    displayTemp=sec2hms(TotalTime);
    set(handles.FullTimeOfWav2,'String',displayTemp)
    handles.snd2 =snd;
    handles.FS2 =FS;
    guidata(hObject, handles);
    axes(handles.axes2);
    plot(snd);
    

     set(handles.second_save, 'Enable','on');
    editCheckerButton2 = 0;

    end
   
     
    snd=handles.snd2;
    FS=handles.FS2;

    startingPoint= get(handles.slider2,'Value');
    if(startingPoint == 0)
    startingPoint=startingPoint+0.0001;
    end
      TotalTime = length(snd) ./ FS  ;
 
 if  (startingPoint < TotalTime) 

    temp=snd(startingPoint * FS : length(snd));
    y = audioplayer(temp,FS);
    TotalTime = length(snd) ./ FS ; % in seconds
    play(y);
    set(hObject, 'UserData',1); %  there is audio running at the moment
    
    handles.wav2Stopper =y;         % take value of y in order to be able to stop the file in stop1 button
    guidata(hObject, handles);

   

    time = startingPoint;
    while and(time <= TotalTime, get(handles.stop2, 'UserData')== 0)  % check if any one pressed stop1 button to stop slider2 or the music has finished

        time=time+1;  
        displayTime=sec2hms(time);
        set(handles.timeOfWav2,'String',displayTime);
        set(handles.slider2,'Value',time);
        pause(1); %Wait 1 second

    end
         

     if  get(handles.stop2, 'UserData')== 0  % check if  stop1 button has not clicked but the audio has finished
         %set(handles.slider1, 'Value', TotalTime); 
         %set(handles.timeOfWav1,'String',sec2hms(TotalTime));
         % pause(0.2); %Wait 1 second
         set(handles.timeOfWav2,'String',sec2hms(0));
         set(handles.slider2, 'Value', 0);
         set(hObject, 'UserData',0); % the audio is finished now so you can play it again!
     end
end  % end if
end 

% --- Executes on button press in stop2.
function stop2_Callback(hObject, eventdata, handles)
% hObject    handle to stop2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 stop(handles.wav2Stopper);
 set (hObject, 'UserData',1);  % this means that this button is pressed now!
 set(handles.play2, 'UserData',0);  % this means that there is no audio running at the moment
 

% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
myVal=get(hObject,'Value');
valInTimeFormat=sec2hms(myVal);
set(handles.timeOfWav2,'String',valInTimeFormat);

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in second_edit.
function second_edit_Callback(hObject, eventdata, handles)
% hObject    handle to second_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global movingSnd;
movingSnd=handles.snd2;

global movingFs;
movingFs=handles.FS2;

global firstbutton;
firstbutton=0;

global secondbutton;
secondbutton=1;
edit;

 
% --- Executes on button press in first_edit.
function first_edit_Callback(hObject, eventdata, handles)
% hObject    handle to first_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global movingSnd;
movingSnd=handles.snd1;

global movingFs;
movingFs=handles.FS1;

global firstbutton;
firstbutton=1;

global secondbutton;
secondbutton=0;
edit;
 


% --- Executes on button press in Record1.
function Record1_Callback(hObject, eventdata, handles)
% hObject    handle to Record1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
   
    set(handles.Record1,'string','Recording...');
    set(handles.first_save,'Enable','on');
    set(hObject,'UserData',1);
    rec = audiorecorder(44100, 16, 2);
    record(rec) 
    
    handles.rac =rec;
    guidata(hObject, handles);
    set(handles.StopRecording1, 'Enable','on');

 

 


% --- Executes on button press in StopRecording1.
function StopRecording1_Callback(hObject, eventdata, handles)
% hObject    handle to StopRecording1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(handles.Record1,'UserData')==1
    
    set(handles.StopRecording1, 'Enable','off');
    set(handles.Record1,'string','Record');
    set(handles.Record1,'UserData',0);
    
    r= handles.rac ;
    result = getaudiodata(r);
   
    %sound(result, 44100);
    set(hObject,'UserData',0);
    set(handles.Record1,'string','Record');
    
    TotalTime = length(result) ./ 44100 ; % in seconds
    set(handles.slider1, 'min', 0);
    set(handles.slider1, 'max', TotalTime+1);
    set(handles.slider1,'Value',0);
    displayTemp=sec2hms(TotalTime);
    set(handles.FullTimeOfWav1,'String',displayTemp);

    handles.snd1 =result;
    handles.FS1 =44100;
    guidata(hObject, handles);

    axes(handles.axes1);
    plot(result);
    
    
end


% --- Executes on button press in Record2.
function Record2_Callback(hObject, eventdata, handles)
% hObject    handle to Record2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    set(handles.Record2,'string','Recording...');
    set(handles.second_save,'Enable','on');
    set(hObject,'UserData',1);
    rec = audiorecorder(44100, 16, 2);
    record(rec) 
    
    handles.rac =rec;
    guidata(hObject, handles);
    set(handles.StopRecording2, 'Enable','on');


% --- Executes on button press in StopRecording2.
function StopRecording2_Callback(hObject, eventdata, handles)
% hObject    handle to StopRecording2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if get(handles.Record2,'UserData')==1
    
    set(handles.StopRecording2, 'Enable','off');
    set(handles.Record2,'string','Record');
    set(handles.Record2,'UserData',0);
    
    r= handles.rac ;
    result = getaudiodata(r);
   
    %sound(result, 44100);
    set(hObject,'UserData',0);
    set(handles.Record2,'string','Record');
    
    TotalTime = length(result) ./ 44100 ; % in seconds
    set(handles.slider2, 'min', 0);
    set(handles.slider2, 'max', TotalTime+1);
    set(handles.slider2,'Value',0);
    displayTemp=sec2hms(TotalTime);
    set(handles.FullTimeOfWav2,'String',displayTemp);

    handles.snd2 =result;
    handles.FS2 =44100;
    guidata(hObject, handles);

    axes(handles.axes2);
    plot(result);
    
    set(handles.second_edit, 'Enable','on');
end


 


% --- Executes on button press in join.
function join_Callback(hObject, eventdata, handles)
% hObject    handle to join (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


[nfname,npath]=uiputfile('.wav','Save audio','new_sound.wav');
if isequal(nfname,0) || isequal(npath,0)
   return  % or whatever other action if 'CANCEL'
else
  nwavfile=fullfile(npath,nfname);
  final_audio = [handles.snd1 ;handles.snd2]; % collect the final virsion 
  audiowrite(nwavfile , final_audio , handles.FS1);      % fill in appropriate other arguments
end


% --- Executes on button press in first_save.
function first_save_Callback(hObject, eventdata, handles)
% hObject    handle to first_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[nfname,npath]=uiputfile('.wav','Save audio','new_sound.wav');
if isequal(nfname,0) || isequal(npath,0)
   return  % or whatever other action if 'CANCEL'
else
  nwavfile=fullfile(npath,nfname);
  audiowrite(nwavfile , handles.snd1, handles.FS1);   
end

% --- Executes on button press in second_save.
function second_save_Callback(hObject, eventdata, handles)
% hObject    handle to second_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


[nfname,npath]=uiputfile('.wav','Save audio','new_sound.wav');
if isequal(nfname,0) || isequal(npath,0)
   return  % or whatever other action if 'CANCEL'
else
  nwavfile=fullfile(npath,nfname);
  audiowrite(nwavfile , handles.snd2, handles.FS2);   
end
