% RESULTSEXPLORER Makes new RESULTSEXPLORER or finds the existing singleton
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% ResultsExplorer:
%     By itself, creates a new RESULTSEXPLORER or raises the existing
%      singleton. See GUI Options on GUIDE's Tools menu.  Choose "GUI 
%      allows only one instance to run (singleton)".
%
%     RESULTSEXPLORER('CALLBACK',hObject,eventData,handles,...) calls the 
%      local function named CALLBACK in RESULTSEXPLORER.M with the given 
%      input arguments.
%
%     RESULTSEXPLORER('Property','Value',...) creates a new 
%      RESULTSEXPLORER or raises the existing singleton*.  Starting from 
%      the left, property value pairs are applied to the GUI before 
%      ResultsExplorer_OpeningFunction gets called.  An unrecognized 
%      property name or invalid value makes property application stop.  All
%      inputs are passed to ResultsExplorer_OpeningFcn via varargin.
%
% ************************************************************************
% * #NOTE: To future Cosmo'r
% * The following error occured when running CreateNewFunc.
% * CreateNewFunc>>WARNING: Selected Ouput argument name: "varargout" is a
% * function name!
% * -JPG
% ************************************************************************
%
% SYNTAX:
%	[varargout] = ResultsExplorer(varargin, 'PropertyName', PropertyValue)
%	[varargout] = ResultsExplorer(varargin)
%
% INPUTS: 
%	Name     	Size		Units		Description
%	varargin	[N/A]		[varies]	Optional function inputs that
%	     		        				 should be entered in pairs.
%	     		        				 See the 'VARARGIN' section
%	     		        				 below for more details
%
% OUTPUTS: 
%	Name     	Size		Units		Description
%	varargout	<size>		<units>		<Description> 
%
% NOTES:
%	<Any Additional Information>
%
%	VARARGIN PROPERTIES:
%	PropertyName		PropertyValue	Default		Description
%	<PropertyName>		<units>			<Default>	<Description>
%
% EXAMPLES:
%	% <Enter Description of Example #1>
%	[varargout] = ResultsExplorer(varargin)
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[varargout] = ResultsExplorer(varargin)
%	% <Copy expected outputs from Command Window>
%
% SOURCE DOCUMENTATION:
% <Enter as many sources as needed.  Some popular ones are listed here.>
% <Note, these citation examples came from: http://honolulu.hawaii.edu/legacylib/mlahcc.html >
% Website Citation:
% [1]   Author.  "Title of Web Page." Title of the Site. Editor. Dat and/or Version Number.
%       Date of Access <URL>
% Book with One Author:
% [2]   Author Last Name, Author First Name. Title of Book. City of Publication: Publisher, Year. Eqn #, pg #
% Book with Two Author:
% [3]   Author #1 Last Name, Author #1 First Name, and Author #2 Full Name. Title of Book. City of Publication: Publisher, Year. Eqn #, pg #
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit ResultsExplorer.m">ResultsExplorer.m</a>
%	  Driver script: <a href="matlab:edit Driver_ResultsExplorer.m">Driver_ResultsExplorer.m</a>
%	  Documentation: <a href="matlab:pptOpen('ResultsExplorer_Function_Documentation.pptx');">ResultsExplorer_Function_Documentation.pptx</a>
%
% See also GUIDE, GUIDATA, GUIHANDLES
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/512
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/PlottingUtilities/ResultsExplorer/ResultsExplorer.m $
% $Rev: 1724 $
% $Date: 2011-05-11 18:34:55 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [varargout] = ResultsExplorer(varargin)

%% Debugging & Display Utilities:
spc  = sprintf(' ');                                % One Single Space
tab  = sprintf('\t');                               % One Tab
endl = sprintf('\n');                               % Line Return
[mfpath,mfnam] = fileparts(mfilename('fullpath'));  % Full Path to Function, Name of Function
mfspc = char(ones(1,length(mfnam))*spc);            % String of Spaces the length of the function name
mlink = ['<a href = "matlab:help ' mfnam '">' mfnam '</a>']; % Hyperlink to mask help that can be added to a error disp

% Examples of Different Display Formats:
% disp([mfnam '>> Output with filename included...' ]);
% disp([mfspc '>> further outputs will be justified the same']);
% disp([mfspc '>> CAUTION: or mfnam: note lack of space after">>"']);
% disp([mfnam '>> WARNING: <- Very important warning (does not terminate)']);
% disp([mfnam '>> ERROR: <-if followed by "return" used if continued exit desired']);
% errstr = [mfnam '>> ERROR: <define error here> See ' mlink ' help'];      % <-- Couple with error function
% error([mfnam 'class:file:Identifier'], errstr);    % Call error function with error string

%% Initialize Outputs:
% varargout= -1;
% Begin initialization code - DO NOT XAXISDATA
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @ResultsExplorer_OpeningFcn, ...
    'gui_OutputFcn',  @ResultsExplorer_OutputFcn, ...
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
% End initialization code - DO NOT XAXISDATA
end
%% Input Argument Conditioning:
% Pick out Properties Entered via varargin
% [<PropertyValue>, varargin]  = format_varargin('<PropertyValue', <Default>, 2, varargin);

%  switch(nargin)
%       case 0
%        
%       case 1
%        
%  end
%
%% Main Function:

%% --- Executes just before ResultsExplorer is made visible.
function ResultsExplorer_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structurelistbox with handles and user data (see GUIDATA)
% varargin   command line arguments to ResultsExplorer (see VARARGIN)

% Choose default command line output for ResultsExplorer
handles.output = hObject;

%% Initialization

% Set default hold status:
handles.HoldStatus      = 'off';
handles.ClearStatus     = 'no';
handles.CurrentUnits    = 'Degrees';
handles.axes1           = gca;
handles.flgLegendLong   = 0;
handles.flgShortFull    = 0;
handles.flgUseNoLegend  = 0;
handles.Apply4AllResults = 0;
handles.flgSplitVectors = 0;
handles.AddVectorTag    = 0;
handles.GUIwindow       = gcf;
handles.legend_pos      = 'NorthEast';
set(handles.popup_legend_string, 'Value', 1);
set(handles.lstVector, 'String', '');
set(handles.lstVector, 'BackgroundColor', [0.75 0.75 0.75]);
handles.flgPlotXLine = 0;
handles.flgPlotYLine = 0;
handles.flgCleanAxis = 0;
set(handles.checkboxCleanAxis, 'Value', handles.flgCleanAxis);

%% Initialize lstResults:

Results = GetLatestWorkspaceData();
h = handles.figure1;
if(isempty(Results))
    handles = LoadMatFile(handles);
else
    handles.lists.Results(1,:) = {'Results'};
    handles.Results = Results;

    if(isfield(Results, 'PlotLabel'))
        handles.lists.PlotLabels(1, :) = {Results.PlotLabel};
    else
        handles.lists.PlotLabels(1, :) = {''};
    end
end
figure(h);

set(handles.lstResults, 'String', handles.lists.Results);
set(handles.lstResults, 'Value', 1);
handles.Selected.Results = char(handles.lists.Results(1,:));

%% Initialize lstStructures:
VehName = eval(['fieldnames(handles.' cell2str(handles.lists.Results) ')']);

handles.Selected.Structure = [VehName{1} '.StateBus'];
handles.Selected.Member = 'Alt';

if(isfield(handles.lists, 'Structure'))
    handles.lists = rmfield(handles.lists, 'Structure');
end

handles = CreateStarterLists(handles);

handles.lists.DispStructure = FormatDisplay(handles.lists.Structure);
set(handles.lstStructures, 'String', handles.lists.DispStructure);
set(handles.lstStructures,'Value',handles.Selected.iStructure);

handles.lists.Members = eval(['ExcludeStructure(fieldnames(handles.' ...
    char(handles.Selected.Results) '.' char(handles.Selected.Structure) '));']);
for i = 1:length(handles.lists.Members)
    if(strcmp(handles.lists.Members(i,:), handles.Selected.Member))
        handles.Selected.iMembers = i;
        break;
    end
end
set(handles.lstMembers, 'String', handles.lists.Members);
set(handles.lstMembers, 'Value', handles.Selected.iMembers);

handles = CompileData2Plot(handles);
PlotData(handles);

if(~isempty(varargin))
    %     listResults = { varargin{1} };
    %     handles.lists.Results(1,:) = listResults(1,:);
    handles = Loadmat(handles, listResults, []);
end

guidata(hObject, handles);

end

%% --- Designed to get the latest Structures
function handles = CreateStarterLists(handles)

% Crate Structure List:
ptrPeriods = findstr(handles.Selected.Structure, '.');
numPeriods = length(ptrPeriods);
str2expand = handles.Selected.Structure(1:(ptrPeriods(1)-1));

curData = ['handles.' char(handles.Selected.Results)];
lstData = ExcludeStructure(fieldnames(eval(curData)));

iStruct = 0;
iMem = 0;

for i = 1:size(lstData,1)
    DataName = char(lstData(i,:));
    flgStruct = isstruct(eval([curData '.' DataName]));

    if(flgStruct)
        iStruct = iStruct + 1;
        handles.lists.Structure(iStruct).name = DataName;
        handles.lists.Structure(iStruct).flgStruct = 1;
        handles.lists.Structure(iStruct).flgExpanded = 0;

        if(strcmp(DataName, str2expand))
            handles.lists.Structure = ExpandStructure(handles, iStruct);
            iStruct = length(handles.lists.Structure);
        end
    end
end

for iSelected = 1:size(handles.lists.Structure,2)
    curMember = handles.lists.Structure(iSelected).name;

    if(strcmp(curMember, handles.Selected.Structure))
        handles.Selected.iStructure = iSelected;
        break;
    end
end
end
% Create Member List

%% --- Outputs from this function are returned to the command line.
function varargout = ResultsExplorer_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structurelistbox with handles and user data (see GUIDATA)

% Get default command line output from handles structurelistbox
varargout{1} = handles.output;
end

%% --- Executes on button press in HoldButton.
function HoldButton_Callback(hObject, eventdata, handles)
% hObject    handle to HoldButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structurelistbox with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of HoldButton

% Toggle holding of the axes1:
switch get(hObject,'Value')
    case 0
        handles.HoldStatus = 'off';
    case 1
        handles.HoldStatus = 'on';
        handles.ClearStatus = 'no';
end
% Update handles structurelistbox
guidata(hObject, handles);
end

%% --- Executes on button press in ClearButton.
function ClearButton_Callback(hObject, eventdata, handles)
% hObject    handle to ClearButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structurelistbox with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ClearButton

handles.ClearStatus = 'yes';
% Clear the axes:
cla(handles.axes1);
legend('off');
set(handles.HoldButton, 'Value', 0);
handles.HoldStatus      = 'off';
ylim([-1 1]);
guidata(hObject, handles);
end

%% --- Designed to get the latest Results from the base workspace
% in the event that the data is newer there. This is needed on
% initialization as well as when the user desires so that there is some
% data to plot.
function Results = GetLatestWorkspaceData(strResults)
if nargin == 0
    strResults = 'Results';
end

if(isempty(strResults))
    Results = [];
else
    if(evalin('base', ['exist(''' strResults ''', ''var'')']))
        Results = evalin('base', strResults);
    else
        Results = [];
    end
end
end

%% --- Executes on button press in GetResultsButton.
function GetResultsButton_Callback(hObject, eventdata, handles)
% hObject    handle to GetResultsButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structurelistbox with handles and user data (see GUIDATA)

Results = GetLatestWorkspaceData();
handles.Results = Results;
% Update handles structurelistbox
guidata(hObject, handles);
end

% --- Executes on selection change in DegRadPopup.
function DegRadPopup_Callback(hObject, eventdata, handles)
% hObject    handle to DegRadPopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns DegRadPopup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from DegRadPopup
switch get(hObject,'Value')
    case 1
        handles.CurrentUnits = 'Degrees';
    case 2
        handles.CurrentUnits = 'Radians';
end
PlotData(handles);
guidata(hObject, handles);
end

% --- Executes during object creation, after setting all properties.
function DegRadPopup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DegRadPopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

%% ExcludeStructure:
function CleanStruct = ExcludeStructure( RawStructure )

arrExclusions = {'DataRecorded';
    'Units'};

CleanStruct = {''};

iClean = 0;
for i = 1:length(RawStructure)
    curStructure = RawStructure(i,:);

    flgPass = 1;
    for iEx = 1:size(arrExclusions, 1)
        curExclusion = arrExclusions(iEx, :);
        match = findstr(char(curStructure), char(curExclusion));
        if( ~isempty(match) )
            flgPass = 0;
            break;
        end
    end

    if(flgPass)
        iClean = iClean + 1;
        CleanStruct(iClean,:) = curStructure;
    end
end
end

%% --- Generates the Plot
function PlotData(handles)

arrPlotTypes = {'b-', 'r-', 'g-', 'k-', 'c-', ...
    'b--', 'r--', 'g--', 'k--', 'c--', ...
    'b:', 'r:', 'g:', 'k:', 'c:', ...
    'b-.', 'r-.', 'g-.', 'k-.', 'c-.'};

numData2Plot = size(handles.Data2Plot, 2);
% strYLabel = '';
for iData = 1:numData2Plot
    % XData:
    x = handles.Data2Plot(iData).YDataTime;
    xUnits = handles.Data2Plot(iData).XUnits;
    XMember = handles.Data2Plot(iData).XMember;
    XMember = strrep(XMember, 'simtime', 'Simulation Time');

    %YData:
    y = handles.Data2Plot(iData).YData;
    yUnits = handles.Data2Plot(iData).YUnits;

    % Adjust Units:
    if(strcmpi(handles.CurrentUnits, 'Degrees'))
        % Desired Display Units are Degrees:
        if (strfind(yUnits, 'rad'))
            yUnits = strrep(yUnits, 'rad', 'deg');
            unitfactor = 180/pi;
        else
            unitfactor = 1;
        end
    else
        % Desired Dispay Units are Radians:
        if (strfind(yUnits, 'deg'))
            yUnits = strrep(yUnits, 'deg', 'rad');
            unitfactor = pi/180;
        else
            unitfactor = 1;
        end
    end

    y = y * unitfactor;

    if(handles.flgLegendLong)
        YMember = handles.Data2Plot(iData).CurrentYData;
        YMember = [YMember ' ' yUnits];
    else
        YMember = handles.Data2Plot(iData).YMember;
        YMember = [YMember ' ' yUnits];

        if(handles.flgShortFull)
            ptrPeriod = strfind(handles.Data2Plot(iData).YParent, '.');
            YParentShort = handles.Data2Plot(iData).YParent(ptrPeriod(end)+1:end);
            YParentShort = strrep(YParentShort, '_', ' ');
            YMember = [YParentShort ' ' YMember];
        end

        if(length(handles.lists.Results) > 1)
            CurrentResults = handles.Data2Plot(iData).PlotLabels;

            if(isempty(CurrentResults))
                CurrentResults = handles.Data2Plot(iData).Results;
            end
            
        else
            CurrentResults = '';
        end
        
        if(numData2Plot == 1)
            strYLabel = YMember;
            YMember = CurrentResults;
        else
            strYLabel = '';
            if(isempty(CurrentResults))
                YMember = [CurrentResults ' ' YMember];
            else
                YMember = [CurrentResults ': ' YMember];
            end
        end
    end

    PlotData(iData).x = x;
    PlotData(iData).y = y;
    PlotData(iData).label = YMember;

end

cla(handles.axes1);
ylim('auto');
legend('off');

for i = 1:numData2Plot;
    h(i) = plotd(PlotData(i).x,PlotData(i).y, [], 'MarkerSize', 8, 'LineWidth', 1.5);
    if (i == 1)
        hold on;
    end
    legend_str{i} = PlotData(i).label;
end

if(~handles.flgUseNoLegend)
    if(handles.flgLegendLong)
        legend(h, legend_str, 'Interpreter', 'none', 'Location', handles.legend_pos);
    else
        legend(h, legend_str, 'Location', handles.legend_pos);
    end
    
    if(isempty(char(legend_str)))
        legend('off');
    end
end

if(handles.flgCleanAxis)
    FixAxis('y');
else
    ResetAxis('y');
end
set(gca, 'FontWeight', 'bold');
set(gca, 'FontSize', 12);

grid on;
xlabel(['\bf' XMember ' ' xUnits]);
ylabel(strYLabel);

zoom on;

% Adjust Axis:
xlimit = xlim;
if(get(handles.SpecifyX,'Value'))
    if(~isempty(get(handles.xmin,'String')))
        xlimit(1) = str2double(get(handles.xmin, 'String'));
    end

    if(~isempty(get(handles.xmax,'String')))
        xlimit(2) = str2double(get(handles.xmax, 'String'));
    end

    xlim(xlimit);
end

if(handles.flgPlotYLine)
    PlotYLine(handles.YLineValue, 'k-.', 'LineWidth', 1.5);
end
if(handles.flgPlotXLine)
    PlotXLine(handles.XLineValue, 'k-.', 'LineWidth', 1.5);
end
end

%% --- Executes on selection change in YBox.
function YBox_Callback(hObject, eventdata, handles)
% hObject    handle to YBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Retrieve Pointer Click:
handles.YSelection  = get(hObject,'Value');
handles.CurrentYData= handles.lstYData(handles.YSelection).name;
flgStruct           = handles.lstYData(handles.YSelection).flgStruct;
flgExpanded         = handles.lstYData(handles.YSelection).flgExpanded;

if(flgStruct)

    if(flgExpanded == 0)
        % Expand Structure:
        handles.lstYData    = ExpandStructure(handles, handles.lstYData, handles.YSelection);
        handles.lstYData_display = FormatDisplay(handles.lstYData);
        set(handles.YBox, 'String', handles.lstYData_display);

    else
        % Collapse Structure:
        handles.lstYData    = CollapseStructure(handles, handles.lstYData, handles.YSelection);
        handles.lstYData_display = FormatDisplay(handles.lstYData);
        set(handles.YBox, 'String', handles.lstYData_display);
    end

else

    handles = CompileData2Plot(handles);

    % Plot Data:
    PlotData(handles);
end

% handles.lists.SubMems = GetListVariables(handles.lstYData);
% set(handles.lstMembers, 'String', handles.lists.SubMems);
% handles.lists.SubStructs = GetListStructures(handles.lstYData);
% set(handles.lstStructures, 'String', handles.lists.SubStructs);

% Update handles structurelistbox
guidata(hObject, handles);
end

%%
function handles = CompileData2Plot(handles)

handles = getResultNames(handles);
handles = getMemberNames(handles);

if((isfield(handles, 'Data2Plot')) & (strfind(handles.HoldStatus, 'off')))
    handles = rmfield(handles, 'Data2Plot');
end

if(~isfield(handles, 'Data2Plot'))
    curIndex = 0;
else
    curIndex = size(handles.Data2Plot, 2);
end

numResults = length(handles.Selected.iResults);
numMembers = length(handles.Selected.iMembers);

for iMember = 1:numMembers
    curMember = char(handles.Selected.Members(iMember));

    for iResult = 1:numResults
        curResult = char(handles.Selected.Results(iResult,:));
        ptrResult = handles.Selected.iResults(iResult);
        
        handles.YParent     = [curResult '.' handles.Selected.Structure];
        handles.YMember     = curMember;
        handles.CurrentYData= [handles.YParent '.' handles.YMember];
        handles.YUnits      = eval(['handles.' handles.YParent '.Units.' handles.YMember ';']);
        handles.YData       = eval(['handles.' handles.CurrentYData ';']);

        ptrPeriods = findstr(handles.CurrentYData, '.');
        for i = 1:length(ptrPeriods)

            str2try = eval(['handles.' handles.CurrentYData(1:ptrPeriods(i)-1)]);
            if(isfield(str2try, 'simtime'))

                handles.XMember = 'simtime';
                handles.XParent = [handles.CurrentYData(1:ptrPeriods(i)-1)];
                handles.CurrentXData = [handles.XParent '.' handles.XMember];
                handles.XUnits  = eval(['handles.' handles.XParent '.Units.' handles.XMember ';']);
                handles.YDataTime   = str2try.simtime;

                break;
            end
        end

        if(handles.flgSplitVectors)
            numYData = length(handles.Selected.iVector);
        else
            numYData = size(handles.YData,2);
            handles.Selected.iVector = 1:numYData;
        end

        for ptr_iYData = 1:numYData
            iYData = handles.Selected.iVector(ptr_iYData);

            Data2Plot.XMember       = handles.XMember;
            Data2Plot.XParent       = handles.XParent;
            Data2Plot.CurrentXData  = handles.CurrentXData;
            Data2Plot.XUnits        = handles.XUnits;
            Data2Plot.YDataTime     = handles.YDataTime;

            if((handles.flgSplitVectors) && (handles.AddVectorTag))
                Data2Plot.YMember       = FormatMember(handles.YMember, 2, iYData);
                Data2Plot.CurrentYData  = [handles.CurrentYData sprintf('(%d)', iYData)];
            else
                Data2Plot.YMember       = FormatMember(handles.YMember, numYData, iYData);
                Data2Plot.CurrentYData  = [handles.CurrentYData sprintf('(%d)', iYData)];
            end
            Data2Plot.YParent       = handles.YParent;

            if(~handles.AddVectorTag)
                if(numYData > 1)
                    Data2Plot.CurrentYData  = [handles.CurrentYData sprintf('(%d)', iYData)];
                else
                    Data2Plot.CurrentYData  = handles.CurrentYData;
                end
            end

            Data2Plot.YUnits        = handles.YUnits;
            Data2Plot.YData         = handles.YData(:,iYData);
            Data2Plot.Results       = curResult;
            Data2Plot.PlotLabels    = char(handles.lists.PlotLabels{ptrResult});

            curIndex = curIndex + 1;
            handles.Data2Plot(curIndex) = Data2Plot;
        end
    end
end
end

%%
function lstMembers = GetMembers(handles)

i_new = 0;
for i_old = 1:length(lstOld);
    curMember = char(lstOld(i_old).name);

    i_new = i_new + 1;
    lstNew(i_new).name      = lstOld(i_old).name;
    lstNew(i_new).flgStruct = lstOld(i_old).flgStruct;
    lstNew(i_new).flgExpanded = lstOld(i_old).flgExpanded;

    if(i_old == numSelection)
        lstNew(i_new).flgExpanded = 1;
        lstAdd = eval(['ExcludeStructure(fieldnames(handles.' curMember '));']);

        for i_add = 1:length(lstAdd)
            i_new = i_new + 1;
            curAdd = char(lstAdd(i_add));
            flgStruct = eval(['isstruct(handles.' curMember '.' curAdd ');']);

            lstNew(i_new).name      = [curMember '.' curAdd];
            lstNew(i_new).flgStruct = flgStruct;
            lstNew(i_new).flgExpanded = 0;
        end
    end
end
end

%%
function strNew = FormatMember(strOld, lengthVec, iVec)

strNew = strOld;
strNew = strrep(strNew, '_', ' ');

if(lengthVec > 1)
    flgFormatted = 0;

    % Replace Euler string with either Phi, Theta, or Psi:
    if(strfind(strNew, 'Euler'))
        switch iVec
            case 1
                strNew = strrep(strNew, 'Euler', 'Phi');
            case 2
                strNew = strrep(strNew, 'Euler', 'Theta');
            case 3
                strNew = strrep(strNew, 'Euler', 'Psi');
        end
        flgFormatted = 1;
    end

    % Replace PQR string with either P, Q, or R:
    if(strfind(strNew, 'PQR'))
        switch iVec
            case 1
                strNew = strrep(strNew, 'PQR', 'P');
            case 2
                strNew = strrep(strNew, 'PQR', 'Q');
            case 3
                strNew = strrep(strNew, 'PQR', 'R');
        end
        flgFormatted = 1;
    end

    % Replace ned string with either N, E, or D:
    if(strfind(strNew,'ned'))
        switch iVec
            case 1
                strNew = strrep(strNew, ' ned', '_N');
            case 2
                strNew = strrep(strNew, ' ned', '_E');
            case 3
                strNew = strrep(strNew, ' ned', '_D');
        end
        flgFormatted = 1;
    end

    % Replace ned string with either N, E, or D:
    if(strfind(strNew,'Inertia'))
        switch iVec
            case 1
                strNew = strrep(strNew, 'Inertia', 'Ixx');
            case 2
                strNew = strrep(strNew, 'Inertia', 'Iyx');
            case 3
                strNew = strrep(strNew, 'Inertia', 'Izx');
            case 4
                strNew = strrep(strNew, 'Inertia', 'Ixy');
            case 5
                strNew = strrep(strNew, 'Inertia', 'Iyy');
            case 6
                strNew = strrep(strNew, 'Inertia', 'Izy');
            case 7
                strNew = strrep(strNew, 'Inertia', 'Izx');
            case 8
                strNew = strrep(strNew, 'Inertia', 'Izy');
            case 9
                strNew = strrep(strNew, 'Inertia', 'Izz');
        end
        flgFormatted = 1;
    end

    if(flgFormatted == 0);
        strNew = [strNew sprintf('(%d)', iVec)];
    end
end
end

%% ========================================================================
function lst2Display = FormatDisplay(lstRaw)

for iMem = 1:size(lstRaw,2)
    curMember = char(lstRaw(iMem).name);
    %     flgStruct = lstRaw(iMem).flgStruct;
    flgStruct = 1;
    flgExpanded = lstRaw(iMem).flgExpanded;
    ptrPeriods = findstr(curMember, '.');

    numPeriods = length(ptrPeriods);
    if isempty(numPeriods)
        numPeriods = 0;
    end

    str2Add = curMember;

    % Add + for Structure:
    if(flgStruct);
        if(flgExpanded)
            str2Add = ['- ' str2Add];
        else
            str2Add = ['+ ' str2Add];
        end
    else
        str2Add = ['  ' str2Add];
    end

    % Indent Substructures:
    if(numPeriods > 0)
        str2Add  = curMember(ptrPeriods(end)+1:end);

        % Add + for Structure:
        if(flgStruct);
            if(flgExpanded)
                str2Add = ['- ' str2Add];
            else
                str2Add = ['+ ' str2Add];
            end
        else
            str2Add = ['  ' str2Add];
        end

        for iPeriod = 1:numPeriods
            str2Add = ['  ' str2Add];
        end
    end

    lst2Display(iMem,:) = {str2Add};
end
end

% --- Executes on button press in CopyFig.
function CopyFig_Callback(hObject, eventdata, handles)
% hObject    handle to CopyFig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles = CopyFig(handles);
end

function handles = CopyFig(handles)
xlimits = xlim;
ylimits = ylim;

figure()
handles.CurCopy = gcf;
% handles.legend_pos = 'SouthWest';
PlotData(handles);
% handles.legend_pos = 'NorthEast';
xlim(xlimits);
ylim(ylimits);

scalar = 1.5;
set(gcf, 'Position', [100 200 560*scalar 420*scalar]);

figure(handles.figure1);
PlotData(handles);
xlim(xlimits);
ylim(ylimits);
end

% --- Executes on button press in flgUseFull.
function flgUseFull_Callback(hObject, eventdata, handles)
% hObject    handle to flgUseFull (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of flgUseFull
handles.flgLegendLong = get(hObject,'Value');
handles.flgUseNoLegend = 0;
handles.xlim = xlim;
handles.ylim = ylim;
PlotData(handles);
set(handles.flgUseNo, 'Value', 0);
guidata(hObject, handles);
end

% --- Executes on button press in CmdAddResults.
function CmdAddResults_Callback(hObject, eventdata, handles)
% hObject    handle to CmdAddResults (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

prompt = {'Enter Additional Results Structure:'};
dlg_title = 'Add Results';
num_lines = 1;
def = {'Results2'};
strResults = char(inputdlg(prompt,dlg_title,num_lines,def));

Results = GetLatestWorkspaceData(strResults);

if(isstruct(Results))
    eval(['handles.' strResults ' = Results;']);

    numList = size(handles.lists.Results, 1);
    handles.lists.Results(numList + 1, :) = { strResults };
    set(handles.lstResults, 'String', handles.lists.Results);
end

guidata(hObject, handles);
end

% --- Executes during object creation, after setting all properties.
function xmin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: xaxisdata controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

function xmax_Callback(hObject, eventdata, handles)
% hObject    handle to xmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xmax as text
%        str2double(get(hObject,'String')) returns contents of xmax as a double
xlimit = xlim;

posLimit = str2double(get(hObject, 'String'));
if(isnumeric(posLimit))
    if(posLimit > xlimit(1))
        xlimit(2) = posLimit;
    else
        set(hObject, 'String', '');
    end
else
    set(hObject, 'String', '');

end

xlim(xlimit);
CleanAxis;
end

% --- Executes during object creation, after setting all properties.
function xmax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: xaxisdata controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

function ymin_Callback(hObject, eventdata, handles)
% hObject    handle to ymin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ymin as text
%        str2double(get(hObject,'String')) returns contents of ymin as a double
ylimit = ylim;

posLimit = str2double(get(hObject, 'String'));
if(isnumeric(posLimit))
    if(posLimit < ylimit(2))
        ylimit(1) = posLimit;
    else
        set(hObject, 'String', '');
    end
else
    set(hObject, 'String', '');

end
ylim(ylimit);
end

% --- Executes during object creation, after setting all properties.
function ymin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ymin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: xaxisdata controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

function ymax_Callback(hObject, eventdata, handles)
% hObject    handle to ymax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ymax as text
%        str2double(get(hObject,'String')) returns contents of ymax as a double
ylimit = ylim;

posLimit = str2double(get(hObject, 'String'));
if(isnumeric(posLimit))
    if(posLimit > ylimit(1))
        ylimit(2) = posLimit;
    else
        set(hObject, 'String', '');
    end
else
    set(hObject, 'String', '');

end
ylim(ylimit);
CleanAxis;
end

% --- Executes during object creation, after setting all properties.
function ymax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ymax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: xaxisdata controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on button press in SpecifyX.
function SpecifyX_Callback(hObject, eventdata, handles)
% hObject    handle to SpecifyX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if(get(hObject,'Value'))
    set(handles.xmin, 'Enable', 'on');
    set(handles.xmax, 'Enable', 'on');
else
    set(handles.xmin, 'Enable', 'off');
    set(handles.xmax, 'Enable', 'off');
    set(gca,'XLimMode', 'auto');
end
CleanAxis;
end

% --- Executes on button press in SpecifyY.
function SpecifyY_Callback(hObject, eventdata, handles)
% hObject    handle to SpecifyY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if(get(hObject,'Value'))
    set(handles.ymin, 'Enable', 'on');
    set(handles.ymax, 'Enable', 'on');
else
    set(handles.ymin, 'Enable', 'off');
    set(handles.ymax, 'Enable', 'off');
    set(gca,'YLimMode', 'auto');
    CleanAxis;
end
end

function xmin_Callback(hObject, eventdata, handles)
% hObject    handle to xmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xmin as text
%        str2double(get(hObject,'String')) returns contents of xmin as a double
xlimit = xlim;

posLimit = str2double(get(hObject, 'String'));
if(isnumeric(posLimit))
    if(posLimit < xlimit(2))
        xlimit(1) = posLimit;
    else
        set(hObject, 'String', '');
    end
else
    set(hObject, 'String', '');

end
xlim(xlimit);
CleanAxis;
end

% --------------------------------------------------------------------
function Longitude_Callback(hObject, eventdata, handles)
% hObject    handle to Longitude (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%
% Data2Plot.XParent       = handles.XParent;
% Data2Plot.CurrentXData  = handles.CurrentXData;
% Data2Plot.XUnits        = handles.XUnits;
% Data2Plot.YDataTime     = handles.YDataTime;
%
% Data2Plot.YMember       = FormatMember(handles.YMember, numYData, iYData);
% Data2Plot.YParent       = handles.YParent;
% Data2Plot.CurrentYData  = handles.CurrentYData;
%
% Data2Plot.YUnits        = handles.YUnits;
% Data2Plot.YData         = handles.YData(:,iYData);
end

% --------------------------------------------------------------------
function XaxisData_Callback(hObject, eventdata, handles)
% hObject    handle to XaxisData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

% --------------------------------------------------------------------
function Time_Callback(hObject, eventdata, handles)
% hObject    handle to Time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

% --- Executes on button press in SaveToPPT.
function SaveToPPT_Callback(hObject, eventdata, handles)
% hObject    handle to SaveToPPT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% filename_ppt = (get(hObject, 'String'));
handles = CopyFig(handles);
filename_ppt = get(handles.filename_ppt,'String');
save2ppt(filename_ppt, handles.CurCopy);
close(gcf);
end

function filename_ppt_Callback(hObject, eventdata, handles)
% hObject    handle to filename_ppt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of filename_ppt as text
%        str2double(get(hObject,'String')) returns contents of filename_ppt as a double
end

% --- Executes during object creation, after setting all properties.
function filename_ppt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to filename_ppt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on button press in GetPPTFile.
function GetPPTFile_Callback(hObject, eventdata, handles)
% hObject    handle to GetPPTFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[fname, fpath] = uigetfile('*.ppt');
if(fpath ~= 0)
    filespec = fullfile(fpath,fname);
    set(handles.filename_ppt, 'String', filespec);
end
end

% --- Executes on selection change in lstResults.
function lstResults_Callback(hObject, eventdata, handles)
% hObject    handle to lstResults (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns lstResults contents as cell array
%        contents{get(hObject,'Value')} returns selected item from lstResults
handles = getResultNames(handles);
%
% handles.Selected.iResults = get(hObject, 'Value');
% handles.Selected.Results = char(handles.lists.Results(handles.Selected.iResults));
guidata(hObject, handles);
end

function handles = getResultNames(handles)
list_entries = get(handles.lstResults, 'String');
index_selected = get(handles.lstResults,'Value');
handles.Selected.iResults = index_selected;
handles.Selected.Results = handles.lists.Results(handles.Selected.iResults);
end
% --- Executes during object creation, after setting all properties.
function lstResults_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lstResults (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on selection change in lstMembers.
function lstMembers_Callback(hObject, eventdata, handles)
% hObject    handle to lstMembers (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns lstMembers contents as cell array
%        contents{get(hObject,'Value')} returns selected item from lstMembers
handles = getMemberNames(handles);

numMembersSelected = length(handles.Selected.iMembers);
if(numMembersSelected > 1)
    handles.flgSplitVectors = 0;
    set(handles.SplitVectors, 'Value', 0);
end

if(handles.flgSplitVectors)
    curResult = char(handles.Selected.Results(1,:));
    curMember = char(handles.Selected.Members(1,:));

    h.YParent     = [curResult '.' handles.Selected.Structure];
    h.YMember     = curMember;
    h.CurrentYData= [h.YParent '.' h.YMember];
    h.YUnits      = eval(['handles.' h.YParent '.Units.' h.YMember ';']);
    h.YData       = eval(['handles.' h.CurrentYData ';']);

    numYData = size(h.YData,2);
    if(numYData > 1)
        for iYData = 1:numYData
            lstData(iYData,:) = { FormatMember(h.YMember, numYData, iYData) };
        end
        set(handles.lstVector, 'Value', 1);

        set(handles.lstVector, 'Enable', 'on');
        set(handles.lstVector, 'String', lstData);
        set(handles.lstVector, 'BackgroundColor', [1 1 1]);
    else

        set(handles.lstVector, 'Enable', 'off');
        set(handles.lstVector, 'String', '');
        set(handles.lstVector, 'BackgroundColor', [0.75 0.75 0.75]);
    end

    if(size(h.YData, 2) == 1)
        handles.Selected.iVector = 1;
        handles.AddVectorTag = 0;
        handles = CompileData2Plot(handles);
        PlotData(handles);
    end
else
    handles = CompileData2Plot(handles);
    PlotData(handles);
end

guidata(hObject, handles);
end

function handles = getMemberNames(handles)
list_entries = get(handles.lstMembers, 'String');
index_selected = get(handles.lstMembers,'Value');
handles.Selected.iMembers = index_selected;
handles.Selected.Members = handles.lists.Members(handles.Selected.iMembers);
end

% --- Executes during object creation, after setting all properties.
function lstMembers_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lstMembers (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on button press in btnLoadRawFolder.
function btnLoadRawFolder_Callback(hObject, eventdata, handles)
% hObject    handle to btnLoadRawFolder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
directoryname = uigetdir;

if(directoryname ~= 0)
    lstMatFiles = dir([directoryname '\*.mat']);
    
    for i = 1:length(lstMatFiles);
        files2open{i,:} = char(lstMatFiles(i).name);
    end
    
    handles = Loadmat(handles, files2open, directoryname);
    
end
guidata(hObject, handles);
end

% --- Executes on selection change in lstStructures.
function lstStructures_Callback(hObject, eventdata, handles)
% hObject    handle to lstStructures (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns lstStructures contents as cell array
%        contents{get(hObject,'Value')} returns selected item from lstStructures
% Retrieve Pointer Click:
handles.Selected.iStructure =  get(hObject,'Value');
handles.Selected.Structure = handles.lists.Structure(handles.Selected.iStructure).name;

% handles.CurrentYData= handles.lstYData(handles.YSelection).name;
%
% handles.Selected.Structure = handles.lstYData(handles.YSelection).name;

flgExpanded         = handles.lists.Structure(handles.Selected.iStructure).flgExpanded;

if(flgExpanded == 0)

    % Expand Structure:
    handles.lists.Structure = ExpandStructure(handles, handles.Selected.iStructure);
else
    % Collapse Structure:
    handles.lists.Structure = CollapseStructure(handles, handles.Selected.iStructure);
end
%
%     handles.lists.SubMems = GetListVariables(handles.lstYData);
%     set(handles.lstMembers, 'String', handles.lists.SubMems);
%     handles.lists.SubStructs = GetListStructures(handles.lstYData);
%     set(handles.lstStructures, 'String', handles.lists.SubStructs);
% end
handles.lists.DispStructure = FormatDisplay(handles.lists.Structure);
set(handles.lstStructures, 'String', handles.lists.DispStructure);
set(handles.lstStructures,'Value',handles.Selected.iStructure);

rawMembers = eval(['ExcludeStructure(fieldnames(handles.' ...
    char(handles.lists.Results(1,:)) '.' char(handles.Selected.Structure) '));']);

iMem = 0;
trueMem = {''};
for i = 1:length(rawMembers)
    possibleMem = eval(['handles.' char(handles.lists.Results(1,:)) ...
        '.' char(handles.Selected.Structure) '.' char(rawMembers(i,:))]);
    if(~isstruct(possibleMem))
        iMem = iMem + 1;
        trueMem(iMem) = { char(rawMembers(i,:)) };
    end
end

handles.lists.Members = trueMem;
set(handles.lstMembers, 'String', handles.lists.Members);

if(length(handles.lists.Members) < max(handles.Selected.iMembers))
    set(handles.lstMembers, 'Value', 1);
else
    set(handles.lstMembers, 'Value', handles.Selected.iMembers);
end
if(iMem > 0)
    set(handles.lstMembers, 'Enable', 'on');
    set(handles.lstMembers, 'BackgroundColor', [1 1 1]);
else
    set(handles.lstMembers, 'Enable', 'off');
    set(handles.lstMembers, 'BackgroundColor', [0.75 0.75 0.75]);
end

% Update handles structurelistbox
guidata(hObject, handles);
end

%%
function lstNew = ExpandStructure(handles, iSelected);
lstOld = handles.lists.Structure;

i_new = 0;
for i_old = 1:length(lstOld);
    curMember = char(lstOld(i_old).name);

    i_new = i_new + 1;
    lstNew(i_new).name      = lstOld(i_old).name;
    lstNew(i_new).flgExpanded = lstOld(i_old).flgExpanded;

    if(i_old == iSelected)
        lstNew(i_new).flgExpanded = 1;
        curResults = char(handles.lists.Results(1,:));
        curStructure = eval(['handles.'  curResults '.' curMember]);
        lstAdd = eval(['ExcludeStructure(fieldnames(curStructure));']);

        for i_add = 1:length(lstAdd)

            curAdd = char(lstAdd(i_add));
            flgStruct = eval(['isstruct(handles.' curResults '.' curMember '.' curAdd ');']);

            if(flgStruct)
                i_new = i_new + 1;
                lstNew(i_new).name      = [curMember '.' curAdd];
                lstNew(i_new).flgExpanded = 0;
            end
        end
    end
end
end

%%
function lstNew = CollapseStructure(handles, iSelected);
lstOld = handles.lists.Structure;

removeMember = char(handles.Selected.Structure);
% Main Guy to Remove
% removeMember = [char(lstOld(numSelection).name) '.'];

i_new = 0;
for i_old = 1:length(lstOld);
    curMember = char(lstOld(i_old).name);

    posMatch = strfind(curMember, removeMember);

    if(i_old == handles.Selected.iStructure)
        i_new = i_new + 1;
        lstNew(i_new).name      = lstOld(i_old).name;
        %         lstNew(i_new).flgStruct = lstOld(i_old).flgStruct;
        lstNew(i_new).flgExpanded = 0;
    else

        if(isempty(posMatch))
            i_new = i_new + 1;
            lstNew(i_new).name      = lstOld(i_old).name;
            %             lstNew(i_new).flgStruct = lstOld(i_old).flgStruct;
            lstNew(i_new).flgExpanded = lstOld(i_old).flgExpanded;
        end
    end
end
end

% --- Executes during object creation, after setting all properties.
function lstStructures_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lstStructures (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on selection change in popupmenu4.
function popupmenu4_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu4 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu4
end

% --- Executes during object creation, after setting all properties.
function popupmenu4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on button press in btnRemoveResults.
function btnRemoveResults_Callback(hObject, eventdata, handles)
% hObject    handle to btnRemoveResults (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

iResults = handles.Selected.iResults;

iStay = 0;
numList = size(handles.lists.Results, 1);
for iList = 1:numList
    curResults = handles.lists.Results(iList);

    if(max(iResults == iList))
        handles = rmfield(handles, curResults);

    else
        iStay = iStay + 1;
        lstResults(iStay,:) = { char(handles.lists.Results(iList)) };
    end
end

handles.lists.Results = lstResults;
set(handles.lstResults, 'String', handles.lists.Results);
guidata(hObject, handles);
end

% --- Executes on selection change in lstVector.
function lstVector_Callback(hObject, eventdata, handles)
% hObject    handle to lstVector (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns lstVector contents as cell array
%        contents{get(hObject,'Value')} returns selected item from lstVector
handles = getVectorNames(handles);
handles.AddVectorTag = 1;
handles = CompileData2Plot(handles);

PlotData(handles);
guidata(hObject, handles);
end

function handles = getVectorNames(handles)
handles.Selected.iVector = get(handles.lstVector,'Value');
end

% --- Executes during object creation, after setting all properties.
function lstVector_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lstVector (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on button press in pushbutton12.
function pushbutton12_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

% --- Executes on button press in btnLoadCasinoRun.
function btnLoadCasinoRun_Callback(hObject, eventdata, handles)
% hObject    handle to btnLoadCasinoRun (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

% --- Executes on button press in btnLoadmat.
function btnLoadmat_Callback(hObject, eventdata, handles)
% hObject    handle to btnLoadmat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = LoadMatFile(handles);
guidata(hObject, handles);
end

function handles = LoadMatFile(handles)

[filename, pathname, filterindex] = uigetfile( ...
    {  '*.mat','MAT-files (*.mat)'}, ...
    'Selected Saved Results .mat file', ...
    'MultiSelect', 'on');
if(filterindex)
    if(~iscell(filename))
        files2open(1,:) = { filename };
    else
        files2open = filename;
    end

    handles = Loadmat(handles, files2open, pathname);
end
end

function handles = Loadmat(handles, filename, pathname)
if((iscell(filename)) ||(max(isletter(filename))))
    for iFile = 1:length(filename)
        curFilename = char(filename(iFile));
        ptrP = findstr(curFilename, '.');
        rName = [char(curFilename(1:(ptrP-1)))];
        if(isempty(pathname))
            load(curFilename);
        else
            load([pathname '\' curFilename]);
        end
        eval(['handles.' rName ' = Results;']);

        if(isfield(handles, 'lists'))
            numList = size(handles.lists.Results, 1);
        else
            numList = 0;
        end
        handles.lists.Results(numList + 1, :) = { rName };
        handles.lists.PlotLabels(numList + 1, :) = {''};

        if(isfield(Results, 'PlotLabel'))
            handles.lists.PlotLabels(numList + 1, :) = {Results.PlotLabel};
        end
    end
end
set(handles.lstResults, 'String', handles.lists.Results);
end

% --- Executes on button press in SplitVectors.
function SplitVectors_Callback(hObject, eventdata, handles)
% hObject    handle to SplitVectors (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of SplitVectors
handles.flgSplitVectors = get(hObject, 'Value');
if(handles.flgSplitVectors)

    set(handles.lstVector, 'String', '');
    set(handles.lstVector, 'Enable', 'off');
    set(handles.lstVector, 'BackgroundColor', [0.75 0.75 0.75]);

    curResult = char(handles.Selected.Results(1,:));
    curMember = char(handles.Selected.Members(1,:));

    h.CurrentResults = curResult;
    h.YParent     = [curResult '.' handles.Selected.Structure];
    h.YMember     = curMember;
    h.CurrentYData= [h.YParent '.' h.YMember];
    h.YUnits      = eval(['handles.' h.YParent '.Units.' h.YMember ';']);
    h.YData       = eval(['handles.' h.CurrentYData ';']);

    numYData = size(h.YData,2);
    if(numYData > 1)
        for iYData = 1:numYData
            lstData(iYData,:) = { sprintf('%s(%d)', h.YMember, iYData) };
        end
        set(handles.lstVector, 'Enable', 'on');
        set(handles.lstVector, 'String', lstData);
        set(handles.lstVector, 'BackgroundColor', [1 1 1]);
    else
        set(handles.lstVector, 'Enable', 'off');
        set(handles.lstVector, 'String', '');
        set(handles.lstVector, 'BackgroundColor', [0.75 0.75 0.75]);
    end
else

    set(handles.lstVector, 'Enable', 'off');
    set(handles.lstVector, 'String', '');
    set(handles.lstVector, 'BackgroundColor', [0.75 0.75 0.75]);

end
guidata(hObject, handles);
end

% --- Executes on button press in flgUseNo.
function flgUseNo_Callback(hObject, eventdata, handles)
% hObject    handle to flgUseNo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of flgUseNo
handles.flgUseNoLegend = get(hObject,'Value');
handles.flgLegendLong = 0;
handles.xlim = xlim;
handles.ylim = ylim;
PlotData(handles);
set(handles.flgUseFull, 'Value', 0);
guidata(hObject, handles);
end

% --- Executes on key press over lstResults with no controls selected.
function lstResults_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to lstResults (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over lstResults.
function lstResults_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to lstResults (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over lstVector.
function lstVector_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to lstVector (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

% --- Executes on key press over lstVector with no controls selected.
function lstVector_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to lstVector (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

% --- Executes on selection change in popup_legend_loc.
function popup_legend_loc_Callback(hObject, eventdata, handles)
% hObject    handle to popup_legend_loc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popup_legend_loc contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popup_legend_loc
contents = get(hObject,'String');
handles.legend_pos = contents{get(hObject,'Value')};
PlotData(handles);
guidata(hObject, handles);
end 

% --- Executes during object creation, after setting all properties.
function popup_legend_loc_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popup_legend_loc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on button press in btnPlotYBar.
function btnPlotYBar_Callback(hObject, eventdata, handles)
% hObject    handle to btnPlotYBar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of btnPlotYBar
handles.flgPlotYLine = get(hObject, 'Value');
if(handles.flgPlotYLine)
    set(handles.YBarVal, 'Enable', 'on');
else
    set(handles.YBarVal, 'Enable', 'off');
    xlimits = xlim;
    ylimits = ylim;
    PlotData(handles);
    xlim(xlimits);
    ylim(ylimits); 
end
guidata(hObject, handles);
end

function YBarVal_Callback(hObject, eventdata, handles)
% hObject    handle to YBarVal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of YBarVal as text
%        str2double(get(hObject,'String')) returns contents of YBarVal as a double
handles.YLineValue = str2double(get(hObject, 'String'));
PlotYLine(handles.YLineValue, 'k-.', 'LineWidth', 1.5);
guidata(hObject, handles);

guidata(hObject, handles);
end

% --- Executes during object creation, after setting all properties.
function YBarVal_CreateFcn(hObject, eventdata, handles)
% hObject    handle to YBarVal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on button press in btnPlotXBar.
function btnPlotXBar_Callback(hObject, eventdata, handles)
% hObject    handle to btnPlotXBar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of btnPlotXBar
handles.flgPlotXLine = get(hObject, 'Value');
if(handles.flgPlotXLine)
    set(handles.XBarVal, 'Enable', 'on');
else
    set(handles.XBarVal, 'Enable', 'off');
    xlimits = xlim;
    ylimits = ylim;
    PlotData(handles);
    xlim(xlimits);
    ylim(ylimits);    
end
guidata(hObject, handles);
end

% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over text17.
function text17_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to text17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

% --- Executes on button press in ReportBug.
function ReportBug_Callback(hObject, eventdata, handles)
% hObject    handle to ReportBug (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ReportBug
str1 = {'NGGN Users:';
    '    Create a ticket on the VSI Library''s TRAC page';
    ' ';
    'Non-NGGN Users:';
    '    Send email to mike.sufana@ngc.com';
    ' ';
    'Note: Please be descriptive in your bug reporting';
    '      (e.g. include sequence of button clicks used to produce error).';
    ' '};

btn1 = 'Create Ticket (NGGN Only)';
btn2 = 'Cancel';
button = questdlg(str1, 'ResultsExplorer Bug Report', btn1, btn2, btn2);

if(strmatch(button, btn1))
    web('https://vodka.ccc.northgrum.com/trac/VSI_LIB/newticket');
end
end

% --- Executes on selection change in popup_legend_string.
function popup_legend_string_Callback(hObject, eventdata, handles)
% hObject    handle to popup_legend_string (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popup_legend_string contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popup_legend_string
value = get(hObject,'Value');
handles.LegendType      = value;
handles.flgUseNoLegend  = (value == 2);
handles.flgLegendLong   = (value == 3);
handles.flgShortFull    = (value == 4);
if(handles.flgUseNoLegend)
    set(handles.popup_legend_loc, 'Enable', 'off');
else
    set(handles.popup_legend_loc, 'Enable', 'on');
end

handles.xlim = xlim;
handles.ylim = ylim;
PlotData(handles);
guidata(hObject, handles);
end

% --- Executes during object creation, after setting all properties.
function popup_legend_string_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popup_legend_string (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

function XBarVal_Callback(hObject, eventdata, handles)
% hObject    handle to XBarVal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of XBarVal as text
%        str2double(get(hObject,'String')) returns contents of XBarVal as a double
handles.XLineValue = str2double(get(hObject, 'String'));
PlotXLine(handles.XLineValue, 'k-.', 'LineWidth', 1.5);
guidata(hObject, handles);
end

% --- Executes during object creation, after setting all properties.
function XBarVal_CreateFcn(hObject, eventdata, handles)
% hObject    handle to XBarVal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes during object creation, after setting all properties.
function btnLoadmat_CreateFcn(hObject, eventdata, handles)
% hObject    handle to btnLoadmat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

end

% --- Executes on selection change in popupmenu12.
function popupmenu12_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu12 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu12

end

% --- Executes during object creation, after setting all properties.
function popupmenu12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on button press in menuCleanAxis.
function checkboxCleanAxis_Callback(hObject, eventdata, handles)
% hObject    handle to menuCleanAxis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.flgCleanAxis = get(hObject, 'Value');
PlotData(handles);
guidata(hObject, handles);
% Hint: get(hObject,'Value') returns toggle state of menuCleanAxis
end

%% Compile Outputs:
%	varargout= -1;

% << End of function ResultsExplorer >>

%% REVISION HISTORY
% YYMMDD INI: note
% 101101 JPG: Copied over information from the old function.
% 101101 CNF: Function template created using CreateNewFunc
%**Add New Revision notes to TOP of list**

% Initials Identification: 
% INI: FullName             :  Email                :  NGGN Username 
% JPG: James Patrick Gray   :  james.gray2@ngc.com  :  g61720
%% FOOTER
%
% WARNING - This document contains technical data whose export is
%   restricted by the Arms Export Control Act (Title 22, U.S.C. 2751 et 
%   seq.) or the Export Administration Act of 1979, as amended, Title 50,
%   U.S.C., App.2401et seq. Violation of these export-control laws is 
%   subject to severe civil and/or criminal penalties.
%
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------------------- UNCLASSIFIED ---------------------------
