% LISTSTRUCT Lists all fields in a structure (including substructures)
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% listStruct:
%   Compiles a List of All Fields in a Structure (including Substructures)
%
% SYNTAX:
%	[lstStruct] = listStruct(InputStruct, InputStructName)  <-- Normal Call
%	[lstStruct] = listStruct(InputStruct, InputStructName, flgStructOnly, lstStruct) <-- Recursive Call
%
% INPUTS:
%	Name           	Size		Units		Description
%   InputStruct     [structure] N/A         Structure to be Listed
%   InputStructName 'string'    [char]      Name of Inputted Structure
%                                            Optional (Default is '')
%   lstStruct       {Mx1}       {'string'}  Cell array of Current List 
%                                            of Structure Members
%
% OUTPUTS:
%	Name           	Size		Units		Description
%   lstStruct       {Nx1}       {'string'}  List of Structure Members
%
% NOTES:
%	This is a recursive function that will call itself when needed.
%
% EXAMPLES:
%	% Example #1: Create and display a simple structure
%   A.a = 'Hi';
%   A.b.line1 = 'line1';
%   A.b.line2 = 'line2';
%   A.c.ref.a = 'a';
%   A.c.ref.b = 'b';
%   [lstStruct] = listStruct( A, 'A') returns:
%
%   lstStruct =
%     'A.a'
%     'A.b.line1'
%     'A.b.line2'
%     'A.c.ref.a'
%     'A.c.ref.b'
%
% SOURCE DOCUMENTATION:
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit listStruct.m">listStruct.m</a>
%	  Driver script: <a href="matlab:edit Driver_listStruct.m">Driver_listStruct.m</a>
%	  Documentation: <a href="matlab:pptOpen('listStruct_Function_Documentation.pptx');">listStruct_Function_Documentation.pptx</a>
%
% See also fieldnames
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/457
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/MatlabUtilities/listStruct.m $
% $Rev: 2263 $
% $Date: 2011-11-16 17:35:16 -0600 (Wed, 16 Nov 2011) $
% $Author: sufanmi $

function [lstStruct] = listStruct(InputStruct, InputStructName, lstStruct)

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

%% Main Function:
if nargin < 2
    InputStructName = '';
end

if nargin < 3
    lstStruct = { };
end

if(~isempty(InputStruct))
    
    %% Grab Field Names of Current Inputted Structure:
    arrFieldNames = fieldnames( InputStruct );
    
    %% Loop Through Each Field Name:
    for i = 1:length(arrFieldNames);
        
        %% Create String of Possible Structure:
        possibleStruct = sprintf('InputStruct.%s', char(arrFieldNames(i)));
        
        %% Check to see if it is a Structure:
        if isstruct(eval(possibleStruct))
            
            %% Field Member is a Structure:
            %   Update InputStructName:
            if ~isempty(InputStructName)
                newInputStructName = sprintf('%s.%s', InputStructName, ...
                    char(arrFieldNames(i)));
            else
                newInputStructName = sprintf('%s', char(arrFieldNames(i)));
            end
            
            %   Recurse into Structure:
            [lstStruct] = listStruct( eval(possibleStruct), ...
                newInputStructName, lstStruct);
        else

                %% Field Member is NOT a Structure (Add to list):
                ctr = size(lstStruct,1) + 1;    % Increment Counter
                
                % Add Field Member to List:
                if ~isempty(InputStructName)
                    
                    addLine = sprintf('%s.%s', char(InputStructName), ...
                        char(arrFieldNames(i)));
                    lstStruct(ctr,:) = { char(addLine) };
                    
                else
                    addLine = sprintf('%s', char(arrFieldNames(i)));
                    lstStruct(ctr,:) = { char(addLine) };
                    
                end
            end
        end

    
end

end % << End of function listStruct >>

%% REVISION HISTORY
% YYMMDD INI: note
% 101025 JPG: Copied over information from the old function.
% 060821 MWS: Originally developed and added to legacy VSI Library
%             https://vodka.ccc.northgrum.com/svn/VSI_LIB/trunk/CORE/MATLAB_UTILITES/listStruct.m
%**Add New Revision notes to TOP of list**

% Initials Identification:
% INI: FullName             : Email                 : NGGN Username
% JPG: James Patrick Gray   : james.gray2@ngc.com   : g61720
% MWS: Mike Sufana          : mike.sufana@ngc.com   : sufanmi

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
