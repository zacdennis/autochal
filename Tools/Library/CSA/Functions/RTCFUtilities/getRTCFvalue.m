% GETRTCFVALUE Retrieves the values of RTCF connection points
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% getRTCFvalue:
%     Retrieves the current value of RTCF connection points in a running
%     simulation.  Note that booleans will be returned as 1/0 for
%     true/false.
% 
% SYNTAX:
%	[CPValues] = getRTCFvalue(lstCPNames, TryCount_int)
%	[CPValues] = getRTCFvalue(lstCPNames)
%
% INPUTS: 
%	Name            Size		Units       Description
%	lstCPNames      {n x 1}     {'string'}  List of connection points to
%                                           retrieve values for
%   TryCount_int    [1]         [int]       Number of tries to contact
%                                           WinSrvr.exe via ActiveX
%                                            Default is 10
% OUTPUTS: 
%	Name            Size		Units		Description
%	CPValues	    [n]         N/A         Values of each connection point
%                                           (units will vary based on the
%                                           signal in question)
% NOTES:
%
% EXAMPLES:
%	% Retrieve the simtime from a running RTCF simulation
%	SimTime = getRTCFvalue('METRICS.SimTime')
%
% SOURCE DOCUMENTATION:
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit getRTCFvalue.m">getRTCFvalue.m</a>
%	  Driver script: <a href="matlab:edit Driver_getRTCFvalue.m">Driver_getRTCFvalue.m</a>
%	  Documentation: <a href="matlab:winopen(which('getRTCFvalue_Function_Documentation.pptx'));">getRTCFvalue_Function_Documentation.pptx</a>
%
% See also setRTCFvalue 
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://trac.ngst.northgrum.com/CSA/ticket/767
%  
% Copyright Northrop Grumman Corp 2012
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://trac.ngst.northgrum.com/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/RTCFUtilities/getRTCFvalue.m $
% $Rev: 3266 $
% $Date: 2014-10-14 16:09:10 -0500 (Tue, 14 Oct 2014) $
% $Author: sufanmi $

function [CPValues] = getRTCFvalue(lstCPNames, TryCount_int, flgVerbose)

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

%% Input Argument Conditioning:
if((nargin < 3) || isempty(flgVerbose))
    flgVerbose = 1;
end

if((nargin < 2) || isempty(TryCount_int))
    TryCount_int = 10;   % [int]
end

%% Initialize Outputs:

if(ischar(lstCPNames))
    lstCPNames = { lstCPNames };
end

%% Initialize Outputs:
nlines=size(lstCPNames,1);
CPValues = zeros(nlines,1);

%% Main Code:
iTry = 0;
while (iTry < TryCount_int)
    try
        cls=actxGetRunningServer('RQ4CLS.Server');
        break;
    catch
        iTry = iTry + 1;
        pause(1);
    end
end

info_n=1;
for ii=1:nlines
    measname= lstCPNames{ii, 1};
    
    done=0;
    onefound=0;
    jj=1;
    % iterate over possible measurands for match
    full_conn_name ='';
    abbrunits = ' ';
    parts = regexp(measname, '\.', 'split');
    conn_pt=cls.get(char(parts(1)));
    for pp=2:size(parts,2)
        try
            conn_pt=eval(['conn_pt.get(''' char(parts(pp)) ''')']);
            abbrunits=conn_pt.get('AbbrUnits');
            fullunits=conn_pt.get('FullUnits');
            format=conn_pt.get('Format');
            desc=conn_pt.get('Description');
            full_conn_name=conn_pt.get('Path');
            CP_Value=conn_pt.get('Value');
            CPValues(ii) = CP_Value;
            %             disp([full_conn_name ' (' abbrunits ')' ' (' desc ')' ' (currVal=' num2str(CP_Value) ')']);
            break;
        catch ME
            if pp==size(parts,2)
                if(flgVerbose)
                    disp(['Error ' char(parts(pp)) '  ' measname]);
                end
            end
            continue;
        end
    end

end % << End of function getRTCFvalue >>

%% REVISION HISTORY
% YYMMDD INI: note
% 120201 MWS: Created function using CreateNewFunc
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
