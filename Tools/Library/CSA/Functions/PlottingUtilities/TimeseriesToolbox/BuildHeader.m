% BUILDHEADER Builds formatted labels for title use.
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% BuildHeader:
%  Utility function for VSI_LIB TIMESERIES_TOOLBOX functions
%  'PlotMeasurands' and 'PlotMeasurandsXY'.  Builds formatted labels for
%  title use.
% 
% SYNTAX:
%	[lstHeader] = BuildHeader(SourceData2Plot, PO, varargin, 'PropertyName', PropertyValue)
%	[lstHeader] = BuildHeader(SourceData2Plot, PO, varargin)
%	[lstHeader] = BuildHeader(SourceData2Plot, PO)
%
% INPUTS: 
%	Name           	Size		Units		Description
% SourceData2Plot       {struct}    Contains all source data & info
%   .Results            {struct}    'Results' structure from
%                                       ParseRecordedData2ts
%   .Title              [string]    Description of data (e.g. version,
%                                       configuration, etc)
%   .toffset            [sec]       Time offset to shift data
%   .filename           [string]    Filename of plotted data
%
% PO                    {struct}        Plot Options
%   .titlefont1         [1]             Main Title Font     (default: 12)
%   .titlefont2         [1]             Minor Title Font    (default: 10)
%   .Title              [string]        Additonal Title     (default: '')
%	varargin	[N/A]		[varies]	Optional function inputs that
%	     		        				 should be entered in pairs.
%	     		        				 See the 'VARARGIN' section
%	     		        				 below for more details
%
% OUTPUTS: 
%	Name           	Size		Units		Description
% lstHeader             {cell}      Formatted labels for title use
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
%	[lstHeader] = BuildHeader(SourceData2Plot, PO, varargin)
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[lstHeader] = BuildHeader(SourceData2Plot, PO)
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
%	Source function: <a href="matlab:edit BuildHeader.m">BuildHeader.m</a>
%	  Driver script: <a href="matlab:edit Driver_BuildHeader.m">Driver_BuildHeader.m</a>
%	  Documentation: <a href="matlab:pptOpen('BuildHeader_Function_Documentation.pptx');">BuildHeader_Function_Documentation.pptx</a>
%
% See also <add relevant functions> 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/515
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/PlottingUtilities/TimeseriesToolbox/BuildHeader.m $
% $Rev: 2940 $
% $Date: 2013-04-04 15:10:37 -0500 (Thu, 04 Apr 2013) $
% $Author: sufanmi $

function [lstHeader] = BuildHeader(SourceData2Plot, PO, varargin)

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
% lstHeader= -1;

%% Input Argument Conditioning:
% Pick out Properties Entered via varargin
% [<PropertyValue>, varargin]  = format_varargin('<PropertyValue', <Default>, 2, varargin);

%  switch(nargin)
%       case 0
%        PO= ''; SourceData2Plot= ''; 
%       case 1
%        PO= ''; 
%       case 2
%        
%       case 3
%        
%  end
%
%  if(isempty(PO))
%		PO = -1;
%  end
%% Main Function:
numSourceData2Plot = size(SourceData2Plot, 2);
PO = format_struct(PO, 'titlefont1', 12);
PO = format_struct(PO, 'titlefont2', 10);
PO = format_struct(PO, 'Title', '');
PO = format_struct(PO, 'SkipDataNames', 0);
PO = format_struct(PO, 'IncludeTimeOffset', 0);

ihead = 0;

lstHeader{1,:} = '';

if(~isempty(PO.Title))
    if(~iscell(PO.Title))
        PO.Title = {PO.Title};
    end
    
    for irow = 1:size(PO.Title, 1)
        ihead = ihead + 1;
        strTitle2Add = PO.Title{irow,:};
        
        strTitle2Add = strrep(strTitle2Add, '\', '\\');
        strTitle2Add = strrep(strTitle2Add, '_', '\_');

        if(ihead == 1)
            lstHeader{ihead,:} = sprintf('\\bf\\fontsize{%d}%s', PO.titlefont1, strTitle2Add);
        else
            lstHeader{ihead,:} = sprintf('\\bf\\fontsize{%d}%s', PO.titlefont2, strTitle2Add);
        end
    end
end

if(~PO.SkipDataNames)

% Find Max Lengths:
lengthFilename  = 0;
lengthTitle     = 0;
lengthToffset   = 0;

for iSourceData2Plot = 1:numSourceData2Plot
    strFilename = SourceData2Plot(iSourceData2Plot).filename;
    strTitle    = SourceData2Plot(iSourceData2Plot).Title;
    toffset     = SourceData2Plot(iSourceData2Plot).toffset;
    
    if(~isempty(strFilename))
        strFilename = strrep(strFilename, '\', '\\');
        strFilename = strrep(strFilename, '\\\', '\\');
        strFilename = strrep(strFilename, '_', '\_');
        
        strFilename = sprintf('\\fontsize{%d}ds%d: %s', ...
            PO.titlefont2, iSourceData2Plot, strFilename);
    end
    strOffset = ['(\delta_T: ' sprintf('%.2f)', toffset)];
    
    lengthFilename  = max(lengthFilename,   length(strFilename));
    lengthTitle     = max(lengthTitle,      length(strTitle));
    lengthToffset   = max(lengthToffset,    length(strOffset));
end

for iSourceData2Plot = 1:numSourceData2Plot
    strFilename = SourceData2Plot(iSourceData2Plot).filename;
    strTitle    = SourceData2Plot(iSourceData2Plot).Title;
    toffset     = SourceData2Plot(iSourceData2Plot).toffset;
        
    if(~isempty(strFilename))
        strFilename = strrep(strFilename, '\', '\\');
        strFilename = strrep(strFilename, '\\\', '\\');
        strFilename = strrep(strFilename, '_', '\_');
        
        strFilename = sprintf('\\fontsize{%d}ds%d: %s', ...
            PO.titlefont2, iSourceData2Plot, strFilename);
    end
        
    strFilename = [strFilename spaces(lengthFilename - length(strFilename))];
    strTitle    = [strTitle spaces(lengthTitle - length(strTitle))];

    strOffset = ['(\delta_T: ' sprintf('%.2f)', toffset)];
    strOffset = [strOffset spaces(lengthToffset - length(strOffset))];
    
    if(PO.IncludeTimeOffset)
        strHeader = [strFilename ' ' strTitle ' ' strOffset];
        ihead = ihead + 1;
        lstHeader(ihead,:) = { strHeader };
    else
        if( ~isempty(strFilename) && ~isempty(strTitle) )
            strHeader = [strFilename ' ' strTitle];
            ihead = ihead + 1;
            lstHeader(ihead,:) = { strHeader };
        end
    end
end

%% Compile Outputs:
%	lstHeader= -1;

end % << End of function BuildHeader >>

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
