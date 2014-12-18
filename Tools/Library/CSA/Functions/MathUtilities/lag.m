% LAG This subroutine simulates a simple lag
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% lag:
% *   This subroutine simulates a simple lag of the form:
% *--                                                 1
% *--                                     yout = ----------- xin
% *--                                             tau*s + 1
% 
% SYNTAX:
%	[Yout] = lag(Xin, tau, stepsize, p_input, p_output, inTrimMode, varargin, 'PropertyName', PropertyValue)
%	[Yout] = lag(Xin, tau, stepsize, p_input, p_output, inTrimMode, varargin)
%	[Yout] = lag(Xin, tau, stepsize, p_input, p_output, inTrimMode)
%	[Yout] = lag(Xin, tau, stepsize, p_input, p_output)
%
% INPUTS: 
%	Name      	Size	Units           Description
%  	xin			[1x1]	double			Filter input
% 	tau			[1x1]	double			Lag time constant
% 	stepsize	[1x1]	double			Frame time, sec
% 	p_input		[1x1]	double			Previous frame value of the input
% 	p_output	[1x1]	double			Previous frame value of the output
% 	TrimMode	[1x1]	bool			Trim Mode Flag (0=Run; 1=Trim)
%
% OUTPUTS: 
%	Name      	Size		Units		Description
%	Yout	     <size>		<units>		<Description> 
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
%	[Yout] = lag(Xin, tau, stepsize, p_input, p_output, inTrimMode, varargin)
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[Yout] = lag(Xin, tau, stepsize, p_input, p_output, inTrimMode)
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
%	Source function: <a href="matlab:edit lag.m">lag.m</a>
%	  Driver script: <a href="matlab:edit Driver_lag.m">Driver_lag.m</a>
%	  Documentation: <a href="matlab:pptOpen('lag_Function_Documentation.pptx');">lag_Function_Documentation.pptx</a>
%
% See also <add relevant functions> 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/53
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/MathUtilities/lag.m $
% $Rev: 1717 $
% $Date: 2011-05-11 17:32:32 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [Yout] = lag(Xin, tau, stepsize, p_input, p_output, inTrimMode, varargin)

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
Yout= -1;

%% Input Argument Conditioning:
% Pick out Properties Entered via varargin
% [<PropertyValue>, varargin]  = format_varargin('<PropertyValue', <Default>, 2, varargin);

%  switch(nargin)
%       case 0
%        inTrimMode= ''; p_output= ''; p_input= ''; stepsize= ''; tau= ''; Xin= ''; 
%       case 1
%        inTrimMode= ''; p_output= ''; p_input= ''; stepsize= ''; tau= ''; 
%       case 2
%        inTrimMode= ''; p_output= ''; p_input= ''; stepsize= ''; 
%       case 3
%        inTrimMode= ''; p_output= ''; p_input= ''; 
%       case 4
%        inTrimMode= ''; p_output= ''; 
%       case 5
%        inTrimMode= ''; 
%       case 6
%        
%       case 7
%        
%  end
%
%  if(isempty(inTrimMode))
%		inTrimMode = -1;
%  end
%% Main Function:
if(inTrimMode)
    Yout = Xin;
else
    Yout = ((0.5*stepsize/(0.5*stepsize+tau)) * (Xin + p_input) ...
        + ((tau - 0.5*stepsize)/(0.5*stepsize + tau))*p_output);
end

%% Compile Outputs:
%	Yout= -1;

end % << End of function lag >>

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
