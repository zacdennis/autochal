% CHANGEVALUE Changes the value on a Simulink block
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% ChangeValue:
%     Changes the value on a Simulink block
% 
% SYNTAX:
%	[flgParamUsed] = ChangeValue(curParamStr, newParamStr, blockType, sys, varargin, 'PropertyName', PropertyValue)
%	[flgParamUsed] = ChangeValue(curParamStr, newParamStr, blockType, sys, varargin)
%	[flgParamUsed] = ChangeValue(curParamStr, newParamStr, blockType, sys)
%	[flgParamUsed] = ChangeValue(curParamStr, newParamStr, blockType)
%
% INPUTS: 
%	Name        	Size		Units		Description
%   curParamStr     [string]                String to look for
%   newParamStr     [string]                New string to use
%   blockType       [string]                Either: 'Constant', 'Gain', or 'Memory'
%   sys             [string]                Current Mode (Default is bdroot]
%	varargin	[N/A]		[varies]	Optional function inputs that
%	     		        				 should be entered in pairs.
%	     		        				 See the 'VARARGIN' section
%	     		        				 below for more details
%
% OUTPUTS: 
%	Name        	Size		Units		Description
%   flgParamUsed    [bool]                  Was anything actually changed?
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
%	[flgParamUsed] = ChangeValue(curParamStr, newParamStr, blockType, sys, varargin)
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[flgParamUsed] = ChangeValue(curParamStr, newParamStr, blockType, sys)
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
%	Source function: <a href="matlab:edit ChangeValue.m">ChangeValue.m</a>
%	  Driver script: <a href="matlab:edit Driver_ChangeValue.m">Driver_ChangeValue.m</a>
%	  Documentation: <a href="matlab:pptOpen('ChangeValue_Function_Documentation.pptx');">ChangeValue_Function_Documentation.pptx</a>
%
% See also <add relevant functions> 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/532
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/SimulinkUtilities/ChangeValue.m $
% $Rev: 1726 $
% $Date: 2011-05-11 19:02:15 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [flgParamUsed] = ChangeValue(curParamStr, newParamStr, blockType, sys, varargin)

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
% flgParamUsed= -1;

%% Input Argument Conditioning:
% Pick out Properties Entered via varargin
% [<PropertyValue>, varargin]  = format_varargin('<PropertyValue', <Default>, 2, varargin);

%  switch(nargin)
%       case 0
%        sys= ''; blockType= ''; newParamStr= ''; curParamStr= ''; 
%       case 1
%        sys= ''; blockType= ''; newParamStr= ''; 
%       case 2
%        sys= ''; blockType= ''; 
%       case 3
%        sys= ''; 
%       case 4
%        
%       case 5
%        
%  end
%
%  if(isempty(sys))
%		sys = -1;
%  end
%% Main Function:
if(nargin < 4)
    sys = bdroot;
end

flgVerbose = 1;

%% Find All Blocks with Masks and No Help:
switch blockType
    case 'Constant'
        blockValue = 'Value';
    case 'Gain'
        blockValue = 'Gain';
    case 'Memory'
        blockValue = 'X0';
end
    
lstBlocks = find_system(sys, 'FollowLinks', 'on', ...
    'BlockType', blockType, blockValue, curParamStr);
numBlocks = size(lstBlocks, 1);

flgParamUsed = (numBlocks > 0);

%% Loop Through Found Masks:
for iBlock = 1:numBlocks
    curBlock = lstBlocks{iBlock,:};
    
    if(flgVerbose)
        disp(sprintf('%s : Changing %s ''%s'' from ''%s'' to ''%s''...', ...
            mfilename, blockType, curBlock, curParamStr, newParamStr));
    end
    
    set_param(curBlock, blockValue, newParamStr);
end

if(flgParamUsed == 0)
    % Check to see if param is already in use:
    lstBlocks = find_system(sys, 'FollowLinks', 'on', ...
        'BlockType', blockType, blockValue, newParamStr);
    numBlocks = size(lstBlocks, 1);
    flgParamUsed = (numBlocks > 0);
end

%% Compile Outputs:
%	flgParamUsed= -1;

end % << End of function ChangeValue >>

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
