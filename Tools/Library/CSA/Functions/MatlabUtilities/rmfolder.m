% RMFOLDER removes a given folder and all sub-folders from the MATLAB path
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% rmfolder:
%     Removes a given folder and all sub-folders from the MATLAB path
% 
% SYNTAX:
%	[out] = rmfolder(strFolder, flgVerbose)
%	[out] = rmfolder(strFolder)
%
% INPUTS: 
%	Name      	Size		Units		Description
%   strFolder               [string]    Full Pathname to top-level folder
%   flgVerbose              ["bool"]    Confirm folder has been removed?
%
% OUTPUTS: 
%	Name      	Size		Units		Description
%	out 	       <size>		<units>		<Description> 
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
%	[out] = rmfolder(strFolder, flgVerbose, varargin)
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[out] = rmfolder(strFolder, flgVerbose)
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
%	Source function: <a href="matlab:edit rmfolder.m">rmfolder.m</a>
%	  Driver script: <a href="matlab:edit Driver_rmfolder.m">Driver_rmfolder.m</a>
%	  Documentation: <a href="matlab:pptOpen('rmfolder_Function_Documentation.pptx');">rmfolder_Function_Documentation.pptx</a>
%
% See also <add relevant functions> 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/465
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/MatlabUtilities/rmfolder.m $
% $Rev: 1718 $
% $Date: 2011-05-11 18:07:49 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [out] = rmfolder(strFolder, flgVerbose, varargin)

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
%        flgVerbose= ''; strFolder= ''; 
%       case 1
%        flgVerbose= ''; 
%       case 2
%        
%       case 3
%        
%  end
%
%  if(isempty(flgVerbose))
%		flgVerbose = -1;
%  end
%% Main Function:
if(nargin < 2)
    flgVerbose = '';
end

if(isempty(flgVerbose))
    flgVerbose = 1;
end

if(~isdir(strFolder))
    if(flgVerbose)
        disp(sprintf('%s : Warning: ''%s'' doesn''t exist.  Ignoring call.', ...
            mfilename, strFolder));
    end

else
    lstSubfolders = str2cell(genpath(strFolder), ';');
    
    strWarning = 'MATLAB:rmpath:DirNotFound';
    warning('off', strWarning);
    
    for iFolder = 1:size(lstSubfolders, 1)
        curFolder = lstSubfolders{iFolder, :};
        rmpath(curFolder);
    end
    clear lstSubfolders iFolder curFolder;
    
    if(flgVerbose)
        disp(sprintf('%s : Removed ''%s'' and it''s subfolders from path...', ...
            mfilename, strFolder));
    end
    
    warning('on', strWarning);
end

%% Compile Outputs:
%	out= -1;

end % << End of function rmfolder >>

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
