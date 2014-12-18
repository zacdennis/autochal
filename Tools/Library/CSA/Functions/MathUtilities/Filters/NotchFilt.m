% NOTCHFILT Create a notch filter transfer function
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% NotchFilt:
%     Function to make a notch or spike filter 
% 
% SYNTAX:
%	[tf1, Zpos, Ppos] = NotchFilt(wn, magdb, dec, WnShift)
%	[tf1, Zpos, Ppos] = NotchFilt(wn, magdb, dec)
%
% INPUTS: 
%	Name    	Size		Units		Description
%	wn  	    <size>		<units>		Natural Frequency of the filter
%	magdb       <size>		[db]		Magnitude of notch depth(neg=spike)
%	dec 	    <size>		<units>		width of notch in decades
%	WnShift     <size>		<units>		Shift between the num/den +shifts
%                                       den-> higher.
%                                       Defaults: WnShift = 0
%
% OUTPUTS: 
%	Name    	Size		Units		Description
%	tf1 	    [TF object] <units>		The created notch filter
%	Zpos	    <size>		<units>		The zeros of the notch filter
%	Ppos	    <size>		<units>		The poles of the notch filter
%
% NOTES:
%	<Any Additional Information>
%
% EXAMPLES:
%   Example: [tf1,Zpos,Ppos] = NotchFilt(10,20,0.4);
%	% <Enter Description of Example #1>
%	[tf1, Zpos, Ppos] = NotchFilt(wn, magdb, dec, WnShift, varargin)
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[tf1, Zpos, Ppos] = NotchFilt(wn, magdb, dec, WnShift)
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
%	Source function: <a href="matlab:edit NotchFilt.m">NotchFilt.m</a>
%	  Driver script: <a href="matlab:edit Driver_NotchFilt.m">Driver_NotchFilt.m</a>
%	  Documentation: <a href="matlab:pptOpen('NotchFilt_Function_Documentation.pptx');">NotchFilt_Function_Documentation.pptx</a>
%
% See also tf ss 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/49
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/MathUtilities/Filters/NotchFilt.m $
% $Rev: 1715 $
% $Date: 2011-05-11 16:30:05 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [tf1, Zpos, Ppos] = NotchFilt(wn, magdb, dec, WnShift)

%% Debugging & Display Utilities:
spc  = sprintf(' ');                                % One Single Space
tab  = sprintf('\t');                               % One Tab
endl = sprintf('\n');                               % Line Return
[mfpath,mfnam] = fileparts(mfilename('fullpath'));  % Full Path to Function, Name of Function
mfspc = char(ones(1,length(mfnam))*spc);            % String of Spaces the length of the function name
mlink = ['<a href = "matlab:help ' mfnam '">' mfnam '</a>']; % Hyperlink to mask help that can be added to a error disp

%% General Header
s=tf('s');
% Examples of Different Display Formats:
% disp([mfnam '>> Output with filename included...' ]);
% disp([mfspc '>> further outputs will be justified the same']);
% disp([mfspc '>> CAUTION: or mfnam: note lack of space after">>"']);
% disp([mfnam '>> WARNING: <- Very important warning (does not terminate)']);
% disp([mfnam '>> ERROR: <-if followed by "return" used if continued exit desired']);
% errstr = [mfnam '>> ERROR: <define error here> See ' mlink ' help'];      % <-- Couple with error function
% error([mfnam 'class:file:Identifier'], errstr);    % Call error function with error string

%% Initialize Outputs:
tf1= -1;
Zpos= -1;
Ppos= -1;

%% Input Argument Conditioning:
% Pick out Properties Entered via varargin
% [<PropertyValue>, varargin]  = format_varargin('<PropertyValue', <Default>, 2, varargin);

%  switch(nargin)
%       case 0
%        WnShift= ''; dec= ''; magdb= ''; wn= ''; 
%       case 1
%        WnShift= ''; dec= ''; magdb= ''; 
%       case 2
%        WnShift= ''; dec= ''; 
%       case 3
%        WnShift= ''; 
%       case 4
%        
%       case 5
%        
%  end
%
%  if(isempty(WnShift))
%		WnShift = -1;
%  end

if nargin ==3
    WnShift = 0;
end   
%% Main Function:
%% Make Notch filter
magK = 10^(-magdb/20);

etap = 1*dec;
etaz = magK*dec;
K = (wn+WnShift)^2/(wn-WnShift)^2; %Gain need for shfted Wn to make ss value = 1
tf1=K*(s^2+2*etaz*(wn-WnShift)*s + (wn-WnShift)^2)/(s^2+2*etap*(wn+WnShift)*s+(wn+WnShift)^2);

%% Get num and denominator zero/pole locations
Zpos = roots(tf1.num{1});
Ppos = roots(tf1.den{1});

%% Compile Outputs:
%	tf1= -1;
%	Zpos= -1;
%	Ppos= -1;

return;
%end % << End of function NotchFilt >>

%% REVISION HISTORY
% YYMMDD INI: note
% 101021 JPG: Copied over information from the old function.
% 101021 CNF: Function template created using CreateNewFunc
% 061101 TKV: Added Ability to offset the the frequencies -> maintaines 
%             ssgain
% 061014 TKV: Updated Help Text
% 061011 TKV: Added comments and changed 2nd and 3rd Arg output to zero 
%             and pole locations
% 061010 TKV: File Created to build notch filter
%**Add New Revision notes to TOP of list**

% Initials Identification: 
% INI: FullName             :  Email                :  NGGN Username 
% JPG: James Patrick Gray   :  james.gray2@ngc.com  :  g61720
% TKV: Travis Vetter        :  travis.vetter@ngc.com:  vettetr

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
