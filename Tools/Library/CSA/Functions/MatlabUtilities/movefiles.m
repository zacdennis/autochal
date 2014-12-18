% MOVEFILES Moves a list of files to a destination folder
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% movefiles:
%     Moves a list of files to a destination folder
% 
% SYNTAX:
%	[out] = movefiles(lstFiles, destination, sourcefolder, minbytes, flgVerbose)
%	[out] = movefiles(lstFiles, destination, sourcefolder, minbytes)
%	[out] = movefiles(lstFiles, destination, sourcefolder)
%	[out] = movefiles(lstFiles, destination)
%
% INPUTS: 
%	Name        	Size	Units	Description
%   lstFiles        { list }        List of files to move
%   destination     [string]        Full path to destination folder
%   sourcefolder    [string]        Full path to source folder
%                                   Optional: Default is current directory
%   minbytes        [int]           Minimum filesize of file
%                                   (Prevents blank files to be copied)
%                                   Optional: Default is 0
%   flgVerbose      ["bool"]        Show move status?
%                                   Optional: Default is 1 (true)
%
% OUTPUTS: 
%	Name        	Size		Units		Description
%	out 	         <size>		<units>		<Description> 
%
% NOTES:
%	<Any Additional Information>
%
%	VARARGIN PROPERTIES:
%	PropertyName		PropertyValue	Default		Description
%	<PropertyName>		<units>			<Default>	<Description>
%
% EXAMPLES:
%	% <Enter Description of Example #1>
%	[out] = movefiles(lstFiles, destination, sourcefolder, minbytes, flgVerbose, varargin)
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[out] = movefiles(lstFiles, destination, sourcefolder, minbytes, flgVerbose)
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
%	Source function: <a href="matlab:edit movefiles.m">movefiles.m</a>
%	  Driver script: <a href="matlab:edit Driver_movefiles.m">Driver_movefiles.m</a>
%	  Documentation: <a href="matlab:pptOpen('movefiles_Function_Documentation.pptx');">movefiles_Function_Documentation.pptx</a>
%
% See also <add relevant functions> 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/461
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/MatlabUtilities/movefiles.m $
% $Rev: 2262 $
% $Date: 2011-11-14 15:26:41 -0600 (Mon, 14 Nov 2011) $
% $Author: sufanmi $

function [out] = movefiles(lstFiles, destination, sourcefolder, minbytes, flgVerbose, varargin)

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
% out= -1;

%% Input Argument Conditioning:
% Pick out Properties Entered via varargin
% [<PropertyValue>, varargin]  = format_varargin('<PropertyValue', <Default>, 2, varargin);

%  switch(nargin)
%       case 0
%        flgVerbose= ''; minbytes= ''; sourcefolder= ''; destination= ''; lstFiles= ''; 
%       case 1
%        flgVerbose= ''; minbytes= ''; sourcefolder= ''; destination= ''; 
%       case 2
%        flgVerbose= ''; minbytes= ''; sourcefolder= ''; 
%       case 3
%        flgVerbose= ''; minbytes= ''; 
%       case 4
%        flgVerbose= ''; 
%       case 5
%        
%       case 6
%        
%  end
%
%  if(isempty(flgVerbose))
%		flgVerbose = -1;
%  end
%% Main Function:
if(nargin < 5)
    flgVerbose = 1;
end

if(nargin < 4)
    minbytes = 0;
end
minbytes = round(minbytes);
minbytes = max(minbytes, 0);

if(nargin < 3)
    sourcefolder = pwd;
end

if(~isdir(destination))
    if(flgVerbose)
        disp(sprintf('%s : Folder ''%s'' does not exist.  Creating...', ...
            mfilename, destination));
    end
    mkdir(destination);
end

numfiles = size(lstFiles,1);
for ifiles = 1:numfiles
    file2move = lstFiles{ifiles,:};
    
    if(~isempty(sourcefolder))
        origin = [sourcefolder filesep file2move];
    else
        origin = file2move;
    end
    
    if(~isempty(ls(origin)))
        fileinfo = dir(origin);
        if(fileinfo.bytes > minbytes)
            try
                movefile(origin, destination,'f');
            catch
                if(flgVerbose)
                    disp(sprintf('%s : Could NOT move ''%s'' to ''%s''.  File is currently in use by another process.', mfilename, ...
                        file2move, destination));
                end
            end
            
            if(flgVerbose)
                disp(sprintf('%s : Moved ''%s'' to ''%s''', mfilename, ...
                    file2move, destination));
            end
            
        end
    end
end

%% Compile Outputs:
%	out= -1;

end % << End of function movefiles >>

%% REVISION HISTORY
% YYMMDD INI: note
% 101025 JPG: Copied over information from the old function.
% 101025 CNF: Function template created using CreateNewFunc
%**Add New Revision notes to TOP of list**

% Initials Identification: 
% INI: FullName             :  Email                :  NGGN Username 
% JPG: James Patrick Gray   :  james.gray2@ngc.com  :  g61720 

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
