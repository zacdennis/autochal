% LABEL Places a label at a predefined location of a figure
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% label:
%     Places a label at a predefined location of a figure
%
% SYNTAX:
%	[h] = label(strText, strPos)
%	[h] = label(strText)
%
% INPUTS:
%	Name		Size                    Units	Description
%	strText		'string' or {'strings'} N/A		String or cell array of
%                                                strings to add to plot
%	strPos		'string'                N/A		Plot location where label
%                                                is to be added
%                                                Default: 'NorthWest'
% OUTPUTS:
%	Name		Size                    Units   Description
%	h   		[1]                    [double] Label's plot handle
%
% NOTES:
%	strPos can be defined by a string in the following way and is not case sensitive:
%   Label Location             Location in Axes
%   ==============             ================
%   'NorthWest',        'NW'   outside on top of plot; upper left corner (default)
%   'NorthEast',        'NE'   outside on top of plot; upper right corner
%   'WestNorth',        'WN'   outside to left of plot; upper left corner
%   'NorthWestInside',  'NWI'  inside near top of plot; upper left corner
%   'NorthInside',      'NI'   inside near top of plot; centered horizontally
%   'NorthEastInside',  'NEI'  inside near top of plot; upper right corner
%   'EastNorth',        'EN'   outside to right of plot; upper right corner
%   'West',             'W'    outside to left of plot; centered vertically
%   'WestInside',       'WI'   inside left of plot; centered vertically
%   'Center',           'C'    inside of plot; centered vertically/horizontally
%   'EastInside',       'EI'   inside to right of plot; centered vertically
%   'East',             'E'    outside to right of plot; centered vertically
%   'WestSouth',        'WS'   outside to left of plot; lower left corner
%   'SouthWestInside',  'SWI'  inside near bottom of plot; lower left corner
%   'SouthInside',      'SI'   inside near bottom of plot; centered horizontally
%   'SouthEastInside',  'SEI'  inside near bottom of plot; lower right corner
%   'EastSouth',        'ES'   outside to right of plot; lower right corner
%   'SouthWest',        'SW'   outside on bottom of plot; lower left corner
%   'South',            'S'    outside on bottom of plot; centered horizontally
%   'SouthEast',        'SE'   outside on bottom of plot; lower right corner
%
% EXAMPLES:
% 	% Example 1: Show all possible permutations of the label command
%   figure(1); clf(1);  axis([-1 1 -1 1]);
% 	clear h strLabel;
%   lstLabels = {...
%      'NorthWest';    'NorthEast';
%      'WestNorth';    'NorthWestInside';  'NorthInside';  'NorthEastInside';  'EastNorth';
%      'West';         'WestInside';       'Center';       'EastInside';       'East';
%      'WestSouth';    'SouthWestInside';  'SouthInside';  'SouthEastInside';  'EastSouth';
%      'SouthWest';    'South';            'SouthEast' };
% 
%   numLabels = size(lstLabels, 1);
%   for iLabel = 1:numLabels
%      strLabel = lstLabels{iLabel};
%      h(iLabel) = label(strLabel, strLabel);
%   end
%   set(gca, 'XTickLabel', ''); % Blank out the XTickLabel
%   set(gca, 'YTickLabel', ''); % Blank out the YTickLabel
%   title({'\bf\fontsize{12}label Function Verification'; ...
%       '\fontsize{10}Available label Locations'});
%
% 	% Example 2: Generate a blank figure window and add a text label (entered
% 	% as a cell array of strings) to the upper left corner of the figure
%   figure(2); clf(2); axis([-1 1 -1 1]); clear strLabel;
%   strLabel(1,:) = { sprintf('\\fontsize{10}\\bf\\alpha = %.1f^o', 2.5) };
%   strLabel(2,:) = { sprintf('\\fontsize{10}\\bf\\beta = %.1f^o', 0) };
% 	label(strLabel, 'NWI');
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit label.m">label.m</a>
%	  Driver script: <a href="matlab:edit DRIVER_label.m">DRIVER_label.m</a>
%	  Documentation: <a href="matlab:winopen(which('label_Function_Documentation.pptx'));">label_Function_Documentation.pptx</a>
%
% See also text
%
% VERIFICATION DETAILS:
% Verified: Partial.  r393 was Verified Via Peer Review.
%           Updates have not been verified.
% Trac Page: http://trac.ngst.northgrum.com/CSA/ticket/491
%
% Copyright Northrop Grumman Corp 2012
% Maintained by: GN&C Technology (Dept 9V21) - Aerospace Systems - Redondo Beach, CA
% http://trac.ngst.northgrum.com/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/PlottingUtilities/label.m $
% $Rev: 2477 $
% $Date: 2012-09-06 19:34:44 -0500 (Thu, 06 Sep 2012) $
% $Author: sufanmi $

function [h] = label(strText,strPos)
%% Debugging & Display Utilities:
spc  = sprintf(' ');                                % One Single Space
tab  = sprintf('\t');                               % One Tab
endl = sprintf('\n');                               % Line Return
[mfpath,mfnam] = fileparts(mfilename('fullpath'));  % Full Path to Function, Name of Function
mfspc = char(ones(1,length(mfnam))*spc);            % String of Spaces the length of the function name
% Example of Display formats:
% disp([mfnam '>> Output with filename included...' ]);
% disp([mfspc '>> further outputs will be justified the same']);
% disp([mfspc '>> CAUTION: or mfnam: note lack of space after">>"']);
% disp([mfnam '>> WARNING: <- Very important warning (does not terminate)']);
% disp([mfnam '>> ERROR: <-if followed by "return" used if continued exit desired']);
% errstr = [mfname >> ERROR: <define error here> ]; will term with error; "doc Error" ';
% error([mfnam 'class:file:Identifier'],errstr);

%% Initialize Outputs:
h = [];

%% Main Function:
if nargin == 1
    strPos = 'NorthWest';
end

if(iscell(strText))
    strText = char(strText);
end

if ~ischar(strText)
    error([mfnam ':InputArgCheck'], 'Label''s text must be a string or cell array of strings');
end

xlimits = get(gca,'XLim');
str_xdir = get(gca,'XDir');
if(strcmp(str_xdir, 'reverse'));
    xlimits = fliplr(xlimits);
end

ylimits = get(gca,'YLim');
str_ydir = get(gca,'YDir');
if(strcmp(str_ydir, 'reverse'));
    ylimits = fliplr(ylimits);
end

switch lower(strPos)
    case {'northwest', 'nw'}
        txtPos(1) = xlimits(1);
        txtPos(2) = ylimits(2);
        h = text( txtPos(1), txtPos(2), strText );
        set(h, 'HorizontalAlignment','left','VerticalAlignment','bottom');
        
    case {'northeast', 'ne'}
        txtPos(1) = xlimits(2);
        txtPos(2) = ylimits(2);
        h = text( txtPos(1), txtPos(2), strText );
        set(h, 'HorizontalAlignment','right','VerticalAlignment','bottom');
        
    case {'westnorth', 'wn'}
        txtPos(1) = xlimits(1);
        txtPos(2) = ylimits(2);
        h = text( txtPos(1), txtPos(2), strText );
        set(h, 'Rotation', 90,'HorizontalAlignment','right', ...
            'VerticalAlignment','bottom');
        
    case {'northwestinside', 'nwi'}
        txtPos(1) = xlimits(1) + 0.02 * (xlimits(2) - xlimits(1));
        txtPos(2) = ylimits(2) - 0.02 * (ylimits(2) - ylimits(1));
        h = text( txtPos(1), txtPos(2), strText );
        set(h, 'HorizontalAlignment','left','VerticalAlignment', ...
            'top', 'EdgeColor', 'black', 'LineWidth', 1.5, ...
            'BackgroundColor', 'white');
        
    case {'northinside', 'ni'}
        txtPos(1) = (xlimits(1) + xlimits(2))/2;    % X Position
        txtPos(2) = ylimits(2) - 0.02 * (ylimits(2) - ylimits(1));
        h = text( txtPos(1), txtPos(2), strText );
        set(h, 'HorizontalAlignment','center','VerticalAlignment', ...
            'top', 'EdgeColor', 'black', 'LineWidth', 1.5, ...
            'BackgroundColor', 'white');
        
    case {'northeastinside', 'nei'}
        txtPos(1) = xlimits(2) - 0.02 * (xlimits(2) - xlimits(1));
        txtPos(2) = ylimits(2) - 0.02 * (ylimits(2) - ylimits(1));
        h = text( txtPos(1), txtPos(2), strText );
        set(h, 'HorizontalAlignment','right','VerticalAlignment', ...
            'top', 'EdgeColor', 'black', 'LineWidth', 1.5, ...
            'BackgroundColor', 'white');
        
    case {'eastnorth', 'en'}
        txtPos(1) = xlimits(2);
        txtPos(2) = ylimits(2);
        h = text( txtPos(1), txtPos(2), strText );
        set(h, 'Rotation', 90,'HorizontalAlignment','right', ...
            'VerticalAlignment','top');
        
    case {'west', 'w'}
        txtPos(1) = xlimits(1);
        txtPos(2) = (ylimits(1) + ylimits(2))/2;    % Y Position
        h = text( txtPos(1), txtPos(2), strText );
        set(h, 'Rotation', 90,'HorizontalAlignment','center', ...
            'VerticalAlignment','bottom');
        
    case {'westinside', 'wi'}
        txtPos(1) = xlimits(1) + 0.02 * (xlimits(2) - xlimits(1));
        txtPos(2) = (ylimits(1) + ylimits(2))/2;    % Y Position
        h = text( txtPos(1), txtPos(2), strText );
        set(h, 'HorizontalAlignment','left','VerticalAlignment', ...
            'Middle', 'EdgeColor', 'black', 'LineWidth', 1.5, ...
            'BackgroundColor', 'white');
        
    case {'center', 'c'}
        txtPos(1) = (xlimits(1) + xlimits(2))/2;    % X Position
        txtPos(2) = (ylimits(1) + ylimits(2))/2;    % Y Position
        h = text( txtPos(1), txtPos(2), strText );
        set(h,'HorizontalAlignment','center', 'VerticalAlignment', ...
            'Middle', 'EdgeColor', 'black', 'LineWidth', 1.5, ...
            'BackgroundColor', 'white');
        
    case {'eastinside', 'ei'}
        txtPos(1) = xlimits(2) - 0.02 * (xlimits(2) - xlimits(1));
        txtPos(2) = (ylimits(1) + ylimits(2))/2;    % Y Position
        h = text( txtPos(1), txtPos(2), strText );
        set(h, 'HorizontalAlignment','right','VerticalAlignment', ...
            'Middle', 'EdgeColor', 'black', 'LineWidth', 1.5, ...
            'BackgroundColor', 'white');
        
    case {'east', 'e'}
        txtPos(1) = xlimits(2);
        txtPos(2) = (ylimits(1) + ylimits(2))/2;    % Y Position
        h = text( txtPos(1), txtPos(2), strText );
        set(h, 'Rotation', 90,'HorizontalAlignment','center', ...
            'VerticalAlignment','top');
        
    case {'westsouth', 'ws'}
        txtPos(1) = xlimits(1);
        txtPos(2) = ylimits(1);
        h = text( txtPos(1), txtPos(2), strText );
        set(h, 'Rotation', 90,'HorizontalAlignment','left', ...
            'VerticalAlignment','bottom');
        
    case {'southwestinside', 'swi'}
        txtPos(1) = xlimits(1) + 0.02 * (xlimits(2) - xlimits(1));
        txtPos(2) = ylimits(1) + 0.02 * (ylimits(2) - ylimits(1));
        h = text( txtPos(1), txtPos(2), strText );
        set(h, 'HorizontalAlignment','left','VerticalAlignment', ...
            'bottom', 'EdgeColor', 'black', 'LineWidth', 1.5, ...
            'BackgroundColor', 'white');
        
    case {'southinside', 'si'}
        txtPos(1) = (xlimits(1) + xlimits(2))/2;    % X Position
        txtPos(2) = ylimits(1) + 0.02 * (ylimits(2) - ylimits(1));
        h = text( txtPos(1), txtPos(2), strText );
        set(h, 'HorizontalAlignment','center','VerticalAlignment', ...
            'bottom', 'EdgeColor', 'black', 'LineWidth', 1.5, ...
            'BackgroundColor', 'white');
        
    case {'southeastinside', 'sei'}
        txtPos(1) = xlimits(2) - 0.02 * (xlimits(2) - xlimits(1));
        txtPos(2) = ylimits(1) + 0.02 * (ylimits(2) - ylimits(1));
        h = text( txtPos(1), txtPos(2), strText );
        set(h, 'HorizontalAlignment','right','VerticalAlignment', ...
            'bottom', 'EdgeColor', 'black', 'LineWidth', 1.5, ...
            'BackgroundColor', 'white');
        
    case {'eastsouth', 'es'}
        txtPos(1) = xlimits(2);
        txtPos(2) = ylimits(1);
        h = text( txtPos(1), txtPos(2), strText );
        set(h, 'Rotation', 90,'HorizontalAlignment','left', ...
            'VerticalAlignment','top');
        
    case {'southwest', 'sw'}
        txtPos(1) = xlimits(1);
        txtPos(2) = ylimits(1);
        h = text( txtPos(1), txtPos(2), strText );
        set(h, 'HorizontalAlignment','left','VerticalAlignment','top');
        
    case {'south', 's'}
        txtPos(1) = (xlimits(1) + xlimits(2))/2;    % X Position
        txtPos(2) = ylimits(1);
        h = text( txtPos(1), txtPos(2), strText );
        set(h, 'HorizontalAlignment','center','VerticalAlignment', ...
            'top');
        
    case {'southeast', 'se'}
        txtPos(1) = xlimits(2);
        txtPos(2) = ylimits(1);
        h = text( txtPos(1), txtPos(2), strText );
        set(h, 'HorizontalAlignment','right','VerticalAlignment','top');
        
    otherwise
        disp([mfnam '>> WARNING: ''' char(strPos) ''' is not a recognized label location!']);
end
if(~isempty(h))
    set(h, 'FontWeight', 'bold');
end
end
%% REVISION HISTORY
% YYMMDD INI: note
% 100824 JJ:  Filled the description and units of the I/O added input check
% 100819 JJ:  Function template created using CreateNewFunc
% 051103 MWS: Originally created function for VSI_LIB
%             https://vodka.ccc.northgrum.com/svn/VSI_LIB/trunk/CORE/PLOTTING_UTILITIES/label.m
%**Add New Revision notes to TOP of list**

%% Initials Identification:
% INI: FullName         : Email                             : NGGN Username
%  JJ: Jovany Jimenez   : Jovany.Jimenez-Deparias@ngc.com   : g67086
% MWS: Mike Sufana      : mike.sufana@ngc.com               : sufanmi

%% FOOTER
% Distribution
% WARNING - This document contains technical data whose export is
%   restricted by the Arms Export Control Act (Title 22, U.S.C. 2751 et
%   seq.) or the Export Administration Act of 1979, as amended, Title 50,
%   U.S.C., App.2401et seq. Violation of these export-control laws is
%   subject to severe civil and/or criminal penalties.
%
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------------------- UNCLASSIFIED ---------------------------
