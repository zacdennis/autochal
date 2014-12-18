% BUSOBJECT2XML Auto-generates an xml file based on a user-provided bus object
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% BusObject2XML:
%     Auto-generates an xml file based on a user-provided bus object
% 
% SYNTAX:
%	[filename] = BusObject2XML(structname, BOInfo, fldrSave, varargin, 'PropertyName', PropertyValue)
%	[filename] = BusObject2XML(structname, BOInfo, fldrSave, varargin)
%	[filename] = BusObject2XML(structname, BOInfo, fldrSave)
%	[filename] = BusObject2XML(structname, BOInfo)
%
%*************************************************************************
%* #NOTE: From old function
%* INPUTS
%*   namespace   [string]
%*   structname  [string]    Name of BusObject without the 'BO' prefix
%*                               Ex: 'SimEventsBus' for 'BOSimEventsBus'
%*   BOInfo      {struct}
%* -JPG
%*************************************************************************
% INPUTS: 
%	Name      	Size		Units		Description
%	structname	<size>		<units>		<Description>
%	BOInfo	    <size>		<units>		<Description>
%	fldrSave	  <size>		<units>		<Description>
%	varargin	[N/A]		[varies]	Optional function inputs that
%	     		        				 should be entered in pairs.
%	     		        				 See the 'VARARGIN' section
%	     		        				 below for more details
%
% OUTPUTS: 
%	Name      	Size		Units		Description
%	(structname).cs     [file]		<units>		<Description> 
%
% NOTES:
%   Function uses 'BO2ResultsList'
%
%	VARARGIN PROPERTIES:
%	PropertyName		PropertyValue	Default		Description
%	<PropertyName>		<units>			<Default>	<Description>
%
% EXAMPLES:
%	% <Enter Description of Example #1>
%	[filename] = BusObject2XML(structname, BOInfo, fldrSave, varargin)
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[filename] = BusObject2XML(structname, BOInfo, fldrSave)
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
%	Source function: <a href="matlab:edit BusObject2XML.m">BusObject2XML.m</a>
%	  Driver script: <a href="matlab:edit Driver_BusObject2XML.m">Driver_BusObject2XML.m</a>
%	  Documentation: <a href="matlab:pptOpen('BusObject2XML_Function_Documentation.pptx');">BusObject2XML_Function_Documentation.pptx</a>
%
% See also <add relevant functions> 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/529
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/SimulinkUtilities/BusObject2XML.m $
% $Rev: 1726 $
% $Date: 2011-05-11 19:02:15 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [filename] = BusObject2XML(structname, BOInfo, fldrSave, varargin)

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
% filename= -1;

%% Input Argument Conditioning:
% Pick out Properties Entered via varargin
% [<PropertyValue>, varargin]  = format_varargin('<PropertyValue', <Default>, 2, varargin);

%  switch(nargin)
%       case 0
%        fldrSave= ''; BOInfo= ''; structname= ''; 
%       case 1
%        fldrSave= ''; BOInfo= ''; 
%       case 2
%        fldrSave= ''; 
%       case 3
%        
%       case 4
%        
%  end
%
%  if(isempty(fldrSave))
%		fldrSave = -1;
%  end
%% Main Function:
if((nargin < 3) || isempty(fldrSave))
    fldrSave = pwd;
end

if((nargin < 2) || isempty(BOInfo))
    BOInfo = evalin('base', 'BOInfo');
end

if(isstruct(BOInfo))
    lst2write = BO2ResultsList(['BO' structname], BOInfo);
else
    lst2write = BOInfo;
end
    
numSignals = size(lst2write, 1);
% numCols    = size(lst2write, 2);

hd = pwd;
if(~isdir(fldrSave))
    mkdir(fldrSave);
end
cd(fldrSave);

filename = [structname '.xml'];
fp = fopen(filename, 'w');

% Loop Through the List:
flgAddDefaults = 0;

%% Write Header Section
fprintf(fp, '<!--\n');
fprintf(fp, '   Northrop Grumman Proprietary Level I\n');
fprintf(fp, '   NGC Aerospace Systems\n');
fprintf(fp, '   VMS & GNC (Dept 9V21)\n');
fprintf(fp, '   El Segundo, CA 90245\n');
fprintf(fp, '\n');
fprintf(fp, '   Reference Bus Object: BO%s\n', structname);
fprintf(fp, '            Bus Members: %d\n', numSignals);
fprintf(fp, '          Total Signals: %d\n', sum(cell2mat(lst2write(:,2))));
fprintf(fp, '-->\n');
fprintf(fp, '\n');
fprintf(fp, '<doublestream name="%s">\n', structname);

ictr = 0;
for iSignal = 1:numSignals
    strElement = lst2write{iSignal, 1};
    numElement = lst2write{iSignal, 2};
    strUnits   = lst2write{iSignal, 3};
    if(isempty(strfind(strElement, '%')))
        line2write = sprintf('	<point index="%d" name="%s" count="%d" units="%s"', ictr, strElement, numElement, strUnits);
        
        if(flgAddDefaults)
            if(numElement == 1)
                valDefault = 0;
                line2write = sprintf('%s default="%s"', line2write, num2str(valDefault));
            else
                % Time to get fancy...
                line2write = sprintf('%s default="', line2write);
                for iElement = 1:numElement
                    valDefault = 0;     % TBD
                    if(iElement < numElement)
                        line2write = sprintf('%s%s,', line2write, num2str(valDefault));
                    else
                        line2write = sprintf('%s%s"', line2write, num2str(valDefault));
                    end
                end
            end
        end

        line2write = sprintf('%s/>', line2write);
        
        fprintf(fp, '%s\n', line2write);
        ictr = ictr + numElement;
    end
end

fprintf(fp, '</doublestream>\n');

cd(hd);
disp(sprintf('%s : ''%s'' has been created in %s', mfilename, filename, fldrSave));

%% Compile Outputs:
%	filename= -1;

end % << End of function BusObject2XML >>

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
