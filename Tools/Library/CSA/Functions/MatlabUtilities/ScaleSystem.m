% SCALESYSTEM Scales I/0 of statespace based on inputs
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% ScaleSystem:
%   function to scale the inputs and outputs of a system and name the 
%   inputs and outputs
% input:    sys - system to scale in LTI form			
%           ONC - OutputNameCell array in form of cell below
%			INC - InputNameCell array in form of cell below
%
% outputs:  Osys - Scaled output system with names and units
%           Kin  - Premultiplier used to multiply B matrix to modify inputs 
%                   scale
%           Kout - Premultiplir use to multiply C matrix to modric outputs 
%                   scale
%			Isys - Original System with names and units 
%
% WARNING: This function is NOT BACKWARD COMPATIBLE WITH THE PREVIOUS 
% FUNCTION
% OF THE SAME NAME! THE INPUTS ARE REVERSED!  
%  INC and ONC have following form: a Cell array data
%   Column 1(String): name to be used at input/output
%   Column 2(Number): Scale Factor to go from original to desired units 
%   Column 3(String): Original units and Direction
%	Column 4(String): Desired Final Units and Direction
% 
% SYNTAX:
%	[Osys, Kin, Kout, Isys] = ScaleSystem(sys, ONC, INC, varargin, 'PropertyName', PropertyValue)
%	[Osys, Kin, Kout, Isys] = ScaleSystem(sys, ONC, INC, varargin)
%	[Osys, Kin, Kout, Isys] = ScaleSystem(sys, ONC, INC)
%	[Osys, Kin, Kout, Isys] = ScaleSystem(sys, ONC)
%
% INPUTS: 
%	Name    	Size		Units		Description
%	sys 	     <size>		<units>		<Description>
%	ONC 	     <size>		<units>		<Description>
%	INC 	     <size>		<units>		<Description>
%	varargin	[N/A]		[varies]	Optional function inputs that
%	     		        				 should be entered in pairs.
%	     		        				 See the 'VARARGIN' section
%	     		        				 below for more details
%
% OUTPUTS: 
%	Name    	Size		Units		Description
%	Osys	    <size>		<units>		<Description> 
%	Kin 	     <size>		<units>		<Description> 
%	Kout	    <size>		<units>		<Description> 
%	Isys	    <size>		<units>		<Description> 
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
%	[osys,kin,kout,isys] = ScaleSystem(sys,INC,ONC);
%
%	% <Enter Description of Example #1>
%	[Osys, Kin, Kout, Isys] = ScaleSystem(sys, ONC, INC, varargin)
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[Osys, Kin, Kout, Isys] = ScaleSystem(sys, ONC, INC)
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
%	Source function: <a href="matlab:edit ScaleSystem.m">ScaleSystem.m</a>
%	  Driver script: <a href="matlab:edit Driver_ScaleSystem.m">Driver_ScaleSystem.m</a>
%	  Documentation: <a href="matlab:pptOpen('ScaleSystem_Function_Documentation.pptx');">ScaleSystem_Function_Documentation.pptx</a>
%
% See also GetASEModel, aserd
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/28
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/MatlabUtilities/ScaleSystem.m $
% $Rev: 1718 $
% $Date: 2011-05-11 18:07:49 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [Osys, Kin, Kout, Isys] = ScaleSystem(sys, ONC, INC, varargin)

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
% Osys= -1;
% Kin= -1;
% Kout= -1;
% Isys= -1;

%% Input Argument Conditioning:
% Pick out Properties Entered via varargin
% [<PropertyValue>, varargin]  = format_varargin('<PropertyValue', <Default>, 2, varargin);

%  switch(nargin)
%       case 0
%        INC= ''; ONC= ''; sys= ''; 
%       case 1
%        INC= ''; ONC= ''; 
%       case 2
%        INC= ''; 
%       case 3
%        
%       case 4
%        
%  end
%
%  if(isempty(INC))
%		INC = -1;
%  end
if ~isa(sys,'lti')
	error([mfilename '>>ERROR: Argument 1 must be an LTI system!!!']);
	return;
end;

if nargin ~= 3 
    disp([mfilename '>>ERROR!  Wrong number of inputs... Quiting...']);
    Osys=ss(1); Isys = sys; Kin = 1; Kout= 1;
	return;
end;
%% Main Function:
%% String input case
if ischar(ONC) 
	disp([mfnam '>>Caution: BETA FEATURE (String call to ONC of ScaleSystem!']);
	ONC = eval([ONC '()']);%CreateOutputNamesCell();
end
if ischar(INC) 
	disp([mfnam '>>Cauiotn: BETA FEATURE (String call to INC ScaleSystem!']);
	INC = eval([INC '()']);%CreateOutputNamesCell();
end
	
	
%% Begin Code
Osys = sys; Kin = 1; Kout = 1; 
Isys = sys;
%we are going to use the 2nd cell as teh gain... now, in a input we multiply by
%the inverse of the conversion specified...

%% Scale B,D
sb=size(sys.b,2);
sINC = size(INC,1);
if sb ~= sINC
    disp([mfnam '>>WARNING! Specified Sys has < ' num2str(sb) ' > inputs']);
	disp([mfspc '>>         InputNameCell has < ' num2str(sINC) ' > names/scales']);
end;
for i=1:min([sb sINC])
    Kin(i) = INC{i,2}; 
    Osys.b(:,i)=sys.b(:,i) ./ Kin(i); %divide becasue it's an input
    Osys.d(:,i)=sys.d(:,i) ./ Kin(i); %divide becasue it's an input
%     Osys.InputName{i}= INC{i,1};
    Osys.InputName{i}= [INC{i,1} '(' INC{i,4} ')']; %name New system
	Isys.InputName{i}= [INC{i,1} '(' INC{i,3} ')']; %name original system
end;

%% Scale C,D
sc = size(sys.c,1);
sONC = size(ONC,1);
if sc ~= sONC
    disp([mfnam '>>WARNING! Specified Sys has  < ' num2str(sc) ' > outputs']);
	disp([mfspc '>>         OutputNameCell has < ' num2str(sONC) ' > names/scales']);
end;

for i=1:min([sc sONC]) %always run to smallest of teh two)
    Kout(i) = ONC{i,2};
    Osys.c(i,:) = sys.c(i,:) .* Kout(i); %multiply because it is an output...
	Osys.d(i,:) = Osys.d(i,:) .* Kout(i); %multiply Alreay input adapted term! 
%     Osys.OutputName{i}= ONC{i,1};
	Osys.OutputName{i}= [ONC{i,1} '(' ONC{i,4} ')'];%name New system
	Isys.OutputName{i}= [ONC{i,1} '(' ONC{i,3} ')'];%name original system
end;

%% Closeout and Return
if sc ~=sONC && sb~=sINC
	disp([mfnam '>> ****************WARNING***********************'])
	disp([mfspc '>> THIS ERROR may be due to backward compatibiliyt issues'])
	disp([mfspc '>> Check calling function. new input order is sys,ONC,INC (with ONC first)!']);
end

%% Compile Outputs:
%	Osys= -1;
%	Kin= -1;
%	Kout= -1;
%	Isys= -1;

end % << End of function ScaleSystem >>

%% REVISION HISTORY
% YYMMDD INI: note
% 101102 JPG: Copied over information from the old function.
% 101102 CNF: Function template created using CreateNewFunc
% 070525 TKV: Changed order of inputs and added the ability to pass a 
%   filename input for ONC and INC...
% 061207:TKV: isa call to 'LTI' different then 'lti' in win vs. 
%   mac/unix->use 'lti' also updated help to include copyright see 
%   also nad example
% 060917:TKV: Changed length checking and error setup (From error to 
%   warning loop now runs on teh sthorter of the two lists
% 060917:TKV: Added output 'Isys' and cleared 4 input case 
% 060917:TKV: Modified Help / Made units show up in name
% 060803:TKV: Corrected scaling to D matrix, you must operate on the input
% corrected matrix, not just reoperate on the original matrix!
% 0602ish:EV: Added Scaling to D matrix
%**Add New Revision notes to TOP of list**

% Initials Identification: 
% INI: FullName             :  Email                :  NGGN Username 
% EV : Eric Vartio
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
