% SGRIDFCN draws an s-plane grid 
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% sgridfcn:
%     <Function Description> 
% 
% SYNTAX:
%	[h] = sgridfcn(wnlargest, wnint, xoffset, yoffset, rscale)
%	[h] = sgridfcn(wnlargest, wnint, xoffset)
%	[h] = sgridfcn(wnlargest, wnint)
%	[h] = sgridfcn(wnlargest)
%
% INPUTS: 
%	Name     	Size		Units		Description
%	wnlargest	<size>		<units>		<Description>
%	wnint	    <size>		<units>		<Description>
%	xoffset	  <size>		<units>		<Description>
%	yoffset	  <size>		<units>		<Description>
%	rscale	   <size>		<units>		<Description>
%	varargin	[N/A]		[varies]	Optional function inputs that
%	     		        				 should be entered in pairs.
%	     		        				 See the 'VARARGIN' section
%	     		        				 below for more details
%
% OUTPUTS: 
%	Name     	Size		Units		Description
%	h   	        <size>		<units>		<Description> 
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
%  USAGE: (copy and paste line) figure; sgridfcn(6); 
%          Draws sgrid up to wn = 6 rad/sec
%
%  USAGE: (copy and paste line) figure; sgridfcn(6,2); 
%          Draws sgrid up to wn = 6 rad/sec, with circular grid every 2 rad/sec
%
%  USAGE: (copy and paste line) figure; sgridfcn(20, 4, 1.6, 0.6);
%          The xoffset and yoffset values adjust the placement of wn labeling
%
%  USAGE: (copy and paste line) figure; sgridfcn(20, 4, 1.6, 0.6, 1.02);
%          The xoffset and yoffset values adjust the placement of wn labeling
%          The rscale value adjusts the placement of zeta labeling
%
%	% <Enter Description of Example #1>
%	[h] = sgridfcn(wnlargest, wnint, xoffset, yoffset, rscale, varargin)
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[h] = sgridfcn(wnlargest, wnint, xoffset, yoffset, rscale)
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
%	Source function: <a href="matlab:edit sgridfcn.m">sgridfcn.m</a>
%	  Driver script: <a href="matlab:edit Driver_sgridfcn.m">Driver_sgridfcn.m</a>
%	  Documentation: <a href="matlab:pptOpen('sgridfcn_Function_Documentation.pptx');">sgridfcn_Function_Documentation.pptx</a>
%
% See also <add relevant functions> 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/25
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/PlottingUtilities/sgridfcn.m $
% $Rev: 1724 $
% $Date: 2011-05-11 18:34:55 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [h] = sgridfcn(wnlargest, wnint, xoffset, yoffset, rscale, varargin)

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
%        rscale= ''; yoffset= ''; xoffset= ''; wnint= ''; wnlargest= ''; 
%       case 1
%        rscale= ''; yoffset= ''; xoffset= ''; wnint= ''; 
%       case 2
%        rscale= ''; yoffset= ''; xoffset= ''; 
%       case 3
%        rscale= ''; yoffset= ''; 
%       case 4
%        rscale= ''; 
%       case 5
%        
%       case 6
%        
%  end
%
%  if(isempty(rscale))
%		rscale = -1;
%  end
%% Main Function:
%% Preliminary stuff
if nargin < 1
    disp('Please set largest_wn desired.  Example: figure; sgridfcn(6); ');
    disp('Note the locations of wn and zeta labels can be adjusted. See: help sgridfcn');
    return;
end

% Set default wnint, xoffset, yoffset, rscale is user did not
if ~exist('wnint','var')
   wnint = round(wnlargest/5);
end
if isempty(wnint)
   wnint = round(wnlargest/5);    
end

if ~exist('xoffset','var')
   xoffset = 0.2;
end
if isempty(xoffset)
   xoffset = 0.2;    
end

if ~exist('yoffset','var')
   yoffset = 0.2;
end
if isempty(yoffset)
   yoffset = 0.2;   
end

if ~exist('rscale','var')
   rscale = 1;
end
if isempty(rscale)
   rscale = 1;
end

% scale up the grid so we can scale down to get rid of blank area later
wnlast = round(wnlargest*(1/0.7));
if mod(wnlast,wnint)
    wnlast = wnlast + (wnint-mod(wnlast,wnint));
end

% Set the color of the grid lines
gridcolor = [0.75 0.75 0.75];   % [blue, red, green]

%% Draw sgrid
% plot wn circles
hold on;
for j=[0:wnint:wnlast]  % plot every wnint change in wn
    k=1;
    for i=[-pi:0.01:pi]
        x(k)=j*cos(i);
        y(k)=j*sin(i);
        k=k+1;
    end;
    plot(x,y,'-','LineWidth',1,'Color',gridcolor);
    
end;

% plot zeta lines
clear x y;
for j=[-1:0.1:1]  % plot every 0.1 change in zeta
    clear x y;
    k=1;
    for i=[-wnlast -1:0.25:1 wnlast]  % the center number dictates size of blank origin
        x(k)=i*abs(j);
        y(k)=i*sqrt(1-j^2)*sign(j);
        k=k+1;
    end;
    % leave origin blank (so poles don't get obstructed)
    half = round(k/2);
    plot(x(1:half-1),y(1:half-1),'-',x(1+half:end),y(1+half:end),'-','LineWidth',1,'Color',gridcolor);
    
end;

plot([0 0],[wnlast -wnlast],'-','LineWidth',1,'Color',gridcolor);

%% Labeling wn and zeta
% label the wn circles
for i = [-wnlast:wnint:wnlast]
    if (i ~= 0)
      text(i-xoffset, yoffset, num2str(abs(i)), 'color', gridcolor);
    end
end

% label the zeta lines
dist = round(wnlast*0.7); % set the nominal radial distance of text
scalefactor = [5.75/7   6.15/7   1.005   7.85/7   8.7/7   7.8/7]*rscale;  % radial distance of text
k = 1;
for i = [0.2 0.4 0.6:0.1:0.9]
    x = -dist*i           * scalefactor(k)-(0.15*wnint);  % final term shift text to the left slightly
    y =  dist*sqrt(1-i^2) * scalefactor(k);
    text(x,y, num2str(i), 'color', gridcolor);
    k = k+1;
end

axis(0.6*[-wnlast wnlast -wnlast wnlast]);  axis equal;

%% Compile Outputs:
%	h= -1;

end % << End of function sgridfcn >>

%% REVISION HISTORY
% YYMMDD INI: note
% 101026 JPG: Copied over information from the old function.
% 101026 CNF: Function template created using CreateNewFunc
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
