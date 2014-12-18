% CREATENEWFILE_DEFAULTS Default markings for new CSA files
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% CreateNewFile_Defaults:
%   This function establishes the default tags to be included in new CSA
%   files and functions created by the CSA functions CreateNewFunc, 
%   CreateNewScript, and CreateDriverScript.
%
% SYNTAX:
%	[CNF_info] = CreateNewFile_Defaults(flgAddComments, strCallingScript)
%	[CNF_info] = CreateNewFile_Defaults(flgAddComments)
%
% INPUTS:
%	Name            	Size		Units		Description
%	flgAddComments                              Overloaded input
%    (option #1)        [1]         [bool]      Use '%' for comments?
%    (option #2)        'string'    [char]      String for comments
%	strCallingScript	'string'    [char]      Name of calling function
%	varargin            [N/A]		[varies]	Optional function inputs that
%                                               should be entered in pairs.
%                                               See the 'VARARGIN' section
%                                               below for more details
% OUTPUTS:
%	Name            	Size		Units		Description
%	CNF_info	        {struct}                Default markings
%    .CentChar          'string'    [char]      Character to use for
%                                                   centered strings
%    .HelpWidth         [1]         [int]       Width of help section
%    .Classification    'string'    [char]      Document type
%    .Proprietary       'string'    [char]      NGC proprietary level tag
%    .ITAR              'string'    [char]      1-line ITAR tag
%    .ITAR_Paragraph    'string'    [char]      Full ITAR paragraph
%    .Copyright         'string'    [char]      Full copyright tag
%
% NOTES:
%	VARARGIN PROPERTIES:
%	PropertyName		PropertyValue	Default		Description
%   'IncludeITAR'       [1]             true        Include ITAR tags?
%
% EXAMPLES:
%	% Load Default Markings using '#' for comments
%	[CNF_info] = CreateNewFile_Defaults('#')
%
% SOURCE DOCUMENTATION:
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit CreateNewFile_Defaults.m">CreateNewFile_Defaults.m</a>
%	  Driver script: <a href="matlab:edit Driver_CreateNewFile_Defaults.m">Driver_CreateNewFile_Defaults.m</a>
%	  Documentation: <a href="matlab:pptOpen('CreateNewFile_Defaults_Function_Documentation.pptx');">CreateNewFile_Defaults_Function_Documentation.pptx</a>
%
% See also CreateNewFunc, CreateNewScript, CreateDriverScript
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://trac.ngst.northgrum.com/CSA/ticket/636
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://trac.ngst.northgrum.com/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/CoSMO_Utilities/CreateNewFile_Defaults.m $
% $Rev: 3239 $
% $Date: 2014-08-18 19:13:36 -0500 (Mon, 18 Aug 2014) $
% $Author: sufanmi $

function [CNF_info] = CreateNewFile_Defaults(flgAddComments, strCallingScript, varargin)

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
[IncludeITAR, varargin]     = format_varargin('IncludeITAR', true, 2, varargin);

switch(nargin)
    case 0
        strCallingScript= ''; flgAddComments= [];
    case 1
        strCallingScript= '';
    case 2
        
    case 3
        
end

if(isempty(strCallingScript))
    strCallingScript = 'CreateNewFunc';
end

if(isempty(flgAddComments))
    flgAddComments = 1;
end

if(~isnumeric(flgAddComments))
    strC = flgAddComments;
else
    if(flgAddComments)
        strC = '% ';
    else
        strC = '';
    end
end

%% Main Function:
% Check CNF_info
endl = sprintf('\n');
CNF_info.Notes = ['Default Values for ' strCallingScript];
CNF_info.CentChar = '-';
CNF_info.HelpWidth = 67;
CNF_info.Classification = 'UNCLASSIFIED';
CNF_info.Classificaiton_inclBlock = 0; % 1 includes block below
CNF_info.Classification_DeclassYrs = 10; %-1 puts "<enter date>"
CNF_info.Classification_ReviewYrs = 9.6; %uses Y.M not Y.fractions
DeclassDateStr = GetDeclassDate(CNF_info.Classification_DeclassYrs);
ReviewDateStr = GetDeclassDate(CNF_info.Classification_ReviewYrs);
CNF_info.Classification_Block = [...
    strC 'Classified by: ' endl ...
    strC 'Authority: ' endl ...
    strC 'Declassify On: ' DeclassDateStr endl ...
    strC 'Review on: ' ReviewDateStr ];
CNF_info.Proprietary = 'Northrop Grumman Proprietary Level 1';

CNF_info.ITAR = '';
if(IncludeITAR)
    CNF_info.ITAR = 'ITAR Controlled Work Product';
end

CNF_info.ITAR_Paragraph = '';
if(IncludeITAR)
    % http://www.dtic.mil/whs/directives/corres/pdf/523024p.pdf
    % PDF pg 20.
    CNF_info.ITAR_Paragraph =[...
        strC 'WARNING - This document contains technical data whose export is' endl ...
        strC '  restricted by the Arms Export Control Act (Title 22, U.S.C., Sec 2751,' endl ...
        strC '  et seq.) or the Export Administration Act of 1979 (Title 50, U.S.C.,' endl ...
        strC '  App. 2401 et set.), as amended. Violations of these export laws are' endl ...
        strC '  subject to severe criminal penalties.  Disseminate in accordance with' endl ...
        strC '  provisions of DoD Direction 5230.25.'];
end

% http://www.dtic.mil/whs/directives/corres/pdf/523024p.pdf
% PDF pg 21.
CNF_info.Distribution = '';
% CNF_info.Distribution = [...
%     strC 'DISTRIBUTION A. Approved for public release: distribution unlimited.' endl];
% CNF_info.Distribution = [...
%     strC 'DISTRIBUTION B. Distribution authorized to U.S. Government agencies' endl ...
%     strC '  (reason) (date of determination). Other requests for this document' endl ...
%     strC '  shall be referred to (controlling DoD office).' endl];
% CNF_info.Distribution = [...
%     strC 'DISTRIBUTION C. Distribution authorized to U.S. Government agencies' endl ...
%     strC '  and their contractors (reason) (date of determination). Other requests' endl ...
%     strC '  for this document shall be referred to (controlling DoD office).' endl];
% CNF_info.Distribution = [...
%     strC 'DISTRIBUTION D. Distribution authorized to Department of Defense and U.S.' endl ...
%     strC '  DoD contractors only (reason) (date of determination). Other requests' endl ...
%     strC '  for this document shall be referred to (controlling DoD office).' endl];
% CNF_info.Distribution = [...
%     strC 'DISTRIBUTION E. Distribution authorized to DoD Components only (reason)' endl ...
%     strC '  (date of determination). Other requests for this document shall be' endl ...
%     strC '  referred to (controlling DoD office).' endl];
% CNF_info.Distribution = [...
%     strC 'DISTRIBUTION F. Further dissemination only as directed by (controlling' endl ...
%     strC '  office) (date of determination) or higher DoD authority.' endl];

CNF_info.ContractStr = 'Contract Name: <Enter Contract>'; %TODO: Not implemented
CNF_info.ContractNum = '<Enter Contract Number>'; %TODO: Not iplemented.

CNF_info.Verification = [...
    strC 'VERIFICATION DETAILS:' endl ...
    strC 'Verified: No' endl ...
    strC 'Trac Page: http://trac.ngst.northgrum.com/CSA/ticket/<TicketNumber>' endl ...
    strC ' ' endl];

CNF_info.NumExamples = 2;

CNF_info.IncludeHyperlinks = 1;
CNF_info.IncludeRelevantFunctions = 1;
CNF_info.Copyright = [strC 'Copyright Northrop Grumman Corp ' datestr(now,'YYYY') endl];
    
CNF_info.Maintenance = [...    
    strC 'Maintained by: Aerospace Systems' endl ...
    strC 'http://trac.ngst.northgrum.com/CSA/' endl ];

CNF_info.RevisionHistory = '';
% CNF_info.RevisionHistory = [...
%     '%% REVISION HISTORY' endl ...
%     '% YYMMDD INI: note' endl ...
%     '% <YYMMDD> <initials>: <Revision update note>' endl ...
%     '% ' datestr(now,'YYmmdd') ' <INI>: Created function using ' mfnam endl ...
%     '%**Add New Revision notes to TOP of list**' endl];

CNF_info.AuthorIdentification = '';
% CNF_info.AuthorIdentification = [...
%     '%% AUTHOR IDENTIFICATION ' endl ...
%     strC 'INI: FullName            : Email     : NGGN Username ' endl ...
%     strC '<initials>: <Fullname>   : <email>   : <NGGN username> ' endl];
% end

CNF_info.IncludeDebugging = 1;

end % << End of function CreateNewFile_Defaults >>

function [DeclassDateStr] = GetDeclassDate(Yrs,StartDate)
if nargin == 1;
    StartDate = now();
end
if Yrs < 0;
    DeclassDateStr = '<Enter Date>';
    return % Don't want a real calc...
end
yrs = floor(Yrs);
mo = round((Yrs-yrs)*10); % the decimal is months,not fraction
declass = addtodate(datenum(StartDate),yrs,'year');
declass = addtodate(declass,mo,'month');
DeclassDateStr = datestr(declass,'mmmm dd yyyy');
end

%% REVISION HISTORY
% YYMMDD INI: note
% <YYMMDD> <initials>: <Revision update note>
% 101013 CNF: Function template created using CreateNewFunc
%**Add New Revision notes to TOP of list**

% Initials Identification:
% INI: FullName         : Email                 : NGGN Username
% MWS: Mike Sufana      : mike.sufana@ngc.com   : sufanmi

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
