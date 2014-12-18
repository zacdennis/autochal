% LISTIADSPARAMETERS Generates a list of parmater, short, and long names from a Symvionics IADS dataset
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% ListIADSParameters:
%   Interrogates a Symvionics IADS collection of time history data to build
%   a list of IADS parameter, short, and long names.  Data has option to be
%   output to both .mat and .csv format.  Note that the Symvionics' created
%   'iadsread' function is internally used.  'iadsread' extracts 
% 
% SYNTAX:
%	[lstParameters] = ListIADSParameters(DataDirectory, flgIncludeSL, varargin, 'PropertyName', PropertyValue)
%	[lstParameters] = ListIADSParameters(DataDirectory, flgIncludeSL, varargin)
%	[lstParameters] = ListIADSParameters(DataDirectory, flgIncludeSL)
%	[lstParameters] = ListIADSParameters(DataDirectory)
%
% INPUTS: 
%	Name         	Size		Units		Description
%	DataDirectory	'string'    [char]      Directory contained saved
%                                            Symvionics IADS data
%   flgIncludeSL    [1]         [boolean]   Include the short and long
%                                            names in the parameter list.
%                                            Note that extracting the short
%                                            and long names is a labor (ie
%                                            time) intensive task.
%                                            Optional. If not defined, it
%                                            will be the logical OR between
%                                            the varargin parameters
%                                            'SaveMat' and 'SaveCSV'
%	varargin        [N/A]		[varies]    Optional function inputs that
%                                            should be entered in pairs.
%                                            See the 'VARARGIN' section
%                                            below for more details
%
% OUTPUTS: 
%	Name                Size		Units		Description
%	lstParameters       {nxX}       {[char]}    List of IADS measurands (1)
%    {:,1} Parameter    'string'    [char]      Parameter name
%    {:,2} Short Name   'string'    [char]      Short name
%    {:,3} Long Name    'string'    [char]      Long name
%
% NOTES:
%   1: If 'flgIncludeSL' is true, 'lstParametes' will be a {n x 3}.  If
%       'flgIncludeSL' is false, 'lstParamters' will be a {n x 1} which
%       will only contain the parameter names.
%
%	VARARGIN PROPERTIES:
%	PropertyName	PropertyValue	Default         Description
%   'SaveMat'       boolean         false           Save parameter list to
%                                                    .mat file?  Workspace
%                                                    variable will be
%                                                    called 'lstParameters'
%   'SaveCSV'       boolean         false           Save parameter list to
%                                                    .csv fle?
%   'SaveDirectory' 'string'        DataDirectory   Folder in which to save
%                                                    the .mat and/or .csv
%                                                    file(s)
%   'Filename'      'string'        'IADSParameters' Name to use for .mat
%                                                     and/or .csv file(s)
%
% EXAMPLES:
%	% <Enter Description of Example #1>
%   DataDirectory = 'C:\LEMV\GNC\CSA_LIB\CodeVerification\iadsread\SampleData'
%	[lstParameters] = ListIADSParameters(DataDirectory, 'SaveMat', 1, 'SaveCSV', 1)
%	% <Copy expected outputs from Command Window>
%
% SOURCE DOCUMENTATION:
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit ListIADSParameters.m">ListIADSParameters.m</a>
%	  Driver script: <a href="matlab:edit Driver_ListIADSParameters.m">Driver_ListIADSParameters.m</a>
%	  Documentation: <a href="matlab:winopen(which('ListIADSParameters_Function_Documentation.pptx'));">ListIADSParameters_Function_Documentation.pptx</a>
%
% See also iadsread, format_varargin
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/745
%  
% Copyright Northrop Grumman Corp 2012
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/IADSUtilities/ListIADSParameters.m $
% $Rev: 2316 $
% $Date: 2012-03-08 13:31:48 -0600 (Thu, 08 Mar 2012) $
% $Author: sufanmi $

function [lstParameters] = ListIADSParameters(DataDirectory, varargin)

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

[flgSaveMat, varargin]      = format_varargin('SaveMat', 0, 2, varargin);
[flgSaveCSV, varargin]      = format_varargin('SaveCSV', 0, 2, varargin);
[SaveDirectory, varargin]   = format_varargin('SaveDirectory', DataDirectory, 2, varargin);
[Filename, varargin]        = format_varargin('Filename', 'IADSParameters', 2, varargin);

if( mod(numel(varargin), 2) == 1 )
    flgIncludeSL = varargin{1};
else
    flgIncludeSL = (flgSaveMat || flgSaveCSV);
end

% Retrieves Parameter Names as a Character Array
lstParameters_raw = iadsread( DataDirectory, '', 0, '?' );

% Convert character array into a cell array
[numRows, numCols] = size(lstParameters_raw);
if(flgIncludeSL)
    lstParameters = cell(numRows, 3);
else
    lstParameters = cell(numRows, 1);
end

for i = 1:numRows
    lstParameters(i,1) = { sprintf('%s', lstParameters_raw(i,:)) };
end

if(flgIncludeSL)
    disp('Building IADS reference table with corresponding short/long names.  This will take awhile...');
    for i = 1:numRows
        curParameter = lstParameters{i,1};
        if( (i == 1) || (mod(i, 100) == 0) || (i == numRows) )
            disp(sprintf('[%d/%d]: Processing ''%s'' for short/long name...', ...
                i, numRows, curParameter));
        end
    
        infoParameter = iadsread( DataDirectory, '', 0, ['? ' curParameter] );
        lstParameters(i,2) = { infoParameter.ShortName };
        lstParameters(i,3) = { infoParameter.LongName };
    end
end

if(flgSaveMat || flgSaveCSV)
  if(~isdir(SaveDirectory))
        mkdir(SaveDirectory);
  end
  % Make sure you can write to the folder
  fileattrib(SaveDirectory, '+w');
end
 
if(flgSaveCSV)
    % Add a tab with general IADS information?
    % infoData = iadsread(IADSDirectory);
   
	lstParameters = [{'Parameter Name', 'Short Name', 'Long Name'}; lstParameters];
    filename_full = [SaveDirectory filesep Filename '.csv'];
    xlswrite(filename_full, lstParameters);
end

if(flgSaveMat)
    filename_full = [SaveDirectory filesep Filename '.mat'];
    save(filename_full, 'lstParameters');
end

end % << End of function ListIADSParameters >>

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
