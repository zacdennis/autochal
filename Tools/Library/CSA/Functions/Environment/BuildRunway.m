% BUILDRUNWAY builds a runway with give groundtypes and surface conditions
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% BuildRunway:
%     <Function Description> 
% 
% SYNTAX:
%	[Runway] = BuildRunway(RunwayIn, GroundType, SurfCond, varargin, 'PropertyName', PropertyValue)
%	[Runway] = BuildRunway(RunwayIn, GroundType, SurfCond, varargin)
%	[Runway] = BuildRunway(RunwayIn, GroundType, SurfCond)
%	[Runway] = BuildRunway(RunwayIn, GroundType)
%
% INPUTS: 
%	Name      	Size		Units		Description
%	RunwayIn	  <size>		<units>		<Description>
%	GroundType	<size>		<units>		<Description>
%	SurfCond	  <size>		<units>		<Description>
%	varargin	[N/A]		[varies]	Optional function inputs that
%	     		        				 should be entered in pairs.
%	     		        				 See the 'VARARGIN' section
%	     		        				 below for more details
%
% OUTPUTS: 
%	Name      	Size		Units		Description
%	Runway	    <size>		<units>		<Description> 
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
%	[Runway] = BuildRunway(RunwayIn, GroundType, SurfCond, varargin)
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[Runway] = BuildRunway(RunwayIn, GroundType, SurfCond)
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
%	Source function: <a href="matlab:edit BuildRunway.m">BuildRunway.m</a>
%	  Driver script: <a href="matlab:edit Driver_BuildRunway.m">Driver_BuildRunway.m</a>
%	  Documentation: <a href="matlab:pptOpen('BuildRunway_Function_Documentation.pptx');">BuildRunway_Function_Documentation.pptx</a>
%
% See also <add relevant functions> 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/649
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/Environment/BuildRunway.m $
% $Rev: 1716 $
% $Date: 2011-05-11 17:12:24 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [Runway] = BuildRunway(RunwayIn, GroundType, SurfCond, varargin)

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
Runway= -1;

%% Input Argument Conditioning:
% Pick out Properties Entered via varargin
% [<PropertyValue>, varargin]  = format_varargin('<PropertyValue', <Default>, 2, varargin);

%  switch(nargin)
%       case 0
%        SurfCond= ''; GroundType= ''; RunwayIn= ''; 
%       case 1
%        SurfCond= ''; GroundType= ''; 
%       case 2
%        SurfCond= ''; 
%       case 3
%        
%       case 4
%        
%  end
%
%  if(isempty(SurfCond))
%		SurfCond = -1;
%  end
%% Main Function:
conversions;

switch GroundType
    case 'CentralBody'
        Runway.Pned = [0; 0; 0];
        Runway.Euler_ned = [0 0 0];
        Runway.V_ned        = [0 0 0];  % [ft/s]    Ground / Runway Velocity
        Runway.PQRb         = [0 0 0];  % [rad/s]   Ground / Runway Body Rates
        
        Pned(:,1) = [-Runway.Length; -Runway.Width; -Runway.Alt];
        Pned(:,2) = [-Runway.Length;  Runway.Width; -Runway.Alt];
        Pned(:,3) = [ Runway.Length;  Runway.Width; -Runway.Alt];
        Pned(:,4) = [ Runway.Length; -Runway.Width; -Runway.Alt];
    
    case 'Flat'

        Pned(:,1) = [0; Runway.Width/2; 0];
        Pned(:,2) = [Runway.Length;  Runway.Width/2; 0];
        Pned(:,3) = [Runway.Length;  -Runway.Width/2; 0];
        Pned(:,4) = [0; -Runway.Width/2; 0];
    

    case 'Sine'
        Pn = [0:(Runway.Length/1000):Runway.Length];
        Pe = [-Runway.Width/2 Runway.Width/2];
        Pd = Runway.Amp*sin(Pn/200);
        Pned(1,:) = [Pn fliplr(Pn)];
        lefthalf = 1:1:length(Pn);
        righthalf = (length(Pn)+1):1:(2*length(Pn));
        Pned(2,lefthalf) = Runway.Width/2;
        Pned(2,righthalf) = -Runway.Width/2;
        Pned(3,:) = [Pd fliplr(Pd)];

    case 'Random'
        arrPn = [0:(Runway.Length/Runway.LengthScaler):Runway.Length];
        arrPe = [-Runway.Width/2:(Runway.Width/Runway.WidthScaler):Runway.Width/2];
        numPn = length(arrPn);
        numPe = length(arrPe);
        
        tblPd = rand(numPn, numPe) * -Runway.MaxHeightChange;
        
        Pned(1,:) = repmat(arrPn, 1, numPe);
        Pned(2,:) = repmat(arrPe, 1, numPn);
        Pned(3,:) = reshape(tblPd', 1, (numPe * numPn));
       
end
runway_C_ground = eul2dcm(Runway.Euler_ned * C.D2R);
P_ned = repmat(Runway.Pned, 1, length(Pned)) + (runway_C_ground * Pned);

Runway.surfPned = P_ned;
Runway.arrPn = unique(P_ned(1,:));
Runway.arrPe = unique(P_ned(2,:));
numPts = size( P_ned,2);
for i = 1:numPts;
    curPn = P_ned(1,i);
    curPe = P_ned(2,i);
    curPd = P_ned(3,i);
    iPn = find(Runway.arrPn == curPn);
    iPe = find(Runway.arrPe == curPe);
    Runway.tablePd(iPn, iPe) = curPd;
    Runway.tableSurfCond(iPn, iPe) = Runway.SurfaceCondition;
end

%% Compile Outputs:
%	Runway= -1;

end % << End of function BuildRunway >>

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
