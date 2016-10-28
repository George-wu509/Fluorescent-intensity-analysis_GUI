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

% Last Modified by GUIDE v2.5 27-Oct-2016 19:42:24

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

% --- Open folder A ---
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%image_analysis(hObject,handles);


%% data folder and image format
set(handles.edit1,'String','Loading A Images ...');pause(0.1);
guidata(hObject, handles);
rootfolder = pwd;
image_folder=uigetdir(rootfolder);
if image_folder==0
    set(handles.edit1,'String','');pause(0.1);
    guidata(hObject, handles);
    return;
end
addpath(image_folder);
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
    set(handles.edit1,'String','Error: Folder A no images!');
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
n=1;
if isempty(finf1)==0
    set(handles.axes1,'Units','pixels');
    axes(handles.axes1);
    imagesc(imagedata{n});colorbar;title(['Images A     ' basename{n}]);
end

%% figure axis2
if isempty(finf1)==0
    set(handles.axes2,'Units','pixels');
    axes(handles.axes2);
    surf(imagedata{n},'Edgecolor','none');colorbar;title(['Images A     ' basename{n}]);
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

set(handles.edit1,'String','Finish!!');pause(0.1);
guidata(hObject, handles);


%% Update imageA data to handles
handles.image_legendA=image_legend;
handles.rootfolder=rootfolder;
handles.finf1A=finf1;
handles.imagedataA=imagedata;
handles.basenameA=basename;
handles.imagehistA=imagehist;
handles.table_dataA=table_data;
handles.image_folderA=image_folder;
set(handles.pushbutton2,'Enable','on');
if strcmp(get(handles.popupmenu2,'Enable'),'on')==1
    set(handles.pushbutton4,'Enable','on');
end
set(handles.popupmenu1,'Enable','on');
set(handles.checkbox1,'Value',1);
set(handles.checkbox2,'Value',0);
set(handles.checkbox3,'Value',0);
set(handles.edit1,'String','Finish!');pause(0.1);
guidata(hObject, handles);

end

% --- Open folder B ---
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%% data folder and image format
set(handles.edit1,'String','Loading B Images ...');pause(0.1);
guidata(hObject, handles);
rootfolder = pwd;
image_folder=uigetdir(rootfolder);
if image_folder==0
    set(handles.edit1,'String','');pause(0.1);
    guidata(hObject, handles);
    return;
end
addpath(image_folder);
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
    set(handles.edit1,'String','Error: Folder B no images!');
    guidata(hObject, handles);
    return;
end


%% update popupmenu1 and uitable1
set(handles.popupmenu2,'String',popupname);
for i=1:size(imagedata,2)
    B=reshape(imagedata{i},1,size(imagedata{1},1)*size(imagedata{1},2));
    table_data{i,1}=num2str(mean(B));
    table_data{i,2}=num2str(std2(B));
end
set(handles.uitable2,'ColumnName',{'Mean','SD'},'data',table_data);


%% figure axis1
n=1;
if isempty(finf1)==0
    set(handles.axes1,'Units','pixels');
    axes(handles.axes1);
    imagesc(imagedata{n});colorbar;title(['Images B     ' basename{n}]);
end

%% figure axis2
if isempty(finf1)==0
    set(handles.axes2,'Units','pixels');
    axes(handles.axes2);
    surf(imagedata{n},'Edgecolor','none');colorbar;title(['Images B     ' basename{n}]);
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

set(handles.edit1,'String','Finish!!');pause(0.1);
guidata(hObject, handles);


%% Update imageB data to handles
handles.image_legendB=image_legend;
handles.rootfolder=rootfolder;
handles.finf1B=finf1;
handles.imagedataB=imagedata;
handles.basenameB=basename;
handles.imagehistB=imagehist;
handles.table_dataB=table_data;
handles.image_folderB=image_folder;
set(handles.pushbutton2,'Enable','on');
if strcmp(get(handles.popupmenu1,'Enable'),'on')==1
    set(handles.pushbutton4,'Enable','on');
end
set(handles.popupmenu2,'Enable','on');
set(handles.checkbox1,'Value',0);
set(handles.checkbox2,'Value',1);
set(handles.checkbox3,'Value',0);
set(handles.edit1,'String','Finish!');pause(0.1);
guidata(hObject, handles);

end

% --- Calculate ---
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = image_analysis(hObject,handles);
guidata(hObject, handles);
end

% --- Output figures ---
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
set(handles.edit1,'String','Saving figures..');pause(0.1);
guidata(hObject, handles);
out_folder = [handles.rootfolder '/Outfigures/'];
result_file = [out_folder 'result.mat'];
if ispc==1
    out_folder(findstr(out_folder, '/'))='\';
    result_file(findstr(result_file, '/'))='\';
end
if exist(out_folder) ~= 7
    mkdir(out_folder);
end
addpath(out_folder);
save(result_file,'out_folder');

% save datasetA figures annd result
if isfield(handles,'imagedataA')==1
    for i=1:size(handles.finf1A,1)
        filenameA{i} = strrep(handles.basenameA{i}, '\_', '_');
    end
    if isempty(handles.finf1A)==0
        n=size(handles.imagedataA,2);
        for i=1:n
            %% figure axis1
            fh = figure;set(fh,'Units','pixels','visible','off');
            imagesc(handles.imagedataA{n});colorbar;title(handles.basenameA{n});

            if ispc ==1
                set(fh,'visible','on');
                eval(['saveas(fh, [out_folder ''/' filenameA{i} '_img.fig'']);']);
                close(fh);
            else
                set(fh,'visible','on');
                eval(['saveas(fh, [out_folder ''/' filenameA{i} '_img.fig'']);']);
                close(fh);
            end
            %% figure axis2
            fh = figure;set(fh,'Units','pixels','visible','off');
            surf(handles.imagedataA{n},'Edgecolor','none');colorbar;title(handles.basenameA{n});
            h=rotate3d;set(h,'Enable','on');

            if ispc ==1
                set(fh,'visible','on');
                eval(['saveas(fh, [out_folder ''/' filenameA{i} '_surf.fig'']);']);
                close(fh);
            else
                set(fh,'visible','on');
                eval(['saveas(fh, [out_folder ''/' filenameA{i} '_surf.fig'']);']);
                close(fh);
            end
            
            
        end
    end
    %% figure axis3
    fh = figure;set(fh,'Units','pixels','visible','off');
    for i=1:n
        plot(handles.imagehistA{i});hold on;
    end
    hl=legend(handles.image_legendA,'FontSize',12);
    set(hl,'Box','off');
    colorbar;hold off
    
    if ispc ==1
        set(fh,'visible','on');
        eval(['saveas(fh, [out_folder ''/compare_A_intensity_surf.fig'']);']);
        close(fh);
    else
        set(fh,'visible','on');
        eval(['saveas(fh, [out_folder ''/compare_A_intensity_surf.fig'']);']);
        close(fh);
    end
    image_A=handles.imagedataA;
    hist_A=handles.imagehistA;
    mean_A=handles.table_dataA(:,1);
    std_A=handles.table_dataA(:,2);
    save(result_file,'image_A','hist_A','mean_A','std_A','-append');
end

% save datasetB figures annd result
if isfield(handles,'imagedataB')==1
    for i=1:size(handles.finf1B,1)
        filenameB{i} = strrep(handles.basenameB{i}, '\_', '_');
    end
    if isempty(handles.finf1B)==0
        n=size(handles.imagedataB,2);
        for i=1:n
            %% figure axis1
            fh = figure;set(fh,'Units','pixels','visible','off');
            imagesc(handles.imagedataB{n});colorbar;title(handles.basenameB{n});

            if ispc ==1
                set(fh,'visible','on');
                eval(['saveas(fh, [out_folder ''/' filenameB{i} '_img.fig'']);']);
                close(fh);
            else
                set(fh,'visible','on');
                eval(['saveas(fh, [out_folder ''/' filenameB{i} '_img.fig'']);']);
                close(fh);
            end
            %% figure axis2            
            fh = figure;set(fh,'Units','pixels','visible','off');
            surf(handles.imagedataB{n},'Edgecolor','none');colorbar;title(handles.basenameB{n});
            h=rotate3d;set(h,'Enable','on');

            if ispc ==1
                set(fh,'visible','on');
                eval(['saveas(fh, [out_folder ''/' filenameB{i} '_surf.fig'']);']);
                close(fh);
            else
                set(fh,'visible','on');
                eval(['saveas(fh, [out_folder ''/' filenameB{i} '_surf.fig'']);']);
                close(fh);
            end
            
            
            
        end
    end
    %% figure axis3
    fh = figure;set(fh,'Units','pixels','visible','off');
    for i=1:n
        plot(handles.imagehistB{i});hold on;
    end
    hl=legend(handles.image_legendB,'FontSize',12);
    set(hl,'Box','off');
    colorbar;hold off
    
    if ispc ==1
        set(fh,'visible','on');
        eval(['saveas(fh, [out_folder ''/compare_B_intensity_surf.fig'']);']);
        close(fh);
    else
        set(fh,'visible','on');
        eval(['saveas(fh, [out_folder ''/compare_B_intensity_surf.fig'']);']);
        close(fh);
    end
    image_B=handles.imagedataB;
    hist_B=handles.imagehistB;
    mean_B=handles.table_dataB(:,1);
    std_B=handles.table_dataB(:,2);
    save(result_file,'image_B','hist_B','mean_B','std_B','-append');
    
end

%% load all tiff images
if isfield(handles,'imagedataA')==1&&isfield(handles,'imagedataB')==1
    imageA=[];ms_A=zeros(2,size(handles.imagedataA,2));
    for i=1:size(handles.imagedataA,2)
        imageA=[imageA handles.imagedataA{i}];
        ms_A(1,i)=mean(mean(handles.imagedataA{i}));
        ms_A(2,i)=std2(handles.imagedataA{i});
    end
    imageB=[];ms_B=zeros(2,size(handles.imagedataB,2));
    for i=1:size(handles.imagedataB,2)
        imageB=[imageB handles.imagedataB{i}];
        ms_B(1,i)=mean(mean(handles.imagedataB{i}));
        ms_B(2,i)=std2(handles.imagedataB{i});
    end
    [Aa,Ab]=size(imageA);[Ba,Bb]=size(imageB);
    Adata=reshape(imageA,1,Aa*Ab);Bdata=reshape(imageB,1,Ba*Bb);
    maxAB=max(max(Adata),max(Bdata));
    minAB=min(min(Adata),min(Bdata));
    histA = histnum(imageA,2,maxAB,minAB);
    histB = histnum(imageB,2,maxAB,minAB);


    %% figure axis3
    %legend({'Location 1','Location 2','Location 3'},2);
    if isfield(handles,'imagedataA')==1||isfield(handles,'imagedataB')==1
        fh = figure;set(fh,'Units','pixels','visible','off');
        plot(histA);hold on;plot(histB);hold off;
        eval(['image_legend{1,1} = [''Images A'' '' (mean = ' num2str(mean(Adata)) ', std = ' num2str(std2(Adata)) ')''];']);
        eval(['image_legend{2,1} = [''Images B'' '' (mean = ' num2str(mean(Bdata)) ', std = ' num2str(std2(Bdata)) ')''];']);
        hl=legend(image_legend,'FontSize',12);
        set(hl,'Box','off');
        colorbar;

        if ispc ==1
            set(fh,'visible','on');
            eval(['saveas(fh, [out_folder ''/compare_A&B_intensity_surf.fig'']);']);
            close(fh);
        else
            set(fh,'visible','on');
            eval(['saveas(fh, [out_folder ''/compare_A&B_intensity_surf.fig'']);']);
            close(fh);
        end
    end
    [h,p,ci,stats] = ttest2(double(ms_A(1,:)),double(ms_B(1,:)));
    histAB_A=histA;
    histAB_B=histB;
    save(result_file,'histAB_A','histAB_B','h','p','ci','stats','-append');
end

set(handles.edit1,'String','Figures saved!!');pause(0.1);
guidata(hObject, handles);

% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

% --- Menu A ---
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

n=get(handles.popupmenu1,'Value');

%% figure axis1
if isempty(handles.finf1A)==0
    set(handles.axes1,'Units','pixels');
    axes(handles.axes1);
    imagesc(handles.imagedataA{n});colorbar;title(['Images A     ' handles.basenameA{n}]);
end

%% figure axis2
if isempty(handles.finf1A)==0
    set(handles.axes2,'Units','pixels');
    axes(handles.axes2);
    surf(handles.imagedataA{n},'Edgecolor','none');colorbar;title(['Images A     ' handles.basenameA{n}]);
    h=rotate3d;set(h,'Enable','on');
end

set(handles.edit1,'String','Finish!!');pause(0.1);
guidata(hObject, handles);

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1
end

% --- Menu B ---
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
n=get(handles.popupmenu2,'Value');

%% figure axis1
if isempty(handles.finf1B)==0
    set(handles.axes1,'Units','pixels');
    axes(handles.axes1);
    imagesc(handles.imagedataB{n});colorbar;title(['Images B     ' handles.basenameB{n}]);
end

%% figure axis2
if isempty(handles.finf1B)==0
    set(handles.axes2,'Units','pixels');
    axes(handles.axes2);
    surf(handles.imagedataB{n},'Edgecolor','none');colorbar;title(['Images B     ' handles.basenameB{n}]);
    h=rotate3d;set(h,'Enable','on');
end

set(handles.edit1,'String','Finish!!');pause(0.1);
guidata(hObject, handles);
% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2
end

% --- A checkbox ---
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%% figure axis3
%legend({'Location 1','Location 2','Location 3'},2);
finf1=handles.finf1A;
imagedata=handles.imagedataA;
imagehist=handles.imagehistA;
table_data=handles.table_dataA;
basename=handles.basenameA;


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

set(handles.checkbox1,'Value',1);
set(handles.checkbox2,'Value',0);
set(handles.checkbox3,'Value',0);
set(handles.edit1,'String','Finish!');pause(0.1);
guidata(hObject, handles);
% Hint: get(hObject,'Value') returns toggle state of checkbox1
end

% --- B checkbox ---
function checkbox2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
finf1=handles.finf1B;
imagedata=handles.imagedataB;
imagehist=handles.imagehistB;
table_data=handles.table_dataB;
basename=handles.basenameA;


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

set(handles.checkbox1,'Value',0);
set(handles.checkbox2,'Value',1);
set(handles.checkbox3,'Value',0);
set(handles.edit1,'String','Finish!');pause(0.1);
guidata(hObject, handles);
% Hint: get(hObject,'Value') returns toggle state of checkbox2
end

% --- C checkbox ---
function checkbox3_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = image_analysis(hObject,handles);
guidata(hObject, handles);
% Hint: get(hObject,'Value') returns toggle state of checkbox3
end







function handles = image_analysis(hObject,handles)


%% data folder and image format
set(handles.edit1,'String','Calculate ...');pause(0.1);
guidata(hObject, handles);
%image_folder=uigetdir(rootfolder);
if isfield(handles,'imagedataA')~=1||isfield(handles,'imagedataB')~=1
    set(handles.edit1,'String','');pause(0.1);
    guidata(hObject, handles);
    return;
end

%% load all tiff images
imageA=[];ms_A=zeros(2,size(handles.imagedataA,2));
for i=1:size(handles.imagedataA,2)
    imageA=[imageA handles.imagedataA{i}];
    ms_A(1,i)=mean(mean(handles.imagedataA{i}));
    ms_A(2,i)=std2(handles.imagedataA{i});
end
imageB=[];ms_B=zeros(2,size(handles.imagedataB,2));
for i=1:size(handles.imagedataB,2)
    imageB=[imageB handles.imagedataB{i}];
    ms_B(1,i)=mean(mean(handles.imagedataB{i}));
    ms_B(2,i)=std2(handles.imagedataB{i});
end
[Aa,Ab]=size(imageA);[Ba,Bb]=size(imageB);
Adata=reshape(imageA,1,Aa*Ab);Bdata=reshape(imageB,1,Ba*Bb);
maxAB=max(max(Adata),max(Bdata));
minAB=min(min(Adata),min(Bdata));
histA = histnum(imageA,2,maxAB,minAB);
histB = histnum(imageB,2,maxAB,minAB);


%% figure axis3
%legend({'Location 1','Location 2','Location 3'},2);
if isfield(handles,'imagedataA')==1||isfield(handles,'imagedataB')==1
    set(handles.axes3,'Units','pixels');
    axes(handles.axes3);
    plot(histA);hold on;plot(histB);hold off;
    eval(['image_legend{1,1} = [''Images A'' '' (mean = ' num2str(mean(Adata)) ', std = ' num2str(std2(Adata)) ')''];']);
    eval(['image_legend{2,1} = [''Images B'' '' (mean = ' num2str(mean(Bdata)) ', std = ' num2str(std2(Bdata)) ')''];']);
    hl=legend(image_legend,'FontSize',12);
    set(hl,'Box','off');
    colorbar;
end

[h,p,ci,stats] = ttest2(double(ms_A(1,:)),double(ms_B(1,:)));
if h==0
    hh = 'does not reject the null hypothesis.';
else
    hh = 'reject the null hypothesis.';
end
set(handles.uipanel1,'Visible','on');
set(handles.text18,'Visible','on');
set(handles.text12,'Visible','on');
set(handles.text13,'Visible','on');
set(handles.text14,'Visible','on');
set(handles.text15,'Visible','on');
set(handles.text16,'Visible','on');
set(handles.text17,'Visible','on');
set(handles.text18,'Visible','on');
set(handles.text19,'Visible','on');
set(handles.text20,'Visible','on');
set(handles.text15,'String',num2str(p));
set(handles.text16,'String',num2str(ci(1)));
set(handles.text17,'String',num2str(ci(2)));
set(handles.text19,'String',num2str(stats.df));
set(handles.text20,'String',hh);

set(handles.edit1,'String','Finish!!');pause(0.1);
set(handles.checkbox1,'Value',0);
set(handles.checkbox2,'Value',0);
set(handles.checkbox3,'Value',1);
guidata(hObject, handles);


end
function out = histnum(input,n,maxi,mini)

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
if exist('maxi','var')==1&&exist('mini','var')==1
    nn= ceil((maxi-mini)/n)+1;
elseif exist('maxi','var')==1
    nn= ceil(maxin)+1;
elseif exist('mini','var')==1
    nn= ceil((max(data)-mini)/n)+1;
else
    nn= ceil(max(data)/n)+1;
end
out = zeros(1,nn);


%% update out matrix
for i=1:size(data,2)
    t=max(min(ceil(data(1,i)/n),nn),1);
    out(1,t)=out(1,t)+1;
end

end

function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double
end


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
