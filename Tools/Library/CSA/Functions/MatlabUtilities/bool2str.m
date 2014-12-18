% BOOL2STR converts a Boolean signal to string
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% bool2str:
%     Will convert a boolean value to a string.  The user can specify the
%   string for true or false values, or rely on a default 'yes' or 'no'.
% 
% SYNTAX:
%	[str] = bool2str(data, strTrue, strFalse)
%	[str] = bool2str(data, strTrue)
%	[str] = bool2str(data)
%
% INPUTS: 
%	Name    	Size                Units		Description
%	data	    [Varies]            [bool]		Boolean Flag to Convert
%	strTrue     {cell} or 'string'	[ND]		String/Cell to return if
%                                               true
%	strFalse	{cell} or 'string'	[ND]		String/Cell to return if
%                                               false
%                                               Defaults:
%                                               strTrue = 'yes';
%                                               strFalse = 'no';
% OUTPUTS: 
%	Name    	Size                Units		Description
%	str 	    {cell} or 'string'  [ND]		strTrue or strFalse
%
%   Notes:
%	Data can be scalar ([1]), a vector ([1xN] or [Nx1]), or a 
%   multi-dimensional matrix (M x N x P x ...]).  The output 'str' will of
%   the same dimension as the data.  'str' will be a cell unless 'data'
%   is a scalar ([1]) and the 'strTrue' or 'strFalse' input is a string.
%
% EXAMPLES:
%	Example 1: Specifying Everything
%	[str] = bool2str(true, 'Correct', 'Incorrect')
%	Results:
%   str = 'Correct';
%
%	Example 2: Specifying Only True Value 
%	[str] = bool2str(0, 'plausible')
%	Results:
%   str = 'not plausible';
%
%   Example 3: Vector of Boolean Values
%   data = [1 0 0 1];
%	[str] = bool2str(data);
%	Results:
%   str = { 'yes'    'no'    'no'    'yes'}
%
%   Example 4: Cell Values for strTrue/strFalse
%   str = bool2str(0, {'Cell to show'; 'if true'}, {'Cell to show'; 
%   'if false'});
%   iscell(str)
%   Results:
%   iscell(str) = 1
%   str = {'Cell to show'; 'if false'}
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit bool2str.m">bool2str.m</a>
%	  Driver script: <a href="matlab:edit Driver_bool2str.m">Driver_bool2str.m</a>
%	  Documentation: <a href="matlab:pptOpen('bool2str_Function_Documentation.pptx');">bool2str_Function_Documentation.pptx</a>
%
% See also cell2str  
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/437
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/MatlabUtilities/bool2str.m $
% $Rev: 1718 $
% $Date: 2011-05-11 18:07:49 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [str] = bool2str(data, strTrue, strFalse)
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

if (nargin == 0)
   disp([mfnam ' :: Please refer to useage of bool2str' endl ...
   'Syntax: [str] = bool2str(data, strTrue, strFalse)' endl...
   '        [str] = bool2str(data, strTrue)' endl...
   '        [str] = bool2str(data)']);
   return;
elseif(nargin == 1)
    strTrue = 'yes';
    strFalse = 'no';
elseif(nargin == 2)
    if iscell(strTrue);
        strFalse = {'not ' strTrue};
    else
        strFalse = ['not ' strTrue];
    end
end

if (isempty(data))
    errstr = [mfnam tab 'ERROR: data input is empty' ];
    error([mfnam 'CSA:bool2str:EmptyInput'],errstr);
end

%% Main Function:
str = cell(size(data));
for i = 1:numel(data)
    if(data(i))
        str(i) = {strTrue};
        if numel(data) == 1 && ischar(strTrue)
            str = str{1};
        end
    else
        str(i) = {strFalse};
        if numel(data) == 1 && ischar(strTrue)
            str = str{1};
        end
    end
end

end
% << End of function bool2str >>

%% REVISION HISTORY
% YYMMDD INI: note
% 101101 JPG: Removed error checking on empty strings and fix output str to
%              match the input, so cell inputs result in cell outputs.
% 101018 JPG: Added some error checking
% 101014 JPG: Added ability to take in arrays of boolean values.
% 101014 CNF: Function template created using CreateNewFunc
% 100315 MWS: Originally created function under VSI_LIB,
%             https://vodka.ccc.northgrum.com/svn/VSI_LIB/trunk/CORE/MATLAB
%             _UTILITES/bool2str.m
%**Add New Revision notes to TOP of list**

% Initials Identification: 
% INI: FullName             :  Email                :  NGGN Username 
% JPG: James Patrick Gray   :  james.gray2@ngc.com  :  g61720
% MWS: Mike Sufana          :  mike.sufana@ngc.com  :  sufanmi

%% FOOTER
% Distribution
% WARNING - This document contains technical data whose export is
%   restricted by the Arms Export Control Act (Title 22, U.S.C. 2751 et 
%   seq.) or the Export Administration Act of 1979, as amended, Title 50,
%   U.S.C., App.2401et seq. Violation of these export-control laws is 
%   subject to severe civil and/or criminal penalties.
%
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------------------- UNCLASSIFIED ---------------------------
