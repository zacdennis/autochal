% MAT2BIN Writes a 2-D Matrix to a binary file
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% mat2bin:
%     Writes a 2-D matrix to a binary file.  Table data will be written
%     with 'double' precision.
% 
% SYNTAX:
%	[f1] = mat2bin(filename, tbl, strFormat)
%	[f1] = mat2bin(filename, tbl)
%
% INPUTS: 
%	Name    	Size		Units		Description
%	filename	'string'    [char]      Name of binary file to save to
%	tbl 	    [M x N]     [varies]    2-D Table data to save to binary
%   strFormat   'string'    [char]      Precision with which to save data
%                                        Default: 'double'
%
% OUTPUTS: 
%	Name    	Size		Units		Description
%	f1          [1]         [flag]      -1: File did not build
%                                        0: File built correctly (no errors)
%
% NOTES:
%
% EXAMPLES:
% % Example 1:
% % Create some data and save it to binary:
% tbl = [...
%     1   2   3   4;
%     5   6   7   8;
%     9   10  11  12];
% 
% % Save the data to binary:
% strFilename = 'test.bin';
% mat2bin(strFilename, tbl);
% 
% % Read the data from binary:
% [tbl2] = bin2mat(strFilename, 4)
% 
% % Double check that the data is correct
% deltaTbl = tbl2 - tbl
% 
% flgGood = ~max(max(deltaTbl > 0))
%
% SOURCE DOCUMENTATION:
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit mat2bin.m">mat2bin.m</a>
%	  Driver script: <a href="matlab:edit Driver_mat2bin.m">Driver_mat2bin.m</a>
%	  Documentation: <a href="matlab:pptOpen('mat2bin_Function_Documentation.pptx');">mat2bin_Function_Documentation.pptx</a>
%
% See also bin2mat, fwrite
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/673
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: $
% $Rev: $
% $Date: $
% $Author: $

function [f1] = mat2bin(filename, tbl, strFormat)

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
% Pick out Properties Entered via varargin
% [<PropertyValue>, varargin]  = format_varargin('PropertyValue', <Default>, 2, varargin);
if(nargin < 3)
    strFormat = 'double';
end

%% Main Function:

[numRow, numCol] = size(tbl);

% Build filename
filename = [filename '.bin'];
filename = strrep(filename, '.bin.bin', '.bin');

[fid, message] = fopen(filename, 'wb');

if(fid == -1)
    info.error = [mfnam '>> ERROR: File Not created: ' message];
    disp(info.error)
    fl = -1;
else
    fl = 0;
    
    for iRow = 1:numRow
        for iCol = 1:numCol
            fwrite(fid, tbl(iRow, iCol), strFormat);
        end
    end
    
    fclose(fid);
end

end % << End of function mat2bin >>

%% REVISION HISTORY
% YYMMDD INI: note
% 110224 MWS: Created function using CreateNewFunc
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
