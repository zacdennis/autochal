% LOADBINARY loads the binary files saved off by 'SaveToBin' Simulink block
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% LoadBinary:
%     Loads in the binary files that were saved off by the 'SaveToBin'
%       Simulink block
% 
% SYNTAX:
%	[mat, lstFilesOpened] = LoadBinary(strRoot, strFolder, timeStart, timeEnd, idxTime)
%	[mat, lstFilesOpened] = LoadBinary(strRoot, strFolder, timeStart, timeEnd)
%	[mat, lstFilesOpened] = LoadBinary(strRoot, strFolder, timeStart)
%	[mat, lstFilesOpened] = LoadBinary(strRoot, strFolder)
%	[mat, lstFilesOpened] = LoadBinary(strRoot)
%
% INPUTS: 
%	Name        Size    Units	Description
%   strFolder   'string'        Full path to folder containing binary file(s)
%                                Default: 'pwd'
%   timeStart   [1]     [sec]   Start time of desired data to extract
%                                Default: 0
%   timeEnd     [1]     [sec]   End time of desired data to extract
%                                Default: varies (end of last known file)
%   idxTime     [1]     [idx]   Index of the master recorded time in the
%                               binary files.  If the 'Record Internal
%                               Computer Time' on the 'SaveToBin' mask is
%                               true, this will be recognized by this
%                               function.
%                                Default: 1
%
% OUTPUTS: 
%	Name        Size	Units       Description
%   mat         [n x m] [varies]    Matrix containing time history data
%                                   n: number of timesteps
%                                   m: number of recorded signals
%	lstFilesOpened	<size> [vector] [int]  Vector of sets
%
% NOTES:
%	This function uses the 'bin2mat.m' function.
%
%	VARARGIN PROPERTIES:
%	PropertyName		PropertyValue	Default		Description
%	<PropertyName>		<units>			<Default>	<Description>
%
% EXAMPLES:
%
%   Step 1: Open & Run TEST_save2bin.mdl.
%           Depending on the length of the sim run and the maximum filesize
%           of the desired output binary files, this will create two
%           outputs:
%           Binary Output(s): Either test3.bin or test_XXX.bin
%           Log Data: test3_Log.txt
%   Step 2: Call load_biary
%               % Option 1: Load Everything
%               [mat, lstFilesOpened] = LoadBinary('test3')
%               % Option 2: Load Data between 3 and 3.2 seconds
%               [mat, lstFilesOpened] = LoadBinary('test3', pwd, 3, 3.2)
%
%	% <Enter Description of Example #1>
%	[mat, lstFilesOpened] = LoadBinary(strRoot, strFolder, timeStart, timeEnd, idxTime, varargin)
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[mat, lstFilesOpened] = LoadBinary(strRoot, strFolder, timeStart, timeEnd, idxTime)
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
%	Source function: <a href="matlab:edit LoadBinary.m">LoadBinary.m</a>
%	  Driver script: <a href="matlab:edit Driver_LoadBinary.m">Driver_LoadBinary.m</a>
%	  Documentation: <a href="matlab:pptOpen('LoadBinary_Function_Documentation.pptx');">LoadBinary_Function_Documentation.pptx</a>
%
% See also bin2mat 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/458
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/MatlabUtilities/LoadBinary.m $
% $Rev: 1718 $
% $Date: 2011-05-11 18:07:49 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [mat, lstFilesOpened] = LoadBinary(strRoot, strFolder, timeStart, timeEnd, idxTime)

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
% mat= -1;
% lstFilesOpened= -1;

%% Input Argument Conditioning:
% Pick out Properties Entered via varargin
% [<PropertyValue>, varargin]  = format_varargin('<PropertyValue', <Default>, 2, varargin);

%  switch(nargin)
%       case 0
%        idxTime= ''; timeEnd= ''; timeStart= ''; strFolder= ''; strRoot= ''; 
%       case 1
%        idxTime= ''; timeEnd= ''; timeStart= ''; strFolder= ''; 
%       case 2
%        idxTime= ''; timeEnd= ''; timeStart= ''; 
%       case 3
%        idxTime= ''; timeEnd= ''; 
%       case 4
%        idxTime= ''; 
%       case 5
%        
%       case 6
%        
%  end
%
%  if(isempty(idxTime))
%		idxTime = -1;
%  end
%% Main Function:
if((nargin < 5) || isempty(idxTime))
    idxTime = 1;
end

if(nargin < 4)
    timeEnd = [];
end

if(nargin < 3)
    timeStart = [];
end

if((nargin < 2) || isempty(strFolder))
    strFolder = pwd;
end

if nargin == 0
    strRoot = 'test3';
end

hd = pwd;
cd(strFolder);

str_log_cmd = sprintf('%s_Log', strRoot);
str_log_txt = [str_log_cmd '.txt'];
str_log_m   = [str_log_cmd '.m'];

str_log_full_txt = [strFolder filesep str_log_txt];
str_log_full_m = [strFolder filesep str_log_m];

if(exist(str_log_full_m))
    delete(str_log_full_m);
end

if(~exist(str_log_full_txt))
    disp(sprintf('%s : ERROR : ''%s'' was not found', mfilename, str_log_full_txt));
    disp(sprintf('%s           Are you sure you are in the correct directory?', spaces(length(mfilename))));
    mat = [];
    lstFilesOpened = {};
else
    
    copyfile(str_log_full_txt, str_log_full_m);
    eval(str_log_cmd);
    
    numSets = length(LogInfo.Set);
    numRefSignals = LogInfo.TotalSignals;
    
    if(numSets == 1)
        bin_filename = [strRoot '.bin'];
        mat = bin2mat(bin_filename, numRefSignals);
        
    else
        
        arrSet  = zeros(numSets*2, 1);
        arrTime = zeros(numSets*2, 1);
        
        i = 0;
        
        for iSet = 1:numSets
            i = i + 1; arrSet(i) = iSet; arrTime(i) = LogInfo.Set(iSet).StartTime;
            i = i + 1; arrSet(i) = iSet; arrTime(i) = LogInfo.Set(iSet).EndTime;
        end
        
        if(~isempty(timeStart))
            iSetStart = floor(Interp1D(arrTime, arrSet, timeStart));
        else
            iSetStart = 1;
        end
        
        if(~isempty(timeEnd))
            iSetEnd = ceil(Interp1D(arrTime, arrSet, timeEnd));
        else
            iSetEnd = numSets;
        end
        
        % Allocate memory (being smart about it)
        %   Loop through the sets that will be opened, count up the timesteps
        %   saved in each file, and then allocate only that much memory
        numTimesteps = 0;
        for iSet = iSetStart:iSetEnd
            numTimesteps = numTimesteps + LogInfo.Set(iSet).Timesteps;
        end
        mat = zeros(numTimesteps, numRefSignals);
        numSets2Load = max(1, floor(iSetEnd - iSetStart));
        lstFilesOpened = cell(numSets2Load, 1);
        
        %% Load the data in each file
        iEnd = 0;
        iset = 0;
        for iSet = iSetStart:iSetEnd
            iStart = iEnd + 1;
            numTimesteps = LogInfo.Set(iSet).Timesteps;
            curFilename = LogInfo.Set(iSet).Filename;
            iEnd = iStart + numTimesteps - 1;
            mat(iStart:iEnd, :) = bin2mat(curFilename, numRefSignals);
            iset = iset + 1;
            lstFilesOpened{iset,:} = curFilename;
        end
    end
    
    %% Downsample
    if((~isempty(timeStart)) || (~isempty(timeEnd)))
        % User wants to downsample
        
        if(isempty(timeStart))
            timeStart = LogInfo.StartTime;
        end
        
        if(isempty(timeEnd))
            timeEnd = LogInfo.EndTime;
        end
        
        if(LogInfo.TimeIsFirst)
            idxTime = 1;
        else
            % Can't do it directly
            % Even though time may be recorded as one of the signals, there's
            % no way that SaveToBin can know that.  If the 'RecordTime' flag is
            % on, then it is known that the 1st element of each timestep
            % recorded is time, which can be used to sample out the raw data.
            %
            % If the 'RecordTime' flag is false, SaveToBin doesn't know which
            % recorded element is time.
            %
            % You could assume it to be the 1st element... but that's not a
            % good guarentee
        end
        
        arrTime = mat(:,idxTime);
        arrTime = roundDec(arrTime, LogInfo.Baserate/10);
        
        iTimeStart = min(find(arrTime >= timeStart));
        iTimeEnd = max(find(arrTime <= timeEnd));
        arrTimes2Grab = iTimeStart:iTimeEnd;
        numTimesteps = length(arrTimes2Grab);
        mat2 = zeros(numTimesteps, numRefSignals);
        mat2 = mat(arrTimes2Grab, :);
        clear mat;
        mat = mat2; clear mat2;
    end
    
    %% Housekeeping
    if(exist(str_log_full_m))
        delete(str_log_full_m);
    end
end
cd(hd);

%% Compile Outputs:
%	mat= -1;
%	lstFilesOpened= -1;

end % << End of function LoadBinary >>

%% REVISION HISTORY
% YYMMDD INI: note
% 101025 JPG: Copied over information from the old function.
% 101025 CNF: Function template created using CreateNewFunc
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
