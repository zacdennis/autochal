% BANDWIDTH3DB Finds the -3dB bandwdth of a given 'sys'.
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% bandwidth3db:
%   Compute the -3dB bandwidth of a given 'sys' and frequency range 'omega'
%   (w) in radians/sec. Assumes the first magnitude point of the frequencies
%   from the Bode of the system is steady state (or close enough that it is
%   representative of the closed loop bandwidth). In other words, the
%   frequency response must start with Mag approx = 0.
% 
% SYNTAX:
%	[BW] = bandwidth3db(sys, w)
%
% INPUTS: 
%	Name    	Size		Units		Description
%	sys 	    [N\A]		[ND]		A given system 'sys' (i.e. TF, ZPK,
%                                       SS, or FRD)
%	w   	    [1x2]		[rad/sec]   Frequency range [wmin max]
%
% OUTPUTS: 
%	Name    	Size		Units		Description
%	BW  	    [1x1]       [Hz]  		-3dB bandwidth of a given system
%
% NOTES:
%	<Any Additional Information>
%
% EXAMPLES:
%	% <Enter Description of Example #1>
%	[BW] = bandwidth3db(sys, w, varargin)
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[BW] = bandwidth3db(sys, w)
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
%	Source function: <a href="matlab:edit bandwidth3db.m">bandwidth3db.m</a>
%	  Driver script: <a href="matlab:edit Driver_bandwidth3db.m">Driver_bandwidth3db.m</a>
%	  Documentation: <a href="matlab:pptOpen('bandwidth3db_Function_Documentation.pptx');">bandwidth3db_Function_Documentation.pptx</a>
%
% See also <add relevant functions> 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/308
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/FrequencyID/bandwidth3db.m $
% $Rev: 1715 $
% $Date: 2011-05-11 16:30:05 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [BW] = bandwidth3db(sys, w, varargin)

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
BW= -1;

%% Input Argument Conditioning:
% Pick out Properties Entered via varargin
% [<PropertyValue>, varargin]  = format_varargin('<PropertyValue', <Default>, 2, varargin);

%  switch(nargin)
%       case 0
%        w= ''; sys= ''; 
%       case 1
%        w= ''; 
%       case 2
%        
%       case 3
%        
%  end
%
%  if(isempty(w))
%		w = -1;
%  end
%% Main Function:
[Mag, Phase] = bode(sys, w);
MagdB = 20*log10(squeeze(Mag));

BW = interp1(MagdB, w, (MagdB(1)-3))

%% Compile Outputs:
%	BW= -1;

end % << End of function bandwidth3db >>

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
