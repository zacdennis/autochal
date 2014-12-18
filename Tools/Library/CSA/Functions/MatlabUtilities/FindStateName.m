% FINDSTATENAME parses a string array for a certain combination of strings
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% FindStateName:
% This function will parse through a string array and look for the
% combination of strings defined in the cell array SearchArray.
% The indices of matches are returned.
% 
% This function is primarily designed to identify states within a
% simulation's state system given search strings.
% 
% SYNTAX:
%	[StateIndex] = FindStateName(States, SearchCells, verbose)
%	[StateIndex] = FindStateName(States, SearchCells)
%
% INPUTS: 
%	Name       	Size    Units       Description
%   States      [MxN]   [ND]        Cell Array of states to find
%   SearchCells [MxN]   [ND]        Cell Array of blocks to search
%   verbose     [1x1]   [ND]        Flag to display command window
%                                        outputs

%
% OUTPUTS: 
%	Name       	Size	Units		Description
%   StateIndex  [MxN]   [ND]        State Indices
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
% To find the state index i in SYSTEM of a block named IntQuaternion:
% >> [sys,x0,statenames,ts] = SYSTEM([],[],[],'sizes');
% >> i = FindStateIndex(statenames, {'IntQuaternion'});
% 
% To find the state indices i in SYSTEM of all blocks containing
% 'Integrator' && 'Aileron':
% >> [sys,x0,statenames,ts] = SYSTEM([],[],[],'sizes');
% >> i = FindStateIndex(statenames, {'Integrator', 'Aileron'});
%
%	% <Enter Description of Example #1>
%	[StateIndex] = FindStateName(States, SearchCells, verbose, varargin)
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[StateIndex] = FindStateName(States, SearchCells, verbose)
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
%	Source function: <a href="matlab:edit FindStateName.m">FindStateName.m</a>
%	  Driver script: <a href="matlab:edit Driver_FindStateName.m">Driver_FindStateName.m</a>
%	  Documentation: <a href="matlab:pptOpen('FindStateName_Function_Documentation.pptx');">FindStateName_Function_Documentation.pptx</a>
%
% See also <add relevant functions> 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/443
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/MatlabUtilities/FindStateName.m $
% $Rev: 1718 $
% $Date: 2011-05-11 18:07:49 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [StateIndex] = FindStateName(States, SearchCells, verbose)

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
% StateIndex= -1;
ctr         = 0;    % Initialize the counter

%% Input Argument Conditioning:
% Pick out Properties Entered via varargin
% [<PropertyValue>, varargin]  = format_varargin('<PropertyValue', <Default>, 2, varargin);

%  switch(nargin)
%       case 0
%        verbose= ''; SearchCells= ''; States= ''; 
%       case 1
%        verbose= ''; SearchCells= ''; 
%       case 2
%        verbose= ''; 
%       case 3
%        
%       case 4
%        
%  end
%
%  if(isempty(verbose))
%		verbose = -1;
%  end
if nargin < 3
    verbose = 1;
end
%% Main Function:
%% Check the inputs to be sure a cell is used:
UsingCells = iscell(SearchCells);
if UsingCells ~= true
    disp('Error :: FindStateNames :: Cell arrays must be used for SearchCells.');
    disp('Check the input arguments to FindStateNames');
    return;
end

for i = 1:length(States);
    % Grab row from the list:
    States_row = char(States(i,:));
    
    %% Search the row for all of the user defined integrator names:
    check_ctr = 0;  % Initialize Temporary Counter
    for j = 1:length(SearchCells)
        
        str_search = SearchCells{j};
        
        ptrMatch = strfind(States_row, str_search);

        if(ptrMatch ~= 0)
            check_ctr = check_ctr + 1;
        end
        
    end
    
    if(check_ctr == length(SearchCells))
        %% Match found:
        ctr = ctr + 1;
        StateIndex(ctr) = i;
    end
end

% Error Checking:
if ((StateIndex == 0) & (verbose))
    disp(sprintf('WARNING :: %s :: Could not find State with following Paramters:', mfilename));
    for j = 1:length(SearchCells)
         str_search = SearchCells{j};
         disp(sprintf('          %s', str_search));
    end
    disp(sprintf('        Returing 0'));
end

%% Compile Outputs:
%	StateIndex= -1;

end % << End of function FindStateName >>

%% REVISION HISTORY
% YYMMDD INI: note
% 101025 JPG: Copied over information from the old function.
% 101025 CNF: Function template created using CreateNewFunc
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
