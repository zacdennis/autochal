% PLOT <one line description>
% -------------------------- UNCLASSIFIED ---------------------------
% --------------- Nothrop Grumman Proprietary Level 1 ---------------
% ------------------ ITAR Controlled Work Product -------------------
% plot:
%     < Function Description > 
% 
% Inputs - obj: {0,[1]}: <explain {options, [Default]}> 
%		 - varargin: {0,[1]}: <explain {options, [Default]}> 
%		 
% Output - h: <Explanation> 
%        - info: Last argument should be diagnosis info
%
% <any additional informaton>
%
% Example:
%	[h,info] = Plot_AeroTbl(obj,varargin);
%
% See also <add relevent funcions> 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/616
%
% Copyright Northrop Grumman Corp 2011

% Subversion Revsion Informaton At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/AeroDB/@AeroElm/plot.m $
% $Rev:: 1713                                                 $
% $Date:: 2011-05-11 15:12:26 -0500 (Wed, 11 May 2011)        $

function [h,info] = plot(obj,varargin)

%% General Header 
% spc  = sprintf(' ');
% tab  = sprintf('\t');
% endl = sprintf('\n');
% mfnam = mfilename;
% mfspc = char(ones(1,length(mfnam))*spc);

%% Arg conditioning
n = length(obj.IndepVars);
DataCell = cell(n,4);
UnusedNames = ones(n,1);

%DataCellArangment 'name',values, originalDimension

argidx = 1;
for i=1:n % begin loop through arguments
    if argidx > length(varargin)
        if i==n
            DataCell = LocFcn_DataShift(DataCell);
            break;
        else
            error('not enough input arguments');%TODO Update This Error
        end
    elseif ischar(varargin{argidx}) %char input
        nameidx = find(strcmp(obj.IndepVars(:,1),varargin{argidx})); %part of indepvar?
        if ~isempty(nameidx)
            DataCell{i,1} = varargin{argidx};
            UnusedNames(nameidx) = 0; %note 
            argidx = argidx + 1;
            if argidx<=length(varargin) && isnumeric(varargin{argidx})
                if isempty(varargin{argidx})
                    DataCell{i,2} = [-Inf,Inf]; %empty set means all of them
                else
                    DataCell{i,2} = varargin{argidx};
                end
                argidx = argidx + 1; 
            else
                DataCell{i,2} = [-Inf, Inf];
            end
        else %we have reached the plot flags before expected  or there is a bad name in there... 
            if i==n
                DataCell = LocFcn_DataShift(DataCell);
            else
                error('what went wrong?'); %TODO: Fix this... 
            end
        end
    elseif isnumeric(varargin{argidx})
        %the argumetn is numeric, but not prefaced with a string.  
        %leave name blank, fill in teh number
        if isempty(varargin{argidx})
            DataCell{i,2} = [-Inf,Inf]; %empty set means all of them
        else
            DataCell{i,2} = varargin{argidx};
        end
        argidx = argidx + 1; 
    else
        error('improper input type or name'); %Todo: Expand Error to full form
    end
end
 
%Check to see if all the indeps have been allocated... allocate ones not
%selected to first empty space
emptyarray = find(cellfun('isempty',DataCell(:,1)));
fUnusedNames = find(UnusedNames); 
if length(emptyarray) == length(fUnusedNames)
    DataCell(emptyarray,1) = deal(obj.IndepVars(fUnusedNames));
else
     error('can''t allcate all names'); %TODO: Expand error
end

%Determin Plot order
%find the First vector
xdim = find(cellfun('length',DataCell(:,2))>1); % find the vector input(s)
lenxdim = length(xdim);
%Note:First vector input must be the desired X axis 
if lenxdim == 0 || lenxdim > 2
    error('not enough or too many vector arguments in input');
else %has one or two vector in puts... 
    %circulate till first value on top
    DataCell = circshift(DataCell,-[xdim(1)-1]); %#ok<NBRAK> 
    if lenxdim == 2 % has two, rotate the rest... 
        %then rotate rest till second vector on second row
        DataCell(2:end,:) = circshift(DataCell(2:end,:),-[xdim(2)-xdim(1)-1]); %#ok<NBRAK>
    end
end

if length(varargin) > (argidx-1)
    RemArgIn = varargin(argidx:end); %save remaining arguments (pass toplot function)
else
    RemArgIn = ''; 
end
%% setup plot data structure
DimOrder = zeros(n,1);
for i=1:n
    [DataCell{i,4},DimOrder(i)] = obj.GetIndepVal(DataCell{i,1});
    %Values   dimensoion         = GetIndepVal('name');
    if length(DataCell{i,2}) == 1
        DataCell{i,3} = obj.GetNearestIdx(DataCell{i,4},DataCell{i,2});
    else
        DataCell{i,3} = obj.GetIndexRange(DataCell{i,4},DataCell{i,2}); 
    end
    DataCell{i,2} = DataCell{i,4}(DataCell{i,3}); % overwrite domain with values to be used 
    %Indexes... 
end
% Rotate Data 
%I'm not sure if i need to do this... 
Data = permute(obj.DepData,DimOrder);

%% Plot and Format
H = gcf;
if isempty(RemArgIn)
    h = plot(DataCell{1,2},squeeze(Data(DataCell{:,3})),'-d');
else
    h = plot(DataCell{1,2},squeeze(Data(DataCell{:,3})),RemArgIn{:});
end

CurAxis = axis;
newxdif = 0.1*(CurAxis(2) - CurAxis(1));
xlim([CurAxis(1)-newxdif, CurAxis(2)+newxdif]);
newydif = 0.1*(CurAxis(4) - CurAxis(3));
ylim([CurAxis(3)-newydif, CurAxis(4)+newydif]);
grid on; 

% First Title Attempt
% titlestr = ['AeroTbl plot of ' obj.DepVar '(' DataCell{1,1} ')'];  
% if length(h) >1 
%     SecVarRange = [min(DataCell{2,2}) max(DataCell{2,2})];
%     titlestr = [titlestr endl 'for each ' DataCell{2,1} ' ' mat2str(SecVarRange)]; 
% end
% Second Title Attempt
titlestr = [obj.DepVar '(' DataCell{1,1} '(:)'];
si = 2; %start index of general loop
if length(h) >1 
    SecVarRange = [min(DataCell{2,2}) max(DataCell{2,2})];
    titlestr = [titlestr ',' DataCell{2,1} '=' mat2str(SecVarRange)]; 
    si = 3; %change start index of general loop
    
    % Legend
    for i=1:length(h) %for each value used along second direction
        LegendCell{i} = [DataCell{2,1} '= ' num2str(DataCell{2,2}(i))]; %#ok<AGROW>
    end
    legend(LegendCell{:},'Location','Best');
end

for i=si:n
    titlestr = [titlestr ',' DataCell{i,1} '=' num2str(DataCell{i,2})]; %#ok<AGROW>
end
titlestr = [titlestr ')']; 
title(titlestr);

ylabel(obj.DepVar);
xlabel(DataCell{1,1});

%% < Function Sections >

% Example of Display formats ...
% disp([mfnam '>> Output with filename included...' ]);
% disp([mfspc '>> further outputs will be justified the same']);
% disp([mfspc '>>CAUTION: or mfnam: note lack of space after">>"']);
% disp([mfnam '>>WARNING: <- Very important warning (does not terminate)']);
% disp([mfnam '>>ERROR: <-if followed by "return" used if continued exit desired']);
% errstr = [mfname >>ERROR: <define error here> ]; will term with error; "doc Error" ';
% error([mfnam 'class:file:Identifier'],errstr);

%% Outputs 

info = -1;

%% Return 
return

%% SUB: LocFcn_DataShift
function DataCell = LocFcn_DataShift(DataCell)

lastStr = find(cellfun('isclass',DataCell(:,1),'char'),1,'last');%find last string spot
if isempty(lastStr)
    error('too few arguments or something'); %TODO: Fix this error
else
    DataCell(lastStr+1:end,2) = DataCell(lastStr:end-1,2);
    DataCell{lastStr,2} = [-Inf,Inf];
end
return %LocFcn_DataShift

%% Revision History
% ONLY REQUIRED FOR FILES NOT UNDER REVISION CONTROL% YYMMDD INI: note
% 080506 TKV: added improved input arg reading detects last 'indep' as an
% 'indep,[]' if number of input arguments seems to suggest it... 
% 080505 TKV: updated use of DataCell{i,2} to update to USED domain of
% second argument
%             Changed Title printing
%           - Added Legend Code
%           - Major Rework.
% 080505 TKV: Changing Switch logic for Shorcut to if then else... 
% 080505 TKV: Resuming use of this note:
% 080429 TKV: initial attemps... 
% 080429 CNF: File Created by CreateNewFunc
%**Add New Revision notes to TOP of list**

% Initials Identification: 
% INI: FullName  :  Email  :  NGGN Username 
% TKV: Travis Vetter : travis.vetter@ngc.com : vettetr 

%% Footer
% -------------------------- UNCLASSIFIED ---------------------------
% --------------- Nothrop Grumman Proprietary Level 1 ---------------
% ------------------ ITAR Controlled Work Product -------------------
