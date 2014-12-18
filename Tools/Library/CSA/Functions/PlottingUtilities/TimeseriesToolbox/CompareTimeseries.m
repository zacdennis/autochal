% CompareTimeseries Compares Two Directories of Timeseries Signals
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% CompareTimeseries:
%     Compares Two Directories of Timeseries Signals.  This function can be
%     used to compare two revisions of an RTCF simulation.
%
% SYNTAX:
%	LogFilenameFull = CompareTimeseries(NewInfo, OldInfo, varargin, 'PropertyName', PropertyValue)
%	LogFilenameFull = CompareTimeseries(NewInfo, OldInfo, varargin)
%	LogFilenameFull = CompareTimeseries(NewInfo, OldInfo)
%
% INPUTS:
%	Name            Size        Units	Description
%	NewInfo         {struct}            Information on 'New' data
%    .SourceFolder  'string'    [char]  Full path to directory containing
%                                        'New' data in .mat format
%    .Title         'string'    [char]  Short tag for 'New' data
%	OldInfo         {struct}            Information on 'Old' data
%    .SourceFolder  'string'    [char]  Full path to directory containing
%                                        'Old' data in .mat format
%    .Title         'string'    [char]  Short tag for 'Old' data
%	varargin        [N/A]	   [varies] Optional function inputs that
%	     		        				 should be entered in pairs.
%	     		        				 See the 'VARARGIN' section
%	     		        				 below for more details
%
% OUTPUTS:
%	Name            Size		Units	Description
%	LogFilenameFull	'string'    [char]  Full path of outputted log file
%
% NOTES:
%
%	VARARGIN PROPERTIES:
%	PropertyName		PropertyValue	Default		Description
%	'Threshold'         [double]        1e-8        Threshold for declaring
%                                                    delta data good (
%                                                    abs(New-Old) <=
%                                                    Threshold)
%   'NameChanges'       {N x 2 cell}    {}          List of Any Signal name
%                                                    changes between 'New'
%                                                    and 'Old', where...
%                                                   {:,1}: New Signal Name
%                                                   {:,2}: Old Signal Name
%   'TestCases'         {M x 3 cell}    {}          List of Test Case
%                                                    Folders under each
%                                                    SourceFolder
%                                                   {:,1}: New Folder Name
%                                                   {:,2}: Old Folder Name
%                                                          Assumes 'New' if
%                                                          blank
%                                                   {:,3}: Test Case Name
%                                                          Assumes 'New' if
%                                                          blank
%   'SaveFolder'        'string'        pwd         Full path to directory
%                                                    where log file should
%                                                    be created
%   'IncludeUnits'      bool            false       Include units in
%                                                    logging?
%   'TestCase'          'string'        ''          Optional string that
%                                                    can be included in log
%   'OpenLog'           bool            true        Open log after
%                                                    creation?
%
% EXAMPLES:
%   % See 'Driver_CompareTimeseries.m' for full working example.
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit CompareTimeseries.m">CompareTimeseries.m</a>
%	  Driver script: <a href="matlab:edit Driver_CompareTimeseries.m">Driver_CompareTimeseries.m</a>
%	  Documentation: <a href="matlab:winopen(which('CompareTimeseries_Function_Documentation.pptx'));">CompareTimeseries_Function_Documentation.pptx</a>
%
% See also diffts, dir_list, Cell2PaddedStr
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://trac.ngst.northgrum.com/CSA/ticket/859
%
% Copyright Northrop Grumman Corp 2014
% Maintained by: Aerospace Systems
% http://trac.ngst.northgrum.com/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/PlottingUtilities/TimeseriesToolbox/CompareTimeseries.m $
% $Rev: 3319 $
% $Date: 2014-12-03 17:32:17 -0600 (Wed, 03 Dec 2014) $
% $Author: sufanmi $

function LogFilenameFull = CompareTimeseries(NewInfo, OldInfo, varargin)

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

tStart_sec = tic;

%% Input Argument Conditioning:
[Threshold, varargin]       = format_varargin('Threshold', 1e-8, 2, varargin);
[lstNameChanges, varargin]  = format_varargin('NameChanges', {}, 2, varargin);
[SaveFolder, varargin]      = format_varargin('SaveFolder', pwd, 2, varargin);
[LogFilename, varargin]     = format_varargin('LogFilename', '', 2, varargin);
[TestCase, varargin]        = format_varargin('TestCase', '', 2, varargin);
[TimeOffset, varargin]      = format_varargin('TimeOffset', 0, 2, varargin);
[OpenLog, varargin]         = format_varargin('OpenLog', 1, 2, varargin);
[lstTestCases, varargin]    = format_varargin('TestCases', {}, 2, varargin);
[lstSignalIgnore, varargin] = format_varargin('SignalIgnore', {'Time'; 'Tutc';'Tsim'}, 2, varargin);
[PlotFailed, varargin]      = format_varargin('PlotFailed', false, 2, varargin);
[MarkerSize, varargin]      = format_varargin('MarkerSize', 12, 2, varargin);
[LineWidth, varargin]       = format_varargin('LineWidth', 1.5, 2, varargin);
[OldMarkerStr, varargin]    = format_varargin('OldMarkerStr', 'bs-', 2, varargin);
[NewMarkerStr, varargin]    = format_varargin('NewMarkerStr', 'gx--', 2, varargin);
[DiffMarkerStr, varargin]   = format_varargin('DiffMarkerStr', 'bx-', 2, varargin);
[FigurePosition, varargin]  = format_varargin('FigurePosition', [1000   485   851  1013], 2, varargin);
[IncludeUnits, varargin]    = format_varargin('IncludeUnits', false, 2, varargin);
[SavePPT, varargin]         = format_varargin('SavePPT', true, 2, varargin);
[CloseAfterSave, varargin]  = format_varargin('CloseAfterSave', true, 2, varargin);
[BatchMode, varargin]       = format_varargin('BatchMode', false, 2, varargin);
[PPTTemplate, varargin]     = format_varargin('PPTTemplate', which('NGCTemplate.pptx'), 2, varargin);

flgUseTestCases = ~isempty(lstTestCases);
if(isempty(LogFilename))
    LogFilename = sprintf('%s_vs_%s_Comparison_Log.txt', ...
        NewInfo.Title, OldInfo.Title);
end
LogFilenameFull = [SaveFolder filesep LogFilename];
PPTFilenameFull = strrep(LogFilenameFull, '.txt', '.pptx');

if(PlotFailed && SavePPT)
    try
        delete(PPTFilenameFull);
    catch
        disp(sprintf('%s : Warning : Attempted to delete ''%s'', but it''s still open.', ...
            mfilename, PPTFilenameFull));
    end
    copyfile(PPTTemplate, PPTFilenameFull, 'f');
end

if(~iscell(lstSignalIgnore))
    lstSignalIgnore = { lstSignalIgnore };
end
numSignalIgnore = size(lstSignalIgnore, 1);
if(numSignalIgnore > 0)
    for iSignalIgnore = 1:numSignalIgnore
        curSignalIgnore = lstSignalIgnore{iSignalIgnore, 1};
        
        % Ensure that the '.mat' extension is in there
        if( ~strcmp(curSignalIgnore(end-3:end), '.mat') )
            curSignalIgnore = [curSignalIgnore '.mat'];
            lstSignalIgnore{iSignalIgnore, 1} = curSignalIgnore;
        end
    end
end

%% Main Function:
numTestCases = size(lstTestCases, 1);
numTestCases = max(numTestCases, 1);

LogMsg = {};

flgAllPassed = 1;
lstTestPass = {}; iTestPass = 0;
lstTestFail = {}; iTestFail = 0;

for iTestCase = 1:numTestCases
    if(~flgUseTestCases)
        % Assume it's a one-off comparison
        NewSourceFolder = NewInfo.SourceFolder;
        OldSourceFolder = OldInfo.SourceFolder;
    else
        % Comparing multiple subfolders
        numCol = size(lstTestCases, 2);
        NewSubFolder = lstTestCases{iTestCase, 1};
        
        % Pick off the OldSubFolder
        if(numCol > 1)
            OldSubFolder = lstTestCases{iTestCase, 2};
        else
            OldSubFolder = '';
        end
        if(isempty(OldSubFolder))
            OldSubFolder = NewSubFolder;
        end
        
        if(numCol > 2)
            TestCase = lstTestCases{iTestCase, 3};
        else
            TestCase = '';
        end
        if(isempty(TestCase))
            TestCase = NewSubFolder;
        end
        
        if(numCol > 3)
            TimeOffset = lstTestCases{iTestCase, 4};
        else
            TimeOffset = [];
        end
        
        if(isempty(TimeOffset))
            TimeOffset = 0;
        end
        
        NewSourceFolder = [NewInfo.SourceFolder filesep NewSubFolder];
        OldSourceFolder = [OldInfo.SourceFolder filesep OldSubFolder];
        
        disp(sprintf('%s : [%d/%d] : Processing ''%s'' TestCase...', ...
            mfilename, iTestCase, numTestCases, TestCase));
    end
    
    maxLength = 0;
    disp(sprintf('%s : Searching ''New'' Folder - ''%s'' for parsed timeseries .mat files...', ...
        mfilename, NewSourceFolder));
    lstNew = dir_list('*.mat', 0, 'Root', NewSourceFolder, 'FileExclude', lstSignalIgnore);
    
    numNew = size(lstNew, 1);
    disp(sprintf('%s   %d .mat files found...', spaces(length(mfilename)), numNew));
    numNewSignals = 0;
    arrDTNew = []; arrDPNew = [];
    for iNew = 1:numNew
        curNew = lstNew{iNew, 1};
        load([NewSourceFolder filesep curNew]);
        [nDPs, nDim] = size(ts.Data);
        numNewSignals = numNewSignals + nDim;
        curLength = length(strrep(curNew, '.mat', ''));
        if(nDim > 1)
            curLength = curLength + length(sprintf('(%d)', nDim));
        end
        maxLength = max(curLength, maxLength);
        
        if(iNew == 1)
            NewInfo.tStart = ts.TimeInfo.Start;
            NewInfo.tEnd    = ts.TimeInfo.End;
        else
            NewInfo.tStart = min(NewInfo.tStart, ts.TimeInfo.Start);
            NewInfo.tEnd = max(NewInfo.tEnd, ts.TimeInfo.End);
        end
        
        NewInfo.FileInfo(iNew).File     = curNew;
        NewInfo.FileInfo(iNew).nDPs     = nDPs;
        NewInfo.FileInfo(iNew).nDim     = nDim;
        NewInfo.FileInfo(iNew).tStart   = ts.TimeInfo.Start;
        NewInfo.FileInfo(iNew).tEnd     = ts.TimeInfo.End;
        NewInfo.FileInfo(iNew).dt       = ts.Time(2) - ts.Time(1);
        arrDTNew(iNew) = NewInfo.FileInfo(iNew).dt;
        arrDPNew(iNew) = nDPs;
    end
    disp(sprintf('%s   %d total signals found...', spaces(length(mfilename)), numNewSignals));
    arrDTNew = unique(arrDTNew);
    arrDPNew = unique(arrDPNew);
    
    disp(sprintf('%s : Searching ''Old'' Folder - ''%s'' for parsed timeseries .mat files...', ...
        mfilename, OldSourceFolder));
    lstOld = dir_list('*.mat', 0, 'Root', OldSourceFolder, 'FileExclude', lstSignalIgnore);
    numOld = size(lstOld, 1);
    disp(sprintf('%s   %d .mat files found...', spaces(length(mfilename)), numOld));
    numOldSignals = 0;
    arrDTOld = []; arrDPOld = [];
    for iOld = 1:numOld
        curOld = lstOld{iOld, 1};
        curLength = length(strrep(curOld, '.mat', ''));
        load([OldSourceFolder filesep curOld]);
        [nDPs, nDim] = size(ts.Data);
        numOldSignals = numOldSignals + nDim;
        if(nDim > 1)
            curLength = curLength + length(sprintf('(%d)', nDim));
        end
        maxLength = max(curLength, maxLength);
        
        if(iOld == 1)
            OldInfo.tStart = ts.TimeInfo.Start;
            OldInfo.tEnd    = ts.TimeInfo.End;
        else
            OldInfo.tStart = min(OldInfo.tStart, ts.TimeInfo.Start);
            OldInfo.tEnd = max(OldInfo.tEnd, ts.TimeInfo.End);
        end
        
        OldInfo.FileInfo(iOld).File     = curOld;
        OldInfo.FileInfo(iOld).nDPs     = nDPs;
        OldInfo.FileInfo(iOld).nDim     = nDim;
        OldInfo.FileInfo(iOld).tStart   = ts.TimeInfo.Start;
        OldInfo.FileInfo(iOld).tEnd     = ts.TimeInfo.End;
        OldInfo.FileInfo(iOld).dt       = ts.Time(2) - ts.Time(1);
        arrDTOld(iOld) = OldInfo.FileInfo(iOld).dt;
        arrDPOld(iOld) = nDPs;
    end
    disp(sprintf('%s   %d total signals found...', spaces(length(mfilename)), numOldSignals));
    arrDTOld = unique(arrDTOld);
    arrDPOld = unique(arrDPOld);
    
    disp(sprintf('%s :  Determining overlap...', mfilename));
    
    numNC = size(lstNameChanges, 1);
    
    lstCommon       = intersect(lstOld, lstNew);
    lst_New_Only    = setdiff(lstNew, lstOld);
    lst_Old_Only    = setdiff(lstOld, lstNew);
    lst_Old_New     = [lstCommon lstCommon];
    
    % Deterine list of signals that are specific to 'New' and 'Old'
    if(numNC > 0)
        for iNC = 1:numNC
            strNew = lstNameChanges{iNC, 1};
            strOld = lstNameChanges{iNC, 2};
            
            strOldMat = [strOld '.mat'];
            strOldMat = strrep(strOldMat, '.mat.mat', '.mat');
            
            strNewMat = [strNew '.mat'];
            strNewMat = strrep(strNewMat, '.mat.mat', '.mat');
            
            flgNewExists = any(strcmp(lstNew, strNewMat));
            flgOldExists = any(strcmp(lstOld, strOldMat));
            if(flgNewExists && flgOldExists)
                lst_Old_New = [lst_Old_New; { strOldMat, strNewMat }];
                lst_New_Only = setdiff(lst_New_Only, strNewMat);
                lst_Old_Only = setdiff(lst_Old_Only, strOldMat);
            end
        end
    end
    numNewOnly = size(lst_New_Only,1);
    numOldOnly = size(lst_Old_Only,1);
    
    numCommon = size(lst_Old_New, 1);
    disp(sprintf('%s   Found %d common signals...', spaces(length(mfilename)), numCommon));
    
    lstLog = {};
    lstSignalPass = {}; iSignalPass = 0;
    lstSignalFail = {}; iSignalFail = 0;
    lstFilePass = {}; iFilePass = 0;
    lstFileFail = {}; iFileFail = 0;
    
    if(numCommon < 100)
        dispDec = 1;
    else
        dispDec = 10;
    end
    
    lstRateChange = {}; iRC = 0;
    
    % Loop through all common signals:
    for iCommon = 1:numCommon
        strOldMat = lst_Old_New{iCommon, 1};
        strNewMat = lst_Old_New{iCommon, 2};
        
        if( (iCommon == 1) || (iCommon == numCommon) || (mod(iCommon, dispDec) == 0) )
            if(strcmp(strOldMat, strNewMat))
                disp(sprintf('%d/%d : Analyzing ''%s''...', iCommon, numCommon, strNewMat));
            else
                disp(sprintf('%d/%d : Analyzing ''%s'' (was ''%s'')...', iCommon, numCommon, strNewMat, strOldMat));
            end
        end
        
        % Load in the signals:
        load([NewSourceFolder filesep strNewMat]); tsNew = ts;
        load([OldSourceFolder filesep strOldMat]); tsOld = ts;
        
        dimNew = size(tsNew.Data, 2);
        dimOld = size(tsOld.Data, 2);
        if(dimNew ~= dimOld)
            dimMin = min(dimNew, dimOld);
            
            if(dimNew > dimOld)
                % Add to lst_New_Only
                arrNew = [dimOld+1:dimNew];
                strNew = strrep(strNewMat, '.mat', '');
                if(length(arrNew) == 1)
                    strNew = sprintf('%s(%d)', strNew, arrNew);
                else
                    strNew = sprintf('%s(%d:%d)', strNew, arrNew(1), arrNew(end));
                end
                lst_New_Only = [lst_New_Only; strNew];
                numNewOnly = size(lst_New_Only,1);
            else
                % Add to lst_Old_Only
                arrOld = [dimNew+1:dimOld];
                strOld = strrep(strOldMat, '.mat', '');
                if(length(arrOld) == 1)
                    strOld = sprintf('%s(%d)', strOld, arrOld);
                else
                    strOld = sprintf('%s(%d:%d)', strOld, arrOld(1), arrOld(end));
                end
                lst_Old_Only = [lst_Old_Only; strOld];
                numOldOnly = size(lst_Old_Only,1);
            end
            
            tsNew.Data = tsNew.Data(:,[1:dimMin]);
            tsOld.Data = tsOld.Data(:,[1:dimMin]);
        end
        
        % Time Shift 'New' data to align with 'Old'
        tsNew.Time = tsNew.Time - TimeOffset;
        
        [ts1, ts2] = synchronize(tsNew, tsOld, 'Intersection');
        tsDiff = ts1 - ts2;
        
        dtNew       = tsNew.Time(2)  - tsNew.Time(1);
        dtOld       = tsOld.Time(2)  - tsOld.Time(1);
        dtCompare   = tsDiff.Time(2) - tsDiff.Time(1);
        
        if(dtNew ~= dtOld)
            iRC = iRC + 1;
            if(iRC == 1)
                lstRateChange(iRC, 1) = {'  #'};
                lstRateChange(iRC, 2) = {'''New'' Signal'};
                lstRateChange(iRC, 3) = {'New DT (Rate)'};
                lstRateChange(iRC, 4) = {'Old DT (Rate)'};
                lstRateChange(iRC, 5) = {'Compared DT (Rate)'};
                iRC = iRC + 1;
            end
            
            lstRateChange(iRC, 1) = {sprintf('%3.0f', iRC-1)};
            lstRateChange(iRC, 2) = {strrep(strNewMat, '.mat', '')};
            lstRateChange(iRC, 3) = {sprintf('%.2f (%.0f)', dtNew, 1/dtNew)};
            lstRateChange(iRC, 4) = {sprintf('%.2f (%.0f)', dtOld, 1/dtOld)};
            lstRateChange(iRC, 5) = {sprintf('%.2f (%.0f)', dtCompare, 1/dtCompare)};
        end
        
        clear arr_flgPass;
        nDim = size(tsDiff.Data, 2);
        for iDim = 1:nDim
            curDiffData = tsDiff.Data(:,iDim);
            
            [maxDelta, iMax]  = max(abs(curDiffData));      % [varies]
            tMax        = tsDiff.Time(iMax);
            arrPass     = abs(curDiffData) <= Threshold;    % [bool]
            flgPass     = all(arrPass);                     % [bool]
            
            if(flgPass)
                iFirst      = 1;
            else
                iFirst      = find(arrPass == 0, 1);
            end
            
            tFirst      = tsDiff.Time(iFirst);
            firstDelta  = curDiffData(iFirst);
            
            numMatch    = sum(arrPass);
            numPts      = length(arrPass);
            PassPercent = numMatch/numPts * 100;  % [%]
            
            arr_flgPass(iDim) = flgPass;
            
            if(IncludeUnits)
                strUnits =[' ' tsNew.DataInfo.Units];
            else
                strUnits = '';
            end
            
            strSignalNew = strrep(strNewMat, '.mat', '');
            strSignalOld = strrep(strOldMat, '.mat', '');
            if(nDim > 1)
                strSignalNew = sprintf('%s(%d)', strSignalNew, iDim);
                strSignalOld = sprintf('%s(%d)', strSignalOld, iDim);
            end
            
            ecNew = sprintf('sprintf(''%%-%ds'', strSignalNew);', maxLength+1);
            ecOld = sprintf('sprintf(''%%-%ds'', strSignalOld);', maxLength+1);
            
            if(flgPass)
                iSignalPass = iSignalPass + 1;
                if(iSignalPass == 1)
                    % First Time Through Add the Header
                    i = 0;
                    i = i + 1; lstSignalPass{iSignalPass, i} = '  #';
                    
                    if(numNC == 0)
                        i = i + 1; lstSignalPass{iSignalPass, i} = 'Signal';
                    else
                        i = i + 1; lstSignalPass{iSignalPass, i} = '''New'' Signal';
                        i = i + 1; lstSignalPass{iSignalPass, i} = '''Old'' Signal';
                    end
                    
                    i = i + 1; lstSignalPass{iSignalPass, i} = 'Passed/Compared (Pass %)';
                    i = i + 1; lstSignalPass{iSignalPass, i} = '1st Delta';
                    i = i + 1; lstSignalPass{iSignalPass, i} = '@ Time';
                    i = i + 1; lstSignalPass{iSignalPass, i} = 'Max Delta';
                    i = i + 1; lstSignalPass{iSignalPass, i} = '@ Time';
                    iSignalPass = iSignalPass + 1;
                end
                
                i = 0;
                i = i + 1; lstSignalPass{iSignalPass, i} = sprintf('%3.0f', iSignalPass-1);
                i = i + 1; lstSignalPass{iSignalPass, i} = eval(ecNew);
                if(numNC > 0)
                    i = i + 1; lstSignalPass{iSignalPass, i} = eval(ecOld);
                    
                    if( strcmp(lstSignalPass{iSignalPass, i}, lstSignalPass{iSignalPass, i-1}) )
                        lstSignalPass{iSignalPass, i} = '';
                    end
                end
                
                i = i + 1; lstSignalPass{iSignalPass, i} = sprintf('%6.0f/%-6.0f (%7.4f%%)', numMatch, numPts, PassPercent);
               
                i = i + 1; lstSignalPass{iSignalPass, i} = sprintf('%s%s', num2str(firstDelta), strUnits);
                i = i + 1; lstSignalPass{iSignalPass, i} = sprintf('%s', num2str(tFirst));
                
                i = i + 1; lstSignalPass{iSignalPass, i} = sprintf('%s%s', num2str(maxDelta), strUnits);
                i = i + 1; lstSignalPass{iSignalPass, i} = sprintf('%s', num2str(tMax));
                
            else
                iSignalFail = iSignalFail + 1;
                
                if(iSignalFail == 1)
                    % First Time Through Add the Header
                    i = 0;
                    i = i + 1; lstSignalFail{iSignalFail, i} = '  #';
                    if(numNC == 0)
                        i = i + 1; lstSignalFail{iSignalFail, i} = 'Signal';
                    else
                        i = i + 1; lstSignalFail{iSignalFail, i} = '''New'' Signal';
                        i = i + 1; lstSignalFail{iSignalFail, i} = '''Old'' Signal';
                    end
                    i = i + 1; lstSignalFail{iSignalFail, i} = 'Passed/Compared (Pass %)';
                    i = i + 1; lstSignalFail{iSignalFail, i} = '1st Delta';
                    i = i + 1; lstSignalFail{iSignalFail, i} = '@ Time';
                    i = i + 1; lstSignalFail{iSignalFail, i} = 'Max Delta';
                    i = i + 1; lstSignalFail{iSignalFail, i} = '@ Time';
                    iSignalFail = iSignalFail + 1;
                end
                
                i = 0;
                i = i + 1; lstSignalFail{iSignalFail, i} = sprintf('%3.0f', iSignalFail-1);
                i = i + 1; lstSignalFail{iSignalFail, i} = eval(ecNew);
                FigTitle = strSignalNew;
                
                DeltaFigTitle = ['\Delta ' FigTitle];
                if(numNC > 0)
                    i = i + 1; lstSignalFail{iSignalFail, i} = eval(ecOld);
                    
                    if( strcmp(lstSignalFail{iSignalFail, i}, lstSignalFail{iSignalFail, i-1}) )
                        lstSignalFail{iSignalFail, i} = '';
                    else
                        FigTitle = sprintf('%s (was %s)', ...
                            lstSignalFail{iSignalFail, i-1}, ...
                            lstSignalFail{iSignalFail, i});
                        DeltaFigTitle = sprintf('%s - %s', strSignalNew, strSignalOld);
                    end
                end
                i = i + 1; lstSignalFail{iSignalFail, i} = sprintf('%6.0f/%-6.0f (%7.4f%%)', numMatch, numPts, PassPercent);

                i = i + 1; lstSignalFail{iSignalFail, i} = sprintf('%s%s', num2str(firstDelta), strUnits);
                i = i + 1; lstSignalFail{iSignalFail, i} = sprintf('%s', num2str(tFirst));
                
                i = i + 1; lstSignalFail{iSignalFail, i} = sprintf('%s%s', num2str(maxDelta), strUnits);
                i = i + 1; lstSignalFail{iSignalFail, i} = sprintf('%s', num2str(tMax));
            
            
                %% Plot if Failed
                if(PlotFailed)
                    % Do a plot overlay of the failed signal/dimension
                    tsNew.Name = NewInfo.Title;
                    tsOld.Name = OldInfo.Title;
                    tsDiff.Name = sprintf('%s - %s', tsNew.Name, tsOld.Name);

                    % Resample the delta data to accomodate extra
                    % beginning/end times.  If ''Old'' goes from [0 10] sec
                    % and ''New'' goes from [0 15], the both the normal
                    % plot overlay and delta plots should span [0 15].
                    startTime   = min(tsNew.TimeInfo.Start, tsOld.TimeInfo.Start);
                    endTime     = max(tsNew.TimeInfo.End,   tsOld.TimeInfo.End);
                    fullTime    = unique([startTime tsDiff.Time' endTime]);
                                        
                    msgID = 'interpolation:interpolation:noextrap';     % VERSION?!
                    msgID = 'MATLAB:linearinter:noextrap';              % R2012b
                    warning('off', msgID);
                    tsDiff = resample(tsDiff, fullTime);
                    warning('on', msgID);

                    % Construct 
                    Title1Line = sprintf('%s vs %s: %s', NewInfo.Title, OldInfo.Title, TestCase);
                    Title2Line = {...
                        ['\fontsize{12}\bf' sprintf('%s vs %s Comparison: %s', NewInfo.Title, OldInfo.Title, TestCase)];
                        ['\fontsize{10}' FigTitle];
                        };
                    
                       DeltaTitle2Line = {...
                        ['\fontsize{12}\bf' sprintf('%s vs %s Comparison: %s', NewInfo.Title, OldInfo.Title, TestCase)];
                        ['\fontsize{10}' DeltaFigTitle];
                        };
                    
                    % Determine how far apart to space markers
                    % mat_Time_Decimation(:, 1): Simulation Time
                    % mat_Time_Decimation(:, 2): Decimation (Plot markers
                    %                             every n-seconds)
                    mat_Time_Decimation = [...
                        0       0.1;
                        2       0.5;
                        10      1;
                        20      5;
                        50      10;
                        100     20;
                        200     30;
                        600     120;
                        1200    240;
                        1800    360;
                        2400    480];
                    arrTime         = mat_Time_Decimation(:, 1);
                    arrDecimation   = mat_Time_Decimation(:,2);
                    idxDecimation   = floor(Interp1D(arrTime, [1:length(arrTime)], tsDiff.Time(end)));
                    Decimation    = arrDecimation(idxDecimation);
                    
                    % Plot the 'New' and 'Old' on top of each other:
                    fighdl(1) = figure('Position', FigurePosition);
                    clear h;

                    iRefRaw = find(mod(tsOld.Time, Decimation)==0);
                    iRef    = unique([iRefRaw; 1; length(tsOld.Time)]);
                    DecimationOld = floor(iRef);
                    h(1) = plotd(tsOld.Time, tsOld.Data(:, iDim), DecimationOld, OldMarkerStr, ...
                        'LineWidth', LineWidth, 'MarkerSize', MarkerSize);

                    iRefRaw = find(mod(tsNew.Time, Decimation)==0);
                    iRef    = unique([iRefRaw; 1; length(tsNew.Time)]);
                    DecimationNew = floor(iRef);
                    h(2) = plotd(tsNew.Time, tsNew.Data(:, iDim), DecimationNew, NewMarkerStr, ...
                        'LineWidth', LineWidth, 'MarkerSize', MarkerSize);
                    set(gca, 'FontWeight', 'bold'); grid on;
                    title(strrep(Title2Line, '_', '\_'));
                    xlabel('\bfTime [sec]');
                    if(TimeOffset ~= 0)
                        strNote = sprintf('Note: %s has been time shifted by %s [sec]', ...
                            tsNew.Name, TimeOffset);
                        label(strNote, 'SouthEastInside');
                    end
                    lstLegend = {...
                        strrep(tsOld.Name, '_', '\_');
                        strrep(tsNew.Name, '_', '\_');
                        };
                    legend(h, lstLegend, 'Location', 'Best');
                    
                    % Plot the 'New' - 'Old' Delta:
                    fighdl(2) = figure('Position', FigurePosition);
                    lstLeg = {}; clear dh; idh = 1;
                    
                    iRefRaw = find(mod(tsDiff.Time, Decimation)==0);
                    iRef    = unique([iRefRaw; 1; length(tsDiff.Time)]);
                    DecimationDiff = floor(iRef);
                    
                    dh(idh) = plotd(tsDiff.Time, tsDiff.Data(:,iDim), DecimationDiff, DiffMarkerStr, ...
                         'LineWidth', LineWidth, 'MarkerSize', MarkerSize);
                    lstLeg = {strrep(tsDiff.Name, '_', '\_')};
                    title(strrep(DeltaTitle2Line, '_', '\_'));
                   
                    xlimits(1) = tsDiff.Time(1);
                    xlimits(2) = tsDiff.Time(end);
                    xlim(xlimits);
                    
                    set(gca, 'FontWeight', 'bold'); grid on;
                    xlabel('\bfTime [sec]');
                    ylimits = ylim;
                    yScalar = 1.1;
                    ylimits(1) = min(ylimits(1)*yScalar, 0);
                    ylimits(2) = max(ylimits(2)*yScalar, 0);
                    ylim(ylimits);
                    
                    if(ylimits(1) <= -Threshold)
                        idh = idh + 1;
                        lstLeg = [lstLeg; sprintf('Threshold_{MIN} (%s)', num2str(-Threshold))];
                        dh(idh) = plot(xlimits, -[1 1]*Threshold, 'r--', 'LineWidth', LineWidth);
                    end
                    if(ylimits(2) >= Threshold)
                        idh = idh + 1;
                        lstLeg = [lstLeg; sprintf('Threshold_{MAX} (%s)', num2str(Threshold))];
                        dh(idh) = plot(xlimits, [1 1]*Threshold, 'r--', 'LineWidth', LineWidth);
                    end
                     legend(dh, lstLeg, 'Location', 'Best');
                    
                    if(SavePPT)
                        save2ppt(PPTFilenameFull, fighdl, Title1Line, 0, BatchMode, '', -1);
                        if(CloseAfterSave)
                            close(fighdl);
                        end
                    end
                end
            
            end
        end
        
        if( all(arr_flgPass) )
            iFilePass = iFilePass + 1;
            lstFilePass{iFilePass, 1} = iFilePass;
            lstFilePass{iFilePass, 2} = strNewMat;
        else
            iFileFail = iFileFail + 1;
            lstFileFail{iFileFail, 1} = iFileFail;
            lstFileFail{iFileFail, 2} = strNewMat;
        end
    end
    
    numSignalPass = max(iSignalPass-1, 0);
    numSignalFail = max(iSignalFail-1, 0);
    numSignalTotal = numSignalPass + numSignalFail;
    numFilePass     = iFilePass;
    numFileFail     = iFileFail;
    
    %% Compile and Write the Report
    str = [];
    str = [str '===========================================================================' endl];
    str = [str endl];
    str = [str sprintf('Test Case %d of %d : %s', ...
        iTestCase, numTestCases, TestCase) endl];
    str = [str endl];
    str = [str '===========================================================================' endl];
    
    lstLog = {}; iLog = 0;
    iLog = iLog+1; lstLog(iLog, 1)      = { sprintf('''New'' Data:') };
    iLog = iLog+1; lstLog(iLog, 1:2)    = {'Directory:',        NewSourceFolder};
    iLog = iLog+1; lstLog(iLog, 1:2)    = {'Title:',            NewInfo.Title};
    iLog = iLog+1; lstLog(iLog, 1:2)    = {'# of files:',       num2str(numNew)};
    iLog = iLog+1; lstLog(iLog, 1:2)    = {'# of signals:',     num2str(numNewSignals)};
    iLog = iLog+1; lstLog(iLog, 1:2)    = {'tStart [sec]:',     num2str(NewInfo.tStart)};
    iLog = iLog+1; lstLog(iLog, 1:2)    = {'tEnd [sec]:',       num2str(NewInfo.tEnd)};
    
    numRateGroups = length(arrDTNew);
    iLog = iLog+1; lstLog(iLog, 1:2)    = {'# of Rate Groups:', num2str(numRateGroups)};
    
    strRateGroup = [];
    for i = 1:numRateGroups
        strRateGroup = [strRateGroup sprintf('%.2f (%.0f Hz)', arrDTNew(i), 1/arrDTNew(i))];
        if(i < numRateGroups)
            strRateGroup = [strRateGroup ', '];
        end
    end
    iLog = iLog+1; lstLog(iLog, 1:2)    = {'Rate Groups:',     strRateGroup};
    
    iLog = iLog+1;
    iLog = iLog+1; lstLog(iLog, 1)      = { sprintf('''Old'' Data:') };
    iLog = iLog+1; lstLog(iLog, 1:2)    = {'Directory:',        OldSourceFolder};
    iLog = iLog+1; lstLog(iLog, 1:2)    = {'Title:',            OldInfo.Title};
    iLog = iLog+1; lstLog(iLog, 1:2)    = {'# of files:',       num2str(numOld) };
    iLog = iLog+1; lstLog(iLog, 1:2)    = {'# of signals:',     num2str(numOldSignals)};
    iLog = iLog+1; lstLog(iLog, 1:2)    = {'tStart [sec]:',     num2str(OldInfo.tStart)};
    iLog = iLog+1; lstLog(iLog, 1:2)    = {'tEnd [sec]:',       num2str(OldInfo.tEnd)};
    
    numRateGroups = length(arrDTOld);
    iLog = iLog+1; lstLog(iLog, 1:2)    = {'# of Rate Groups:', num2str(numRateGroups)};
    
    strRateGroup = [];
    for i = 1:numRateGroups
        strRateGroup = [strRateGroup sprintf('%.2f (%.0f Hz)', arrDTOld(i), 1/arrDTOld(i))];
        if(i < numRateGroups)
            strRateGroup = [strRateGroup ', '];
        end
    end
    iLog = iLog+1; lstLog(iLog, 1:2)    = {'Rate Groups:',     strRateGroup};
    
    if(NewInfo.tStart ~= OldInfo.tStart)
        iLog = iLog+1;
        if(NewInfo.tStart > OldInfo.tStart)
            iLog = iLog+1; lstLog(iLog, 1:2)    = {'Time WARNING:', '''New'' Data starts after ''Old'' Data'};
        else
            iLog = iLog+1; lstLog(iLog, 1:2)    = {'Time WARNING:', '''New'' Data starts before ''Old'' Data'};
        end
    end
    
    if(NewInfo.tEnd ~= OldInfo.tEnd)
        iLog = iLog+1;
        if(NewInfo.tEnd > OldInfo.tEnd)
            iLog = iLog+1; lstLog(iLog, 1:2)    = {'Time WARNING:', '''New'' Data ends after ''Old'' Data'};
            iLog = iLog+1; lstLog(iLog, 1:2)    = {'', sprintf('%s extra seconds of ''New'' Data', num2str(NewInfo.tEnd - OldInfo.tEnd))};
        else
            iLog = iLog+1; lstLog(iLog, 1:2)    = {'Time WARNING:', '''New'' Data ends before ''Old'' Data'};
            iLog = iLog+1; lstLog(iLog, 1:2)    = {'', sprintf('%s extra seconds of ''Old'' Data', num2str(OldInfo.tEnd - NewInfo.tEnd))};
        end
    end
    
    if(TimeOffset ~= 0)
        iLog = iLog+1;
        iLog = iLog+1; lstLog(iLog, 1:2)    = {'Time WARNING:', sprintf('''New'' Data is time shifted by %s [sec]', num2str(TimeOffset))};
        iLog = iLog+1; lstLog(iLog, 1:2)    = {'', 'for comparison against ''Old'' Data'};
        iLog = iLog+1; lstLog(iLog, 1:2)    = {'', sprintf('''New'' Time = ''Old'' Time + %s', num2str(TimeOffset))};
    end
    
    iLog = iLog+1;
    iLog = iLog+1; lstLog(iLog, 1:2)    = {'Compared Files:', num2str(numCommon)};
    iLog = iLog+1; lstLog(iLog, 1:2)    = {'Compared Signals:', num2str(numSignalTotal)};
    
    % New Time Range
    cStart  = max(NewInfo.tStart-TimeOffset, OldInfo.tStart);
    cEnd    = min(NewInfo.tEnd-TimeOffset,   OldInfo.tEnd);
    
    nStart  = cStart + TimeOffset;
    nEnd    = cEnd + TimeOffset;
    
    iLog = iLog+1; lstLog(iLog, 1:2)    = {'''New'' Time Range:',   sprintf('[%s %s] [sec]', num2str(nStart), num2str(nEnd))};
    iLog = iLog+1; lstLog(iLog, 1:2)    = {'''Old'' Time Range:',   sprintf('[%s %s] [sec]', num2str(cStart), num2str(cEnd))};
    iLog = iLog+1; lstLog(iLog, 1:2)    = {'PASSED Files:', sprintf('%d (%.4f%%)', numFilePass, (numFilePass/numCommon*100))};
    iLog = iLog+1; lstLog(iLog, 1:2)    = {'FAILED Files:', sprintf('%d (%.4f%%)', numFileFail, (numFileFail/numCommon*100))};
    
    if(numFileFail == 0)
        iTestPass = iTestPass + 1;
        if(iTestPass == 1)
            lstTestPass{iTestPass, 1} = '  #';
            lstTestPass{iTestPass, 2} = 'TestCase';
            lstTestPass{iTestPass, 3} = 'Signals Passed/Compared';
            iTestPass = iTestPass + 1;
        end
        
        lstTestPass(iTestPass, 1) = { sprintf('%3.0f', iTestPass-1) };
        lstTestPass(iTestPass, 2) = { TestCase };
        lstTestPass(iTestPass, 3) = { sprintf('%5.0f/%d  %.4f%%', numFilePass, numCommon, (numFilePass/numCommon*100)) };
    else
        iTestFail = iTestFail + 1;
        if(iTestFail == 1)
            lstTestFail{iTestFail, 1} = '  #';
            lstTestFail{iTestFail, 2} = 'TestCase';
            lstTestFail{iTestFail, 3} = 'Signals Passed/Compared';
            iTestFail = iTestFail + 1;
        end
        
        lstTestFail(iTestFail, 1) = { sprintf('%3.0f', iTestFail-1) };
        lstTestFail(iTestFail, 2) = { TestCase };
        lstTestFail(iTestFail, 3) = { sprintf('%5.0f/%d  %.4f%%', numFilePass, numCommon, (numFilePass/numCommon*100)) };
    end
    
    str = [str Cell2PaddedStr(lstLog, 'Padding', ' ')];
    
    %% Line Break
    str = [str endl];
    str = [str '---------------------------------------------------------------------------' endl];
    
    %% List known name changes:
    str = [str 'Comparison Details:' endl];
        
    %% List all signals exclusive to 'New':
    if(numNewOnly == 0)
        if(0)
            str = [str 'New Signals in ''New'' Directory:' endl];
            str = [str ' NONE' endl];
            str = [str endl];
        end
    else
        str = [str 'New Signals in ''New'' Directory (' num2str(numNewOnly) '):' endl];
        lstNewOnly = cell(numNewOnly+1, 2);
        lstNewOnly(1,:) = {'  #', 'Signal'};
        for iNewOnly = 1:numNewOnly
            lstNewOnly(iNewOnly+1, 1) = { sprintf('%3.0f', iNewOnly) };
            lstNewOnly(iNewOnly+1, 2) = { strrep(lst_New_Only{iNewOnly}, '.mat', '') };
        end
        str = [str Cell2PaddedStr(lstNewOnly, 'Padding', '  ')];
        str = [str endl];
    end
    
    %% List all signals exclusive to 'Old':
    if(numOldOnly == 0)
        if(0)
            str = [str 'Discontinued Signals in ''Old'' Directory:' endl];
            str = [str ' NONE' endl];
            str = [str endl];
        end
    else
        str = [str 'Discontinued Signals in ''Old'' Directory (' num2str(numOldOnly) '):' endl];
        lstOldOnly = cell(numOldOnly+1, 2);
        lstOldOnly(1,:) = {'  #', 'Signal'};
        for iOldOnly = 1:numOldOnly
            lstOldOnly(iOldOnly+1, 1) = { sprintf('%3.0f', iOldOnly) };
            lstOldOnly(iOldOnly+1, 2) = { strrep(lst_Old_Only{iOldOnly}, '.mat', '') };
        end
        str = [str Cell2PaddedStr(lstOldOnly, 'Padding', '  ')];
        str = [str endl];
    end
    
    %% List all signals that have changed Rate:
    numRateChange = size(lstRateChange, 1);
    
    if(numRateChange == 0)
        if(0)
            str = [str 'Detected Rate Changes between ''New'' and ''Old'':' endl];
            str = [str ' NONE' endl];
            str = [str endl];
        end
    else
        str = [str 'Detected Rate Changes between ''New'' and ''Old'' (' num2str(numRateChange) '):' endl];
        str = [str 'Delta Time (DT) is in [sec] - Rate is in [Hz]' endl];
        str = [str Cell2PaddedStr(lstRateChange, 'Padding', '  ')];
        str = [str endl];
    end
    
    %%
    str = [str 'PASS Logic:' endl];
    str = [str sprintf('PASS = abs(''New'' - ''Old'') <= Threshold, where Threshold = %s', num2str(Threshold)) endl];
    str = [str endl];
    
    %%
    if((flgAllPassed == 0) || (numSignalFail > 0))
        flgAllPassed = 0;
    end
    if(numSignalFail == 0)
        str = [str 'FAILED Signals:' endl];
        str = [str ' NONE' endl];
        str = [str endl];
    else
        str = [str sprintf('FAILED Signals (%d/%d):', numSignalFail, numSignalTotal) endl];
        str = [str Cell2PaddedStr(lstSignalFail, 'Padding', '  ')];
        str = [str endl];
    end
    
    %%
    if(numSignalPass == 0)
        str = [str 'PASSED Signals:' endl];
        str = [str ' NONE' endl];
    else
        str = [str sprintf('PASSED Signals (%d/%d):', numSignalPass, numSignalTotal) endl];
        str = [str Cell2PaddedStr(lstSignalPass, 'Padding', '  ')];
        
        if(numSignalFail == 0)
            str = [str endl];
            str = [str '*** ALL Signals PASSED ***' endl];
        end
    end
    
    str = [str endl];
    str = [str 'End of Comparison Details for: ' TestCase endl];
    str = [str endl];
    
    LogMsg(iTestCase).str = str;
    
    % Display Mini Results:
    disp(sprintf('%s : Test Case ''%s'' Mini Results:', mfilename, TestCase));
    disp(sprintf('%s   %d/%d PASSED (%.2f%%)', ...
        spaces(length(mfilename)), numSignalPass, numSignalTotal, ...
        (numSignalPass/numSignalTotal)*100));
    disp(sprintf('%s   %d/%d FAILED (%.2f%%)', ...
        spaces(length(mfilename)), numSignalFail, numSignalTotal, ...
        (numSignalFail/numSignalTotal)*100));
 
end

%% Write to file:
if(~isdir(SaveFolder))
    mkdir(SaveFolder);
end

fid = fopen(LogFilenameFull, 'w');

if(flgUseTestCases)
    str = ['COMPARISON LOG SUMMARY:' endl];
    str = [str endl];
    str = [str 'Generated on ' datestr(now, 'dddd, mmmm dd, yyyy @ HH:MM:SS.FFF AM') endl];
    str = [str endl];
    
    lstLog = {}; iLog = 0;
    iLog = iLog+1; lstLog(iLog, 1)      = { sprintf('''New'' Data:') };
    iLog = iLog+1; lstLog(iLog, 1:2)    = {'Head Directory:',        NewInfo.SourceFolder};
    iLog = iLog+1; lstLog(iLog, 1:2)    = {'Title:',            NewInfo.Title};
    iLog = iLog+1;
    iLog = iLog+1; lstLog(iLog, 1)      = { sprintf('''Old'' Data:') };
    iLog = iLog+1; lstLog(iLog, 1:2)    = {'Head Directory:',        OldInfo.SourceFolder};
    iLog = iLog+1; lstLog(iLog, 1:2)    = {'Title:',            OldInfo.Title};
    str = [str Cell2PaddedStr(lstLog, 'Padding', '  ')];
    str = [str endl];
    str = [str 'TOTAL Test Cases: ' num2str(numTestCases) endl];
    str = [str endl];
    
    if(iTestPass == 0)
        str = [str 'PASSED TestCases' endl];
        str = [str ' NONE' endl];
        str = [str endl];
    else
        str = [str sprintf('PASSED TestCases (%d/%d) (%.3f%%):', ...
            (iTestPass-1), numTestCases, ((iTestPass-1)/numTestCases*100)) endl];
        str = [str Cell2PaddedStr(lstTestPass, 'Padding', '  ')];
        str = [str endl];
    end
    
    if(iTestFail == 0)
        str = [str 'FAILED TestCases' endl];
        str = [str ' NONE' endl];
        str = [str endl];
    else
        str = [str sprintf('FAILED TestCases (%d/%d) (%.3f%%):', ...
            (iTestFail-1), numTestCases, ((iTestFail-1)/numTestCases*100)) endl];
        str = [str Cell2PaddedStr(lstTestFail, 'Padding', '  ')];
        str = [str endl];
    end
    
    if(flgAllPassed)
        str = [str '*** ALL TEST CASES PASSED ***' endl];
        str = [str endl];
    end
    
    % Add List of Known Name Changes
    %   Considering removing this since 'New' and 'Old' Signals appear side
    %   by side in the signal Pass/Fail sections
    if(0)
        if(numNC == 0)
            str = [str 'Known Name Changes between ''New'' and ''Old'':' endl];
            str = [str ' NONE' endl];
            str = [str endl];
        else
            str = [str 'Known Name Changes between ''New'' and ''Old'' (' num2str(numNC) '):' endl];
            lstNC = cell(numNC+1,3);
            lstNC(1,:) = {'  #', '''New'' Signal', '''Old'' Signal'};
            
            for iNC = 1:numNC
                lstNC(iNC+1,1) = { sprintf('%3.0f', iNC) };
            end
            
            lstNC(2:end,2) = lstNameChanges(:,1);   % New Name
            lstNC(2:end,3) = lstNameChanges(:,2);   % Old Name
            str = [str Cell2PaddedStr(lstNC, 'Padding', '  ')];
            str = [str endl];
        end
    end
    
    str = [str '===========================================================================' endl];
    str = [str endl];
    str = [str 'Test Case Details' endl];
    str = [str endl];
    fprintf(fid, '%s', str);
end

for iTestCase = 1:numTestCases
    str = LogMsg(iTestCase).str;
    fprintf(fid, '%s', str);
end
fclose(fid);

%%
if(OpenLog)
    edit(LogFilenameFull);
end

tElapsed_sec = toc(tStart_sec);

C.HR2SEC = 60*60;
C.MIN2SEC = 60;
elapsed_hr  = floor( tElapsed_sec / C.HR2SEC );
elapsed_min = floor( (tElapsed_sec - elapsed_hr*C.HR2SEC)/C.MIN2SEC );
elapsed_sec = tElapsed_sec - (elapsed_hr*C.HR2SEC) - (elapsed_min*C.MIN2SEC);
str_hr_min_sec = sprintf('%d hr, %d min, %5.3f sec', elapsed_hr, elapsed_min, elapsed_sec);

strPlural = '';
if(numTestCases > 1)
    strPlural = 's';
end
disp(sprintf('%s : Finished!  %d Test Case%s took %s.', ...
    mfilename, numTestCases, strPlural, str_hr_min_sec));

end % << End of function >>

%% DISTRIBUTION:
% WARNING - This document contains technical data whose export is
%   restricted by the Arms Export Control Act (Title 22, U.S.C., Sec 2751,
%   et seq.) or the Export Administration Act of 1979 (Title 50, U.S.C.,
%   App. 2401 et set.), as amended. Violations of these export laws are
%   subject to severe criminal penalties.  Disseminate in accordance with
%   provisions of DoD Direction 5230.25.
%
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------------------- UNCLASSIFIED ---------------------------
