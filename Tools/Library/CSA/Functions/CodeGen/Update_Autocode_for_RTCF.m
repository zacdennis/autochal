% UPDATE_AUTOCODE_FOR_RTCF Modifies RTW Autocode for Integration into RTCF
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% Update_Autocode_for_RTCF:
%   This function modifies the MATLAB Real-time Workshop autocode so it can
%   be integrated into the Real Time Component Framework environment.
%
%   4 February 2011 Note: This function may not be required for RTCF code
%   generation.  Check with author prior to use.
% 
% SYNTAX:
%	[lstFiles] = Update_Autocode_for_RTCF(strBlock, varargin, 'PropertyName', PropertyValue)
%	[lstFiles] = Update_Autocode_for_RTCF(strBlock, varargin)
%	[lstFiles] = Update_Autocode_for_RTCF(strBlock)
%
% INPUTS: 
%	Name    	Size		Units		Description
%	strBlock	<size>		<units>		<Description>
%	varargin	[N/A]		[varies]	Optional function inputs that
%	     		        				 should be entered in pairs.
%	     		        				 See the 'VARARGIN' section
%	     		        				 below for more details
%
% OUTPUTS: 
%	Name    	Size		Units		Description
%	lstFiles	<size>		<units>		<Description> 
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
%	[lstFiles] = Update_Autocode_for_RTCF(strBlock, varargin)
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[lstFiles] = Update_Autocode_for_RTCF(strBlock)
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
%	Source function: <a href="matlab:edit Update_Autocode_for_RTCF.m">Update_Autocode_for_RTCF.m</a>
%	  Driver script: <a href="matlab:edit Driver_Update_Autocode_for_RTCF.m">Driver_Update_Autocode_for_RTCF.m</a>
%	  Documentation: <a href="matlab:pptOpen('Update_Autocode_for_RTCF_Function_Documentation.pptx');">Update_Autocode_for_RTCF_Function_Documentation.pptx</a>
%
% See also <add relevant functions> 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/624
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: $
% $Rev: $
% $Date: $
% $Author: $

function [lstFiles] = Update_Autocode_for_RTCF(strBlock, varargin)

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

buildInfo = RTW.getBuildDir(strBlock);

%% Change #1
iFile = 0; lstFiles = {};
iFile = iFile + 1; lstFiles(iFile, :) = {[buildInfo.BuildDirectory filesep strBlock '.h']};

str2lookfor = '#include "rtw_shared_utils.h"';
str2replace = [...
    'extern "C" {' endl ...
    tab str2lookfor endl ...
    '}' endl];
txtReplace(lstFiles, str2lookfor, str2replace, 'OpenAfterEdit', true);

%% Change #2
%  2a
iFile = 0; lstFiles = {};
iFile = iFile + 1; lstFiles(iFile, :) = {[buildInfo.BuildDirectory filesep strBlock '_private.h']};
str2lookfor = ['/* __RTWTYPES_H__ */' endl];
str2replace = [...
    str2lookfor ...
    endl ...
    '#ifdef __cplusplus' endl ...
    tab 'extern "C" {' endl ...
    '#endif' endl];
txtReplace(lstFiles, str2lookfor, str2replace, 'OpenAfterEdit', false);

% Change #2b
str2lookfor = ['#endif                                 /* RTW_HEADER_' strBlock '_private_h_ */' endl];
str2replace = [...
    str2lookfor ...
    endl ...
    '#ifdef __cplusplus' endl ...
    '}' endl ...
    '#endif' endl];
txtReplace(lstFiles, str2lookfor, str2replace, 'OpenAfterEdit', true);

end % << End of function Update_Autocode_for_RTCF >>

%% REVISION HISTORY
% YYMMDD INI: note
% 110119 MWS: Created function using CreateNewFunc
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
