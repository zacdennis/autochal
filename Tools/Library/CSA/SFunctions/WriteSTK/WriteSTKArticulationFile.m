% WRITESTKARTICULATIONFILE Constructs name and command str used by WriteSTK
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% WriteSTKArticulationFile:
%  Constructs the articulation name and command strings used by WriteSTK 
% 
% SYNTAX:
%	[] = WriteSTKArticulationFile(lstArts, strVeh, varargin, 'PropertyName', PropertyValue)
%	[] = WriteSTKArticulationFile(lstArts, strVeh, varargin)
%	[] = WriteSTKArticulationFile(lstArts, strVeh)
%	[] = WriteSTKArticulationFile(lstArts)
%
% INPUTS: 
%	Name    	Size		Units		Description
%  lstArts  {N x 4} Cell Array
%   Column 1: Name of the Control Surface in the Results.STKBus or in the
%               Simulation Model (Not Used by this function, used for
%               reference only)
%   Column 2: Name of the Control Surface in the STK Model
%   Column 3: Articualation Command in the STK Model
%   Column 4: Size of Signal (Optional)  (Assumed to be 1 if not specfied)
%	strVeh	  <size>		<units>		<Description>
%	varargin	[N/A]		[varies]	Optional function inputs that
%	     		        				 should be entered in pairs.
%	     		        				 See the 'VARARGIN' section
%	     		        				 below for more details
%
% OUTPUTS: 
%	Name    	Size		Units		Description
%  WriteSTK     {structure} WriteSTK Parameters
%   .numArticulations   [1]         Number of Articulations
%   .ArtNames           {M x 1}     Articulation Names Cell Array
%   .ArtCmds            {M x 1}     Articualtion Commands Cell Array
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
%  lstArts = {
%     'Xcg'                   'Vehicle'           'Xcg'      1;
%     'LeftRudder'            'LeftRudder'        'Deflect'  1;
%     'Booster_Throttle'      'BoosterFlame'      'Size'     2};
% WriteSTK = WriteSTKArticulationFile(lstArts, 'fourArts')
%
%	% <Enter Description of Example #1>
%	[] = WriteSTKArticulationFile(lstArts, strVeh, varargin)
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[] = WriteSTKArticulationFile(lstArts, strVeh)
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
%	Source function: <a href="matlab:edit WriteSTKArticulationFile.m">WriteSTKArticulationFile.m</a>
%	  Driver script: <a href="matlab:edit Driver_WriteSTKArticulationFile.m">Driver_WriteSTKArticulationFile.m</a>
%	  Documentation: <a href="matlab:pptOpen('WriteSTKArticulationFile_Function_Documentation.pptx');">WriteSTKArticulationFile_Function_Documentation.pptx</a>
%
% See also <add relevant functions> 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/<TicketNumber>
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/SFunctions/WriteSTK/WriteSTKArticulationFile.m $
% $Rev: 1704 $
% $Date: 2011-05-10 18:51:22 -0500 (Tue, 10 May 2011) $
% $Author: healypa $

function [] = WriteSTKArticulationFile(lstArts, strVeh, varargin)

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
%        strVeh= ''; lstArts= ''; 
%       case 1
%        strVeh= ''; 
%       case 2
%        
%       case 3
%        
%  end
%
%  if(isempty(strVeh))
%		strVeh = -1;
%  end
%% Main Function:
numArts = size(lstArts, 1);
numCols = size(lstArts, 2);
ctr = 0;

if(nargin < 2)
    strVeh = sprintf('test_%d_arts', numArts);
end

STK_filename = sprintf('STK_%s_Info.txt', strVeh);

fp = fopen(STK_filename, 'w');

for iArt = 1:numArts
    curArtName  = lstArts{iArt, 2};
    curArtCmd   = lstArts{iArt, 3};
    
    if(numCols > 3) 
        curArtSize  = lstArts{iArt, 4};
    else
        curArtSize = 1;
    end
    
    for iSize = 1:curArtSize
        ctr = ctr + 1;
        if(curArtSize == 1)
            name2add = curArtName;
        else
            name2add = [curArtName num2str(iSize)];
        end
        fprintf(fp, '%s %s\n', name2add, curArtCmd);      
    end
end

fclose(fp);

disp(sprintf('%s : Wrote ''%s''', mfilename, STK_filename));

%% Compile Outputs:
%	= -1;

end % << End of function WriteSTKArticulationFile >>

%% REVISION HISTORY
% YYMMDD INI: note
% 101026 JPG: Copied over information from the old Script.
% 101026 CNF: Function template created using CreateNewScript
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
