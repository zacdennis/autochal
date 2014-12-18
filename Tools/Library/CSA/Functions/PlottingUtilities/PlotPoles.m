% PLOTPOLES plots the poles of a system easily
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% PlotPoles:
%       Function to plot the poles of a system easily
% 
% SYNTAX:
%	[h] = PlotPoles(FigNum, HoldCmd, varargin, 'PropertyName', PropertyValue)
%	[h] = PlotPoles(FigNum, HoldCmd, varargin)
%	[h] = PlotPoles(FigNum, HoldCmd)
%	[h] = PlotPoles(FigNum)
%
%
% Inputs - Fignum : desired figure number
%		 - holdcmd: would you like to maintain your current figure?
% 		 - System/Symbole pairs
% 		   ...,Sys,'bo',sys2,'bx'... 1 or more but always a pair
% Outputs- none
%
% INPUTS: 
%	Name    	Size		Units		Description
%	FigNum	  <size>		<units>		<Description>
%	HoldCmd	 <size>		<units>		<Description>
%	varargin	[N/A]		[varies]	Optional function inputs that
%	     		        				 should be entered in pairs.
%	     		        				 See the 'VARARGIN' section
%	     		        				 below for more details
%
% OUTPUTS: 
%	Name    	Size		Units		Description
%	h   	       <size>		<units>		<Description> 
%
% NOTES:
%	<Any Additional Information>
%
%	VARARGIN PROPERTIES:
%	PropertyName		PropertyValue	Default		Description
%	<PropertyName>		<units>			<Default>	<Description>
%
% EXAMPLES:
%
% PlotPoles(5,0,sys1,'bx',sys2,'bo');
%
%	% <Enter Description of Example #1>
%	[h] = PlotPoles(FigNum, HoldCmd, varargin)
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[h] = PlotPoles(FigNum, HoldCmd)
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
%	Source function: <a href="matlab:edit PlotPoles.m">PlotPoles.m</a>
%	  Driver script: <a href="matlab:edit Driver_PlotPoles.m">Driver_PlotPoles.m</a>
%	  Documentation: <a href="matlab:pptOpen('PlotPoles_Function_Documentation.pptx');">PlotPoles_Function_Documentation.pptx</a>
%
% See also <add relevant functions> 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/48
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/PlottingUtilities/PlotPoles.m $
% $Rev: 1724 $
% $Date: 2011-05-11 18:34:55 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [h] = PlotPoles(FigNum, HoldCmd, varargin)

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
% h= -1;

%% Input Argument Conditioning:
% Pick out Properties Entered via varargin
% [<PropertyValue>, varargin]  = format_varargin('<PropertyValue', <Default>, 2, varargin);

%  switch(nargin)
%       case 0
%        HoldCmd= ''; FigNum= ''; 
%       case 1
%        HoldCmd= ''; 
%       case 2
%        
%       case 3
%        
%  end
%
%  if(isempty(HoldCmd))
%		HoldCmd = -1;
%  end
if nargin <4
	error([mfnam '>> Too few inputs']);
end;
if mod(length(varargin),2)==1
	error([mfnam '>> Number of inputs makes no sense, and neither does this error msg']);
end
NSys = length(varargin)/2; %get umber of system pairs
for i=0:NSys-1
	Sys{i+1} = varargin{2*i+1};
	symbole{i+1} = varargin{2*i+2};
end
%% Main Function:
%% SetupPlots

figure(FigNum);
if HoldCmd == 1
	hold on;
else
	clf;
end

%% Plot Data
for i=1:NSys
	eig1=eig(Sys{i});
	hold on;
	plot(real(eig1),imag(eig1),symbole{i})
end
hold off;

%% Final Format
sgrid;

%% Outputs
%NONE

%% Compile Outputs:
%	h= -1;

end % << End of function PlotPoles >>

%% REVISION HISTORY
% YYMMDD INI: note
% 101026 JPG: Copied over information from the old function.
% 101026 CNF: Function template created using CreateNewFunc
% 061009 TKV: Initial File Construction - Very plain
%**Add New Revision notes to TOP of list**

% Initials Identification: 
% INI: FullName             :  Email                :  NGGN Username 
% JPG: James Patrick Gray   :  james.gray2@ngc.com  :  g61720 
% TKV: Travis Vetter

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
