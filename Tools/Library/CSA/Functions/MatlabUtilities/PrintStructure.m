% PRINTSTRUCTURE Prints the elements of a structure
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% PrintStructure:
%     Function to Plot all the members of a structure
% 
% Inputs - var: Structure variable to print fields of.
%		 - textfname: filename to make text file 
%		 - DispVals: {[0],1}: Partially Supported
%           set to max size of data to print out 
%               
%		 
% Output - outstring: A string that lists teh fields of a strcutre
% File named <textfnam> with the output string as the body.
% 
% SYNTAX:
%	[outstring] = PrintStructure(var, textfname, DispVals, varargin, 'PropertyName', PropertyValue)
%	[outstring] = PrintStructure(var, textfname, DispVals, varargin)
%	[outstring] = PrintStructure(var, textfname, DispVals)
%	[outstring] = PrintStructure(var, textfname)
%
% INPUTS: 
%	Name     	Size		Units		Description
%	var 	      <size>		<units>		<Description>
%	textfname	<size>		<units>		<Description>
%	DispVals	 <size>		<units>		<Description>
%	varargin	[N/A]		[varies]	Optional function inputs that
%	     		        				 should be entered in pairs.
%	     		        				 See the 'VARARGIN' section
%	     		        				 below for more details
%
% OUTPUTS: 
%	Name     	Size		Units		Description
%	outstring	<size>		<units>		<Description> 
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
%	[outstring] = PrintStructure(MyStruct,'MyStruct.txt');
%   [outstring] = PrintStructure(MyStruct,'MyStructVals.txt',1);
%
%	% <Enter Description of Example #1>
%	[outstring] = PrintStructure(var, textfname, DispVals, varargin)
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[outstring] = PrintStructure(var, textfname, DispVals)
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
%	Source function: <a href="matlab:edit PrintStructure.m">PrintStructure.m</a>
%	  Driver script: <a href="matlab:edit Driver_PrintStructure.m">Driver_PrintStructure.m</a>
%	  Documentation: <a href="matlab:pptOpen('PrintStructure_Function_Documentation.pptx');">PrintStructure_Function_Documentation.pptx</a>
%
% See also struct fieldnames 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/37
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/MatlabUtilities/PrintStructure.m $
% $Rev: 1718 $
% $Date: 2011-05-11 18:07:49 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [outstring] = PrintStructure(var, textfname, DispVals, varargin)

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
% outstring= -1;

%% Input Argument Conditioning:
% Pick out Properties Entered via varargin
% [<PropertyValue>, varargin]  = format_varargin('<PropertyValue', <Default>, 2, varargin);

%  switch(nargin)
%       case 0
%        DispVals= ''; textfname= ''; var= ''; 
%       case 1
%        DispVals= ''; textfname= ''; 
%       case 2
%        DispVals= ''; 
%       case 3
%        
%       case 4
%        
%  end
%
%  if(isempty(DispVals))
%		DispVals = -1;
%  end
outstring = '';  
switch nargin
    case 1
        printfile = 0;
        DispVals = 0;
    case 2
        if ischar(textfname)
            printfile = 1;
            DispVals = 0; 
        elseif isnumeric (textfname)
            printfile = 0;
            DispVals = textfname;
        else
            disp([mfnam '>>ERROR: Can''t interpret inputs']);
            return;
        end
    case 3
        if ischar(textfname)
            printfile = 1;
        else
            disp([mfnam '>> WARNING: 2nd arg in 3 arg call should be a string.']);
            disp([mfspc '>> Ignoreing file name for output and not writing file']);
            printfile = 0;
        end
        if ~isnumeric(DispVals)
            disp([mfnam '>>WARNING: 3rd entry in 3 arg call shoudl be numeric.']);
            disp([mfspc '>> Ignoring EvalVals setting and assuming 0.  ']);
            DispVals = 0; 
        end       
end

if DispVals == 1; %set plot size to default
    DispVals = 5; % Default size of largest array to display
end 
%% Main Function:
s = fieldnames(var);
for i=1:length(s)
	if isa(var.(s{i}),'struct') && length(var.(s{i}))>1 %Test For Array of structures
		[n,m] = size(var.(s{i}));
		arraystr = [' [ ' num2str(n) 'x' num2str(m) ' struct array ]'];
		tempstr{i} = [char(s{i}) ':' arraystr PrintStructure(var.(s{i})(1),DispVals)]; %#ok<AGROW>
		tempstr{i} = [endl BlockTab(tempstr{i})]; %#ok<AGROW> %Get new line and indent
		%classname ='';
	elseif isa(var.(s{i}),'struct'); % Test for a Substruct
		tempstr{i} = [char(s{i}) ':' PrintStructure(var.(s{i}),DispVals)]; %#ok<AGROW>
		tempstr{i} = [endl BlockTab([tempstr{i}])]; %#ok<AGROW> %Get new line and indent
		%classname ='';		 
	else
		classname = class(var.(s{i}));
        classsizenum = size(var.(s{i}));
		classsize = num2str(classsizenum);
		classsize2= strrep(classsize,'  ',' '); %reduce all 2 spaces to 1
		while ~strcmp(classsize2,classsize)
			classsize = classsize2;
			classsize2 = strrep(classsize,'  ', ' '); %reduce all 2spacew by one
		end;
		classsize = strrep(classsize, ' ',','); %replace single spaces with comma
		if isa(var.(s{i}),'LTI') 
            classorder = num2str(order(var.(s{i})));
            tempstr{i} = [char(s{i}) ':(' classname '):[' classsize ']: ' classorder ' states']; %#ok<AGROW>
            if DispVals > 0
                tempstr{i} = [tempstr{i} PrintStructure(var.(s{i}),DispVals)]; %#ok<AGROW>
                tempstr{i} = BlockTab([tempstr{i}]); %#ok<AGROW> %indent
            end
        else
			tempstr{i} = [char(s{i}) ':(' classname '):[' classsize ']'];  %#ok<AGROW>
            % Should we display Values? 
            if DispVals > 0; 
                if isnumeric(var.(s{i})) && (length(classsizenum)<=2) && (max(classsizenum) <= DispVals)
                   tempstr{i} = [tempstr{i} '= ' mat2str(var.(s{i}))];  %#ok<AGROW>
                end
                switch classname
                    case 'char'
                        tempstr{i} = [tempstr{i} ': ' var.(s{i})]; %#ok<AGROW>
                    case 'cell'
                        % nop
                    otherwise
                        % nop
                end
            end
		end %isa(var.(s{i}),'LTI');
		tempstr{i} = [endl tempstr{i}]; %#ok<AGROW> %Get new line and put data
	end %if elseif 
	outstring = [outstring char(tempstr{i}) ]; %#ok<AGROW>
end %fieldname loop
%outstring = outstring(1:end-1); % We must remove the reset to teh next line 

%% If PrintFile is 1
if printfile == 1;
	fid = fopen(textfname,'wt');
	if fid <=0 
		disp([mfnam '>>ERROR: file cannot be opened']);
      return;
	end;
	if isempty(inputname(1))
		outstring = ['Argument 1 was Calculated or a SubStruct' BlockTab(outstring)];
	else
		outstring=[inputname(1) BlockTab(outstring)]; %doesn't work with structures
	end	 
   fprintf(fid,'%s',outstring);
   fclose(fid);
   open(textfname);
end;

%% Compile Outputs:
%	outstring= -1;

end % << End of function PrintStructure >>

%% Function: BlockTab 
function outstring = BlockTab(instring)
%find all \n replace with \n\t
endl = sprintf('\n');
% outstring = strrep(instring,endl,[endl sprintf('|\t')]); %old way
% NewWay:
outstring = strrep(instring,endl,[endl '|   ']); %spaces instead of tabs
linenum = strfind(outstring,'| ');
if ~isempty(linenum);
    outstring(linenum(end):linenum(end)+1) = '|_'; %update last line
end
end
%% REVISION HISTORY
% YYMMDD INI: note
% <YYMMDD> <initials>: <Revision update note>
% 101102 CNF: Function template created using CreateNewFunc
% 080604 TKV: added 3rd argument - see if it takes... Function is
% completely backwards compatible. 
% 080604 TKV: Copied from other file to this one to get all CNF features
% 080604 CNF: File Created by CreateNewFunc
% 060301 TKV:Corrected to make 1 and 2 arg call teh same output(as close as 
%       it should be) and Added Cell markers
% 060301:TKV:Corrected doubles get printed wrong format if n-D
%		BUG??: output is different if called without fielname? neccessary? 
% 060301:TKV:Modified to output size of each element
%		BUG: doubles only get printed in the proper format if they are 2-D
% TKV Modified to add a '|' at each level to help find common levels 
%       accross pages
% TKV Base File created
%**Add New Revision notes to TOP of list**

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
