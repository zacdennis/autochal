% VT_CHECK Checks a model for illegal block parameters
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% vt_check:
% This model checks the specified Simulink system for illegal block
% parameters A list of illegal parameters is built as a cell array and
% looped through The name and path of offending blocks is displayed. Also
% displayed is a count of the function points, Inports, and Outports.
% 
% To Do:
% - Refine list of checks
% - Unconnected signal checking
% - Highlight offending blocks - set the color?
%
% SYNTAX:
%	[] = vt_check(mdl, varargin, 'PropertyName', PropertyValue)
%	[] = vt_check(mdl, varargin)
%	[] = vt_check(mdl)
%
% INPUTS: 
%	Name    	Size		Units		Description
%	mdl 	     <size>		<units>		<Description>
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
%	[] = vt_check(mdl, varargin)
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[] = vt_check(mdl)
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
%	Source function: <a href="matlab:edit vt_check.m">vt_check.m</a>
%	  Driver script: <a href="matlab:edit Driver_vt_check.m">Driver_vt_check.m</a>
%	  Documentation: <a href="matlab:pptOpen('vt_check_Function_Documentation.pptx');">vt_check_Function_Documentation.pptx</a>
%
% See also <add relevant functions> 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/542
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/SimulinkUtilities/vt_check.m $
% $Rev: 1726 $
% $Date: 2011-05-11 19:02:15 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [] = vt_check(mdl, varargin)

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
%        mdl= ''; 
%       case 1
%        
%       case 2
%        
%  end
%
%% Main Function:
% The criteria matrices are cell arrays The first and third columns are
% vectors of parameter names, and the second and fourth columns are vectors
% of the values.

% The first criteria matrix lists condtitions that are not allowed If
% there are multiple illegal values for a parameter, then that parameter
% must have multiple entries The third and fourth columns define an
% exception condition Blocks that meet both conditions are allowed In
% other words, condition one is not allowed unless condition two is met.
% pass if   NOT Condition 1 OR (Condition 1 AND Condition 2)
%           NOT Condition 1 (Condition 2 not set)
% fail if   Condition 1 AND NOT Condition 2
%           Condition 1 (Condition 2 not set)
criteria1 =  [{'DataType'},          {'auto'},               {'null'},           {'null'}    ;
              {'DataType'},          {'single'},             {'null'},           {'null'}    ;
              {'DataType'},          {'int8'},               {'null'},           {'null'}    ;
              {'DataType'},          {'int16'},              {'null'},           {'null'}    ;
              {'DataType'},          {'uint8'},              {'null'},           {'null'}    ;
              {'DataType'},          {'uint16'},             {'null'},           {'null'}    ;
              {'DataType'},          {'unint32'},            {'null'},           {'null'}    ;
              {'DataType'},          {'Specify via dialog'}, {'null'},           {'null'}    ;
              {'SignalType'},        {'complex'},            {'null'},           {'null'}    ;
              {'SignalType'},        {'auto'},               {'DataType'},       {'boolean'} ;
              {'PortDimensions'},    {'-1'},                 {'null'},           {'null'}   ];

% The second criteria matrix lists mandatory conditions The two pairs of
% parameters form an OR condition If either is true, the block passes.
% pass if   Condition 1 OR Condition 2
%           Condition 1 (Condition 2 not set)
% fail if   NOT Condition 1 AND NOT Condition 2
%           NOT Condition 1 (Condition 2 not set)
criteria2 =  [{'SampleTime'},        {'-1'},                 {'SampleTime'},     {'inf'}];

% The third condition matrix lists mandatory combinations The two paris
% of parameters form an AND condition If both are true, the block passes.
% pass if   NOT Condition 1 OR (Condition 1 AND NOT Condition 2)
%           NOT Condition 1 (Condition 2 not set)
% fail if   Condition 1 AND Condition 2
%           Condition 1 (Condition 2 not set)
criteria3 =  [{'TreatAsAtomicUnit'}, {'off'},                {'ReferenceBlock'}, {'null'}];

disp(' ')
disp(['Checking model ' mdl])
disp(' ')

% Get a list of all the blocks
%blocks_all = find_system(mdl);

%-----------------------
% First Criteria Matrix
%-----------------------

% Loop through parameters
[np, junk] = size(criteria1);

for i=1:np

    blocks1 = find_system(mdl, criteria1{i,1}, criteria1{i,2});

    % Check the second criteria if applicable
    if (~strcmp(criteria1{i,3}, 'null'))

        disp(['**** Checking parameter [(' criteria1{i,1} ' ~= ' criteria1{i,2} ...
              ') unless (' criteria1{i,3} ' = ' criteria1{i,4} ')]'])

        % Find all blocks that met the second criteria
        blocks2 = find_system(blocks1, criteria1{i,3}, criteria1{i,4});

        % Remove these blocks from the first list
        blk_list = setdiff(blocks1, blocks2);

    else
        disp(['**** Checking parameter [' criteria1{i,1} ' ~= ' criteria1{i,2} ']'])
        blk_list = blocks1;
    end

    % Display the output
    listblocks(blk_list);

end

%------------------------
% Second Criteria Matrix
%------------------------

% Loop through parameters
[np, junk] = size(criteria2);

for i=1:np

    % Find all blocks that have this parameter name
    blocks1 = find_system(mdl, 'regexp', 'on', criteria2{i,1}, '.*');

    % Find all blocks meeting the first criteria in this list
    blocks2 = find_system(blocks1, criteria2{i,1}, criteria2{i,2});

    % Remove these blocks from the complete list
    blk_list = setdiff(blocks1, blocks2);

    % Check the second criteria if applicable
    if (~strcmp(criteria2{i,3}, 'null'))
        
        disp(['**** Checking parameter [(' criteria2{i,1} ' = ' criteria2{i,2} ...
              ') or (' criteria2{i,3} ' = ' criteria2{i,4} ')]'])

        % Find all blocks meeting the second criteria
        blocks3 = find_system(blocks1, criteria2{i,3}, criteria2{i,4});

        % Remove these blocks from the complete list
        blk_list = setdiff(blk_list, blocks3);

    else
        disp(['**** Checking parameter [' criteria2{i,1} ' = ' criteria2{i,2} ']'])
    end

    % Display the output
    listblocks(blk_list);

end

%-----------------------
% Third Criteria Matrix
%-----------------------

% Loop through parameters
[np, junk] = size(criteria3);

for i=1:np

    blocks1 = find_system(mdl, criteria3{i,1}, criteria3{i,2});

    % Check the second criteria if applicable
    if (~strcmp(criteria3{i,3}, 'null'))

        disp(['**** Checking parameter [(' criteria3{i,1} ' ~= ' criteria3{i,2} ...
              ') unless (' criteria3{i,3} ' ~= ' criteria3{i,4} ')]'])

        % Find blocks in the first list that met the second criteria
        blk_list = find_system(blocks1, criteria3{i,3}, criteria3{i,4});

    else
        disp(['**** Checking parameter [' criteria3{i,1} ' ~= ' criteria3{i,2} ']'])
        blk_list = blocks1;
    end

    % Display the output
    listblocks(blk_list);

end

%-----------------------
% Function Points
%-----------------------

% Function points is a count of how many blocks there are, excluding
% inputs, outputs, and the parent block. Lists of inputs and outputs are
% subtracted from the master block list. One must be subtracted from the
% total count to account for the parent block. This routine does not check
% linked blocks or libraries.

% Get list of all blocks
blocks1 = find_system(mdl);
blocksi = find_system(mdl, 'BlockType', 'Inport');
blockso = find_system(mdl, 'BlockType', 'Outport');

% Subtract ports from master list
blk_list = setdiff(blocks1, blocksi);
blk_list = setdiff(blk_list, blockso);

[nb, junk] = size(blk_list);
disp(['**** ' num2str(nb-1) ' function points']);
[ni, junk] = size(blocksi);
disp(['**** ' num2str(ni) ' Inports']);
[no, junk] = size(blockso);
disp(['**** ' num2str(no) ' Outports']);

end

function listblocks(blocklist)
%-------------------------------------------------------------
% listblocks(blocklist)
% This function displays a list of blocks Special handling
% ensures that the full name will be printed If the array
% is empty, a message will be printed sayting that all blocks
% passed the check.
%-------------------------------------------------------------

% Loop through blocks array to display properly
[nb, junk] = size(blocklist);

% Loop only if one or more blocks
if (nb > 0)
    for j=1:nb

        % Save warning state, disable warnings (strrep doesn't really like
        % strings with returns in them)
        s = warning('query', 'all');
        warning off all

        % Remove returns and line feeds
        text_tmp = strrep(blocklist{j},10,' ');
        text_out = strrep(text_tmp,13,' ');

        % Restore warnings
        warning(s);
        
        % Use the sprintf without formatting to get all the characters
        disp(sprintf(text_out))
    end

else
    disp('     All blocks OK')
end

disp(' ')

%% Compile Outputs:
%	= -1;

end % << End of function vt_check >>

%% REVISION HISTORY
% YYMMDD INI: note
% 101026 JPG: Copied over information from the old function.
% 101026 CNF: Function template created using CreateNewFunc
% 050509 JM : Created
%**Add New Revision notes to TOP of list**

% Initials Identification: 
% INI: FullName             :  Email                :  NGGN Username 
% JM : Jann Mayer
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
