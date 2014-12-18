% DISPVALNAME Displays a vector of values associated with cell/array of names
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% DispValName:
% Displays values in first arguement with names in second argument. Useful with
% the state, input and output names when working with simulink 'model'
% calls or other named list arrangements. 
% 
% Inputs - Values:{values, -1} A vector of values, a '-1' plots idx and names
%		 - Names: A cell or string array of names
%		 - strlen:{uInt}( :-2] Displays LAST	strlen characters of Names
%			   <Default>[  -1] Displays ENTIRE	characters of Names 
%						[ 0  ] Displays NO		characters of Names 
%						[1:  ) Displays FIRST	strlen characters of Names 
%
% Outputs- OutStr: The text (with numbers) that would be displayed if no
%           ouput argument is given.  
%
% SYNTAX:
%	[outstr] = DispValName(val, nam, namlen, varargin, 'PropertyName', PropertyValue)
%	[outstr] = DispValName(val, nam, namlen, varargin)
%	[outstr] = DispValName(val, nam, namlen)
%	[outstr] = DispValName(val, nam)
%
% INPUTS: 
%	Name    	Size		Units		Description
%	val 	     <size>		<units>		<Description>
%	nam 	     <size>		<units>		<Description>
%	namlen	  <size>		<units>		<Description>
%	varargin	[N/A]		[varies]	Optional function inputs that
%	     		        				 should be entered in pairs.
%	     		        				 See the 'VARARGIN' section
%	     		        				 below for more details
%
% OUTPUTS: 
%	Name    	Size		Units		Description
%	outstr	  <size>		<units>		<Description> 
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
%	[outstr] = DispValName(x0,str,5); % Display values in x0 along side first 5 
%                                       characters of str, and writes it to 
%                                       the output only;
%              DispValname(x0,str,-4); %Diplay values in x0 along side last
%                                       4 characters of str
%
%	% <Enter Description of Example #1>
%	[outstr] = DispValName(val, nam, namlen, varargin)
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[outstr] = DispValName(val, nam, namlen)
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
%	Source function: <a href="matlab:edit DispValName.m">DispValName.m</a>
%	  Driver script: <a href="matlab:edit Driver_DispValName.m">Driver_DispValName.m</a>
%	  Documentation: <a href="matlab:pptOpen('DispValName_Function_Documentation.pptx');">DispValName_Function_Documentation.pptx</a>
%
% See also model, disp, sprintf 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/50
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/SimulinkUtilities/DispValName.m $
% $Rev: 1726 $
% $Date: 2011-05-11 19:02:15 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [outstr] = DispValName(val, nam, namlen, varargin)

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
outstr= -1;

%% Input Argument Conditioning:
% Pick out Properties Entered via varargin
% [<PropertyValue>, varargin]  = format_varargin('<PropertyValue', <Default>, 2, varargin);

%  switch(nargin)
%       case 0
%        namlen= ''; nam= ''; val= ''; 
%       case 1
%        namlen= ''; nam= ''; 
%       case 2
%        namlen= ''; 
%       case 3
%        
%       case 4
%        
%  end
%
%  if(isempty(namlen))
%		namlen = -1;
%  end
if nargin == 1
		nam = [];
		namlen= -1; %zero => all plot
elseif nargin == 2;
	namlen = -1;
elseif nargin == 3;
	if namlen == 0 %this is an invalid length.
		nam = []; %make name empty
		namlen = -1; %set to full length (of all empty strings)
	end
else
	error([mfnam '>> Invalid number of input arguments (>3)']);
end

%Check input values to see if it is an "ignore" flag...
%flag to say "just number the names" - uses all -1's for valuess
if  isempty(val) || all(val == -1)
	val = -ones(length(nam),1);
end

% Get length of val input
lenVal = length(val);

% Check if empty string passed as name, means don't display any Names
if isempty(nam)
    for i=1:lenVal
		nam{i} = '';
    end
end
if ischar(nam)
    nam = cellstr(nam); %convert to cell array of strings
end
    
% check lengths to see if either needs to be augmented to make function work
if length(nam) < lenVal
    errstr = [mfnam '>>Warning: Length of names < length of values: Augmenting'];
    disp(errstr);
    for i=length(nam)+1:lenVal
        nam{i} = '<exess>';
        disp([bksp '.']);
    end;
    disp([bksp 'done']);
elseif length(nam) > lenVal
    errstr = [mfnam '>>Caution: Length of Value > Length of Names...'];
    disp(errstr);
end

% Check for empty elements internal to name list cell array
emptyspots = find(cellfun('isempty',nam));
if ~isempty(emptyspots)
    for i=emptyspots
    nam{i} = '<undef>';
    end
end

%% Main Function:
%% get lengths of values represened as strings
valstr = cell(lenVal,1); % Preallocate
lenvalstr=zeros(lenVal,1); % Preallocate
for i=1:lenVal
	valstr{i} = sprintf('%g',val(i));
	lenvalstr(i) = length(valstr{i});
end
%find longest value of valstr - How many spaces to reserve for the longest value
maxvalstrlen = max(lenvalstr);
valformatstr = ['%' num2str(maxvalstrlen) 'g'];

%% get length index format string
%This specifies how many spaces to save for the index
lennum=ceil(log10(lenVal));
idxformatstr = [' :[%' num2str(lennum) 'g]: '];

%% Assymble string
outstr = [char(ones(1,lennum-1))*spc '#']; % outstr is a temp here..
outstr=[char(ones(1,max([maxvalstrlen-6,1])))*spc 'Values:[' outstr ']:Names'];

numstr = cell(lenVal,1); % Preallocate
if namlen == -1 %unlimited name length
	for i=1:lenVal;
		valstr{i} = sprintf(valformatstr,val(i));
		numstr{i} = sprintf(idxformatstr,i);
		outstr = [outstr endl valstr{i} numstr{i} nam{i}]; %#ok<AGROW>
	end
elseif namlen > 1 && namlen < intmax % If NamLen>1 -> use begining characters
	for i=1:lenVal
		valstr{i} = sprintf(valformatstr,val(i));
		numstr{i} = sprintf(idxformatstr,i);
		outstr = [outstr endl valstr{i} numstr{i} nam{i}(1:min([namlen length(nam{i})]))]; %#ok<AGROW>
	end
elseif namlen < -1 && namlen > -intmax % If NamLen < -1 -> Use end characters
	namlen = -namlen -1; %correct to positive and offset one
	for i=1:lenVal
		valstr{i} = sprintf(valformatstr,val(i));
		numstr{i} = sprintf(idxformatstr,i);
		outstr = [outstr endl valstr{i} numstr{i} nam{i}(max([end-namlen 1]):end)];%#ok<AGROW>
	end
else
	errorstr([mfnam '>>Internal Error: Can''t Determine how to plot output. Check input order and values']);
	error(errorstr);
end

%% Outputs
if nargout == 0 
	disp(outstr)
end

%% Compile Outputs:
%	outstr= -1;

end % << End of function DispValName >>

%% REVISION HISTORY
% YYMMDD INI: note
% 101101 JPG: Copied over information from the old function.
% 101101 CNF: Function template created using CreateNewFunc
% 071203 TKV: Updated the Help to match function behavior. Added
% preallocation for speed and noted mlint flags.
% 071003 TKV: Corrected bug in Argument Checking of line55
% 070729 TKV: Updated to accept empty vals (when you dont' care) and to
% accept character arrays for the Names (internally converted to CellArray
% of strings
% 070306 TKV: Updated to 3 input args, output now based on nargout: 3rd 
%              argument can now display begining or end of string based on 
%			   sign: Improved error checking and use of 0 len output: this 
%			   is a potential submission to the vsi library
% 070228 TKV: Added -1 flag to first input -> ignores values and plots 
%              numbered names
% 070128 TKV: added row number in center column
% 070127 TKV: Right Justified "Values"
% 070127 TKV: correcte "... " to not have extra '.'s and no space. 
% 070127 TKV: Created file
% *Add New Revision notes to TOP of list*

% Initials Identification: 
% INI: FullName             :  Email                :  NGGN Username 
% JPG: James Patrick Gray   :  james.gray2@ngc.com  :  g61720
% TKV: Travis Vetter        :  travis.vetter@ngc.com:  vettetr

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
