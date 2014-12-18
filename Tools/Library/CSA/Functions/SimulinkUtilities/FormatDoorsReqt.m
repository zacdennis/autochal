% FORMATDOORSREQT Formats a block's RequirementInfo field into a readable string
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% FormatDoorsReqt:
%   This function returns the 'RequirementInfo' section of a block into an
%   easy to read string.  This string can then be added to the block's
%   description field so that the requirements show up as easy to read text
%   fields in the autocode.
% 
% SYNTAX:
%	[strReqt] = FormatDoorsReqt(blockName, varargin, 'PropertyName', PropertyValue)
%	[strReqt] = FormatDoorsReqt(blockName, varargin)
%	[strReqt] = FormatDoorsReqt(blockName)
%
% INPUTS: 
%	Name    	Size		Units		Description
%	blockName   'string'    [char]      Full path of Simulink block with
%                                       Requirements info
%                                       Default: gcb
%	varargin	[N/A]		[varies]	Optional function inputs that
%	     		        				 should be entered in pairs.
%	     		        				 See the 'VARARGIN' section
%	     		        				 below for more details
%
% OUTPUTS: 
%	Name    	Size		Units		Description
%	strReqt     'string'    [char]      Block's requirements formatted into
%                                       an easy to read string
% NOTES:
%
%	VARARGIN PROPERTIES:
%	PropertyName		PropertyValue	Default		Description
%	'IncludeItemNum'    [bool]          true        Include Req Item # in
%                                                   formatted string?
%   'RequirementPrefix' 'string'        'VMS'       Requirement Item Prefix
%                                                   to use
%   'RemovePound'       [bool]          false       Remove the '#' sign
%                                                   when formatting the 
%                                                   item number?
%
% EXAMPLES:
%	% <Enter Description of Example #1>
%	[strReqt] = FormatDoorsReqt(blockName, varargin)
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
%	Source function: <a href="matlab:edit FormatDoorsReqt.m">FormatDoorsReqt.m</a>
%	  Driver script: <a href="matlab:edit Driver_FormatDoorsReqt.m">Driver_FormatDoorsReqt.m</a>
%	  Documentation: <a href="matlab:pptOpen('FormatDoorsReqt_Function_Documentation.pptx');">FormatDoorsReqt_Function_Documentation.pptx</a>
%
% See also <add relevant functions> 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/687
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: $
% $Rev: $
% $Date: $
% $Author: $

function [strReqt] = FormatDoorsReqt(blockName, varargin)

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
strReqt = '';       % Initialize String

%% Input Argument Conditioning:
% Pick out Properties Entered via varargin
[flgIncludeItemNum, varargin]   = format_varargin('IncludeItemNum', true, 2, varargin);
[ReqtPrefix, varargin]          = format_varargin('RequirementPrefix', 'VMS', 2, varargin);
[flgRemovePound, varargin]      = format_varargin('RemovePound', false, 2, varargin);

%% Main Function:
blockReqmts = get_param(blockName, 'RequirementInfo');
if(~isempty(blockReqmts))
    
    cellReqInfo = eval(blockReqmts);
    numReqts = size(cellReqInfo, 1);

    for iReq = 1:numReqts
        lstReqts(iReq).linktype      = cellReqInfo{iReq, 1};
        
        strDoc = cellReqInfo{iReq, 2};
        ptrSpaces = findstr(strDoc, ' ');
        strItemNum = strDoc(1:ptrSpaces(1)-1);
        strDoc2 = strDoc(ptrSpaces(1)+1:end);
        
        strDescription = cellReqInfo{iReq, 5};
        
        lstReqts(iReq).doc           = strDoc2;
        lstReqts(iReq).id            = cellReqInfo{iReq, 3};
        lstReqts(iReq).description   = [strItemNum ' ' strDescription];
    end
    
    strPrefix = '   ';  % Description formatting
    
    for iReqt = 1:numReqts
        rmiReqt = lstReqts(iReqt);
        
        if(flgRemovePound)
            rmiReqt.id = rmiReqt.id(2:end);
        end
        
        str = '';
        if(~isempty(ReqtPrefix))
            rmiReqt.id = [ReqtPrefix '-' rmiReqt.id];
        end
        str = [str 'DOORS Requirements Link:  ' rmiReqt.id endl];
        
        str = [str 'Reference Document: ' rmiReqt.doc endl];
        if(~isempty(str2num(rmiReqt.description(1))))
            ptrSpace = findstr(rmiReqt.description, ' ');
            rmiReqt.ItemNum = rmiReqt.description(1:(ptrSpace(1)-1));
            rmiReqt.description = rmiReqt.description(ptrSpace(1)+1:end);
            str = [str 'Reference Section:  ' rmiReqt.ItemNum endl];
        end
        str = [str str2paragraph(rmiReqt.description, 'Prefix', strPrefix) endl];
        strReqt = [strReqt str];
    end
%     strReqt = [strReqt 'Auto-inserted using ' mfnam '.m' endl];
end

%% Compile Outputs:
%	strReqt= -1;

end % << End of function FormatDoorsReqt >>

%% REVISION HISTORY
% YYMMDD INI: note
% 101118 MWS: Function template created using CreateNewFunc
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
