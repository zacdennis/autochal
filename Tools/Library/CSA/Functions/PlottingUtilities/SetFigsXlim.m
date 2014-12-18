% SETFIGSXLIM Sets a range of figures to have the same xlimits
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% SetFigsXlim:
% Sets all axis in a series to teh same width
% Inputs - figstart(opt): lowest figure number to modify 
%		 - figstop(opt): highest figure number to modify 
%        - xstart(req): highest figure number to modify 
%        - xfinal(req): highest figure number to modify 
% Outputs- ErrorFlag: Flag to output if an error
% 
% Alternate function Call forms are:
%       SetFigsXlim(xstart,xfinal)
%               figstart = 1; figstop = Inf;
%       SetFigsXlim(figstart,xstart,xfinal)
%               figstop = figstart -> inf
% see also: plot figure clf 
% example : [errflg] = SetFigsXlim(20,40);
% 
% ************************************************************************
% * #NOTE: To future Cosmo'r, the following warning appeared from
% * CreateNewFunc
% * CreateNewFunc>>WARNING: Selected Input argument name: "xlim" is a
% * function name!
% * -JPG
% ************************************************************************
%
% SYNTAX:
%	[errrorflag] = SetFigsXlim(figstart, figstop, xlim, varargin, 'PropertyName', PropertyValue)
%	[errrorflag] = SetFigsXlim(figstart, figstop, xlim, varargin)
%	[errrorflag] = SetFigsXlim(figstart, figstop, xlim)
%	[errrorflag] = SetFigsXlim(figstart, figstop)
%
% INPUTS: 
%	Name      	Size		Units		Description
%	figstart	  <size>		<units>		<Description>
%	figstop	   <size>		<units>		<Description>
%	xlim	      <size>		<units>		<Description>
%	varargin	[N/A]		[varies]	Optional function inputs that
%	     		        				 should be entered in pairs.
%	     		        				 See the 'VARARGIN' section
%	     		        				 below for more details
%
% OUTPUTS: 
%	Name      	Size		Units		Description
%	errrorflag	<size>		<units>		<Description> 
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
%	[errrorflag] = SetFigsXlim(figstart, figstop, xlim, varargin)
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[errrorflag] = SetFigsXlim(figstart, figstop, xlim)
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
%	Source function: <a href="matlab:edit SetFigsXlim.m">SetFigsXlim.m</a>
%	  Driver script: <a href="matlab:edit Driver_SetFigsXlim.m">Driver_SetFigsXlim.m</a>
%	  Documentation: <a href="matlab:pptOpen('SetFigsXlim_Function_Documentation.pptx');">SetFigsXlim_Function_Documentation.pptx</a>
%
% See also <add relevant functions> 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/57
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/PlottingUtilities/SetFigsXlim.m $
% $Rev: 1724 $
% $Date: 2011-05-11 18:34:55 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [errrorflag] = SetFigsXlim(figstart, figstop, xlim, varargin)

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
% errrorflag= -1;

%% Input Argument Conditioning:
% Pick out Properties Entered via varargin
% [<PropertyValue>, varargin]  = format_varargin('<PropertyValue', <Default>, 2, varargin);

%  switch(nargin)
%       case 0
%        xlim= ''; figstop= ''; figstart= ''; 
%       case 1
%        xlim= ''; figstop= ''; 
%       case 2
%        xlim= ''; 
%       case 3
%        
%       case 4
%        
%  end
%
%  if(isempty(xlim))
%		xlim = -1;
%  end
switch nargin
    case 1
        xlim = figstart;
        figstart = 1;
        figstop = Inf;
    case 2
        xlim = figstop; 
        figstop = Inf;
    case 3
        %no op: nominal
end

xlimsize = size(xlim);
if max(xlimsize)~=2 && min(xlimsize)~=1
    errorstr = [mfnam '>>ERROR: impropler xlim size'];
    error(errorstr);
end
%% Main Function:
%% Get figure handles
%get handles
figs = get(0,'children');
wdafigs = find((figs>=figstart) & (figs<=figstop));
%% set axis
for i=1:length(wdafigs)
    %get axis at current figure
    a = get(figs(wdafigs(i)),'children');
    for j= 1:length(a)
        if isfield(get(a(j)),'Interpreter')
            continue;
        else
            set(a(j),'XLim',xlim);
        end
    end;
end

%% Outputs
errrorflag = 0;

%% Compile Outputs:
%	errrorflag= -1;

end % << End of function SetFigsXlim >>

%% REVISION HISTORY
% YYMMDD INI: note
% 101101 JPG: Copied over information from the old function.
% 101101 CNF: Function template created using CreateNewFunc
% 070926 TKV: Changed Xlim to vector call for Xlimits... instead of two 
%              arguments
% 070805 TKV: added to TKV_Lib and changed name to SetFigsXlim
% 070805 TMW: Modified to correct legend issues...  by The Mathworks... 
% 061114 TKV: created
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
