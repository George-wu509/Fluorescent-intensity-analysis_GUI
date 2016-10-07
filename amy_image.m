function varargout = amy_image(varargin)
% AMY_IMAGE MATLAB code for amy_image.fig
%      AMY_IMAGE, by itself, creates a new AMY_IMAGE or raises the existing
%      singleton*.
%
%      H = AMY_IMAGE returns the handle to a new AMY_IMAGE or the handle to
%      the existing singleton*.
%
%      AMY_IMAGE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in AMY_IMAGE.M with the given input arguments.
%
%      AMY_IMAGE('Property','Value',...) creates a new AMY_IMAGE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before amy_image_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to amy_image_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help amy_image

% Last Modified by GUIDE v2.5 06-Oct-2016 21:16:24

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @amy_image_OpeningFcn, ...
                   'gui_OutputFcn',  @amy_image_OutputFcn, ...
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
end

% --- Executes just before amy_image is made visible.
function amy_image_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to amy_image (see VARARGIN)

% Choose default command line output for amy_image
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes amy_image wait for user response (see UIRESUME)
% uiwait(handles.figure1);
end

% --- Outputs from this function are returned to the command line.
function varargout = amy_image_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
end

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
image_analysis(hObject,handles);
end

% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

n=get(handles.popupmenu1,'Value');

%% figure axis1
if isempty(handles.finf1)==0
    set(handles.axes1,'Units','pixels');
    axes(handles.axes1);
    imagesc(handles.imagedata{n});colorbar;title(handles.basename{n});
end

%% figure axis2
if isempty(handles.finf1)==0
    set(handles.axes2,'Units','pixels');
    axes(handles.axes2);
    surf(handles.imagedata{n},'Edgecolor','none');colorbar;title(handles.basename{n});
    h=rotate3d;set(h,'Enable','on');
end

set(handles.edit1,'String','Finish!!');pause(0.1);
guidata(hObject, handles);

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1
end

% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
set(handles.edit1,'String','Saving figures..');pause(0.1);
guidata(hObject, handles);
out_folder = [handles.image_folder '/Outfigures/'];
if ispc==1
    out_folder(findstr(out_folder, '/'))='\';
end
if exist(out_folder) ~= 7
    mkdir(out_folder);
end
for i=1:size(handles.finf1,1)
    filename{i} = strrep(handles.basename{i}, '\_', '_');
end
n=size(handles.imagedata,2);

%% figure axis1
if isempty(handles.finf1)==0
    for i=1:n
        fh = figure;set(fh,'Units','pixels','visible','off');
        imagesc(handles.imagedata{n});colorbar;title(handles.basename{n});
        
        if ispc ==1
            set(fh,'visible','on');
            eval(['saveas(fh, [out_folder ''/' filename{i} '_img.fig'']);']);
            close(fh);
        else
            set(fh,'visible','on');
            eval(['saveas(fh, [out_folder ''/' filename{i} '_img.fig'']);']);
            close(fh);
        end
    end
end

%% figure axis2
if isempty(handles.finf1)==0
    for i=1:n
        fh = figure;set(fh,'Units','pixels','visible','off');
        surf(handles.imagedata{n},'Edgecolor','none');colorbar;title(handles.basename{n});
        h=rotate3d;set(h,'Enable','on');
        
        if ispc ==1
            set(fh,'visible','on');
            eval(['saveas(fh, [out_folder ''/' filename{i} '_surf.fig'']);']);
            close(fh);
        else
            set(fh,'visible','on');
            eval(['saveas(fh, [out_folder ''/' filename{i} '_surf.fig'']);']);
            close(fh);
        end
    end
end


%% figure axis3
%legend({'Location 1','Location 2','Location 3'},2);
if isempty(handles.finf1)==0
    fh = figure;set(fh,'Units','pixels','visible','off');
    for i=1:n
        plot(handles.imagehist{i});hold on;
    end
    hl=legend(handles.image_legend,'FontSize',12);
    set(hl,'Box','off');
    colorbar;hold off
    
    if ispc ==1
        set(fh,'visible','on');
        eval(['saveas(fh, [out_folder ''/compare_intensity_surf.fig'']);']);
        close(fh);
    else
        set(fh,'visible','on');
        eval(['saveas(fh, [out_folder ''/compare_intensity_surf.fig'']);']);
        close(fh);
    end
end

set(handles.edit1,'String','Figures saved!!');pause(0.1);
guidata(hObject, handles);

% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end


function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double
end

% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

function image_analysis(hObject,handles)


%% data folder and image format
set(handles.edit1,'String','Loading Images ...');pause(0.1);
guidata(hObject, handles);
rootfolder = pwd;
%image_folder=uigetdir(rootfolder);
image_folder=rootfolder;
if image_folder==0
    set(handles.edit1,'String','');pause(0.1);
    guidata(hObject, handles);
    return;
end    
image_folder1 = [image_folder '/*.tif'];
if ispc==1
    image_folder1(findstr(image_folder1, '/'))='\';
end
finf1 = dir(image_folder1);


%% load all tiff images
if isempty(finf1)==0
    for i=1:size(finf1,1)
        imagename{i}=finf1(i).name;
        basename0=imagename{i}(1:strfind(imagename{i},'.')-1);
        basename{i} = strrep(basename0, '_', '\_');
        popupname{i,1}=imagename{i}(1:strfind(imagename{i},'.')-1);
        imageformat{i}=imagename{i}(strfind(imagename{i},'.'):end);
        temp = imread(imagename{i});
        
        imagedata{i} = temp(:,:,2);
        imagehist{i} = histnum(imagedata{i},2);
    end
else
    set(handles.edit1,'String','Error: No images!');
    guidata(hObject, handles);
    return;
end


%% update popupmenu1 and uitable1
set(handles.popupmenu1,'String',popupname);
for i=1:size(imagedata,2)
    B=reshape(imagedata{i},1,size(imagedata{1},1)*size(imagedata{1},2));
    table_data{i,1}=num2str(mean(B));
    table_data{i,2}=num2str(std2(B));
end
set(handles.uitable1,'ColumnName',{'Mean','SD'},'data',table_data);


%% figure axis1
if isempty(finf1)==0
    set(handles.axes1,'Units','pixels');
    axes(handles.axes1);
    imagesc(imagedata{1});colorbar;title(basename{1});
end

%% figure axis2
if isempty(finf1)==0
    set(handles.axes2,'Units','pixels');
    axes(handles.axes2);
    surf(imagedata{1},'Edgecolor','none');colorbar;title(basename{1});
    h=rotate3d;set(h,'Enable','on');
end


%% figure axis3
%legend({'Location 1','Location 2','Location 3'},2);
if isempty(finf1)==0
    set(handles.axes3,'Units','pixels');
    axes(handles.axes3);
    for i=1:size(imagedata,2)
        plot(imagehist{i});hold on;
        eval(['image_legend{i,1} = [basename{i} '' (mean = ' table_data{i,1} ', std = ' table_data{i,2} ')''];']);
    end
    hl=legend(image_legend,'FontSize',12);
    set(hl,'Box','off');
    colorbar;hold off
end


%% update handles
handles.finf1=finf1;
handles.imagedata=imagedata;
handles.basename=basename;
handles.imagehist=imagehist;
handles.table_data=table_data;
handles.image_folder=image_folder;
handles.image_legend=image_legend;

set(handles.edit1,'String','Finish!!');pause(0.1);
guidata(hObject, handles);
end
function out = histnum(input,n)

%% transfrom input into data = [1xn] matrix
[a,b] = size(input);
if a==1&&b~=1
    data=sort(input);
elseif a~=1&&b==1
    data=sort(input');
else
    data=sort(reshape(input,1,a*b));
end

%% create out matrix
nn= ceil(max(data)/n)+1;
out = zeros(1,nn);


%% update out matrix
for i=1:size(data,2)
    t=ceil(data(1,i)/n);
    out(1,t)=out(1,t)+1;
end

end
