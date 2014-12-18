% SYSRD reads in ZERO/ASE data file 
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% sysrd:
%     <Function Description> 
% 
% SYNTAX:
%	[V, rho, n, m, l, ABCD, A, B, C, D, G, Bg, Dg] = sysrd(filename, outputformat, varargin, 'PropertyName', PropertyValue)
%	[V, rho, n, m, l, ABCD, A, B, C, D, G, Bg, Dg] = sysrd(filename, outputformat, varargin)
%	[V, rho, n, m, l, ABCD, A, B, C, D, G, Bg, Dg] = sysrd(filename, outputformat)
%	[V, rho, n, m, l, ABCD, A, B, C, D, G, Bg, Dg] = sysrd(filename)
%
% INPUTS: 
%	Name        	Size        Units		Description
%	filename	    <size>      <units>		Name of data file
%	outputformat	<size>      <units>		{'LTI' | {'SYSTEM'}} dictates 
%                                           output format of ABCD variable 
%                                           (Default is SYSTEM for backward
%                                           compatibility)
%
% OUTPUTS: 
%	Name        	Size		Units		Description
%	V   	        <size>		<units>		Velocity value
%	rho 	        <size>		<units>		Density value
%	n   	        <size>		<units>		number of states of the model
%	m   	        <size>		<units>		number of inputs of the model
%	l   	        <size>		<units>		number of outputs of the model 
%	ABCD	        <size>		<units>		Matrix | A B | of statescpace
%                                                  | C D | model
%	A   	        <size>		<units>		System matrix 
%	B   	        <size>		<units>		Input matrix 
%	C   	        <size>		<units>		Output matrix 
%	D   	        <size>		<units>		Direct Transmission term 
%	G   	        <size>		<units>		Control gain matrix 
%	Bg  	        <size>		<units>		Gust matrix Input of the SS
%                                           model
%	Dg  	        <size>		<units>		Gust matrix output of the SS
%                                           model
%
% NOTES:
%	<Any Additional Information>
%
% EXAMPLES:
%	% <Enter Description of Example #1>
%	[V, rho, n, m, l, ABCD, A, B, C, D, G, Bg, Dg] = sysrd(filename, outputformat, varargin)
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[V, rho, n, m, l, ABCD, A, B, C, D, G, Bg, Dg] = sysrd(filename, outputformat)
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
%	Source function: <a href="matlab:edit sysrd.m">sysrd.m</a>
%	  Driver script: <a href="matlab:edit Driver_sysrd.m">Driver_sysrd.m</a>
%	  Documentation: <a href="matlab:pptOpen('sysrd_Function_Documentation.pptx');">sysrd_Function_Documentation.pptx</a>
%
% See also <add relevant functions> 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/24
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/AeroServoElastic/sysrd.m $
% $Rev: 1715 $
% $Date: 2011-05-11 16:30:05 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [V, rho, n, m, l, ABCD, A, B, C, D, G, Bg, Dg] = sysrd(filename, outputformat)

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
V= -1;
rho= -1;
n= -1;
m= -1;
l= -1;
ABCD= -1;
A= -1;
B= -1;
C= -1;
D= -1;
G= -1;
Bg= -1;
Dg= -1;

%% Input Argument Conditioning:
% Pick out Properties Entered via varargin
% [<PropertyValue>, varargin]  = format_varargin('<PropertyValue', <Default>, 2, varargin);

%  switch(nargin)
%       case 0
%        outputformat= ''; filename= ''; 
%       case 1
%        outputformat= ''; 
%       case 2
%        
%       case 3
%        
%  end
%
%  if(isempty(outputformat))
%		outputformat = -1;
%  end
%% Main Function:
%% get infor on input arguments.  
if nargin==2
    switch outputformat
        case 'LTI' %TV: I am adding this output option
            LTI=1;
        case 'SYSTEM' %this was what it functionally used to be
            LTI=0;
        otherwise  %This outpts the same as before...
            LTI=0;
    end;
else
    LTI = 0;
end;

%% identify Sysrd being run
disp('sysrd called from directory: ');
disp(['    ' mfilename('fullpath')]);
            
%% Open file
fid = fopen(filename);
disp(['Reading file: ' filename])

%% Read and display the header
head=fgetl(fid); disp(head)
V=str2num(head(36:46)); rho=str2num(head(56:66)); 

%% Read dimensions
tmp=fgetl(fid); tmp=sscanf(tmp,'%i');

if length(tmp)==1
   n=tmp(1); m=0; l=0;
elseif length(tmp)==3
   n=tmp(1); m=tmp(2); l=tmp(3);
else
   disp(['FATAL ERROR: File ' filename ' corupt.']); return
end

%% Read state-space matrices
ABCD  = zeros(n+l,n+m);
ABCD  = fscanf(fid,'%g',[n+l,n+m]);
A=ABCD(1:n,1:n);
B=ABCD(1:n,n+1:n+m);
C=ABCD(n+1:n+l,1:n);
D=ABCD(n+1:n+l,n+1:n+m);

if LTI==1 %if we want the output in LTI Form
    ABCD=ss(A,B,C,D); 
end;

%% Read gain matrix
if head(74:80)=='VEHICLE'
    fgetl(fid);line = fgetl(fid);
    G = fscanf(fid,'%g',[m,l]);
else
    G = [];
end
%% Read gust state-space matrices
% 
fgetl(fid);line = fgetl(fid);
if ~isstr(line)
    Bg=[]; Dg=[]; return
else 
    nG2= fscanf(fid,'%g',1);
    Bg = fscanf(fid,'%g',[n,nG2]); %was Bw = fscanf(fid,'%g',[n,2]); in some previous version 
end   
fgetl(fid); line = fgetl(fid);
if ~isstr(line), Dg=[]; return,
else Dg = fscanf(fid,'%g',[l,nG2]); %was else CG = fscanf(fid,'%g',[l,2]); in some previous version
end   

%% Close file
fclose(fid);

%% Compile Outputs:
%	V= -1;
%	rho= -1;
%	n= -1;
%	m= -1;
%	l= -1;
%	ABCD= -1;
%	A= -1;
%	B= -1;
%	C= -1;
%	D= -1;
%	G= -1;
%	Bg= -1;
%	Dg= -1;

end % << End of function sysrd >>

%% REVISION HISTORY
% YYMMDD INI: note

% 101021 JPG: Copied over information from the old function.
% 101021 CNF: Function template created using CreateNewFunc
% Revised 1/13/05 Robert Miller - cleaned up to conform to Matlab style guide
% Revised 3/01/05 Travis Vetter - Cleaned up text to make sense...
% Revised 3/02/05 Travis Vetter - Allowed for outputs ABCD to be in LTI
%                                 form
% Original Author Eric Vartio 
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
