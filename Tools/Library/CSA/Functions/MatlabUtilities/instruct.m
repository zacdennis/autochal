% INSTRUCT Enhanced version of isfield where True if field is in structure array
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% instruct:
%     Determines if a fieldname or a list of fieldnames is in a given
%     structure.  This function is an enhanced version of MATLAB's isfield.
%     This function supports the '.' in a fieldname so that subfields can
%     be found within a given structure.
% 
% SYNTAX:
%	[tf] = instruct(s, lstFields)
%
% INPUTS: 
%	Name      	Size		Units		Description
%   s           {struct}    N/A         Structure
%	lstFields	{'string'}  [char]      n-number of field names to check
%
% OUTPUTS: 
%	Name      	Size		Units		Description
%	tf          [n x 1]     [bool]      Is field name in the structure?
%
% NOTES:
%
% EXAMPLES:
%	% Example 1: Show that sample fields can and cannot be found in a
%   %            structure.
%   % Build the sample structure:
%   clear A;
%   A.a = 'Hi';
%   A.b.line1 = 'line1';
%   A.b.line2 = 'line2';
%   A.c.ref.a = 'a';
%   A.c.ref.b = 'b';
%
%   % Look at all the structure members:
%   [lstStruct] = listStruct( A, 'A')
%   %   returns:
%   %   lstStruct =
%   %       'A.a'
%   %       'A.b.line1'
%   %       'A.b.line2'
%   %       'A.c.ref.a'
%   %       'A.c.ref.b'
%
%   % Show that 'b' exists
%   instruct(A, 'b')
%   %   returns 1
%   isfield(A, 'b')
%   %   returns 1
%
%   % Show that 'b.line1' exists
%   % Note that both methods work
%   instruct(A, 'b.line1')
%   %   returns 1
%   instruct(A.b, 'line1')
%   %   returns 1
%
%   % Note that only this isfield method works:
%   isfield(A.b, 'line1')
%   %   returns 1
%   % but this one does not...
%   isfield(A, 'b.line1')
%   %   returns 0
%
%   % Now check multiple fields at once
%   instruct(A, {'b.line2';'b.line3';'c';'d'})
%   %   returns     
%   %      1
%   %      0
%   %      1
%   %      0
%
% SOURCE DOCUMENTATION:
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit instruct.m">instruct.m</a>
%	  Driver script: <a href="matlab:edit Driver_instruct.m">Driver_instruct.m</a>
%	  Documentation: <a href="matlab:pptOpen('instruct_Function_Documentation.pptx');">instruct_Function_Documentation.pptx</a>
%
% See also isfield, listStruct
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/708
%  
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/MatlabUtilities/instruct.m $
% $Rev: 2305 $
% $Date: 2012-02-13 15:11:25 -0600 (Mon, 13 Feb 2012) $
% $Author: sufanmi $

function [tf] = instruct(s, lstFields)

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
if(ischar(lstFields))
    lstFields = { lstFields };
end
numFields = size(lstFields, 1);
tf = zeros(numFields, 1);

for i = 1:numFields
    curField = lstFields{i};
    
    ptrDot = findstr(curField, '.');
    if(isempty(ptrDot))
        tf(i) = isfield(s, curField);
    else
        
        numDots = length(ptrDot);
        for idot = 1:(numDots+1)
            if(idot == 1)
                curSubStruct = curField(1:ptrDot(idot)-1);
                tmp = isfield(s, curSubStruct);
                curSubStructLast = curSubStruct;
            else
                if(idot <= numDots)
                    curSubStruct = curField(ptrDot(idot-1)+1:ptrDot(idot)-1);
                else
                    curSubStruct = curField(ptrDot(idot-1)+1:end);
                end
                eval_cmd = ['tmp = isfield(s.' curSubStructLast ', ''' curSubStruct ''');'];
                eval(eval_cmd);
                curSubStructLast = [curSubStructLast '.' curSubStruct];
            end
            if(~tmp)
                break;
            end
        end
        
        if(~tmp)
            tf(i) = 0;
        else
            curStruct = curField(1:ptrDot(end)-1);
            curField = curField(ptrDot(end)+1:end);
            eval_cmd = [' tf(i)  = isfield(s.' curStruct ', ''' curField ''');'];
                eval(eval_cmd);
        end
    end
end

end % << End of function instruct >>

%% REVISION HISTORY
% YYMMDD INI: note
% 110524 MWS: Created function using CreateNewFunc
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
