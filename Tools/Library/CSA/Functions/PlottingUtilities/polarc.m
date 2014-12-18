% POLARC Polar coordinate plot with LineSpec and plot options
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% polarc:
%  Polar coordinate plot with LineSpec and plot options
%
% SYNTAX:
%   hpol = polarc(theta_deg, rho, varargin, 'PropertyName', PropertyValue)
%   hpol = polarc(theta_deg, rho, varargin)
%   hpol = polarc(theta_deg, rho)
%
% INPUTS:
%	Name    	Size		Units		Description
%   theta_deg       [n]         [deg]   Polar Angle where 0 is up
%   rho         [n]         [varies]    Polar distance/radius
%	varargin	[N/A]		[varies]	Optional function inputs that
%	     		        				 should be entered in pairs.
%	     		        				 See the 'VARARGIN' section
%	     		        				 below for more details
%
% OUTPUTS:
%	Name    	Size		Units		Description
%   hpol        [1]         [int]       Plot handle
%
% NOTES:
%	VARARGIN PROPERTIES:
%	PropertyName		PropertyValue	Default		Description
%   'WedgeAngle'        [double]        30          Angle between radial
%                                                    gridlines, [deg]
%   'RotateCW'          boolean         true        Assume clockwise (CW)
%                                                    rotation for plotting.
%                                                    If false, assumes
%                                                    counter clockwise
%   'Rotation'          [double]        90          Rotation angle from
%                                                   horizontal to 0 theta
%   'RangeUnits'        'string'        ''          Units to use for range
%   'Use360'            boolean         true        Use 0-360 deg for
%                                                    radials?
%                                                    True:     0 to 360 deg
%                                                    False: -180 to 180 deg

%   'RangeIncrements'   [double]        []          Distance between range
%                                                    rings
%   'MaxRange'          [double]        []          Maximum range.  If
%                                                    empty, will be
%                                                    determined from
%                                                    inputted 'rho'.  See
%                                                    Note #1 below.
%   'RangeRadial'       [double]        82          Radial along with to
%                                                    show range ring units,
%                                                    [deg]
%   'UseTag'            boolean         false       Place text at polar
%                                                    location instead of 
%                                                    plot marker
%   'Tag'               {n x 2 'string'} {}         Text tag structure
%       Tag{:,1}        'string'                    Text tag to use in
%                                                    place of plot marker
%       Tag{:,2}        'string'        'black'     Text tag color
%   'FontWeight'        'string'        'bold'      Font Weight to use
%
% Note #1: 'MaxRange' can be either a scalar or vector.  If 'scalar', the
% range ticks will be a function of 'RangeIncrements' and 'MaxRange' (ie.
% RangeTicks = [RangeIncrements : RangeIncrements : MaxRange]).  If
% 'MaxRange' is a vector, the range ticks are the vector values (ie.
% RangeTicks = MaxRage).
%
% EXAMPLES:
%   % Create data to be used for all examples:
%   theta_deg = 0:5:360;
%   theta_rad = theta_deg * pi/180;
%   rho = theta_deg*0;
%   i = find(theta_deg <=90);
%   rho(i) = cosd(theta_deg(i));
%   i = find(theta_deg > 90 & theta_deg <=180);
%   rho(i) = .5;
%   i = find(theta_deg > 180 & theta_deg <=270);
%   rho(i) = .75;
%   i = find(theta_deg > 270);
%   rho(i) = -sind(theta_deg(i));
%
%   % Example 1: Show differences between MATLAB polar.m and CSA polarc.m calls
%   figure()
%   subplot(121);
%   h = polar(theta_rad, rho, '--rs')
%   set(h, 'LineWidth', 2, 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'g');
%   title({'\bfUsing ''polar.m'''; '0 is Right, Rotation is CCW'; 'Angles are 0-360 deg'});
%   subplot(122);
%   polarc(theta_deg, rho, '--rs', ...
%         'Rotation', -90, 'RotateCW', false, ...
%       'LineWidth', 2, 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'g');
%   title({'\bfUsing ''polarc.m'''; '0 is Right, Rotation is CCW'; 'Angles are 0-360 deg'});
% 
%   % Example 2: Show use of 'Use360'
%   figure();
%   subplot(121);
%   polarc(theta_deg, rho, '--bo', 'LineWidth', .5);
%   title({'\bfShowcasing ''Use360'' = true'; '0 is Up, Rotation is CW'; 'Angles are 0-360 deg'});
%   subplot(122);
%   polarc(theta_deg, rho, '--bo', 'Use360', false, 'LineWidth', .5);
%   title({'\bfShowcasing ''Use360'' = false'; '0 is Up, Rotation is CW'; 'Angles are -180 to 180 deg'});  
%   
%   % Example 3: Show use of 'RotateCW'
%   figure();
%   subplot(121);
%   polarc(theta_deg, rho, '--bo', 'LineWidth', .5);
%   title({'\bfShowcasing ''RotateCW'' = true'; '0 is Up, Rotation is CW'});
%   subplot(122);
%   polarc(theta_deg, rho, '--bo', 'RotateCW', false, 'LineWidth', .5);
%   title({'\bfShowcasing ''RotateCW'' = false'; '0 is Up, Rotation is CCW'}); 
% 
%   % Example 4: Show use of 'Rotation'
%   figure();
%   subplot(121);
%   polarc(theta_deg, rho, '--bo', 'LineWidth', .5);
%   title({'\bfShowcasing ''Rotation'' = 0'; '0 is Up, Rotation is CW'});
%   subplot(122);
%   polarc(theta_deg, rho, '--bo', 'Rotation', 30, 'LineWidth', .5);
%   title({'\bfShowcasing ''Rotation'' = 30'; '0 is Down, Rotation is CW'});
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit polarc.m">polarc.m</a>
%	  Driver script: <a href="matlab:edit Driver_polarc.m">Driver_polarc.m</a>
%	  Documentation: <a href="matlab:winopen(which('polarc_Function_Documentation.pptx'));">polarc_Function_Documentation.pptx</a>
%
% See also polar, format_varargin
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://trac.ngst.northgrum.com/CSA/ticket/808
%
% Copyright Northrop Grumman Corp 2013
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://trac.ngst.northgrum.com/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/PlottingUtilities/polarc.m $
% $Rev: 3204 $
% $Date: 2014-06-16 14:16:10 -0500 (Mon, 16 Jun 2014) $
% $Author: sufanmi $

function hpol = polarc(varargin)
%------------- BEGIN CODE --------------

% Parse possible Axes input
[WedgeAngle_deg, varargin]      = format_varargin('WedgeAngle', 30, 2, varargin);
[RotateCW, varargin]            = format_varargin('RotateCW', true, 2, varargin);
[RotationRef_deg, varargin]     = format_varargin('Rotation', 0, 2, varargin);
[RangeUnits, varargin]          = format_varargin('RangeUnits', '', 2, varargin);
[Use360, varargin]              = format_varargin('Use360', true, 2, varargin);
[MaxRange, varargin]            = format_varargin('MaxRange', [], 2, varargin);
[RangeIncrements, varargin]     = format_varargin('RangeIncrements', '', 2, varargin);
[RangeTagRadial_deg, varargin]  = format_varargin('RangeRadial', 82, 2, varargin);
[UseTag, varargin]              = format_varargin('UseTag', false, 2, varargin);
[lstTag, varargin]              = format_varargin('Tag', {}, 2, varargin);
[FontWeight, varargin]          = format_varargin('FontWeight', 'bold', 2, varargin);

if(~iscell(lstTag))
    lstTag = { lstTag };
end

if(RotateCW)
    Rotation_deg = 90 - RotationRef_deg;
else
    Rotation_deg = 90 + RotationRef_deg;
end

[cax, args, nargs] = axescheck(varargin{:});
% Rotation_rad = Rotation_deg * acos(-1)/180;
C = {};

if nargs < 1 || rem(nargs,2) == 0
    error(message('MATLAB:polar:InvalidDataInputs'));
elseif nargs == 2
    theta_deg = args{1};
    rho = args{2};
    if ischar(rho)
        line_style = rho;
        rho = theta_deg;
        [mr, nr] = size(rho);
        if mr == 1
            theta_deg = 1 : nr;
        else
            th = (1 : mr)';
            theta_deg = th(:, ones(1, nr));
        end
    else
        line_style = 'auto';
    end
elseif nargs == 1
    theta_deg = args{1};
    line_style = 'auto';
    rho = theta_deg;
    [mr, nr] = size(rho);
    if mr == 1
        theta_deg = 1 : nr;
    else
        th = (1 : mr)';
        theta_deg = th(:, ones(1, nr));
    end
elseif nargs == 3
    [theta_deg, rho, line_style] = deal(args{1 : 3});
else % assuming that all others are the plot
    [theta_deg, rho, line_style] = deal(args{1 : 3});
    for ii = 4:2:nargs
        C(:,ii/2-1) = {args{ii}; args{ii+1}};
    end
end
if ischar(theta_deg) || ischar(rho)
    error(message('MATLAB:polar:InvalidInputType'));
end
if ~isequal(size(theta_deg), size(rho))
    error(message('MATLAB:polar:InvalidInputDimensions'));
end

% get hold state
cax = newplot(cax);

next = lower(get(cax, 'NextPlot'));
hold_state = ishold(cax);

% get x-axis text color so grid is in same color
tc = get(cax, 'XColor');
ls = get(cax, 'GridLineStyle');

% Hold on to current Text defaults, reset them to the
% Axes' font attributes so tick marks use them.
fAngle = get(cax, 'DefaultTextFontAngle');
fName = get(cax, 'DefaultTextFontName');
fSize = get(cax, 'DefaultTextFontSize');
fWeight = get(cax, 'DefaultTextFontWeight');
fUnits = get(cax, 'DefaultTextUnits');
set(cax, ...
    'DefaultTextFontAngle', get(cax, 'FontAngle'), ...
    'DefaultTextFontName', get(cax, 'FontName'), ...
    'DefaultTextFontSize', get(cax, 'FontSize'), ...
    'DefaultTextFontWeight', get(cax, 'FontWeight'), ...
    'DefaultTextUnits', 'data');

% only do grids if hold is off
if ~hold_state
    
    % make a radial grid
    hold(cax, 'on');
    % ensure that Inf values don't enter into the limit calculation.
    arho = abs(rho(:));
    if(~isempty(MaxRange))
        maxrho = max(abs(MaxRange));
        set(cax, 'XLim', [-maxrho maxrho], 'YLim', [-maxrho maxrho]);
    else
        maxrho = max(arho(arho ~= Inf));
    end
    hhh = line([-maxrho, -maxrho, maxrho, maxrho], [-maxrho, maxrho, maxrho, -maxrho], 'Parent', cax);
    set(cax, 'DataAspectRatio', [1, 1, 1], 'PlotBoxAspectRatioMode', 'auto');
    v = [get(cax, 'XLim') get(cax, 'YLim')];
    ticks = sum(get(cax, 'YTick') >= 0);
    delete(hhh);
    % check radial limits and ticks
    rmin = 0;
    rmax = v(4);
    
    if( ~isempty(MaxRange) && (length(MaxRange) > 1) )
        arrRanges = MaxRange;
    else
        
        if(~isempty(RangeIncrements))
            rinc = abs(RangeIncrements);
            
        else
            rticks = max(ticks - 1, 2);
            if rticks > 5   % see if we can reduce the number
                if rem(rticks, 2) == 0
                    rticks = rticks / 2;
                elseif rem(rticks, 3) == 0
                    rticks = rticks / 3;
                end
            end
            rinc = (rmax - rmin) / rticks;
        end
        arrRanges = (rmin + rinc) : rinc : rmax;
    end
    
    % define a circle
    th = 0 : pi / 50 : 2 * pi;
    xunit = cos(th);
    yunit = sin(th);
    % now really force points on x/y axes to lie on them exactly
    inds = 1 : (length(th) - 1) / 4 : length(th);
    xunit(inds(2 : 2 : 4)) = zeros(2, 1);
    yunit(inds(1 : 2 : 5)) = zeros(3, 1);
    % plot background if necessary
    if ~ischar(get(cax, 'Color'))
        patch('XData', xunit * rmax, 'YData', yunit * rmax, ...
            'EdgeColor', tc, 'FaceColor', get(cax, 'Color'), ...
            'HandleVisibility', 'off', 'Parent', cax);
    end
    
    % draw radial circles
    if(RotateCW)
        % Rotate Clockwise
        TotalRotation_deg = Rotation_deg - RangeTagRadial_deg;
        cRT = cosd(TotalRotation_deg);
        sRT = sind(TotalRotation_deg);
        
        if(abs(TotalRotation_deg) > 0)
            VertAlign = 'bottom';
        else
            VertAlign = 'top';
        end
        
    else
        % Rotate Counter-clockwise
        TotalRotation_deg = Rotation_deg + RangeTagRadial_deg;
        cRT = cosd(TotalRotation_deg);
        sRT = sind(TotalRotation_deg);
        
            if(abs(TotalRotation_deg) > 0)
            VertAlign = 'bottom';
        else
            VertAlign = 'top';
        end
        
    end

    numRanges = length(arrRanges);
    for iRange = 1:numRanges
        curRange = arrRanges(iRange);
        % Radial Circle
        hhh = line(xunit * curRange, yunit * curRange, 'LineStyle', ls, 'Color', tc, 'LineWidth', 1, ...
            'HandleVisibility', 'off', 'Parent', cax);
        % Text marker
        % Place 5% beyond range line
        xTag = (curRange * 1.05) * cRT;
        yTag = (curRange * 1.05) * sRT;
        strTag = [num2str(curRange)];
        if(iRange == numRanges);
            strTag = [strTag ' ' RangeUnits];
        end

        text(xTag, yTag, strTag, ...
            'VerticalAlignment', VertAlign, ...
            'HandleVisibility', 'off', 'Parent', cax, 'FontWeight', FontWeight);
    end
    set(hhh, 'LineStyle', '-'); % Make outer circle solid
    
    % Plot spokes
    arrTheta_deg = [0 : WedgeAngle_deg : 360] + Rotation_deg;
    arrTheta_deg = unique(mod(arrTheta_deg, 360));  % Wrap to be within 0-360
    
    if(~Use360)
        i = find(arrTheta_deg > 180);
        arrTheta_deg(i) = arrTheta_deg(i) - 360;
        arrTheta_deg = sort(arrTheta_deg);
    end
    
    % annotate spokes in degrees
    rt = 1.1 * rmax;
    for i = 1 : length(arrTheta_deg)
        curTheta_deg = arrTheta_deg(i);
        
        if(RotateCW)
            % Rotate Clockwise
            cst = cosd(Rotation_deg - curTheta_deg);
            snt = sind(Rotation_deg - curTheta_deg);
        else
            % Rotate Counter-clockwise
            cst = cosd(Rotation_deg + curTheta_deg);
            snt = sind(Rotation_deg + curTheta_deg);
        end

        line([0 rmax*cst],[0 rmax*snt], 'LineStyle', ls, 'Color', tc, 'LineWidth', 1, ...
            'HandleVisibility', 'off', 'Parent', cax);
        
        % annotate spokes in degrees
        text(rt * cst, rt * snt, [num2str(curTheta_deg) '^{\circ}'],...
            'HorizontalAlignment', 'center', ...
            'HandleVisibility', 'off', 'Parent', cax, 'FontWeight', FontWeight);

    end
    
    % set view to 2-D
    view(cax, 2);
    % set axis limits
    axis(cax, rmax * [-1, 1, -1.15, 1.15]);
end

% Reset defaults.
set(cax, ...
    'DefaultTextFontAngle', fAngle , ...
    'DefaultTextFontName', fName , ...
    'DefaultTextFontSize', fSize, ...
    'DefaultTextFontWeight', fWeight, ...
    'DefaultTextUnits', fUnits );

% transform data to Cartesian coordinates.

if(RotateCW)
    % Rotate Clockwise
    xx = rho .* cosd(Rotation_deg - theta_deg);
    yy = rho .* sind(Rotation_deg - theta_deg);
else
    % Rotate Counter-clockwise
    xx = rho .* cosd(Rotation_deg + theta_deg);
    yy = rho .* sind(Rotation_deg + theta_deg);
end

% plot data on top of grid
% text(xTime, yTime, strTime, 'EdgeColor', TimeTag.Color, 'BackgroundColor', 'w');
if(UseTag)
    nPts = length(xx);
    [~, arr_iSorted] = sort(rho);
    
    flgColorIncluded = size(lstTag, 2) > 1;
   for i = nPts:-1:1
       iPt = arr_iSorted(i);
       curX = xx(iPt);
       curY = yy(iPt);
       strTag = lstTag{iPt,1};
       
       if(flgColorIncluded)
           strTagColor = lstTag{iPt, 2};
       else
           strTagColor = 'black';
       end

       hTxt =   text(curX, curY, strTag);
       set(hTxt, 'HorizontalAlignment','center', 'VerticalAlignment', ...
            'Middle', 'EdgeColor', 'black', ...
            'Color', strTagColor, 'LineWidth', 1, ...
            'BackgroundColor', 'white', 'FontWeight', FontWeight);
        q(i) = hTxt;
   end
else
    if strcmp(line_style, 'auto')
        q = plot(cax, xx, yy, C{:});
    else
        q = plot(cax, xx, yy, line_style, C{:});
    end
end

if nargout == 1
    hpol = q;
end

if ~hold_state
    set(cax, 'DataAspectRatio', [1, 1, 1]), axis(cax, 'off');
    set(cax, 'NextPlot', next);
end
set(get(cax, 'XLabel'), 'Visible', 'on');
set(get(cax, 'YLabel'), 'Visible', 'on');

if ~isempty(q) && ~isdeployed
    makemcode('RegisterHandle', cax, 'IgnoreHandle', q, 'FunctionName', 'polar');
end
end
%% REVISION HISTORY
% YYMMDD INI: note
% 130716 MWS: Extracted polarc.m from The Mathworks' file exchange website
%
%             'polarc.m' was originally an enhancement to MATLAB's
%             'polar.m'.  Enhancement was ability to specify the
%             'LineSpec' options.
%
%             Original Author:
%               Marco Borges, Ph.D. Student, Computer/Biomedical Engineer
%               UFMG, PPGEE, Neurodinamica Lab, Brazil
%               $Revision: 3204 $  $Date: 2014-06-16 14:16:10 -0500 (Mon, 16 Jun 2014) $
%               April 2013; Version: v1; Last revision: 2013-04-30
%
%            Additional enhancments added by MWS
%             Added ability to specify wedge angle, rotation direction,
%             and figure rotation direction.
%**Add New Revision notes to TOP of list**

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