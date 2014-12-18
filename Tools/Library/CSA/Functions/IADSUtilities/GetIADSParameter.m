% GETIADSPARAMETER Retrieves the Parameter, Short, or Long Name from an IADS Parameter Map
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% GetIADSParameter:
%   Retrieves the parameter, short name, or long name of a list of signals
%   that are contained in an Symvionics IADS parameter map.  The list of 
%   desired signals can be any combination of IADS parameter names, short 
%   names, and/or long names.
% 
% SYNTAX:
%	[lstIADSParameters] = GetIADSParameter(lstParameterMap, lstDesired, strMapType)
%	[lstIADSParameters] = GetIADSParameter(lstParameterMap, lstDesired)
%
% INPUTS: 
%	Name             	Size		Units		Description
%	lstParameterMap     {n x 3}     {[char]}    IADS parameter list where
%    {:,1} Parameter    'string'    [char]      Parameter name
%    {:,2} Short Name   'string'    [char]      Short name
%    {:,3} Long Name    'string'    [char]      Long name
%
%	lstDesired          {m x 1}     {[char]}    List of parameter, short,
%                                                and/or long names to look
%                                                up a reference for
%	strMapType	       'string'     [char]      Reference parameter to
%                                                retrieve.  Can be either:
%                                                'Parameter' (default),
%                                                'ShortName', or 'LongName'
%
% OUTPUTS: 
%	Name             	Size		Units		Description
%	lstIADSParameters	{m x 1}     {[char]}    Depending on the desired
%                                               'strMapType', this will be
%                                               a list of the desired
%                                               parameter, short name, or
%                                               long name for the list of
%                                               'lstDesired' signals
% NOTES:
%
% EXAMPLES:
%	% Example 1a: Retrieve the 'Parameter' (Column 1) from a list of IADS
%   %            paramters
%   lstParameterMap = {'A', 'Short A', 'Long A';
%                      'B', 'Short B', 'Long B';
%                      'C', 'Short C', 'Long C';
%                      'D', 'Short D', 'Long D'};
%   lstDesired = {'Short B'; 'Long C'; 'D'};
%	[lstIADSParameters] = GetIADSParameter(lstParameterMap, lstDesired, 'Parameter')
%	% Returns 'lstIADSParameters = 
%   %     'B'
%   %     'C'
%   %     'D'
%
%   % Example 1b: Retrive the 'ShortName' (Column 2) from the same list
%	[lstIADSParameters] = GetIADSParameter(lstParameterMap, lstDesired, 'ShortName')
%	% Returns 'lstIADSParameters = 
%   %     'Short B'
%   %     'Short C'
%   %     'Short D'
%
% SOURCE DOCUMENTATION:
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit GetIADSParameter.m">GetIADSParameter.m</a>
%	  Driver script: <a href="matlab:edit Driver_GetIADSParameter.m">Driver_GetIADSParameter.m</a>
%	  Documentation: <a href="matlab:winopen(which('GetIADSParameter_Function_Documentation.pptx'));">GetIADSParameter_Function_Documentation.pptx</a>
%
% See also ListIADSParameters 
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/746
%  
% Copyright Northrop Grumman Corp 2012
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/IADSUtilities/GetIADSParameter.m $
% $Rev: 2316 $
% $Date: 2012-03-08 13:31:48 -0600 (Thu, 08 Mar 2012) $
% $Author: sufanmi $

function [lstIADSParameters] = GetIADSParameter(lstParameterMap, lstDesired, strMapType)

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


if(nargin < 3)
    strMapType = 'Parameter';
end

% Search order is:
%   1. Parameter Name
%   2. Long Name
%   3. Short Name

if(ischar(lstDesired))
    lstDesired = { lstDesired };
end

numDesired = size(lstDesired, 1);

numParamMapCol = size(lstParameterMap, 2);

lstParameterName= lstParameterMap(:,1);
numParameterMap = size(lstParameterMap, 1);
if(numParamMapCol == 1)
    if(~strcmp(lower(strMapType), 'parameter'))
        disp(sprintf('%s : Warning : Parameter Map does not contain a Short/Long Column.  Searching only the Parameter Name', ...
            mfnam));
        strMapType = 'Parameter';
        lstShortName = {};
        lstLongName = {};
    end
else
    lstShortName    = lstParameterMap(:,2);
    lstLongName     = lstParameterMap(:,3);
end

lstIADSParameters = cell(numDesired, 1);
for iDesired = 1:numDesired
    curDesired = lstDesired{iDesired};
    
    % Parameter Name
    if(any(strcmp(lstParameterName, curDesired)))
        idxRow = max(strcmp(lstParameterName, curDesired) .* [1:numParameterMap]');
        
    elseif(any(strcmp(lstLongName, curDesired)))
        idxRow = max(strcmp(lstLongName, curDesired) .* [1:numParameterMap]');
        
    elseif(any(strcmp(lstShortName, curDesired)))
        idxRow = max(strcmp(lstShortName, curDesired) .* [1:numParameterMap]');
        
    else
        disp(sprintf('%s : Warning : NO Parameter/Short/Long Name for ''%s''.  Return null', ...
            mfilename, curDesired));
        idxRow = [];
    end

    if(isempty(idxRow))
        refParam = '';
    else
        switch lower(strMapType)
            case 'parameter'
                 refParam = lstParameterName{idxRow, 1};
            case {'short'; 'shortname'}
                 refParam = lstShortName{idxRow, 1};
            case {'long'; 'longname'}
                refParam = lstLongName{idxRow, 1};
        end
    end
    
    lstIADSParameters(iDesired) = { refParam };
end

% Turn it from a cell back into a string if only 1 signal is desired
if(numDesired == 1)
    lstIADSParameters = lstIADSParameters{1};
end

end % << End of function GetIADSParameter >>

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
