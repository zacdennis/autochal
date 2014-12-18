% COMPUTETRIMENVELOPE Compute Trim Envelope from Trim Successful Table
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% ComputeTrimEnvelope:
%     <Function Description> 
% 
% SYNTAX:
%	[TrimX, TrimY] = ComputeTrimEnvelope(arrX, arrY, tblXYTrim, varargin, 'PropertyName', PropertyValue)
%	[TrimX, TrimY] = ComputeTrimEnvelope(arrX, arrY, tblXYTrim, varargin)
%	[TrimX, TrimY] = ComputeTrimEnvelope(arrX, arrY, tblXYTrim)
%
% INPUTS: 
%	Name    	Size		Units		Description
%	arrX 	    [m]         [N/A]       Trim Success Table's X breakpoints
%	arrY 	    [n]         [N/A]       Trim Success Table's Y breakpoints
%	tblXYTrim   [m x n]     [bool]      Trim Success Table
%                                         1/true:  Trim was successful
%                                         0/false: Trim was NOT successful
%	varargin    [N/A]       [varies]    Optional function inputs that
%                                        should be entered in pairs.
%                                        See the 'VARARGIN' section
%                                        below for more details
%
% OUTPUTS: 
%	Name    	Size		Units		Description
%	TrimX	    [p]         [N/A]      X breakpoints defining trim bounds
%	TrimY	    [p]         [N/A]      Y breakpoints defining trim bounds
%
% NOTES:
%   'TrimX' will carry the same units as 'arrX'.  'TrimY' will carry the
%   same units as 'arrY'.
%
%	VARARGIN PROPERTIES:
%	PropertyName        PropertyValue	Default		Description
%   'Plot'              [bool]          false       Plot Trim Envelope?
%   'PlotHandle'        [double]        []          Plot Handle if adding
%                                                    to existing figure
%   'Name'              'string'        ''          Figure Name
%   'Position'          [1x4]           []          Figure Position
%   'MarkerGood'        plot Marker     'x'         Plot marker for good
%                                                    trimmed points
%   'MarkerBad'         plot Marker     'o'         Plot marker for bad
%                                                    trim points
%   'MarkerSize'        [double]        10          Marker size
%   'MarkerColor'       plot color      'b'         Marker color
%   'MarkerLineWidth'   [double]        1.5         Marker line width
%   'EnvelopeColor'     plot color      'k'         Envelope color
%   'EnvelopeLineStyle' string          '-'         Envelope line style
%   'EnvelopeLineWidth' [double]        1.5         Envelope line width
%   'XDataLabel'        string          'X'         Description of 'arrX'
%   'YDataLabel'        string          'Y'         Description of 'arrY'
%   'FlipXY'            bool            true        Flip Axes
%                                                    0/false: Y as fcn of X
%                                                    1/true:  X as fcn of Y
%   'Title'             {'string'}      {}          Figure Title
%
%   NOTE: If a figure handle is given (ie overplotting an existing figure),
%   the following fields are ignored: 'Name', 'Position', 'XDataLabel', 
%   'YDataLabel', 'Title'.
%
% EXAMPLES:
%	% Determine Trim Envelope for Sample Data
%   arrAlt      = [0 : 1000 : 10000];   % [ft]
%   arrMach     = [0 : 0.05 : 1];       % [ND]
%   tblTrimmed  = [...
%       0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0;      % Alt = 0 ft
%       0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0;  
%       0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0;
%       0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0;
%       0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0;
%       0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0;      % Alt = 5000 ft
%       0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0;
%       0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0;
%       0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0;
%       0 0 0 1 1 1 1 1 1 1 0 0 0 0 0 1 1 1 1 1 0;
%       0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];     % Alt = 10000 ft
%
%	[TrimBoundsAlt, TrimBoundsMach] = ComputeTrimEnvelope(arrAlt, arrMach, tblTrimmed, ...
%       'Plot', 1, 'Name', 'Trim Envelope Example', ...
%       'XDataLabel', 'Altitude [ft]', 'YDataLabel', 'Mach [ND]', ...
%       'FlipXY', 1, 'Title', 'Trim Envelope Example');
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit ComputeTrimEnvelope.m">ComputeTrimEnvelope.m</a>
%	  Driver script: <a href="matlab:edit Driver_ComputeTrimEnvelope.m">Driver_ComputeTrimEnvelope.m</a>
%	  Documentation: <a href="matlab:winopen(which('ComputeTrimEnvelope_Function_Documentation.pptx'));">ComputeTrimEnvelope_Function_Documentation.pptx</a>
%
% See also TrimMap_Tutorial 
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://trac.ngst.northgrum.com/CSA/ticket/809
%  
% Copyright Northrop Grumman Corp 2013
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://trac.ngst.northgrum.com/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/TrimUtilities/ComputeTrimEnvelope.m $
% $Rev: 2981 $
% $Date: 2013-08-01 14:16:42 -0500 (Thu, 01 Aug 2013) $
% $Author: sufanmi $
function [TrimX, TrimY, PlotHandle] = ComputeTrimEnvelope(arrX, arrY, tblXYTrim, varargin)
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

%% Input Argument Conditioning:
% Pick out Properties Entered via varargin
[PlotEnvelope, varargin]        = format_varargin('Plot', 0, 2, varargin);
[PlotHandle, varargin]          = format_varargin('PlotHandle', [], 2, varargin);
[FigName, varargin]            	= format_varargin('Name', '', 2, varargin);
[FigPosition, varargin]         = format_varargin('Position', [], 2, varargin);
[MarkerGood, varargin]          = format_varargin('MarkerGood', 'x', 2, varargin);
[MarkerBad, varargin]           = format_varargin('MarkerBad', 'o', 2, varargin);
[MarkerSize, varargin]          = format_varargin('MarkerSize', 10, 2, varargin);
[MarkerColor, varargin]         = format_varargin('MarkerColor', 'b', 2, varargin);
[MarkerLineWidth, varargin]     = format_varargin('MarkerLineWidth', 1.5, 2, varargin);
[EnvelopeColor, varargin]       = format_varargin('EnvelopeColor', 'k', 2, varargin);
[EnvelopeLineStyle, varargin]   = format_varargin('EnvelopeLineStyle', '-', 2, varargin);
[EnvelopeLineWidth, varargin]   = format_varargin('EnvelopeLineWidth', 1.5, 2, varargin);
[XString, varargin]             = format_varargin('XDataLabel', 'X', 2, varargin);
[YString, varargin]             = format_varargin('YDataLabel', 'Y', 2, varargin);
[FlipXY, varargin]              = format_varargin('FlipXY', true, 2, varargin);
[cellTitle, varargin]           = format_varargin('Title', {}, 2, varargin);

%% Main Function:
%  Search Order: Lower X, Upper Y, Upper X, Lower Y
numX = length(arrX);
numY = length(arrY);

%%  Lower X Bounds
Left.X = [];
Left.Y = [];
j = 0;
for iY = 1:numY
    curY = arrY(iY);
    for iX = 1:numX
        curX = arrX(iX);
        curTrim = tblXYTrim(iX, iY);
        if(curTrim)
            j = j + 1;
            Left.X(j) = curX;
            Left.Y(j) = curY;
            break;
        end
    end
end

%%  Upper Y Bounds
Top.X = [];
Top.Y = [];
j = 0;
iXstart = find(arrX == Left.X(end));
iYstart = find(arrY == Left.Y(end));
for iX = iXstart:numX
    curX = arrX(iX);
    
    for iY = iYstart:-1:1
        curY = arrY(iY);
        
        curTrim = tblXYTrim(iX, iY);
        if(curTrim)
            j = j + 1;
            Top.X(j) = curX;
            Top.Y(j) = curY;
            break;
        end
    end
end

%%  Upper X Bounds
Right.X = [];
Right.Y = [];
j = 0;
iXstart = find(arrX == Top.X(end));
iYstart = find(arrY == Top.Y(end));
for iY = iYstart:-1:1
    curY = arrY(iY);
    for iX = iXstart:-1:1
        curX = arrX(iX);
        curTrim = tblXYTrim(iX, iY);
        if(curTrim)
            j = j + 1;
            Right.X(j) = curX;
            Right.Y(j) = curY;
            break;
        end
    end
end

%%  Lower Y Bounds
Bottom.X = [];
Bottom.Y = [];
j = 0;
iXstart = find(arrX == Right.X(end));
iYstart = find(arrY == Right.Y(end));
iXend = find(arrX == Left.X(1));
iYend = numY;

for iX = iXstart:-1:iXend
    curX = arrX(iX);
    
    for iY = iYstart:1:iYend
        curY = arrY(iY);
        
        curTrim = tblXYTrim(iX, iY);
        if(curTrim)
            j = j + 1;
            Bottom.X(j) = curX;
            Bottom.Y(j) = curY;
            break;
        end
    end
end
TrimX = [Left.X Top.X Right.X Bottom.X];
TrimY = [Left.Y Top.Y Right.Y Bottom.Y];

%%
if(PlotEnvelope)
    flgExisting = ~isempty(PlotHandle);
    if(flgExisting)
        figure(PlotHandle)
    else
        PlotHandle = figure();
        if(~isempty(FigName))
            set(PlotHandle, 'Name', FigName);
        end
        if(~isempty(FigPosition))
            set(PlotHandle, 'Position', FigPosition);
        end
    end
    %   figure()
    hold on;
    for iY = 1:length(arrY)
        curY = arrY(iY);
        for iX = 1:length(arrX)
            curX = arrX(iX);
            curTrim = tblXYTrim(iX, iY);
            if(curTrim)
                curMarker = MarkerGood;
            else
                curMarker = MarkerBad;
            end
            
            if(FlipXY)
                plot(curY, curX, curMarker, 'Color', MarkerColor, ...
                    'LineWidth', MarkerLineWidth, 'MarkerSize', MarkerSize);
            else
                
                plot(curX, curY, curMarker, 'Color', MarkerColor, ...
                    'LineWidth', MarkerLineWidth, 'MarkerSize', MarkerSize);
            end
        end
    end
    
    cellLabel = {...
        sprintf('%s: Trim Successful', MarkerGood);
        sprintf('%s: Trim NOT Successful', MarkerBad)};
    
    if(FlipXY)
        plot(TrimY, TrimX, 'LineStyle', EnvelopeLineStyle, ...
            'Color', EnvelopeColor, 'LineWidth', EnvelopeLineWidth);
    else
        plot(TrimX, TrimY, 'LineStyle', EnvelopeLineStyle, ...
            'Color', EnvelopeColor, 'LineWidth', EnvelopeLineWidth);
    end
    
    label(cellLabel, 'NorthWestInside');
    if(~flgExisting)
        grid on; set(gca, 'FontWeight', 'bold');
        if(FlipXY)
            xlabel(YString, 'FontWeight', 'bold');
            ylabel(XString, 'FontWeight', 'bold');
        else
            xlabel(XString, 'FontWeight', 'bold');
            ylabel(YString, 'FontWeight', 'bold');
        end
        title(cellTitle);
    end
end

end % << End of function ComputeTrimEnvelope >>

%% REVISION HISTORY
% YYMMDD INI: note
% 130731 MWS: Created function using CreateNewFunc

% Initials Identification: 
% INI: FullName     : Email                 : NGGN Username 
% MWS: Mike Sufana  : mike.sufana@ngc.com   : sufanmi

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
