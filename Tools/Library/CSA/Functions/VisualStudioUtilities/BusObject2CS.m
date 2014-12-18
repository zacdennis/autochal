% BUSOBJECT2CS Auto-generates a C# data file for use with visuals/displays
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% BusObject2CS:
%     Auto-generates a C# data file for use with visuals/displays
% 
% SYNTAX:
%	[filename] = BusObject2CS(structname, namespace, BOInfo, fldrSave, strBOprefix, varargin, 'PropertyName', PropertyValue)
%	[filename] = BusObject2CS(structname, namespace, BOInfo, fldrSave, strBOprefix, varargin)
%	[filename] = BusObject2CS(structname, namespace, BOInfo, fldrSave, strBOprefix)
%	[filename] = BusObject2CS(structname, namespace, BOInfo, fldrSave)
%   BusObject2CS(structname, namespace, BOInfo, fldrSave, strBOprefix)
%   BusObject2CS(structname, namespace, BOInfo, fldrSave)
%   BusObject2CS(structname, namespace, BOInfo)
%   BusObject2CS(structname, namespace)
%   BusObject2CS(structname)
%
% INPUTS: 
%	Name       	Size		Units		Description
%   namespace   [string]    Namespace in C# Project
%   structname  [string]    Name of BusObject without the bus object prefix
%                               Ex: 'SimEventsBus' for 'BOSimEventsBus'
%   BOInfo      {struct}    Structure with reference bus object information
%   fldrSave    [string]    Full pathname of folder in which to save
%                            generated file (assumes 'pwd' if not provided)
%   strBOprefix [string]    Bus object prefix (e.g. 'BO' or 'BO_')
%	varargin	[N/A]		[varies]	Optional function inputs that
%	     		        				 should be entered in pairs.
%	     		        				 See the 'VARARGIN' section
%	     		        				 below for more details
%
% OUTPUTS: 
%	Name            Size		Units		Description
%	(filename).cs	[file]		<units>		<Description> 
%
% NOTES:
%   Function uses 'BO2ResultsList' and 'BuildDataViewerCS'
%
%	VARARGIN PROPERTIES:
%	PropertyName		PropertyValue	Default		Description
%	<PropertyName>		<units>			<Default>	<Description>
%
% EXAMPLES:
%	% <Enter Description of Example #1>
%	[filename] = BusObject2CS(structname, namespace, BOInfo, fldrSave, strBOprefix, varargin)
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
%	Source function: <a href="matlab:edit BusObject2CS.m">BusObject2CS.m</a>
%	  Driver script: <a href="matlab:edit Driver_BusObject2CS.m">Driver_BusObject2CS.m</a>
%	  Documentation: <a href="matlab:pptOpen('BusObject2CS_Function_Documentation.pptx');">BusObject2CS_Function_Documentation.pptx</a>
%
% See also BO2ResultsList, BuildDataViewerCS
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/527
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/VisualStudioUtilities/BusObject2CS.m $
% $Rev: 2290 $
% $Date: 2012-01-27 11:14:39 -0600 (Fri, 27 Jan 2012) $
% $Author: sufanmi $

function [filename] = BusObject2CS(structname, namespace, BOInfo, fldrSave, strBOprefix, varargin)

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
% filename= -1;

%% Input Argument Conditioning:
% Pick out Properties Entered via varargin
% [<PropertyValue>, varargin]  = format_varargin('<PropertyValue', <Default>, 2, varargin);

%  switch(nargin)
%       case 0
%        strBOprefix= ''; fldrSave= ''; BOInfo= ''; namespace= ''; structname= ''; 
%       case 1
%        strBOprefix= ''; fldrSave= ''; BOInfo= ''; namespace= ''; 
%       case 2
%        strBOprefix= ''; fldrSave= ''; BOInfo= ''; 
%       case 3
%        strBOprefix= ''; fldrSave= ''; 
%       case 4
%        strBOprefix= ''; 
%       case 5
%        
%       case 6
%        
%  end
%
%  if(isempty(strBOprefix))
%		strBOprefix = -1;
%  end
%% Main Function:
if((nargin < 5) || isempty(strBOprefix))
    strBOprefix = '';
end

if((nargin < 4) || isempty(fldrSave))
    fldrSave = pwd;
end

if((nargin < 3) || isempty(BOInfo))
    BOInfo = evalin('base', 'BOInfo');
end

if((nargin < 2) || isempty(namespace))
    namespace = 'CSA_CSharp_Library';
end

lst2write = BO2ResultsList([strBOprefix structname], BOInfo);

hd = pwd;
cd(fldrSave)
filename = BuildDataViewerCS(lst2write, structname, namespace);
cd(hd);

%% Compile Outputs:
%	filename= -1;

end % << End of function BusObject2CS >>

%% REVISION HISTORY
% YYMMDD INI: note
% 101026 JPG: Copied over information from the old function.
% 101026 CNF: Function template created using CreateNewFunc
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
