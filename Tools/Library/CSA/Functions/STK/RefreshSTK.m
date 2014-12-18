% REFRESHSTK Calls STK Connect and pipes in an input file to refresh
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% RefreshSTK:
%  the running STK models' articulations, ephemeris, and attitudes
%  STK must be installed, running, and the current scenario must contain
%  a Stage1 and Stage2 satellite for this script to work.
%
% *************************************************************************
% * #NOTE: To future COSMO'er, the following warning occured when running
% * CreateNewFunc.
% * CreateNewFunc>>WARNING: Selected Input argument name: "exex/status" is 
% * a function name!
% * -JPG
% *************************************************************************
% SYNTAX:
%	[status] = RefreshSTK(STKConnectRefreshScript, exec, varargin, 'PropertyName', PropertyValue)
%	[status] = RefreshSTK(STKConnectRefreshScript, exec, varargin)
%	[status] = RefreshSTK(STKConnectRefreshScript, exec)
%	[status] = RefreshSTK(STKConnectRefreshScript)
%
% INPUTS: 
%	Name                   	Size		Units		Description
%	STKConnectRefreshScript	<size>		<units>		<Description>
%	exec	                   <size>		<units>		<Description>
%	varargin	[N/A]		[varies]	Optional function inputs that
%	     		        				 should be entered in pairs.
%	     		        				 See the 'VARARGIN' section
%	     		        				 below for more details
%
% OUTPUTS: 
%	Name                   	Size		Units		Description
%	status	                 <size>		<units>		<Description> 
%
% NOTES:
%	Assumes use of STK 9
%
%	VARARGIN PROPERTIES:
%	PropertyName		PropertyValue	Default		Description
%	<PropertyName>		<units>			<Default>	<Description>
%
% EXAMPLES:
%	% <Enter Description of Example #1>
%	[status] = RefreshSTK(STKConnectRefreshScript, exec, varargin)
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[status] = RefreshSTK(STKConnectRefreshScript, exec)
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
%	Source function: <a href="matlab:edit RefreshSTK.m">RefreshSTK.m</a>
%	  Driver script: <a href="matlab:edit Driver_RefreshSTK.m">Driver_RefreshSTK.m</a>
%	  Documentation: <a href="matlab:pptOpen('RefreshSTK_Function_Documentation.pptx');">RefreshSTK_Function_Documentation.pptx</a>
%
% See also <add relevant functions> 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/552
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/STK/RefreshSTK.m $
% $Rev: 3147 $
% $Date: 2014-04-17 19:53:40 -0500 (Thu, 17 Apr 2014) $
% $Author: salluda $

function [status] = RefreshSTK(STKConnectRefreshScript, exec, varargin)

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
% status= -1;

%% Input Argument Conditioning:
% Pick out Properties Entered via varargin
% [<PropertyValue>, varargin]  = format_varargin('<PropertyValue', <Default>, 2, varargin);

%  switch(nargin)
%       case 0
%        exec= ''; STKConnectRefreshScript= ''; 
%       case 1
%        exec= ''; 
%       case 2
%        
%       case 3
%        
%  end
%
%  if(isempty(exec))
%		exec = -1;
%  end

%% Define the search path for the location of AGICEXP.exe
if nargin < 2
    if ( strcmp(computer, 'PCWIN') )
        %  Determine if STK 9 or 10 is being used on 32 bit:
        if (exist('C:\Program Files\AGI\STK 10\bin\AGIPCEXP.exe', 'file') == 2)
            % STK 10 is available:
            exec = 'C:\Program Files\AGI\STK 10\bin\AGIPCEXP.exe';
            evalstr = ['!"C:\Program Files\AGI\STK 10\bin\AGIPCEXP.exe" < "'...
                STKConnectRefreshScript '";' ];
        elseif (exist('C:\Program Files\AGI\STK 9\bin\AGIPCEXP.exe', 'file') == 2)
            % STK 9 is available:
        else
            % No supported version available:
            error('Could not determine which STK version to use.');
        end
    elseif ( strcmp(computer, 'PCWIN64') )
        %  Determine if STK 9 or 10 is being used on 64 bit:
        if (exist('C:\Program Files (x86)\AGI\STK 10\bin\AGIPCEXP.exe', 'file') == 2)
            % STK 10 is available:
            exec = 'C:\Program Files (x86)\AGI\STK 10\bin\AGIPCEXP.exe';
            evalstr = ['!"C:\Program Files (x86)\AGI\STK 10\bin\AGIPCEXP.exe" < "'...
                STKConnectRefreshScript '";' ];
        elseif (exist('C:\Program Files (x86)\AGI\STK 9\bin\AGIPCEXP.exe', 'file') == 2)
            % STK 9 is available:
        else
            % No supported version available:
            error('Could not determine which STK version to use.');
        end
    else
        disp('Could not determine platform type in RefreshSTK.');
        disp(['Please check that your platform is defined/supported: ' computer]);
    end
end

%% Check to be sure that the AGI executable exists:
if exist(exec, 'file') == 2
    % Run the command to reload everything:
    eval(evalstr);
    status = 'Successful';
else
    status = 'Failed';
    return;
end

disp(['RefreshSTK : STK Update ' status]);
%% Compile Outputs:
%	status= -1;

end % << End of function RefreshSTK >>

%% REVISION HISTORY
% YYMMDD INI: note
% 101026 JPG: Copied over information from the old function.
% 101026 CNF: Function template created using CreateNewFunc
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
