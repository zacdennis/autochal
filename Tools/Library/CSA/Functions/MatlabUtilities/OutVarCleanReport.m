% OUTVARCLEANREPORT Report on results of an OutVarClean Effort
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% OutVarCleanReport:
%     This funcition reports on teh success of the OutVarClean Routine
%     Flags should be a vector of integers from -2 to 1
% 
% SYNTAX:
%	[] = OutVarCleanReport(Flags, varargin, 'PropertyName', PropertyValue)
%	[] = OutVarCleanReport(Flags, varargin)
%	[] = OutVarCleanReport(Flags)
%
% INPUTS: 
%	Name    	Size		Units		Description
%	Flags	   <size>		<units>		<Description>
%	varargin	[N/A]		[varies]	Optional function inputs that
%	     		        				 should be entered in pairs.
%	     		        				 See the 'VARARGIN' section
%	     		        				 below for more details
%
% OUTPUTS: 
%	Name    	Size		Units		Description
%	    	        <size>		<units>		<Description> 
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
%	[] = OutVarCleanReport(Flags, varargin)
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[] = OutVarCleanReport(Flags)
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
%	Source function: <a href="matlab:edit OutVarCleanReport.m">OutVarCleanReport.m</a>
%	  Driver script: <a href="matlab:edit Driver_OutVarCleanReport.m">Driver_OutVarCleanReport.m</a>
%	  Documentation: <a href="matlab:pptOpen('OutVarCleanReport_Function_Documentation.pptx');">OutVarCleanReport_Function_Documentation.pptx</a>
%
% See also OutVarClean 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/38
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/MatlabUtilities/OutVarCleanReport.m $
% $Rev: 1718 $
% $Date: 2011-05-11 18:07:49 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [] = OutVarCleanReport(Flags, varargin)

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

%% Input Argument Conditioning:
% Pick out Properties Entered via varargin
% [<PropertyValue>, varargin]  = format_varargin('<PropertyValue', <Default>, 2, varargin);

%  switch(nargin)
%       case 0
%        Flags= ''; 
%       case 1
%        
%       case 2
%        
%  end
%
if nargin~=1
    disp([mfilename '>> Problem with Flags Variable ']);
    return;
end
Nm2Flags=0;
Nm1Flags=0;
NzeroFlags=0;
N1Flags=0;
%% Main Function:
for i=1:length(Flags)
    switch Flags(i)
        case -2,
            Nm2Flags=Nm2Flags+1;
        case -1,
            Nm1Flags=Nm1Flags+1;
        case 0,
            NzeroFlags=NzeroFlags+1;
        case 1, 
            N1Flags=N1Flags+1;
    end; %Switch
end%

disp([mfilename '>> Report on Flag variable']);
disp(['         ' num2str(NzeroFlags) '  Cases of Source found and Parent Found (Nominal)'])
disp(['         ' num2str(Nm1Flags) '  Cases of Source found and NEW Parent Created (1st Run?)'])
disp(['         ' num2str(Nm2Flags) '  Cases of No Source Variable but Prexisting Var (Warning)'])
disp(['         ' num2str(N1Flags) '  Cases of NO SOURCE and NO Previous value (ERROR)'])

%                      1: No source found No Previous Value Found
%                      0: No Problems, write Perfomed, Parent object found
%                     -1: Source Found New Parent Created.(Warning) 
%                     -2: No Source Found Previous Value at new Var Exists

%% Compile Outputs:
%	= -1;

end % << End of function OutVarCleanReport >>

%% REVISION HISTORY
% YYMMDD INI: note
% 101102 JPG: Copied over information from the old function.
% 101102 CNF: Function template created using CreateNewFunc
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
