% FORMAT_VARARGIN Function utility for variable input arguments
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% format_varargin:
%  Looks at all the additional inputted arguments and returns the value if
%  the property is found.  If not, returns the default.
% 
% SYNTAX:
%	[y, argin2] = format_varargin(strDefault, valDefault, SortMode, argin)
%
% INPUTS: 
%	Name      	Size		Units		Description
%  strDefault  'string'     [char]      Input argument to look for
%  valDefault  [varies]     [varies]    Default value
%  SortMode     [1]         [int]       Sorting Mode where
%                                       0: Overwrites Default Value If Empty or 
%                                          Adds Property/Value if nonexistant
%                                       1: Overwrites Default Value
%                                       2: Removes property and value
%                                           (Overwrites empty with default)
%                                       3: Removes property and value
%                                           (No Overwrite if empty)
%  argin        {cell}                  Input arguments to sort through

%
% OUTPUTS: 
%	Name      	Size		Units		Description
%   y          [varies]    [varies]     Property value
%	argin2	   {cell}                   argin with Property Name and Value
%                                        removed
%
% NOTES:
%
% EXAMPLES:
%   argin = {'LineWidth', 10, 'FontWeight', 'bold'};
%
% EX #1: With Sort Mode = 0...
%
%  [y, argin2] = format_varargin('NewProp', 1, 0, argin)
% y =
%      1
% argin2 = 
%     'LineWidth'    [10]    'FontWeight'    'bold'    'NewProp'    [1]
%
% EX #2: With Sort Mode = 1...
%
% [y, argin2] = format_varargin('FontWeight', 1, 1, argin)
% y =
%      1
% argin2 = 
%     'LineWidth'    [10]    'FontWeight'    [1]
%
% EX #3: With Sort Mode = 2, returns property value...
%
%[y, argin2] = format_varargin('FontWeight', 1, 2, argin)
% y =
% bold
% argin2 = 
%     'LineWidth'    [10]
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit format_varargin.m">format_varargin.m</a>
%	  Driver script: <a href="matlab:edit Driver_format_varargin.m">Driver_format_varargin.m</a>
%	  Documentation: <a href="matlab:pptOpen('format_varargin_Function_Documentation.pptx');">format_varargin_Function_Documentation.pptx</a>
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/445
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/MatlabUtilities/format_varargin.m $
% $Rev: 2960 $
% $Date: 2013-05-31 16:09:37 -0500 (Fri, 31 May 2013) $
% $Author: sufanmi $

function [y, argin2] = format_varargin(strDefault, valDefault, SortMode, argin, varargin)

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

y = valDefault;

if(isempty(argin))
        if((SortMode == 0) || (SortMode == 1))
            argin2{1} = strDefault;
            argin2{2} = valDefault;
        else
            argin2 = argin;
        end
else

    argin2 = {};
    numArgin = size(argin, 2);
    
    ptrOld = 0;
    ptrNew = 0;
    
    flgMatchFound = 0;
    
    while (ptrOld < numArgin)
        ptrOld = ptrOld + 1;
        curArg = argin{ptrOld};
        
        flgMatch = 0;
        if(ischar(curArg))
            % Only Check for Strings since inputted "values" could be
            % scalar, vector, or even a cell array
            flgMatch = (strcmp(lower(curArg), lower(strDefault)));
        end
        
        if(flgMatch)
            switch SortMode
                case 0
                    % Overwrite Default:
                    ptrNew = ptrNew + 1;
                    argin2{ptrNew} = curArg;

                    ptrOld = ptrOld + 1;
                    curArg = argin{ptrOld}; 
                    ptrNew = ptrNew + 1;
                    curArg = argin{ptrOld}; 
                    if(isempty(curArg))
                        argin2{ptrNew} = valDefault;
                    else
                        argin2{ptrNew} = curArg;
                        y = curArg;
                    end
                    flgMatchFound = 1;
     
                case 1
                    % Overwrite Default:
                    ptrNew = ptrNew + 1;
                    argin2{ptrNew} = curArg;
                    
                    ptrOld = ptrOld + 1;
                    curArg = argin{ptrOld};
                    ptrNew = ptrNew + 1;
                    argin2{ptrNew} = valDefault;
                    flgMatchFound = 1;
                    
                case 2
                    % Strip out Variable (Overwrite if empty):
                    
                    ptrOld = ptrOld + 1;
                    y = argin{ptrOld};
                    
                    if(isempty(y))
                        y = valDefault;
                    end
                case 3
                    % Strip out Variable (Do nothing if empty):
                    
                    ptrOld = ptrOld + 1;
                    y = argin{ptrOld};
            end
        else
            ptrNew = ptrNew + 1;
            argin2{ptrNew} = curArg;
        end
    end
    
    if((flgMatchFound == 0) && ((SortMode == 0) || (SortMode == 1)))
            ptrNew = ptrNew + 1;
            argin2{ptrNew} = strDefault;
            ptrNew = ptrNew + 1;
            argin2{ptrNew} = valDefault;
    end
    
end

end % << End of function format_varargin >>

%% REVISION HISTORY
% YYMMDD INI: note
% 101019 MWS: Cleaned up internal documentation with CreateNewFunc
% 081218 MWS: Originally created function for VSI_LIB
%               https://vodka.ccc.northgrum.com/svn/VSI_LIB/trunk/CORE/MATLAB_UTILITES/format_varargin.m
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
