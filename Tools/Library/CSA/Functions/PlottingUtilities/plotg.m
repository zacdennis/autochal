% PLOTG Plots data on a Gerber grid
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% plotg:
%     Plot data on a gerber grid.
%
%    Plot data on a gerber grid.
%    PLOTG(X,Y) plots vector Y versus vector X. If X or Y is a matrix,
%    then the vector is plotted versus the rows or columns of the matrix,
%    whichever line up.  If X is a scalar and Y is a vector, length(Y)
%    disconnected points are plotted.
%  
%    PLOTG(X,Y,[xmin, xmax],[ymin, ymax]) plots vector Y versus vector X
%    with axes in the range of x and y.
%  
%    By default, data are plotted with the same default options as the PLOT
%    function. The use of symbols and line types is possible by defining
%    variable 'plotgstyle' as global and defining it as follows:
%      global plotgstyle
%      plotgstyle = 'symbols' or 's' Use symbols to differentiate curves
%      plotgstyle = 'lines'   or 'l' Use lines to differentiate curves
%      plotgstyle = '?' or all else  Symbols w/ black lines will be used
%      plotgstyle = ''               Colored lines (default PLOT options)
%
% SYNTAX:
%	[] = plotg(varargin, 'PropertyName', PropertyValue)
%	[] = plotg(varargin)
%
% INPUTS: 
%	Name    	Size		Units		Description
%	varargin	[N/A]		[varies]	Optional function inputs that
%	     		        				 should be entered in pairs.
%	     		        				 See the 'VARARGIN' section
%	     		        				 below for more details
%
% OUTPUTS: 
%	Name    	Size		Units		Description
%	    	        <size>		<units>		<Description> 
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
%	[] = plotg(varargin)
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[] = plotg(varargin)
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
%	Source function: <a href="matlab:edit plotg.m">plotg.m</a>
%	  Driver script: <a href="matlab:edit Driver_plotg.m">Driver_plotg.m</a>
%	  Documentation: <a href="matlab:pptOpen('plotg_Function_Documentation.pptx');">plotg_Function_Documentation.pptx</a>
%
% See also <add relevant functions> 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/498
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/PlottingUtilities/plotg.m $
% $Rev: 1724 $
% $Date: 2011-05-11 18:34:55 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [] = plotg(varargin)

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


%% Input Argument Conditioning:
% Pick out Properties Entered via varargin
% [<PropertyValue>, varargin]  = format_varargin('<PropertyValue', <Default>, 2, varargin);

%  switch(nargin)
%       case 0
%        
%       case 1
%        
%  end
%
%% Main Function:
global plotgstyle

if length(varargin) > 4, error('Too many inputs!  Max is FOUR.'), end
if length(varargin) < 2, error('Not enough inputs!  Min is TWO.'), end

if ~isempty(plotgstyle)
   [m1,n1] = size(varargin{1});
   [m2,n2] = size(varargin{2});
   % Define line styles
   lnstlz  = {'- ','--',': ','-.'};
   num_lns = length(lnstlz);
   switch lower(plotgstyle(1))
      case {'s'}
      % Use symbols to differentiate curves (blue)
         mrkstlz = {'o','^','d','s','p','h','<','*','v','x','+','>'};
         num_mrks = length(mrkstlz);
         num_stlz = num_mrks*num_lns;
         lnstl_ndx = 0;
         while lnstl_ndx <= n2
            for i = 1:num_lns
               for j = 1:num_mrks
                  lnstl_ndx = lnstl_ndx+1;
                  lnstl{lnstl_ndx} = {[mrkstlz{j} lnstlz{i}]};
               end
            end
         end
      case {'l'}
      % Use linestyles and colors to differentiate curves
         mrkstlz = {'b','g','r','c','m','y','k'};
         num_mrks = length(mrkstlz);
         num_stlz = num_mrks*num_lns;
         lnstl_ndx = 0;
         while lnstl_ndx <= n2
            for i = 1:num_mrks
               for j = 1:num_lns
                  lnstl_ndx = lnstl_ndx+1;
                  lnstl{lnstl_ndx} = {[mrkstlz{i} lnstlz{j}]};
               end
            end
         end
      otherwise
         mrkstlz = {'o','^','d','s','p','h','<','*','v','x','+','>'};
         num_mrks = length(mrkstlz);
         num_stlz = num_mrks*num_lns;
         lnstl_ndx = 0;
         while lnstl_ndx <= n2
            for i = 1:num_lns
               for j = 1:num_mrks
                  lnstl_ndx = lnstl_ndx+1;
                  lnstl{lnstl_ndx} = {['k' mrkstlz{j} lnstlz{i}]};
               end
            end
         end
      end

      % Plot data to size axes and initialize markers for 'legend'
      for i = 1:n2
         if n1 == 1
            plt = plot(varargin{1},varargin{2}(:,i),char(lnstl{i}));
            hold on
         elseif n1 == n2
            plt = plot(varargin{1}(:,i),varargin{2}(:,i),char(lnstl{i}));
            hold on
         else
            error('Number of X and Y data to plot is not right.')
         end
      end
else
   plt = plot(varargin{1:2});
   hold on
end

if length(varargin) > 2
  if ~isempty(varargin{3}), set(gca,'XLim',varargin{3}), end
  if ~isempty(varargin{4}), set(gca,'YLim',varargin{4}), end
end

% get the axis scaling for the current plot:
% [xmin, xmax, ymin, ymax];
v = axis;

% round the scalings to the nearest integers
% v = round(v);
xmin = v(1);
xmax = v(2);
ymin = v(3);
ymax = v(4);

% rescale the plot axis
axis(v);

% tick marks
xtick = get(gca,'XTick');
ytick = get(gca,'YTick');

% gerber grid increments
dx = (xtick(2) - xtick(1))/10;
dy = (ytick(2) - ytick(1))/10;

% Create gerber grid lines
xgrid = xmin:dx:xmax; 
ygrid = ymin:dy:ymax; 

% plot x-gerber-grids
plot([xmin xmax], [1 1]'*ygrid, 'Color', .95*[1 1 1]);

% plot y-gerber-grids
plot([1 1]'*xgrid, [ymin ymax], 'Color', .95*[1 1 1]);

% plot main x-grid lines
nx = length(xtick);
dxtick = abs(xtick(2)-xtick(1));
plot([xtick(1)-dxtick xtick(nx)+dxtick], [1 1]'*ytick, 'Color',.5*[1 1 1]);

% plot main y-grid lines
ny = length(ytick);
dytick = abs(ytick(2)-ytick(1));
plot([1 1]'*xtick, [ytick(1)-dytick ytick(ny)+dytick], 'Color',.5*[1 1 1]);

% plot data on top of the gerber-grid
if isempty(plotgstyle)
   plt = plot(varargin{1:2});
else
   for i = 1:n2
      if n1 == 1
         plt = plot(varargin{1},varargin{2}(:,i),char(lnstl{i}));
      else
         plt = plot(varargin{1}(:,i),varargin{2}(:,i),char(lnstl{i}));
      end
   end
end

hold off

%% Compile Outputs:
%	= -1;

end % << End of function plotg >>

%% REVISION HISTORY
% YYMMDD INI: note
% 101026 JPG: Copied over information from the old function.
% 101026 CNF: Function template created using CreateNewFunc
% 050625 DNS: Removed return value.
% 041209 JNG: Allowed for use of colored markers.
% 041029 JNG: Added line markers
% 040916 JNG: Added custon range and input checking
% 040713 JNG: Created
%**Add New Revision notes to TOP of list**

% Initials Identification: 
% INI: FullName             :  Email                :  NGGN Username
% DNS: ????
% JNG: J Nijel Granda
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
