% VCAL2VTRUE Converts calibrated airspeed to true airspeed at alt
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% vcal2vtrue:
%     convert calibrated airspeed to true airspeed at alt
%     not valid for speeds in excess of Mach 1
% 
% SYNTAX:
%	[v] = vcal2vtrue(alt, vcal, dT, varargin, 'PropertyName', PropertyValue)
%	[v] = vcal2vtrue(alt, vcal, dT, varargin)
%	[v] = vcal2vtrue(alt, vcal, dT)
%	[v] = vcal2vtrue(alt, vcal)
%
% INPUTS: 
%	Name    	Size		Units		Description
%	alt 	     <size>		<units>		<Description>
%	vcal	    <size>		<units>		<Description>
%	dT  	      <size>		<units>		<Description>
%	varargin	[N/A]		[varies]	Optional function inputs that
%	     		        				 should be entered in pairs.
%	     		        				 See the 'VARARGIN' section
%	     		        				 below for more details
%
% OUTPUTS: 
%	Name    	Size		Units		Description
%	v   	       <size>		<units>		<Description> 
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
%	[v] = vcal2vtrue(alt, vcal, dT, varargin)
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[v] = vcal2vtrue(alt, vcal, dT)
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
%	Source function: <a href="matlab:edit vcal2vtrue.m">vcal2vtrue.m</a>
%	  Driver script: <a href="matlab:edit Driver_vcal2vtrue.m">Driver_vcal2vtrue.m</a>
%	  Documentation: <a href="matlab:pptOpen('vcal2vtrue_Function_Documentation.pptx');">vcal2vtrue_Function_Documentation.pptx</a>
%
% See also <add relevant functions> 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/114
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/FlightParameters/vcal2vtrue.m $
% $Rev: 1716 $
% $Date: 2011-05-11 17:12:24 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [v] = vcal2vtrue(alt, vcal, dT, varargin)

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
v= -1;

%% Input Argument Conditioning:
% Pick out Properties Entered via varargin
% [<PropertyValue>, varargin]  = format_varargin('<PropertyValue', <Default>, 2, varargin);

%  switch(nargin)
%       case 0
%        dT= ''; vcal= ''; alt= ''; 
%       case 1
%        dT= ''; vcal= ''; 
%       case 2
%        dT= ''; 
%       case 3
%        
%       case 4
%        
%  end
%
%  if(isempty(dT))
%		dT = -1;
%  end
if nargin == 2
    dT = 0;
end

%% Main Function:
% get std atmos quantities.
[rho, temp, press, asound] = stdAtmos(alt, dT);

% we need access to some atmosphere structural parameters.
atmosphere;

%    vtrue = asound * ((((p0/press)+1)^(1/KGAM1) - 1)/.2)^0.5;
g1 = (((vcal^2)/atmos.KGAM2)+1)^(atmos.KGAM1);
g2 = (g1 - 1);
p0 = g2 * atmos.static_press_SL_std;

f1 = ((p0/press)+1)^(1/atmos.KGAM1);
f2 = (f1 - 1)*5.0;
f3 = f2^0.5;
v = asound * f3;

%% Compile Outputs:
%	v= -1;

end % << End of function vcal2vtrue >>

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
