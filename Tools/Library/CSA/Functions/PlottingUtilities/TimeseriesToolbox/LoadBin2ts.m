% LOADBIN2TS Loads in the binary files that were saved off by the 'SaveToBin' Simulink block
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% LoadBin2ts:
%     Loads in the binary files that were saved off by the 'SaveToBin'
%   Simulink block
%
% SYNTAX:
%	[Results, lstFilesOpened, mat] = LoadBin2ts(strRoot, strFolder, timeStart, timeEnd, idxTime, Results, OutputStruct, varargin, 'PropertyName', PropertyValue)
%	[Results, lstFilesOpened, mat] = LoadBin2ts(strRoot, strFolder, timeStart, timeEnd, idxTime, Results, OutputStruct, varargin)
%	[Results, lstFilesOpened, mat] = LoadBin2ts(strRoot, strFolder, timeStart, timeEnd, idxTime, Results, OutputStruct)
%	[Results, lstFilesOpened, mat] = LoadBin2ts(strRoot, strFolder, timeStart, timeEnd, idxTime, Results)
%	[Results, lstFilesOpened, mat] = LoadBin2ts(strRoot, strFolder, timeStart, timeEnd)
%	[Results, lstFilesOpened, mat] = LoadBin2ts(strRoot, strFolder, timeStart)
%	[Results, lstFilesOpened, mat] = LoadBin2ts(strRoot, strFolder)
%	[Results, lstFilesOpened, mat] = LoadBin2ts(strRoot)
%
% INPUTS:
%	Name          	Size		Units		Description
%   strRoot     'string'        Binary Filename Root
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
%   Results     {structure}     Results structure in which to add parsed
%                               data
%                                Default: []
%   OutputStruct    'string'    Name of sub-structure in which to place
%                               parsed data
%                                Default: ''
%	varargin	[N/A]		[varies]	Optional function inputs that
%	     		        				 should be entered in pairs.
%	     		        				 See the 'VARARGIN' section
%	     		        				 below for more details
%
% OUTPUTS:
%	Name          	Size		Units		Description
%   Results         {structure}     Input Results Structure with added data
%   lstFilesOpened  {strings}       List of Binary Files that were opened
%   mat         [n x m]  [varies]   Matrix containing time history data
%                                   n: number of timesteps
%                                   m: number of recorded signals
%      [vector] [int]  Vector of sets
%
% NOTES:
%   This function uses the 'bin2mat.m' function.
%
%	VARARGIN PROPERTIES:
%	PropertyName		PropertyValue	Default		Description
%   'SignalList'        {'string'}      (all)
%
% EXAMPLES:
%
%   Refer to DRIVER_save2bin.m located in TOOLS\SAVE2BIN for full example.
%
%	% <Enter Description of Example #1>
%	[Results, lstFilesOpened, mat] = LoadBin2ts(strRoot, strFolder, timeStart, timeEnd, idxTime, Results, OutputStruct, varargin)
%	% <Copy expected outputs from Command Window>
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit LoadBin2ts.m">LoadBin2ts.m</a>
%	  Driver script: <a href="matlab:edit Driver_LoadBin2ts.m">Driver_LoadBin2ts.m</a>
%	  Documentation: <a href="matlab:pptOpen('LoadBin2ts_Function_Documentation.pptx');">LoadBin2ts_Function_Documentation.pptx</a>
%
% See also bin2mat
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/676
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/PlottingUtilities/TimeseriesToolbox/LoadBin2ts.m $
% $Rev: 2468 $
% $Date: 2012-08-10 09:13:13 -0500 (Fri, 10 Aug 2012) $
% $Author: healypa $

function [Results, lstFilesOpened, mat] = LoadBin2ts(strRoot, strFolder, timeStart, timeEnd, idxTime, Results, OutputStruct, varargin)

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
% Results= -1;
% lstFilesOpened= -1;
% mat= -1;

%% Input Argument Conditioning:
% Pick out Properties Entered via varargin
[lstSignalsToExtractRaw, varargin]  = format_varargin('SignalList', '', 2, varargin);
[SaveOnly, varargin]                = format_varargin('SaveOnly', 0, 2, varargin);
[SaveIndividual, varargin]          = format_varargin('SaveIndividual', SaveOnly, 2, varargin);
[SaveFolder, varargin]              = format_varargin('SaveFolder', strFolder, 2, varargin);
[verbose, varargin]                 = format_varargin('verbose', 1, 2, varargin);

if(nargin < 7)
    OutputStruct = '';
end

if(nargin < 6)
    Results = [];
end

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

%% Main Function:
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
    
    %% Part 1: Open up the LogInfo:
    copyfile(str_log_full_txt, str_log_full_m);
    clear LogInfo;
    eval(['clear ' str_log_cmd]);
    eval(str_log_cmd);
    
    numSets = length(LogInfo.Set);
    numRefSignals = LogInfo.TotalSignals;
    
    %% Part 2: Read in the lstResultsList:
    if(isempty(LogInfo.lstResultsList))
        for i = 1:LogInfo.TotalSignals;
            if(i == 1 && LogInfo.TimeIsFirst)
                LogInfo.lstResultsList(i,1) = { 'Time' };
                LogInfo.lstResultsList(i,2) = { 1 };
                LogInfo.lstResultsList(i,3) = { '[sec]' };
            else
                LogInfo.lstResultsList(i,1) = { sprintf('signal%d', i) };
                LogInfo.lstResultsList(i,2) = { 1 };
                LogInfo.lstResultsList(i,3) = { 'UNK' };
            end
        end
    end
    
    if(isempty(lstSignalsToExtractRaw))
        %         lstSignalsToExtract = LogInfo.TotalSignals;
        LoadMethod_idx = 2;     % 1 - Individual, 2 - All at once
        lstSignalsToExtractRaw = LogInfo.lstResultsList;
        %         arrSignalsToExtract = [1:numRefSignals];
        %                 LogInfo.lstDesired  = LogInfo.lstResultsList;
        
    else
        %         lstSignalsToExtract = {};
        %         arrSignalsToExtract = [];
        %         LogInfo.lstDesired  = {};
        LoadMethod_idx = 1;
        if(ischar(lstSignalsToExtractRaw))
            lstSignalsToExtractRaw = { lstSignalsToExtractRaw };
        end
    end
    
    %%
    ctr = 1;
    SignalToExtract(ctr).Signal = 'Time';
    SignalToExtract(ctr).Dim    = 1;
    SignalToExtract(ctr).Units  = '[sec]';
    SignalToExtract(ctr).Indices= idxTime;
    
    if(LogInfo.TimeIsFirst)
        loopStart = 2;
    else
        loopStart = 1;
        disp('WARNING!');
    end
    idxStart = loopStart;
    
    for i = loopStart:size(LogInfo.lstResultsList, 1)
        curSignalRaw = LogInfo.lstResultsList{i, 1};
        if(isempty(OutputStruct))
            curSignal = curSignalRaw;
        else
            curSignal = [OutputStruct '.' curSignalRaw];
        end
        
        curDim    = LogInfo.lstResultsList{i, 2};
        curUnits  = LogInfo.lstResultsList{i, 3};
        idxEnd = idxStart + curDim - 1;
        arrIndices = unique([idxStart:idxEnd]);
        
        for j = 1:size(lstSignalsToExtractRaw, 1)
            curSignalToExtract = lstSignalsToExtractRaw{j,:};
            
            if(~isempty(strfind(curSignal, curSignalToExtract)))
                % Now check for <Signal>(1) sort of commands
                % <TODO> Add this in
                ctr = ctr + 1;
                SignalToExtract(ctr).Signal = curSignal;
                SignalToExtract(ctr).Dim    = curDim;
                SignalToExtract(ctr).Units  = curUnits;
                SignalToExtract(ctr).Indices= arrIndices;
                break;
            end
        end
        idxStart = idxEnd+1;
    end
    numSignalsToExtract = size(SignalToExtract, 2);
    
    if(numSignalsToExtract > 1)
        if(verbose)
            disp(sprintf('%s : Loading %d signals from ''%s'' binary files in ''%s'' folder..', ...
                mfilename, numSignalsToExtract, strRoot, strFolder));
        end
        
        
        switch LoadMethod_idx
            case 2
                clear mat;
                
                %% Load in the binary date
                if(numSets == 1)
                    bin_filename = LogInfo.Set(1).Filename;
%                     mat = bin2mat(bin_filename, numRefSignals, [], [], 0, 1);
                    mat = bin2mat(bin_filename, numRefSignals, [], [], 0, 0);
                    lstFilesOpened = { bin_filename };
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
%                     mat = zeros(numTimesteps, numRefSignals);
                    mat = zeros(numRefSignals, numTimesteps);
                    
                    numSets2Load = max(1, floor(iSetEnd - iSetStart)+1);
                    lstFilesOpened = cell(numSets2Load, 1);
                    
                    %% Load the data in each file
                    iEnd = 0;
                    for iSet = iSetStart:iSetEnd
                        iStart = iEnd + 1;
                        numTimesteps = LogInfo.Set(iSet).Timesteps;
                        curFilename = LogInfo.Set(iSet).Filename;
                        iEnd = iStart + numTimesteps - 1;
                        
%                         mat(iStart:iEnd, :) = bin2mat(curFilename, numRefSignals, [], [], 0, 1);
                        mat(:, iStart:iEnd) = bin2mat(curFilename, numRefSignals, [], [], 0, 0);
                        lstFilesOpened{iSet-iSetStart+1,:} = curFilename;
                    end
                end
                
                curSignalLast = '';
                for iSignalToExtract = 1:numSignalsToExtract
                    curSignal   = SignalToExtract(iSignalToExtract).Signal;
                    curDim      = SignalToExtract(iSignalToExtract).Dim;
                    curUnits    = SignalToExtract(iSignalToExtract).Units;
                    curIndices  = SignalToExtract(iSignalToExtract).Indices;
                    if(verbose)
                        disp(sprintf('%s : %d/%d Processing %s...', mfilename, ...
                            iSignalToExtract, numSignalsToExtract, curSignal));
                    end
                    if(strcmp(curSignal, curSignalLast))
                        %                 disp('DEBUG');
                    else
                        curSignalLast = curSignal;
                    end
                    
                    if(iSignalToExtract == 1)
                        %% Get Time
%                         t = mat(:, curIndices);
                        t = mat(curIndices, :)';
                        numTimesteps = length(t);
                        iTimes2Grab = [1:numTimesteps]';
                        
                        %% Downsample
                        if((~isempty(timeStart)) || (~isempty(timeEnd)))
                            % User wants to downsample
                            if(isempty(timeStart))
                                timeStart = LogInfo.StartTime;
                            end
                            
                            if(isempty(timeEnd))
                                timeEnd = LogInfo.EndTime;
                            end
                            
                            arrTime = roundDec(t, LogInfo.Baserate/10);
                            
                            iTimeStart = min(find(arrTime >= timeStart));
                            iTimeEnd = max(find(arrTime <= timeEnd));
                            iTimes2Grab = [iTimeStart:iTimeEnd]';
                            
                            t = arrTime(iTimes2Grab);
                            numTimesteps = length(t);
                        end
                        
                    else
                        
                        %% Place data into Time Series
                        clear y;
                        y = zeros(numTimesteps, curDim);
%                         y = mat(iTimes2Grab, curIndices);
                        y = mat(curIndices, iTimes2Grab)';
                        
                        clear ts;
                        ts = timeseries(y, t);
                        ts.Name = curSignal;
                        ts.DataInfo.Units = curUnits;
                        
                        if(SaveIndividual)
                            SaveFilename =  sprintf('%s%s%s.mat', SaveFolder, filesep, ts.Name);
                            save(SaveFilename, 'ts');
                        end
                        
                        if(~SaveOnly)
                            eval_str = ['Results.' curSignal ' = ts;'];
                            eval_str = strrep(eval_str, '..', '.');
                            eval(eval_str);
                        end
                    end
                end
                
                %% ====================================================
            case 1
                
                curSignalLast = '';
                for iSignalToExtract = 1:numSignalsToExtract
                    curSignal   = SignalToExtract(iSignalToExtract).Signal;
                    curDim      = SignalToExtract(iSignalToExtract).Dim;
                    curUnits    = SignalToExtract(iSignalToExtract).Units;
                    curIndices  = SignalToExtract(iSignalToExtract).Indices;
                    if(verbose)
                        disp(sprintf('%s : %d/%d Processing %s...', mfilename, ...
                            iSignalToExtract, numSignalsToExtract, curSignal));
                    end
                    if(strcmp(curSignal, curSignalLast))
                        %                 disp('DEBUG');
                    else
                        curSignalLast = curSignal;
                    end
                    
                    if(numSets == 1)
                        bin_filename = LogInfo.Set(1).Filename;
                        mat = bin2mat(bin_filename, numRefSignals, curIndices, [], 0);
                        lstFilesOpened = { bin_filename };
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
                        mat = zeros(numTimesteps, numSignalsToExtract);
                        
                        numSets2Load = max(1, floor(iSetEnd - iSetStart)+1);
                        lstFilesOpened = cell(numSets2Load, 1);
                        
                        %% Load the data in each file
                        iEnd = 0;
                        for iSet = iSetStart:iSetEnd
                            iStart = iEnd + 1;
                            numTimesteps = LogInfo.Set(iSet).Timesteps;
                            curFilename = LogInfo.Set(iSet).Filename;
                            iEnd = iStart + numTimesteps - 1;
                            
                            mat(iStart:iEnd, :) = bin2mat(curFilename, numRefSignals, curIdxSignalToExtract);
                            lstFilesOpened{iSet-iSetStart+1,:} = curFilename;
                        end
                    end
                    
                    if(iSignalToExtract == 1)
                        
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
                        
                        t = mat;
                    else
                        
                        %% Place data into Time Series
                        curSignalToExtract = SignalToExtract(iSignalToExtract);
                        ynamefull   = curSignalToExtract.Signal;
                        numDims     = curSignalToExtract.Dim;
                        yunits      = curSignalToExtract.Units;
                        
                        % Loop Through the Dimensions of the ListMatFile Member
                        clear y;
                        y = mat;
                        
                        clear ts;
                        ts = timeseries(y, t);
                        ts.Name = ynamefull;
                        ts.DataInfo.Units = yunits;
                        
                        if(SaveIndividual)
                            SaveFilename =  sprintf('%s%s%s.mat', SaveFolder, filesep, ts.Name);
                            save(SaveFilename, 'ts');
                        end
                        
                        if(~SaveOnly)
                            eval_str = ['Results.' ynamefull ' = ts;'];
                            eval_str = strrep(eval_str, '..', '.');
                            eval(eval_str);
                        end
                    end
                end
                
        end
    end
    
    %% Housekeeping
    if(exist(str_log_full_m))
        delete(str_log_full_m);
    end
    
end
cd(hd);

end % << End of function LoadBin2ts >>



%% REVISION HISTORY
% YYMMDD INI: note
% 101026 JPG: Copied over information from the old function.
% 101026 CNF: Function template created using CreateNewFunc
%**Add New Revision notes to TOP of list**

% Initials Identification:
% INI: FullName             : Email                 : NGGN Username
% MWS: Mike Sufana          : mike.sufana@ngc.com   : sufanmi
% JPG: James Patrick Gray   : james.gray2@ngc.com   : g61720

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
