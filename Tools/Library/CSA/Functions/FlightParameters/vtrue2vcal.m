% VTRUE2VCAL Converts true airspeed at alt to calibrated airspeed at alt
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% vtrue2vcal:
%     <Function Description> 
% 
% SYNTAX:
%	[v,M] = vtrue2vcal(alt,vtrue)
%	[v,M] = vtrue2vcal(alt)
%
% INPUTS: 
%	Name		Size		Units		Description
%	alt 		<size>		<units>		<Description>
%	vtrue		<size>		<units>		<Description>
%										 Default: <Enter Default Value>
%
% OUTPUTS: 
%	Name		Size		Units		Description
%	v   		<size>		<units>		<Description> 
%	M   		<size>		<units>		<Description> 
%
% NOTES:
%	<Any Additional Information>
%
% EXAMPLES:
%	% <Enter Description of Example #1>
%	[v,M] = vtrue2vcal(alt,vtrue)
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[v,M] = vtrue2vcal(alt)
%	% <Copy expected outputs from Command Window>
%
% SOURCE DOCUMENTATION:
%	[1]    http://www...
%	[2]    Author. Book Title. Publisher, City, Copyright year
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit vtrue2vcal.m">vtrue2vcal.m</a>
%	  Driver script: <a href="matlab:edit DRIVER_vtrue2vcal.m">DRIVER_vtrue2vcal.m</a>
%	  Documentation: <a href="matlab:pptOpen('vtrue2vcal Documentation.pptx');">vtrue2vcal Documentation.pptx</a>
%
% See also <add relevant functions> 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/113
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21) - Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/FlightParameters/vtrue2vcal.m $
% $Rev: 1716 $
% $Date: 2011-05-11 17:12:24 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [v,M] = vtrue2vcal(alt,vtrue)

%% Debugging & Display Utilities:
spc  = sprintf(' ');                                % One Single Space
tab  = sprintf('\t');                               % One Tab
endl = sprintf('\n');                               % Line Return
[mfpath,mfnam] = fileparts(mfilename('fullpath'));  % Full Path to Function, Name of Function
mfspc = char(ones(1,length(mfnam))*spc);            % String of Spaces the length of the function name
% Example of Display formats:
% disp([mfnam '>> Output with filename included...' ]);
% disp([mfspc '>> further outputs will be justified the same']);
% disp([mfspc '>> CAUTION: or mfnam: note lack of space after">>"']);
% disp([mfnam '>> WARNING: <- Very important warning (does not terminate)']);
% disp([mfnam '>> ERROR: <-if followed by "return" used if continued exit desired']);
% errstr = [mfname >> ERROR: <define error here> ]; will term with error; "doc Error" ';
% error([mfnam 'class:file:Identifier'],errstr);

%% Main Function:
% get std atmos quantities.
[Atmos.rho, temp, Atmos.PPo,Atmos.sound] = Coesa1976(alt);

% we need access to some atmosphere structural parameters.
atmosphere;

M = vtrue/asound;
qc = ((0.2*M.^2 + 1).^atmos.KGAM1 - 1)*press;
v2 = ((qc/atmos.static_press_SL_std + 1).^(1/atmos.KGAM1) - 1)*atmos.KGAM2;
v = sqrt(max(v2, 0));

end 
%% REVISION HISTORY
% YYMMDD INI: note
% <YYMMDD> <initials>: <Revision update note>
% 100831 CNF: Function template created using CreateNewFunc
%**Add New Revision notes to TOP of list**

% Initials Identification: 
% INI: FullName  :  Email  :  NGGN Username 
% <initials>: <Fullname> : <email> : <NGGN username> 

%% FOOTER
% Distribution
% WARNING - This document contains technical data whose export is
%   restricted by the Arms Export Control Act (Title 22, U.S.C. 2751 et 
%   seq.) or the Export Administration Act of 1979, as amended, Title 50,
%   U.S.C., App.2401et seq. Violation of these export-control laws is 
%   subject to severe civil and/or criminal penalties.
%
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------------------- UNCLASSIFIED ---------------------------
