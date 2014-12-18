% Compare_SL_and_Code Simple plot overlay utility for comparing Simulink and Autocode time histories
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% Compare_SL_and_Code:
%     <Function Description> 
% 
% SYNTAX:
%	[h, delta, flgPass] = Compare_SL_and_Code(ResultsSL, ResultsCC, signal2plot, varargin, 'PropertyName', PropertyValue)
%	[h, delta, flgPass] = Compare_SL_and_Code(ResultsSL, ResultsCC, signal2plot, varargin)
%	[h, delta, flgPass] = Compare_SL_and_Code(ResultsSL, ResultsCC, signal2plot)
%	[h, delta, flgPass] = Compare_SL_and_Code(ResultsSL, ResultsCC)
%
% INPUTS: 
%	Name       	Size		Units		Description
%	ResultsSL	  <size>		<units>		<Description>
%	ResultsCC	<size>		<units>		<Description>
%	signal2plot	<size>		<units>		<Description>
%	varargin	[N/A]		[varies]	Optional function inputs that
%	     		        				 should be entered in pairs.
%	     		        				 See the 'VARARGIN' section
%	     		        				 below for more details
%
% OUTPUTS: 
%	Name       	Size		Units		Description
%	h   	          <size>		<units>		<Description> 
%	delta	      <size>		<units>		<Description> 
%	flgPass	    <size>		<units>		<Description> 
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
%	[h, delta, flgPass] = Compare_SL_and_Code(ResultsSL, ResultsCC, signal2plot, varargin)
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[h, delta, flgPass] = Compare_SL_and_Code(ResultsSL, ResultsCC, signal2plot)
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
%	Source function: <a href="matlab:edit Compare_SL_and_Code.m">Compare_SL_and_Code.m</a>
%	  Driver script: <a href="matlab:edit Driver_Compare_SL_and_Code.m">Driver_Compare_SL_and_Code.m</a>
%	  Documentation: <a href="matlab:pptOpen('Compare_SL_and_Code_Function_Documentation.pptx');">Compare_SL_and_Code_Function_Documentation.pptx</a>
%
% See also <add relevant functions> 
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/702
%  
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: $
% $Rev: $
% $Date: $
% $Author: $

function [flgPass, strPassPercent, delta_ts] = Compare_SL_and_Code(ResultsSL, ResultsCC, signal2plot, varargin)

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
[PO.Decimation, varargin]   = format_varargin('Decimation', [], 2, varargin);
[PO.LineWidth, varargin]    = format_varargin('LineWidth', 1.5, 2, varargin);
[PO.MarkerSize, varargin]   = format_varargin('MarkerSize', 10, 2, varargin);
[Threshold, varargin]       = format_varargin('Threshold', 1e-8, 2, varargin);
[Title, varargin]           = format_varargin('Title', '', 2, varargin);
[flgPlot, varargin]         = format_varargin('Plot', 1, 2, varargin);
[PlotOrder, varargin]       = format_varargin('PlotOrder', {}, 2, varargin);
[FigurePosition, varargin]  =  format_varargin('FigurePosition', [], 2, varargin);
[ForceSameTime, varargin]   =  format_varargin('ForceSameTime', 1, 2, varargin);

%% Main Function:
ts_SL = getts(ResultsSL, signal2plot, 0, varargin{:});
ts_CC = getts(ResultsCC, signal2plot, 0, varargin{:});

if(ForceSameTime)
    ts_CC.Time = ts_SL.Time;
end

lst_ts = {ts_SL; ts_CC};
delta_ts = diffts(lst_ts);

str_leg_warn = 'MATLAB:legend:IgnoringExtraEntries';
warning('off', str_leg_warn);

if(flgPlot)
    if(isempty(Title))
        strTitle(1,:) = {'\fontsize{12}RTW Code Check'};
    else
        strTitle(1,:) = {['\fontsize{12}RTW Code Check for ' strrep(Title, '_', '\_')]};
    end
    strTitle(2,:) = {['\fontsize{10}' strrep(signal2plot, '_', '\_')]};
    
    figure('Name', signal2plot);
    if(~isempty(FigurePosition))
        set(gcf, 'Position', FigurePosition);
    end
    subplot(211);
    
    h(1:2) = plotts({ts_SL; ts_CC}, 'LineWidth', PO.LineWidth, ...
        'MarkerSize', PO.MarkerSize, ...
        'Decimation', PO.Decimation, 'PlotOrder', PlotOrder);
    legend(h, {'Simulink';'Autocode'}, 'Location', 'NorthWest');
    ylabel(ts_SL.DataInfo.Units, 'FontWeight', 'bold');
    title(strTitle);

    subplot(212);
    h(1) = plotts(delta_ts, 'LineWidth', PO.LineWidth, ...
        'MarkerSize', PO.MarkerSize, ...
        'Decimation', PO.Decimation, 'PlotOrder', PlotOrder);
    hold on;
    h(2:3) = PlotYLine([Threshold; -Threshold], 'r--', 'LineWidth', 1.5);
%     PlotYLine(-Threshold, 'r--', 'LineWidth', 1.5);
    
    maxError = maxAll(delta_ts.Data);
    if( (3*Threshold) > maxError )
        ylim( [-1 1]*3*Threshold );
    end

    ylabel(['\Delta ' ts_SL.DataInfo.Units], 'FontWeight', 'bold');
    strThresh = sprintf('Threshold (%.2g)', Threshold);
    strThresh = strrep(strThresh, 'e-0', 'e-');
    strThresh = strrep(strThresh, 'e-0', 'e-');
    
    legend(h, {'Simulink - Autocode'; strThresh}, 'Location', 'NorthWest');
end

maxDelta    = maxAll(abs(delta_ts.Data));       % [varies]
arrPass     = abs(delta_ts.Data) <= Threshold;  % [bool]
flgPass     = all(arrPass);                     % [bool]
numMatch    = sum(arrPass);
numPts      = length(arrPass);
PassPercent = numMatch/numPts * 100;  % [%]

if(flgPass)
    strPass = 'PASSED';
else
    strPass = 'FAILED';
end

strPassPercent = sprintf('%s: %5.0f/%d (%.4f%% within threshhold) - Max Delta: %s %s', ...
    strPass, numMatch, numPts, PassPercent, num2str(maxDelta), ts_SL.DataInfo.Units);

warning('on', str_leg_warn);

end % << End of function Compare_SL_and_Code >>

%% REVISION HISTORY
% YYMMDD INI: note
% 110517 MWS: Created function using CreateNewFunc
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
