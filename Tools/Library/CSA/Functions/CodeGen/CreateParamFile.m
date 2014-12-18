% CREATEPARAMFILE Splits the default parameter struct out from ert_main.cpp
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% CreateParamFile:
%     Splits the default parameter structure out from ert_main.cpp
%
% SYNTAX:
%	[] = CreateParamFile(modname, ertmain)
%
% INPUTS:
%	Name    	Size		Units		Description
%	modname     'strin'     [char]      Root name of block or component
%                                       that was just coded
%	ertmain     'string'    [char]      Filename (partial or full) of
%                                       ert_main.cpp just created by
%                                       Real-Time workshop
%
% OUTPUTS:
%	Name    	Size		Units		Description
%   None
%
% NOTES:
%	<Any Additional Information>
%
% EXAMPLES:
%	% <Enter Description of Example #1>
%	[] = CreateParamFile(modname, ertmain)
%	% <Copy expected outputs from Command Window>
%
% SOURCE DOCUMENTATION:
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit CreateParamFile.m">CreateParamFile.m</a>
%	  Driver script: <a href="matlab:edit Driver_CreateParamFile.m">Driver_CreateParamFile.m</a>
%	  Documentation: <a href="matlab:pptOpen('CreateParamFile_Function_Documentation.pptx');">CreateParamFile_Function_Documentation.pptx</a>
%
% See also <add relevant functions>
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/111
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/CodeGen/CreateParamFile.m $
% $Rev: 2511 $
% $Date: 2012-10-04 20:29:12 -0500 (Thu, 04 Oct 2012) $
% $Author: sufanmi $

function [] = CreateParamFile(modname, ertmain)

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

%% Main Function:
[pathstr, name, ext] = fileparts(ertmain);

fd_ert = fopen(ertmain);

struct_decl = ['Parameters_' modname];
end_decl = 'Modifiable parameters';

line = 0;
printflag = 0;
param_exists = 0;

if(fd_ert == -1)
    disp(sprintf('ERROR: ''%s'' was not found.', ertmain));
else
    
    while ~feof(fd_ert)
        line = fgetl(fd_ert);
        
        if printflag
            fprintf(fd_data, '%s\n', line);
            i = strfind(line, end_decl);
            if ~isempty(i)
                printflag = 0;
                break;
            end
        else
            % see if the line contains the parameters structure declaration
            i = strfind(line, struct_decl);
            if ~isempty(i)
                printflag = 1;
                param_exists = 1;
                fd_data = fopen([pathstr filesep modname '_data.cpp'], 'w');
                fprintf(fd_data, '#include "%s.h"\n', modname);
                fprintf(fd_data, '#include "%s_private.h"\n\n', modname);
                fprintf(fd_data, 'Parameters_%s %s_P_dflt = ', modname, modname);
                % If the structure declaration includes the opening brace,
                % print it here; otherwise do not, because it'll be copied from the next
                % line
                j = strfind(line, '{');
                if ~isempty(j)
                    fprintf(fd_data, '{\n');
                else
                    fprintf(fd_data, '\n');
                end
                
            end
        end
    end
    
    fclose(fd_ert);
    if param_exists
        fclose(fd_data);
        fprintf(1, 'Created file %s_data.cpp in %s\n', modname, pathstr);
    else
        fprintf(1, 'Did not find a Parameter structure definition for\n');
    end
end

end % << End of function CreateParamFile >>

%% REVISION HISTORY
% YYMMDD INI: note
% 110119 MWS: Added Deena's check to see if the structure declaration
%               includes the opening brace
% 101026 JPG: Copied over information from the old function.
% 101026 CNF: Function template created using CreateNewFunc
%**Add New Revision notes to TOP of list**

% Initials Identification:
% INI: FullName             : Email                 : NGGN Username
% MWS: Mike Sufana          : mike.sufana@ngc.com   : sufanmi
% DT:  Deena Tin            : deena.tin@ngc.com     : tinde
% JPG: James Patrick Gray   : james.gray2@ngc.com   : g61720

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
