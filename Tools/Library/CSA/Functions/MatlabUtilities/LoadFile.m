% LOADFILE Reads an ascii style file into the workspace
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% LoadFile:
%     Opens and  
% 
% SYNTAX:
%	[fileinfo] = LoadFile(filename, flgLoadInEditor, varargin, 'PropertyName', PropertyValue)
%	[fileinfo] = LoadFile(filename, flgLoadInEditor, varargin)
%	[fileinfo] = LoadFile(filename, flgLoadInEditor)
%	[fileinfo] = LoadFile(filename)
%
% INPUTS: 
%	Name           	Size		Units		Description
%	filename	       <size>		<units>		<Description>
%	flgLoadInEditor	<size>		<units>		<Description>
%	varargin	[N/A]		[varies]	Optional function inputs that
%	     		        				 should be entered in pairs.
%	     		        				 See the 'VARARGIN' section
%	     		        				 below for more details
%
% OUTPUTS: 
%	Name           	Size		Units		Description
%	str 	            <size>		<units>		<Description> 
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
%	[str] = LoadFile(filename, flgLoadInEditor, varargin)
%	% <Copy expected outputs from Command Window>
%
% SOURCE DOCUMENTATION:
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit LoadFile.m">LoadFile.m</a>
%	  Driver script: <a href="matlab:edit Driver_LoadFile.m">Driver_LoadFile.m</a>
%	  Documentation: <a href="matlab:pptOpen('LoadFile_Function_Documentation.pptx');">LoadFile_Function_Documentation.pptx</a>
%
% See also <add relevant functions> 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/590
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: $
% $Rev: $
% $Date: $
% $Author: $

function [fileinfo] = LoadFile(filename, flgLoadInEditor, varargin)

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
str= '';

%% Input Argument Conditioning:
if( (nargin == 1) || isempty(flgLoadInEditor) )
    flgLoadInEditor = 0;
end

switch(nargin)
      case 1
       flgLoadInEditor= ''; 
 end
%
%  if(isempty(flgLoadInEditor))
%		flgLoadInEditor = -1;
%  end
%% Main Function:
if(~isempty(filename))
    
    % Open the file and loop through them:
    fid = fopen(filename);
    
    % Read in the entire file, note that this could get huge but was done this
    % way so that you could do multi-line searches
    while 1
        tlineo = fgetl(fid);
        if ~ischar(tlineo)
            break
        end
        str = [str tlineo endl]; %#okAGROW
    end
    fclose(fid);
end

if(flgLoadInEditor)
    edit(filename);
end

fileinfo.Text = str;

end % << End of function LoadFile >>

%% REVISION HISTORY
% YYMMDD INI: note
% <YYMMDD> <initials>: <Revision update note>
% 110211 <INI>: Created function using CreateNewFunc
%**Add New Revision notes to TOP of list**

% Initials Identification: 
% INI: FullName            : Email     : NGGN Username 
% <initials>: <Fullname>   : <email>   : <NGGN username> 

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
