% CLEANAXIS Fixes the axis labels when values are displayed as (x 10^n)
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% CleanAxis:
%     Fixes the axis labels when values are displayed as (x 10^n)
% 
% *************************************************************************
% * #NOTE: To future COSMO'er, the following warning occured when running
% * CreateNewFunc.
% * CreateNewFunc>>WARNING: Selected Input argument name: "strAxis" is a
% * function name!
% * -JPG
% *************************************************************************
% SYNTAX:
%	[] = CleanAxis(strAxis)
%
% INPUTS: 
%	Name    	Size		Units		Description
%   strAxis     [string]                Axis to correct 
%                                        (e.g. 'x', 'y', or 'z')
%                                        Default is 'y' axis
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
%   Within the MATLAB 'plot' routine there exists a function which
%   automatically places labels on the X, Y, and Z axis.  One of the
%   "features" of this function is that MATLAB will convert any label
%   number larger than 10,000 into scientific notation (1 x 10^4).
%
%   For instance, take a plot of Altitude vs. Time.  If the altitude ranges
%   from say 40,000 to 45,0000 feet, MATLAB's plotting routine will
%   automatically convert the Y tick labels from 4 to 4.5 with a (x 10^4)
%   printed in the upper left corner of the title line.
%
%   This function will restore the intended labeling.  BUT BE WARNED, when
%   the image is displayed as a figure, axis labels will appear correct.
%   When users expand the window, MATLAB will automatically readjust the
%   axis labels.  It is POSSIBLE that this screw up the now "clean"
%   labeling.  This is typically seen if the figure is saved and later
%   reopened for a presentation or report.
%
%	VARARGIN PROPERTIES:
%	PropertyName		PropertyValue	Default		Description
%	<PropertyName>		<units>			<Default>	<Description>
%
% EXAMPLES:
%	% <Enter Description of Example #1>
%	[] = CleanAxis(strAxis, varargin)
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[] = CleanAxis(strAxis)
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
%	Source function: <a href="matlab:edit CleanAxis.m">CleanAxis.m</a>
%	  Driver script: <a href="matlab:edit Driver_CleanAxis.m">Driver_CleanAxis.m</a>
%	  Documentation: <a href="matlab:pptOpen('CleanAxis_Function_Documentation.pptx');">CleanAxis_Function_Documentation.pptx</a>
%
% See also <add relevant functions> 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/479
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/PlottingUtilities/CleanAxis.m $
% $Rev: 1724 $
% $Date: 2011-05-11 18:34:55 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [] = CleanAxis(strAxis, varargin)

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
%        strAxis= ''; 
%       case 1
%        
%       case 2
%        
%  end
%
%% Main Function:
if nargin == 0
    strAxis = 'Y';
end

strAxis = upper(strAxis);

set(gca,'FontWeight','bold');
set(gca, [strAxis 'TickLabelMode'],'auto')
set(gca, [strAxis 'TickMode'],'auto')

%% Retrieve Current Tick marks
curticks  = get(gca, [strAxis 'Tick']);
curlabels = (str2num(get(gca, [strAxis 'TickLabel']))');

if (max(abs(curlabels-curticks)>1e-6))
    %% MATLAB Readjusted the Axis
    alim = get(gca, [strAxis 'Lim']);
    a = get(gca, [strAxis 'Tick']);

    %  Compute delta between ticks
    da = a(2) - a(1);

    %  Split the Difference
    if length(a) < 4
        db = da/2;
    else
        db = da;
    end
    
    d1 = a(1);
    d2 = a(end);
    
    if ( (a(1)-db) > alim(1) )
        d1 = a(1) - db;
    end
        
    if ( (a(end)+db) < alim(end) )
        d2 = a(end) + db;
    end
    
    arrb = [d1 : db : d2];
    
    set(gca, [strAxis 'Tick'], arrb);
%     set(gca, [strAxis 'TickLabel'],arrb);  %% <-- Elegant Solution which Matlab doesn't like    

    %% Sledgehammer Solution
    %   Build Label
    med = median(arrb);
    if abs(med) > 1e6
        for j = 1:length(arrb);
            a = sprintf('%.2e', arrb(j));
            if ispc
                a = strrep(a, 'e+00', 'e+');
                a = strrep(a, 'e+0', 'e+');
            end
            strb(j,:) = { a };
        end
    elseif abs(med) < 1
        for j = 1:length(arrb);
             strb(j,:) = { sprintf('%.4f', arrb(j)) };
        end
        
    else
        for j = 1:length(arrb);
             strb(j,:) = { sprintf('%.0f', arrb(j)) };
        end
    end
    
    set(gca, [strAxis 'TickLabel'], strb);

end

%% Compile Outputs:
%	= -1;

end % << End of function CleanAxis >>

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
