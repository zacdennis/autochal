% LOAD_SAVED_TS Load inidividual .mat files into a 'Results' structure
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% load_saved_ts:
%     Loads individual .mat files into a 'Results' structure 
% 
% SYNTAX:
%	[Results] = load_saved_ts(lstSignals, Results, varargin, 'PropertyName', PropertyValue)
%	[Results] = load_saved_ts(lstSignals, Results, varargin)
%	[Results] = load_saved_ts(lstSignals, Results)
%	[Results] = load_saved_ts(lstSignals)
%
% INPUTS: 
%	Name      	Size		Units           Description
%	lstSignals	{'string'}  {[char]}        List of signals to load
%   Results     {struct}    [timeseries]    Structure of timeseries to add
%                                            new parsed data to
%	varargin	[N/A]		[varies]        Optional function inputs that
%                                            should be entered in pairs.
%                                            See the 'VARARGIN' section
%                                            below for more details
%
% OUTPUTS: 
%	Name      	Size		Units           Description
%	Results     {struct}    [timeseries]    Parsed output in timeseries
%                                            format
%
% NOTES:
%
%	VARARGIN PROPERTIES:
%	PropertyName		PropertyValue	Default		Description
%   'SourceFolder'      'string'        pwd         Folder in which to
%                                                    find individual .mat
%                                                    files
%   'StartTime'         [1]             []          Desired start time for
%                                                    extracted data
%   'EndTime'           [1]             []          Desired end time for
%                                                    extracted data
% EXAMPLES:
%	% <Enter Description of Example #1>
%	[Results] = load_saved_ts(lstSignals, varargin)
%	% <Copy expected outputs from Command Window>
%
% SOURCE DOCUMENTATION:
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit load_saved_ts.m">load_saved_ts.m</a>
%	  Driver script: <a href="matlab:edit Driver_load_saved_ts.m">Driver_load_saved_ts.m</a>
%	  Documentation: <a href="matlab:winopen(which('load_saved_ts_Function_Documentation.pptx'));">load_saved_ts_Function_Documentation.pptx</a>
%
% See also format_varargin, getsampleusingtime
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://trac.ngst.northgrum.com/CSA/ticket/758
%  
% Copyright Northrop Grumman Corp 2012
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://trac.ngst.northgrum.com/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/PlottingUtilities/TimeseriesToolbox/load_saved_ts.m $
% $Rev: 3258 $
% $Date: 2014-10-06 19:29:21 -0500 (Mon, 06 Oct 2014) $
% $Author: sufanmi $

function [Results] = load_saved_ts(lstSignals, varargin)

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

%% Input Argument Conditioning:
% Pick out Properties Entered via varargin
[SourceFolder, varargin]    = format_varargin('SourceFolder', pwd, 2, varargin);
[ReturnTSIfSingle, varargin]= format_varargin('ReturnTSIfSingle', false, 2, varargin);
[AllowReduce, varargin]     = format_varargin('AllowReduce', true, 2, varargin);

if(mod(numel(varargin),2) == 1)
    Results = varargin{1};
else
    Results = [];
end

%% Main Function:
if(ischar(lstSignals))
    lstSignals = { lstSignals };
end

numSignals = size(lstSignals, 1);

for iSignal = 1:numSignals
    curSignal = lstSignals{iSignal, 1};
    
    if( size(lstSignals, 2) > 1 )
        curName = lstSignals{iSignal,2};
    else
        curName = '';
    end
    
    %% Add Plugs for <Signal>(#)
    lstExtra = {'*';'/';'+';'-'};
    for iExtra = 1:size(lstExtra, 1);
        curExtra = lstExtra{iExtra};
        ptrExtra = strfind(curSignal, curExtra);
        if( ~isempty(ptrExtra) && (ptrExtra(1) > 1) )
            curSignal = curSignal(1:ptrExtra(1)-1);
        end
    end
    
    ptrParen = strfind(curSignal, '(');
    if(~isempty(ptrParen))
        curSignal2Get = curSignal(1:ptrParen(end)-1);
        flgReduce = 1;
    else
        curSignal2Get = curSignal;
        flgReduce = 0;
    end
    
    ptrPound = strfind(curSignal, '#');
    if(~isempty(ptrPound))
        curSignal2Get = curSignal(1:ptrPound(end)-2);
        flgReduce = 1;
    end
    
    % This should return 'ts'
    filename = [SourceFolder filesep curSignal2Get '.mat'];
    if(exist(filename) == 0)
        disp(sprintf('%s : WARNING : ''%s'' does not exist in folder ''%s''.  Ingoring load call.', ...
            mfnam, curSignal2Get, SourceFolder));
        ts = [];
    else
        load(filename);
        
        % Down select
        curStartTime = ts.TimeInfo.Start;
        curEndTime = ts.TimeInfo.End;
        [StartTime, varargin]   = format_varargin('StartTime', curStartTime, 0, varargin);
        [EndTime, varargin]     = format_varargin('EndTime', curEndTime, 0, varargin);
        ts2 = getsampleusingtime(ts,StartTime,EndTime);
        ts2.Name = ts.Name;
        
        if(AllowReduce && flgReduce)
            if(~isempty(ptrPound))
                i = str2num(curSignal(ptrPound(end)+1:end)) + 1;
                strReduce = sprintf('(:,%d)', i);
            else
                strReduce = curSignal(ptrParen(end):end);
                strReduce = strrep(strReduce, '(:,', '');
                strReduce = strrep(strReduce, '(', '(:,');
            end

            strName = curSignal;
            strName = strrep(strName, '(:,', '(');
%             strName = strrep(strName, '(', '');
%             strName = strrep(strName, ')', '');
            ts2.Name = strName;
            
            ec = ['ts2.Data = ts.Data' strReduce ';'];
            eval(ec);
        end
        
        if(~isempty(curName))
            ts2.Name = curName;
        end
        
        if(isempty(ts2.Name))
            ts2.Name = curSignal;
        end
        ts = ts2;
        
        % Add to Results
        ec = ['Results.' curSignal2Get ' = ts;'];
        eval(ec);
    end
end
    
if( ReturnTSIfSingle && (numSignals == 1) ) 
    Results = ts;
end

end % << End of function load_saved_ts >>

%% REVISION HISTORY
% YYMMDD INI: note
% 120223 MWS: Created function using CreateNewFunc
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
