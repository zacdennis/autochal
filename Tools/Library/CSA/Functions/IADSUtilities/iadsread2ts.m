% IADSREAD2TS Loads flight test time history data from IADS into MATLAB timeseries
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% iadsread2ts:
%   Loads flight test time history data from Symvionics' IADS and returns
%   data in MATLAB timeseries form.
% 
% SYNTAX:
%	[ts] = iadsread2ts(DataDirectory, lstDesired, varargin, 'PropertyName', PropertyValue)
%	[ts] = iadsread2ts(DataDirectory, lstDesired, varargin)
%	[ts] = iadsread2ts(DataDirectory, lstDesired)
%	[ts] = iadsread2ts(DataDirectory)
%
% INPUTS: 
%	Name         	Size            Units	Description
%	DataDirectory	'string'        [char]  Directory containing saved
%                                            Symvionics IADS data
%	lstDesired      'string'        [char]  List of IADS signals (either
%                    or {'strings'} {[char]} Parameter, ShortName, or
%                                            LongName) to extract
%	varargin	[N/A]		[varies]        Optional function inputs that
%                                            should be entered in pairs.
%                                            See the 'VARARGIN' section
%                                            below for more details
% OUTPUTS: 
%	Name         	Size            Units	Description
%	ts  	        [time-series]           IADS data in MATLAB timeseries
%                    or {time-series}        format
% NOTES:
%	If only one signal is desired for extraction, the returned 'ts' will be
%	the timeseries itself.  If multiple signals are desired at once, 'ts'
%	will be a Results-style structure which will use the signal names for
%	their structure name (e.g. ts.Name = 'A.b' will map to ts.A.b).
%
%	VARARGIN PROPERTIES:
%	PropertyName		PropertyValue	Default		Description
%   'TimeParam'         'string'        ''          Alternate IADS
%                                                    measurand (parameter,
%                                                    short name, long name)
%                                                    to use for time.  If
%                                                    blank, standard IADS
%                                                    Irig time is returned.
%   'StartTime'      2 options:
%                    1: 'string'        ''          Irig time at which to
%                         -or-                      begin extracting data.
%                                                   If blank, will use
%                                                   first recorded Irig
%                                                   time.
%                    2: [double]                    'TimeParam' value at
%                                                   which to begin
%                                                   extracting data. If
%                                                   blank, will use first
%                                                   recorded 'TimeParam'
%                                                   value.
%   'StopTime'       3 options:
%                    1: 'string'        ''          Irig time at which to
%                                                   stop extracting data.
%                                                   If blank, will use last
%                                                   recorded Irig time.
%                    2: [double]        ''          If 'TimeParam' is NOT
%                                                   specified, the amount
%                                                   of time, in [sec],
%                                                   after the Irig
%                                                   'StartTime'
%                    3: [double]        ''          If 'TimeParam' is
%                                                   specified, the value of
%                                                   'TimeParam' at which to
%                                                   stop extracting data.
%   'DurationTime'  [sec]               ''          Only used if
%                                                   'TimeParam' is
%                                                   specified.  Specifies
%                                                   duration of time to
%                                                   extract (e.g. 100 sec)
%   'IADSParameterFile' 'string'   'IADSParameter'  Name of reference .mat
%                                                    file containing
%                                                    mapping of each
%                                                    signal's Parameter,
%                                                    ShortName, and
%                                                    LongName.  File will
%                                                    be created if not
%                                                    found using
%                                                    ListIADSParameters.
%   'ParameterList'     {n x 3}         {}          IADS parameter list
%                                                    that contains the
%                                                    short name and long
%                                                    name for each IADS
%                                                    parameter.  See notes
%                                                    #1 and #2 below.
%
% Note #1 - Breakdown of Parameter List:
%	Name             	Size		Units		Description
%	ParameterList       {n x 3}     {[char]}    IADS parameter list where
%    {:,1} Parameter    'string'    [char]      Parameter name
%    {:,2} Short Name   'string'    [char]      Short name
%    {:,3} Long Name    'string'    [char]      Long name
% Note #2 - If the parameter list is not provided, the function will first
% look to the 'DataDictionary' to see if a saved '.mat' file of the
% parameter list exists.  If it exists, it'll be loaded.  If not, the list
% will be created, which could take a few minutes to generate depending on
% the size of the recorded IADS data.
%
% EXAMPLES:
%   % See IADS_Tutorial.m (hyperlink below) for full working example.  The
%   % following are copied snippets from that file.  To begin, one must 
%   % specify two variables.
%   IADSDirectory = <Enter Full Path to Folder Containing IADS Data>
%   curParam      = <Enter IADS Paramter Name>
%
%   % To retrieve information on this signal, type:
%   infoParam = iadsread(IADSDirectory, '', 0, ['? ' curParam])
%   
%   %  Example 1a:
%   %  To load the data into MATLAB using the IADS Irig time for time, simply
%   %  do this.  Note that you can specify either the 'Parameter', 'ShortName',
%   %  or 'LongName'.  'iadsread2ts' will return a MATLAB timeseries
%   object.
%   ts_1a = iadsread2ts(IADSDirectory, curParam)
%
%   %  Example 1b:
%   % IADS data could contain several hours worth of data.  To extract a
%   % reduced set of data, use the overloaded 'StartTime' and 'StopTime'
%   % fields. Suppose you want to extract the 1st 10 seconds worth of data.
%   % You can do this 1 of 2 ways:
%   % Option 1: Specify a time in [sec] for the 'StopTime'.  The function will
%   %           do the rest
%   ts_1b = iadsread2ts(IADSDirectory, curParam, 'StopTime', 10)
%
%   % Example 1c:
%   % Now suppose that you want to extract 1 minute worth of data starting 10
%   % seconds into the run.  Now you must specify a 'StartTime'
%   StartTime = AddToIrigTime(infoData.StartTime, 10);
%   ts_1c = iadsread2ts(IADSDirectory, curParam, 'StartTime', StartTime, 'StopTime', 60)
%
%   % Example 1d:
%   %  Now suppose that we want load the data into MATLAB using another signal
%   %  from the same set of IADS data.  You need to define the parameter, short
%   %  name, or long name of the measurand you want to use for time prior to
%   %  calling 'iadsread2ts'.
%   ref_IADS_time = <Enter Parameter, ShortName, or LongName>
%   ts_1d = iadsread2ts(IADSDirectory, curParam, 'TimeParam', ref_IADS_time);
%
%   % Example 1e:
%   %  Similar to 1c, to extract 100 seconds worth of data using a
%   %  'TimeParam', set the 'DurationTime'
%   ts_1e = iadsread2ts(IADSDirectory, curParam, 'TimeParam', ref_IADS_time, 'DurationTime', 100);
%
%   % Example 1g:
%   %  Similar to 1c, to extract 100 seconds worth of data starting 10 seconds
%   %  into the run
%   ts_1g = iadsread2ts(IADSDirectory, curParam, 'TimeParam', ref_IADS_time, 'StartTime', 10, 'DurationTime', 100);
%
% SOURCE DOCUMENTATION:
%
% HYPERLINKS:
%     IADS tutorial: <a href="matlab:edit IADS_Tutorial.m">IADS_Tutorial.m</a>
%	Source function: <a href="matlab:edit iadsread2ts.m">iadsread2ts.m</a>
%	  Driver script: <a href="matlab:edit Driver_iadsread2ts.m">Driver_iadsread2ts.m</a>
%	  Documentation: <a href="matlab:winopen(which('iadsread2ts_Function_Documentation.pptx'));">iadsread2ts_Function_Documentation.pptx</a>
%
% See also ListIADSParameters, format_varargin
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/747
%  
% Copyright Northrop Grumman Corp 2012
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/IADSUtilities/iadsread2ts.m $
% $Rev: 2340 $
% $Date: 2012-07-09 19:39:04 -0500 (Mon, 09 Jul 2012) $
% $Author: sufanmi $

function [ts] = iadsread2ts(DataDirectory, lstDesired, varargin)

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

[TimeParam, varargin]           = format_varargin('TimeParam', '', 2, varargin);
[StartTime, varargin]           = format_varargin('StartTime', '', 2, varargin);
[StopTime, varargin]            = format_varargin('StopTime', '', 2, varargin);
[DurationTime, varargin]        = format_varargin('DurationTime', '', 2, varargin);
[IADSParameterFile, varargin]   = format_varargin('IADSParameterFile', 'IADSParameters', 2, varargin);
[lstKnownParameters, varargin]  = format_varargin('ParameterList', {}, 2, varargin);

flgUserDefinedTime = ~isempty(TimeParam);

% Get Raw Info
infoData = iadsread(DataDirectory);

if(isempty(lstKnownParameters))
    % Check to see if it exists in the IADS DataDirectory
    filename_lstParameters = [DataDirectory filesep IADSParameterFile '.mat'];
    if(exist(filename_lstParameters))
        load(filename_lstParameters);
        lstKnownParameters = lstParameters; clear lstParameters;
    else
        disp(sprintf('%s : IADS Parameter Table does not exist.  Creating table...', mfnam));
        lstKnownParameters = ListIADSParameters(DataDirectory, ...
            'SaveMat', 1, 'SaveCSV', 1);
    end
end

flgSingle = 0;
if(ischar(lstDesired))
    flgSingle = 1;
    lstDesired = { lstDesired };
end

numDesired = size(lstDesired, 1);
for iDesired = 1:numDesired
    curDesired = lstDesired{iDesired, :};
    curRefParameter = GetIADSParameter(lstKnownParameters, curDesired);
    ts = [];
    if( isempty(curRefParameter) )
        disp(sprintf('%s : ERROR : Parameter ''%s'' was not found.', ...
            mfilename, curDesired));
    else
        infoParameter = iadsread( DataDirectory, '', 0, ['? ' curRefParameter] );

        if(isempty(infoParameter.StartTime) || isempty(infoParameter.StopTime))
            disp(sprintf('%s : WARNING : Issues Extracting ''%s''.  DataStatusText: %s', ...
                mfnam, curRefParameter, infoParameter.DataStatusText));
        else

        decParamStart = IrigTime2DecTime(infoParameter.StartTime);
        decParamStop  = IrigTime2DecTime(infoParameter.StopTime);
        
        if(flgUserDefinedTime)
            % User wants a different time source, like from another recorded
            % parameter.  Assumption is that these were recorded at the same
            % rate.
            RefTimeParam = GetIADSParameter(lstKnownParameters, TimeParam);
            infoTimeParam = iadsread( DataDirectory, '', 0, ['? ' RefTimeParam] );
            decTimeStart = IrigTime2DecTime(infoTimeParam.StartTime);
            decTimeStop  = IrigTime2DecTime(infoTimeParam.StopTime);
        end

        UserDefinedStartTime = [];
        if(isempty(StartTime))
            LookupStartTime = infoParameter.StartTime;
        else
            if(flgUserDefinedTime)
                UserDefinedStartTime = StartTime;
                
                % User Provided a start time value for the user-defined time (non IRIG
                % time).  Hence, we gotta get a little fancy.  Sometimes
                % the start times for two IADS parameters (e.g. current and
                % the reference time) aren't exactly the same.  We have to
                % use the latter of the two to ensure matching time/value
                % combo.
                if(decParamStart > decTimeStart)
                    LookupStartTime = infoParameter.StartTime;
                else
                    LookupStartTime = infoTimeParam.StartTime;
                end
            else
                LookupStartTime = StartTime;
            end
        end
        
        UserDefinedStopTime = [];
        if(isempty(StopTime))
            if(isempty(DurationTime))
                LookupStopTime = infoParameter.StopTime;
            else
                LookupStopTime = DurationTime;
            end

        else
            if(~ischar(StopTime) && (flgUserDefinedTime))
                UserDefinedStopTime = StopTime;
                
                % User Provided a stop time value for the user-defined time (non IRIG
                % time).  Hence, we gotta get a little fancy.  Sometimes
                % the stop times for two IADS parameters (e.g. current and
                % the reference time) aren't exactly the same.  We have to
                % use the earlier of the two to ensure matching time/value
                % combo.
                if(decParamStop < decTimeStop)
                    LookupStopTime = infoParameter.StopTime;
                else
                    LookupStopTime = infoTimeParam.StopTime;
                end
            else
                LookupStopTime = StopTime;
            end
        end
        
        try
            data = iadsread( DataDirectory, LookupStartTime, ...
                LookupStopTime, curRefParameter, ...
                'ReturnTimeVector', 1);
            valid_irig_stoptime = LookupStopTime;
        catch
            [msgstr, msgid] = lasterr;
            disp(msgstr);           
        end
        
        if(~isempty(TimeParam))
            % User wants a different time source, like from another recorded
            % parameter.  Assumption is that these were recorded at the same
            % rate.
            t = iadsread( DataDirectory, LookupStartTime, LookupStopTime, RefTimeParam);
        else
            t = data(:,1);
        end
        
        y = data(:,2);
        
        % Check to make sure data is unique
        [t, iUnique] = unique(t);
        y = y(iUnique);
        
        if( (~isempty(UserDefinedStartTime)) || (~isempty(UserDefinedStopTime)) )
            if(isempty(UserDefinedStartTime))
                UserDefinedStartTime = t(1);
            end
            idxGTEStart = find(t>=UserDefinedStartTime);

            if(isempty(UserDefinedStopTime))
                UserDefinedStopTime = t(end);
            end
            idxLTEStop = find(t<=UserDefinedStopTime);
            
            idxGood = intersect(idxGTEStart, idxLTEStop);
            t = t(idxGood);
            y = y(idxGood);
        end
        
        ts = timeseries(y, t);
        ts.Name = curDesired;
        
        strUnits = infoParameter.Units;
        if(isempty(strUnits))
            strUnits = 'TBD';
        end
        
        ts.DataInfo.Units = ['[' strUnits ']' ];
        
        ParameterInfo = addStruct(infoData, infoParameter);
        
        % UserData cannot be a structure, so convert whole thing into a string
        ts.UserData = dispStruct(ParameterInfo);
        end
    end
    
    if(~flgSingle)
        structName = curDesired;
        structName = strrep(structName, ' ', '');
        structName = strrep(structName, ',', '');
        
        % Add to Results
        es = ['Results.' structName ' = ts;'];
        eval(es);
    end
    
end

if(flgSingle)
    % Do nothing for now
else
    % Return the structure of timeseries
    ts = Results;
end

end % << End of function iadsread2ts >>

%% REVISION HISTORY
% YYMMDD INI: note
% 120305 MWS: Created function using CreateNewFunc
%**Add New Revision notes to TOP of list**

% Initials Identification: 
% INI: FullName     : Email                 : NGGN Username 
% MWS: Mike Sufana  : mike.sufana@ngc.com   : sufanmi

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
