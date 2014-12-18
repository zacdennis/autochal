% REMOVEASESTATES eliminates unwanted states from an ASE model
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% RemoveASEStates:
%     Assumes that the order of states in the state space model is:
%     [RB, dRB/dt, SM, dSM/dt, RBlags, SMlags, Act, dAct/dt, d²Act/dt²]
% 
% SYNTAX:
%	[newSys] = RemoveASEStates(Sys, Method, RB, ST, nrig, nelas, nlag, ACT,
%	nact)
%
% INPUTS: 
%	Name    	Size		Units		Description
%	Sys 	    <size>		<units>		State Space model
%	Method      <size>		<units>		Either 'modred' or 'SysSort'
%	RB  	    <size>		<units>		Indices of rigid body modes to
%                                       eliminate
%	ST  	    <size>		<units>		Indices of structural modes to
%                                       eliminate
%	nrig	    <size>		<units>		Number of rigid body states
%	nelas       <size>		<units>		Number of elastic states
%	nlag	    <size>		<units>		Number of lags per state
%	ACT 	    <size>		<units>		Remove Actuator states? [1/0]
%	nact	    <size>		<units>		Number of actuator states
%
% OUTPUTS: 
%	Name    	Size		Units		Description
%	newSys      <size>		<units>		Reduced System
%
% NOTES:
%	<Any Additional Information>
%
%	VARARGIN PROPERTIES:
%	PropertyName		PropertyValue	Default		Description
%	<PropertyName>		<units>			<Default>	<Description>
%
% EXAMPLES:
%	Example Call:
%		[newSys] = RemoveStates(Sys, 'modred',[], [5:17], 3, 17, 6, 1, 9);
%       [newSys] = RemoveStates(Sys, 'SysSort',[],[10:17], 3, 17, 6,1, 9);
%
%	% <Enter Description of Example #1>
%	[newSys] = RemoveASEStates(Sys, Method, RB, ST, nrig, nelas, nlag, ACT, nact, varargin)
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[newSys] = RemoveASEStates(Sys, Method, RB, ST, nrig, nelas, nlag, ACT, nact)
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
%	Source function: <a href="matlab:edit RemoveASEStates.m">RemoveASEStates.m</a>
%	  Driver script: <a href="matlab:edit Driver_RemoveASEStates.m">Driver_RemoveASEStates.m</a>
%	  Documentation: <a href="matlab:pptOpen('RemoveASEStates_Function_Documentation.pptx');">RemoveASEStates_Function_Documentation.pptx</a>
%
% See also <add relevant functions> 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/47
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/AeroServoElastic/RemoveASEStates.m $
% $Rev: 1715 $
% $Date: 2011-05-11 16:30:05 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [newSys] = RemoveASEStates(Sys, Method, RB, ST, nrig, nelas, nlag, ACT, nact)

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
newSys= -1;

%% Input Argument Conditioning:
% Pick out Properties Entered via varargin
% [<PropertyValue>, varargin]  = format_varargin('<PropertyValue', <Default>, 2, varargin);

%  switch(nargin)
%       case 0
%        nact= ''; ACT= ''; nlag= ''; nelas= ''; nrig= ''; ST= ''; RB= ''; Method= ''; Sys= ''; 
%       case 1
%        nact= ''; ACT= ''; nlag= ''; nelas= ''; nrig= ''; ST= ''; RB= ''; Method= ''; 
%       case 2
%        nact= ''; ACT= ''; nlag= ''; nelas= ''; nrig= ''; ST= ''; RB= ''; 
%       case 3
%        nact= ''; ACT= ''; nlag= ''; nelas= ''; nrig= ''; ST= ''; 
%       case 4
%        nact= ''; ACT= ''; nlag= ''; nelas= ''; nrig= ''; 
%       case 5
%        nact= ''; ACT= ''; nlag= ''; nelas= ''; 
%       case 6
%        nact= ''; ACT= ''; nlag= ''; 
%       case 7
%        nact= ''; ACT= ''; 
%       case 8
%        nact= ''; 
%       case 9
%        
%       case 10
%        
%  end
%
%  if(isempty(nact))
%		nact = -1;
%  end
%% Main Function:
%% Lag states 
nlr     = nlag*nrig;
nle     = nlag*nelas;

%% Remove Rigid Body Modes
if isempty(RB)
    eRB = [];
    eRBlag = [];
else
    eRB = [];
    eRBlag= [];
end
%% Remove Rigid Body Lags
% if isempty(RBLag)
%     eRBlag = [];
% else
%     eRBlag= [];
% end

%% Remove Structural Modes
if isempty(ST)
    eST = [];
    eSTlag = [];
else
eST = [ST + 2*nrig, ST + 2*nrig + nelas];

% Remove Unwanted Structural Mode Lags  
for n = 1:length(ST)
eSTlag((n-1)*nlag+1:((n-1)*nlag+nlag)*[1:nlag]) = 2*(nrig+nelas)+nlr + (ST(n)-1)*nlag +[1:nlag];
end
end
%% Remove Actuator States
if ACT == 1
eACT = 2*(nrig+nelas)+nlr+nle+1:2*(nrig+nelas)+nlr+nle+nact;
else
eACT = [];
end

%% Buildup of final remove vector
E = [eRB eST eRBlag eSTlag eACT]';

if strcmp(Method, 'modred')
%% Call modred to reduce SS model
newSys = modred(Sys,E);
elseif strcmp(Method, 'SysSort')
%% Call SysSort to reduce model
newSys = SysSort(Sys, 'r', E);
else
    disp('warning goes here')
end

%% Compile Outputs:
%	newSys= -1;

end % << End of function RemoveASEStates >>

%% REVISION HISTORY
% YYMMDD INI: note
% 101021 JPG: Copied over information from the old function.
% 101021 CNF: Function template created using CreateNewFunc
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
