% SETRTCFVALUE Sets the values of RTCF connection points
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% setRTCFvalue:
%     Sets the values of RTCF connection points in a running simulation.
%
% SYNTAX:
%	[CmdTook] = setRTCFvalue(lstCPNames, TryCount_int)
%	[CmdTook] = setRTCFvalue(lstCPNames)
%
% INPUTS:
%	Name            Size    Units               Description
%	lstCPNames      {n x 2} {'string' value}    List of connection points
%                                               and their desired values
%   TryCount_int    [1]     [int]               Number of tries to contact
%                                               WinSrvr.exe via ActiveX
%                                                Default is 10
% OUTPUTS:
%	Name            Size	Units               Description
%	CmdTook         [n]     [boolean]           Command was accepted via
%                                               WinSrvr.exe
%
% NOTES:
%
% EXAMPLES:
%	% Example 1: Set a boolean signal to true
%   ValueTook = setRTCFvalue( {'<Component>.IN.ICs.IC_GroundTestMode_flg', 'True'} );
%
%   % Example 2: Set a numeric signal to some value
%   ValueTook = setRTCFvalue( {...
%               '<Component>.IN.ICs.IC_Mode_idx',   1;
%               '<Component>.IN.ICs.IC_Alt_ft',     20000 };
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit setRTCFvalue.m">setRTCFvalue.m</a>
%	  Driver script: <a href="matlab:edit Driver_setRTCFvalue.m">Driver_setRTCFvalue.m</a>
%	  Documentation: <a href="matlab:winopen(which('setRTCFvalue_Function_Documentation.pptx'));">setRTCFvalue_Function_Documentation.pptx</a>
%
% See also setRTCFvalue
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://trac.ngst.northgrum.com/CSA/ticket/768
%
% Copyright Northrop Grumman Corp 2012
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://trac.ngst.northgrum.com/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/RTCFUtilities/setRTCFvalue.m $
% $Rev: 2513 $
% $Date: 2012-10-05 13:42:01 -0500 (Fri, 05 Oct 2012) $
% $Author: sufanmi $

function [CmdTook] = setRTCFvalue(lstCPNames, TryCount_int)

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
CmdTook = zeros(size(lstCPNames,1),1);

%% Input Argument Conditioning:
if((nargin < 2) || isempty(TryCount_int))
    TryCount_int = 10;   % [int]
end

%% Main Function:
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

numCPs=size(lstCPNames,1);

for iCP=1:numCPs
    CPName= lstCPNames{iCP, 1};
    CPVal = lstCPNames{iCP, 2};
    done=0;
    onefound=0;
    % iterate over possible measurands for match
    parts = regexp(CPName, '\.', 'split');
    try
        conn_pt=cls.get(char(parts(1)));
    catch
        disp(['Error : Unkown RTCF Connection Point: ' CPName]);
    end
    
    numParts = size(parts, 2);
    for pp=2:numParts
        try
            conn_pt=eval(['conn_pt.get(''' char(parts(pp)) ''')']);
            if(pp == numParts)
                onefound = 1;
            end
        catch ME
            disp(ME.message);
            break;
        end
    end
    
    if(onefound)
        if(isempty(CPVal))
            conn_pt.set('Fixed',false);
            
        else
            conn_pt.set('FixedValue', CPVal);
            conn_pt.set('Fixed',true);
        end
    else
        disp(sprintf('RTCF Connection point ''%s'' not found!', CPName));
    end
    CmdTook(iCP) = onefound;
end

end % << End of function setRTCFvalue >>

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
