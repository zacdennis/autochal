% ASERD reads *.ase files and extracts data
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% aserd:
%     reads in ZERO/ASE data file.  SYSRD(filename) where filename is the
%     name of the ZERO/ASE data file, which is the ASEOUT bulk data card (a
%     character file).
% 
% SYNTAX:
%	[Sys, Mach, V, rho, n, m, l, G, Bg, Dg, IM] = aserd(filename, verbose)
%
% INPUTS: 
%	Name        Size		Units		Description
%	filename	<size>		<units>		name of data file (Character)
%	verbose     <size>		<units>		opt(1) Set to zero if no output is
%                                           desired
%
% OUTPUTS: 
%	Name    	Size		Units		Description
%	Sys 	    <size>		<units>		LTI object of the statespace. 
%                                           Note: Sys.UserData contains all
%                                           other outputs and other info!
%	Mach	    <size>		<units>		Mach Value
%	V   	    <size>		<units>		Velocity Value 
%	rho 	    <size>		<units>		Density Value
%	n   	    <size>		<units>		Number of states of the model
%	m   	    <size>		<units>		Number of inputs of the model
%	l   	    <size>		<units>		Number of outputs of the model
%	G   	    <size>		<units>		Control Gain Matrix
%	Bg  	    <size>		<units>		Input Gust Matrix of the SS model 
%	Dg  	    <size>		<units>		Output gust matrix of the SS model
%	IM  	    <size>		<units>		Inertia matrix
%
% NOTES:
%	Additional info in file: ASE File Use and Description.doc
%
% EXAMPLES:
%	% <Enter Description of Example #1>
%	[Sys, Mach, V, rho, n, m, l, G, Bg, Dg, IM] = aserd(filename, verbose, varargin)
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[Sys, Mach, V, rho, n, m, l, G, Bg, Dg, IM] = aserd(filename, verbose)
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
%	Source function: <a href="matlab:edit aserd.m">aserd.m</a>
%	  Driver script: <a href="matlab:edit Driver_aserd.m">Driver_aserd.m</a>
%	  Documentation: <a href="matlab:pptOpen('aserd_Function_Documentation.pptx');">aserd_Function_Documentation.pptx</a>
%
% See also GetAseModel
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/26
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/AeroServoElastic/aserd.m $
% $Rev: 1715 $
% $Date: 2011-05-11 16:30:05 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [Sys, Mach, V, rho, n, m, l, G, Bg, Dg, IM] = aserd(filename, verbose, varargin)

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
% error([mfnam 'class:file:Identifier'], errstr);    % Call error function
% with error string

%% Argument Conditioning  
Sys = [];Mach = 0; V=0; rho = 0; n=0; m=0; l=0; G=[]; Bg=[]; Dg=[]; IM=[];
switch nargin
	case 0
		disp([mfnam '>>WARNING: Now input Argument: Returning Empty outputs!']);
		return;
	case 1
		verbose = 1;
	case 2
		if ~ischar(filename) || ~isnumeric(verbose)
			errormsg = [mfnam '>>****************************************' endl];
			errormsg = [errormsg mfspc '>> ERROR: Inputs are not proper type'];
			errormsg = [errormsg mfspc '>>*********************************'];
			error([mfnam ': ArgType Mismatch'],'%s',errormsg);
		end
	otherwise
		if ~ischar(filename) || ~isnumeric(verbose)
			errormsg = [mfnam '>>****************************************' endl];
			errormsg = [errormsg mfspc '>> ERROR: Too Many Inputs! '];
			errormsg = [errormsg mfspc '>>*********************************'];
			error([mfnam ': ArgType Mismatch'],'%s',errormsg);
		end
end
%% identify aserd being run
if verbose 
	disp('');
	disp([mfnam '>> ASERD called from directory: ']);
	disp([mfspc '     ' mfilename('fullpath')]);
end

%% Open file
% apend .ase if no extension given
[pathstr,name,ext] = fileparts(filename);
if strcmp(ext,'');
	filename = [filename '.ase'];
end
% Open file
fid = fopen(filename);
if fid == -1
	errormsg = [mfnam '>>********************************************************'];
	errormsg = [errormsg endl mfnam '>>ERROR: Can''t open file: ' filename]; 
	errormsg = [errormsg endl mfspc '>>From Directory: ' pwd ];
	errormsg = [errormsg endl mfnam '>>********************************************************'];
	%RETURN ERROR
	error([mfnam ':fileopen'],'%s',errormsg);
elseif verbose
	disp([mfspc '>> Reading file: ' filename])
end

%% Set Case for not able to find tag
AnyTagFound = 0; % No Tags have been found yet...
FileVersion = -1; %unspecified -> Probably old version with data at foot of file! 
FileCreatedDate = -1; %datestr(0,31); %Set No date found
Author = -1;
Description = -1;
Interface = -1;
ZAERO_run = -1;
NASTRAN_run = -1;
ModeMap = -1;
ModeMapNotes = -1;
RBRefAx = -Inf;
RBIM_modes = -1;
RBIM = -1;
VehMass = -1;
CGpos = -Inf;
IMCG = -1;

%% READ: File Begin 
% Read File, Skip Comments, End When 'ASE=' is found. Before thatgrab tags and 
% compare to a given set.
UnitStr = ''; %Setup Empty Units String
CustUnitStr = ''; % Empty Cust Tag Unit String;
while 1 
	[isC,Lstr,Rstr,clnpos] = ParseLine(fgetl(fid)); % Parse Line
	if isC == -1
		break
	elseif isC == 1; %if the line is a comment skip it and move on
		continue
	elseif findstr('ASE=',Lstr); 
		%we have reached the end of the tag section 
		break
	end
	%We now have parsed the line and it is a cleaned tag line
	switch Lstr
%% READ:SWITCH: File Data
		case 'FileVersion'  
			FileVersion = str2double(Rstr);
			AnyTagFound = 1;
		case 'File Created' 
			FileCreatedDate = Rstr;
			AnyTagFound = 1;
		case 'Author' 
			Author = Rstr;
			AnyTagFound = 1;
		case 'Description' %'NotFound';
			Description = Rstr;
			AnyTagFound = 1;
		case 'Interfaces' %'NotFound';
			Interface = Rstr;
			AnyTagFound = 1;
		case 'ZAERO run' % 'NotFoune';	
			ZAERO_run = Rstr;
			AnyTagFound = 1;
		case 'NASTRAN run' %'NotFound'
			NASTRAN_run = Rstr;
			AnyTagFound = 1;
		case 'Mode Map' %[0 0 0 0];
			ModeMap = sscanf(Rstr,'%g')';
			if isnan(ModeMap) 
				errorstr = [mfnam '>>CAUTION: Mode Map argument has improper format!'];
	%             error([mfnam ':ModeMap'],'%s',errormsg);
				Info.ModeMapCaution = errorstr;
				disp(errorstr);
			end
			AnyTagFound = 1;
		case 'Mode Map Notes'
			ModeMapNotes = '';
			IsC = 1; %Start Read of Section
			fpos = ftell(fid); %save position at end of Tag Line
			while IsC
				[IsC, Lstr] = ParseLine(fgetl(fid)); %What if we get to EOF?
				if IsC == 1 && ~isempty(Lstr) %a empty line breaks teh designtated note
					ModeMapNotes = [ModeMapNotes Lstr endl]; %Append and lineFeed
					fpos = ftell(fid); %update 'last good' positon to end of last read
				elseif IsC == 0 || isempty(Lstr) 
					ModeMapNotes = ModeMapNotes(1:end-1); %Remove last line feed from ModeMapNotes
					fseek(fid,fpos,'bof'); %move to end of last good to reread next line -> may be a tag!
					IsC = 0; % break loop since end of valid note reached
				elseif IsC == -1|| findstr('ASE=',Lstr)% EOF or 'ASE' Found!
					fclose(fid); %Close file before exit
					errorstr = [mfnam '>>ERROR! - EOF/ASE Reached while looking for Vehicle Mass After Tag!'];
					error([mfnam ': Invalide File Format'],'%s',errorstr);
				end
			end
			AnyTagFound = 1;
%% READ:SWITCH: RigidBody Terms	
		case 'RigidBody Reference Axis' %RBRefAx = 0;
			RBRefAx_units = GetUnitStr(Rstr); % recover units from String to right of Colon
			[IsC,Lstr] = ParseLine(fgetl(fid));
			while IsC
				[IsC, Lstr] = ParseLine(fgetl(fid));
				if IsC == -1 || findstr('ASE=',Lstr) %EOF / ASE FOUND!
					fclose(fid); %Close file before error
					errormsg = [mfnam '>> ERROR! - EOF/ASE reached while looking for Vehicle Mass After Tag!'];
					error([mfnam ': Invalid File Format'],'%s',errormsg);
				end
			end
			RBRefAx = sscanf(Lstr,'%g')'; % Convert read line to matrix
			% 			for i=1:3
			% 				RBRefAx(i) = fscanf(fid,'%g',1);
			% 			end
			% RBRefAx = fscanf(fid,'%g',3); % Which one of these works?  
			UnitStr = [UnitStr 'RBRefAx:' RBRefAx_units ' '];
			AnyTagFound = 1;
		
		case 'RigidBody Inertia Matrix' % RBIM = 0;
			RBIM_units = GetUnitStr(Rstr);
			%now get Mode Names
			[IsC,Lstr,Rstr,ClnPos]  = ParseLine(fgetl(fid));
			if IsC || isempty(ClnPos) || isempty(Rstr)
				fclose(fid); %close open file
				errormsg = [mfnam '>> *****************************************' endl];
				errormsg = [errormsg mfspc '>>ERROR! - Invalid File format: line after "RigidBody Inertia Matrix" must not be a comment and must contain a colon (folowed by the RB mode list)'];
				error([mfnam ':Invalid RBIM Info Line'],'%s',errormsg); %EXIT with Error
			end
			RBIM_modes = Rstr; % Gets the Mode Direction/Names
			% Get teh size the matrix should be based on number of Modes
			rbimsize = length(findstr(' ',strtrim(RBIM_modes)))+1;
			%Now Read Matrix 
			try
				RBIM  = fscanf(fid,'%g',[rbimsize,rbimsize]);	
			catch
				RBIM = -1; 
				disp([mfnam '>>WARNING: could not read Rigid Body Interta Matrix!']);
			end
			UnitStr = [UnitStr 'RBIM:' RBIM_units ' '];
			AnyTagFound = 1;
			
		case 'Vehicle Mass'
			Mass_units = GetUnitStr(Rstr);
			%get Value
			[IsC, Lstr] = ParseLine(fgetl(fid));
			while IsC
				[IsC, Lstr] = ParseLine(fgetl(fid)); %What if we get to EOF? 
				if IsC == -1|| findstr('ASE=',Lstr)% EOF or 'ASE' Found!
					fclose(fid); %Close file before exit
					errorstr = [mfnam '>>ERROR! - EOF/ASE Reached while looking for Vehicle Mass After Tag!'];
					error([mfnam ': Invalide File Format'],'%s',errorstr);
				end
			end
			VehMass = sscanf(Lstr,'%g'); %Get String already stored in Lstr
			UnitStr = [UnitStr 'VehMass:' Mass_units ' '];
			AnyTagFound = 1;
		
		case 'Center of Gravity Location'
			CGpos_units = GetUnitStr(Rstr);
			%get value
			[IsC,Lstr] = ParseLine(fgetl(fid));
			while IsC
				[IsC,Lstr] = ParseLine(fgetl(fid));
				if IsC == -1 || findstr('ASE=',Lstr)% EOF or 'ASE' Found!
					fclose(fid); %Close file before error
					errorstr = [mfnam '>>ERROR! - EOF/ASE Reached while looking for CG Location After Tag!'];
					error([mfnam ': Invalide File Format'],'%s',errorstr);
				end
			end
			CGpos = sscanf(Lstr,'%g')'; 
			UnitStr = [UnitStr 'CGpos:' CGpos_units ' '];
			AnyTagFound = 1;
	
		case 'Inertia Matrix about CG'
			IMCG_units = GetUnitStr(Rstr);
			fileposition = ftell(fid);
			IsC = ParseLine(fgetl(fid));
			while IsC
				fileposition = ftell(fid);
				[IsC,Lstr] = ParseLine(fgetl(fid));
				if IsC == -1 || findstr('ASE=',Lstr)% EOF or 'ASE' Found!
					fclose(fid); %Close file before error
					errorstr = [mfnam '>>ERROR! - EOF/ASE Reached while looking for Inertia Matrix After Tag!'];
					error([mfnam ': Invalide File Format'],'%s',errorstr);
				end
			end
			fseek(fid,fileposition,'bof'); %datafound, go to previous line 
			IMCG = fscanf(fid,'%g',[3,3]);
			UnitStr = [UnitStr 'IM_CG:' IMCG_units ' '];
			AnyTagFound = 1;

		otherwise %no predefined tags found!
			if ~isempty(clnpos)
				try
					TagName = genvarname(Lstr);
					TagUnits = GetUnitStr(Rstr);
					if isempty(TagUnits)
						CustTag.(TagName) = Rstr;
						if verbose
							disp([mfspc '>>CustomTag: ' TagName ': ' CustTag.(TagName)]);
						end
					else
						CustUnitStr = [CustUnitStr TagName ':' TagUnits ' '];
						CustTag.(TagName) = fscanf(fid,'%g');
						if verbose
							datalength = length(CustTag.(TagName));
							if datalength <= 3
								disp([mfspc '>>CustomTag: ' TagName ':(' TagUnits ')' mat2str(CustTag.(TagName))]);
							else
								disp([mfspc '>>CustomTag: ' TagName ':(' TagUnits ') DataLength: ' mat2str(size(CustTag.(TagName))) ]);
							end
						end
					end
					AnyTagFound = 1; %Correct Place
				catch
					disp([mfnam '>>Caution: Unknown Tag Found, Invalid format']);
				end
			else
				disp([mfnam '>>Caution: Unidentified unformated tag found!']);
				disp([mfspc '  The Comment character is a "%"!']);
			end
% 			AnyTagFound = 1; WRONG PLACE
	end
end

%% Display Data/Warnings
if verbose && AnyTagFound == 1;
	% FileVersion
	if FileVersion == -1
		disp([mfspc '>>WARNING: "FileVersion" not found in: ' filename]);
	elseif isempty(FileVersion)
		disp([mfspc '>>Caution: "FileVersion" is empty in: ' filename]);
	else
		disp([mfspc '   FileVersion : ' num2str(FileVersion)]);
	end
	% FileCreateDate = datestr(0,31); %Set No date found
	if FileCreatedDate == -1 
		disp([mfspc '>>WARNING: "File Created" not found in: ' filename]);
	elseif isempty(FileCreatedDate)
		disp([mfspc '>>Caution: "File Created" Tag is empty in: ' filename])
	else
		disp([mfspc '   File Created: ' FileCreatedDate]);
	end
	% Author = '';
	% Description 
	if Description == -1
		disp([mfspc '>>WARNING: "Description" not found in: ' filename]);
	elseif isempty(Description)
		disp([mfspc '>>Caution: "Discription" is emtpy in: ' filename]);
	else
		disp([mfspc '   Description : ' Description]);
	end	
	% Interface = '';
	if Interface == -1
		disp([mfspc '>>WARNING: "Interfaces" not found in: ' filename]);
	elseif isempty(Interface)
		disp([mfspc '>>Caution: "Interfaces" is empty in: ' filename]);
	else
		disp([mfspc '   Interface  : ' Interface]);
	end	
	% ZAERO_run = '';
	if ZAERO_run == -1
		disp([mfspc '>>WARNING: "ZAERO Run" not found in: ' filename '!']);
	elseif isempty(ZAERO_run)
		disp([mfspc '>>Caution: "ZAERO Run" found but empty in: ' filename ]);
	else
		%no op
	end
	% NASTRAN_run = '';
	if NASTRAN_run == -1
		disp([mfspc '>>WARNING: "NASTRAN run" not found in: ' filename '!']);
	elseif isempty(NASTRAN_run)
		disp([mfspc '>>Caution: "NASTRAN run" found but empty in: ' filename ]);
	else
		%no op
	end
	% ModeMap = [];
	if ModeMap == -1 
		disp([mfspc '>>WARNING: "Mode Map" not found in: ' filename]);
	else
		disp([mfspc '   ModeMap     : ' num2str(ModeMap)]);
	end
	if ModeMapNotes == -1
		disp([mfspc '>>WARNING: "Mode Map Notes" not found in: ' filename]);
	elseif isempty(ModeMapNotes)
		disp([mfspc '>>Caution: ModeMapNotes is empty in: ' filename]);
	else
		disp([mfspc '   ModeMapNotes: O.K. ' num2str(length(findstr(ModeMapNotes,endl))+1) ' Lines Found.' ]);
	end
	% RBRefAx
	if isinf(RBRefAx)
		disp([mfspc '>>WARNING: "RigidBody Reference Axis" not found in: ' filename]);
		%RBRefAx = -1;
	elseif isempty(RBRefAx)
		disp([mfspc '>>WARNING: "RigidBody Reference Axis" is empty!']);
	else
		disp([mfspc '   Rigid Body Ref Axis Origin :(' RBRefAx_units ') ' num2str(RBRefAx)]); 
	end;
	% Rigid Body Inertia Matrix
	if RBIM == -1
		disp([mfspc '>>WARNING: "RigidBody Inertia Matrix" not found in: ' filename]);
	elseif isempty(RBIM)
		disp([mfspc '>>WARNING: "RigidBody Inertia Matrix" was empty in: ' filename]);
	else
		disp([mfspc '   RigBody Inert of Flex modes:(' RBIM_units ')     Size is: ' mat2str(size(RBIM)) ] ); 	
	end
	% VehMass 
	if VehMass == -1
		disp([mfspc '>>WARNING: "Vehicle Mass" Not found in: ' filename]);
	elseif isempty(VehMass)
		disp([mfspc '>>Caution: "Vehicle Mass" Found but empty in: ' filename]);
	else
		disp([mfspc '   Vehicle Mass Was Found     :(' Mass_units ') ' num2str(VehMass)]);
	end
	% CG Position
	if isinf(CGpos)
		disp([mfspc '>>WARNING: "Center of Gravity Location" not found in: ' filename]);
		%CGpos = -1;
	elseif isempty(CGpos)
		disp([mfspc '>>Caution: "Center of Gravity Location" found but empty in: ' filename]);
	else
		disp([mfspc '   Center of Gravity Location :(' CGpos_units ') ' num2str(CGpos)]);
	end
	% RBIM
	if RBIM == -1
		disp([mfspc '>>WARNING: "RigidBody Inertia Matrix" not found in: ' filename]);
	elseif isempty(RBIM)
		disp([mfspc '>>Caution: "RigidBody Inerita Matrix" found but empty in: ' filename]);
	else
		disp([mfspc '   Rot Inertia Matrix about CG:(' RBIM_units ')    Size is: ' mat2str(size(RBIM))]); 
	end
end %verbose

%% Read Header
% We should have the ASE line in Lstr now
Header = Lstr;
if Header == -1; %EOF Reached without finding ASEline
	fclose(fid);
	errormsg = [mfnam '>>***************************************************'];
	errormsg = [errormsg endl mfspc '>>ERROR: File Found but "ASE=" Line not found!'];
	error([mfnam ':NoASELine'],'%s',errormsg); %This will exit with error
else
	DimensionLine = fgetl(fid); %now get the Dimension line and save it.
end

if AnyTagFound == 1
%% Read Header & Dimensions
	% If we are here, we believe we have found the header line 
	% Read ASE Line
	%The position assume there is 1 leading zero which was removed by ParseLine
	Header = [' ' Header]; 
	if verbose
		disp([mfspc '>>' Header]);
	end
	Mach = str2double(Header(20:31));
	V    = str2double(Header(36:46)); 
	rho  = str2double(Header(56:66)); 

	% Read Dimensions
	tmp=sscanf(DimensionLine,'%i'); %get numbers
	if length(tmp)==1
	   n=tmp(1); m=0; l=0;
	elseif length(tmp)==3
	   n=tmp(1); m=tmp(2); l=tmp(3);
	else
		fclose(fid); %close open file
	% 	disp(['FATAL ERROR: File ' filename ' corupt.']); return
		errormsg = [mfnam '>>******************************************'];
		errormsg = [errormsg endl mfspc '>> ERROR: Corrupt Dimesions***'];
		error([mfnam ':InvalidDimensions'],'%s',errormsg); %This will exit with error
	end

%% Read state-space matrices
	% ABCD  = zeros(n+l,n+m);
	ABCD  = fscanf(fid,'%g',[n+l,n+m]);
	A=ABCD(1:n,1:n);
	B=ABCD(1:n,n+1:n+m);
	C=ABCD(n+1:n+l,1:n);
	D=ABCD(n+1:n+l,n+1:n+m);

	Sys=ss(A,B,C,D); %convert to statespace

%% Read gain matrix
	% if strcmp(Header(74:80),'VEHICLE')
	if strfind(Header(70:end),'VEHICLE');%loosen search and use more robust search
		fgetl(fid);%I guess this Jumps over the "G" Matrix name when a "VEHICLE" is designated
		fgetl(fid);%I guess this Jumps over the "G" Matrix name when a "VEHICLE" is designated
		G = fscanf(fid,'%g',[m,l]);
	else
		G = [];
	end

%% Read gust state-space matrices 
	% This is the old method,(Very Clumsy -> how did eric do it?  
	while 1
		[IsC,Lstr] = ParseLine(fgetl(fid));
		if IsC == -1; %EOF
			Bg = []; Dg = []; %if you can't find a Bg there shouldn't be a Dg!
			break
		end
		if strfind(Lstr,'GUST MATRIX Bpw'); % Found Gust Header
			nG2 = fscanf(fid,'%g',1);
			Bg = fscanf(fid,'%g',[n,nG2]);%was Bw = fscanf(fid,'%g',[n,2])); in some previous version
			%% now look for Dg (this won't happen unless bg has been found...)
			while 1
				[IsC,Lstr] = ParseLine(fgetl(fid));
				if IsC == -1; %EOF
					Dg = [];
					disp([mfnam '>>ERROR: BGust found but Dgust not found! in: ' filename]);
					return;	
				end
				if strfind (Lstr, 'GUST MATRIX CGa');
					Dg = fscanf(fid,'%g',[l,nG2]);
					break
				end %search for Dg
			end %While search for Dg
		end %if Bg
	end %While search for Bg
end %If AnyTagFound == 1;
%% Close file
fclose(fid);

%% Validate Mode Map
% Validate teh mode map to the nmber of states
% This does not guarantee the order and may become defunct, but in teh meantime
% Th eqn is: n1 + n2 + n1 + n2 + (n1+n2)*n3 + n4*n5 + n6 == size(A)
if length(ModeMap) == 6 %did you read a mode map?  
	nbar = ModeMap(1)*2+ModeMap(2)*2 + (ModeMap(1)+ModeMap(2))*ModeMap(3) + ModeMap(4)*ModeMap(5) + ModeMap(6);
	if nbar ~= n && verbose 
		disp([mfspc '>>CAUTION: ModeMap is invalid!  It does not match size(A)! '])
	end
end
% Note: The mode map section may be modified over time... i am just not sure 
% how stable it is since the modeling is still varied... 

%% write data to Sys.UserData
%FModel Explanation Components
Sys.UserData.SrcFile = name; %Gets Name of file without path
Sys.UserData.Desc = Description;
Sys.UserData.Interface.Name = Interface;
Sys.UserData.Modes.Map = ModeMap;
Sys.UserData.Modes.MapNotes = ModeMapNotes;
Sys.UserData.Mach = Mach;
Sys.UserData.V = V;
Sys.UserData.rho = rho;
%Mass Properties 
Sys.UserData.RefAxis = RBRefAx;
Sys.UserData.FlexModeRB_Names = RBIM_modes;
Sys.UserData.FlexModeRBInert_Ref = RBIM;
Sys.UserData.Mass = VehMass;
Sys.UserData.CGpos = CGpos;
Sys.UserData.InertiaMatrix_CG = IMCG;
% Units
Sys.UserData.Units = UnitStr;
% Source File Information
Sys.UserData.SrcFileInfo.Name = filename;
Sys.UserData.SrcFileInfo.Version = FileVersion;
Sys.UserData.SrcFileInfo.CreatedDate = FileCreatedDate;
Sys.UserData.SrcFileInfo.Author = Author;
Sys.UserData.SrcFileInfo.ZAERO_run = ZAERO_run;
Sys.UserData.SrcFileInfo.NASTRAN_run = NASTRAN_run;

% This outputs the custom tags/ values
if exist('CustTag','var')
	Sys.UserData.CustTags = CustTag;
	Sys.UserData.CustTags.Units = CustUnitStr;
else
	Sys.UserData.CustTags = [];
end

% Other Info
Sys.UserData.G = G;
Sys.UserData.bg = Bg;
Sys.UserData.dg = Dg;

%% OLD VERSION Contingincy
% This section tests to see if the ase file opened was an old format. 
% It detects this by teh absence of any tags above the ase line.  if so it
% calls the old version of teh aserd file(which has been renamed aserd_old) and
% uses that output here.  It concatinates teh userdata section from both
% function calls, overwriting this function with values found in the other
% fucntion.  To do this it uses the function catstruct from matlab central.  
if AnyTagFound == 0;
	disp([mfnam '>>********CAUTION ************ CAUTION *******']);
	disp([mfnam '>>CAUTION: No Header Tags Found! Closing File.  Will call the old version of aserd and will use that output.!']);
	disp([mfspc '>>Suggest: Update This file to new version! Find fils ASE_File_Readme.txt']);
	disp([mfspc '>>NOTE: Fieldnames in this mode will be dramatically out of order.  ']);
	disp([mfspc '>>********************************************']);
	
	%Call old aserd
	[SysOld,Mach,V,rho,n,m,l,G,Bg,Dg,IM]=aserd_old(filename); 
% 	disp([mfnam '>> Ignore this warning... ']);
	temp = warning('query','catstruct:DupFieldnames'); %Get Current warning State
	warning('off','catstruct:DupFieldnames'); %Set Current warning state to off
	Sys.UserData = catstruct(Sys.UserData, SysOld.UserData); %Concatenate structure (will issue warning)
	warning(temp);
% 	warning(temp); % Return to normal warning state
	
end
	
%% Return
if verbose 
	disp([mfnam '>> ASERD completed.']);
end
return;
 
%% SubFunction: ParseLine
function [isC,Lstr,Rstr,clnpos] = ParseLine(TestLine)
%isC=1 if line is a comment (first non space character = %
%Lstr is teh tag after a 'strtrim' call of the string to the left of the ':'
%Rstr is the tag after a 'strtrim' call of the string to the right of the ':'
%clnpos = positio of the first colon in line if not a comment else = -1;
% Check for empty line
	if TestLine == -1 %EOF?
		isC = -1; 
		Lstr = ''; Rstr = ''; clnpos = -1;
		return;
	elseif ischar(TestLine) % This function doesn't take Cells... (Should it?)
		TestLine = strtrim(TestLine); %Clean up lines (remove spaces)
	end
	% Test for Empty LInes (or lines that were only spaces!
	if isempty(TestLine)
		isC = 1;
		Lstr = ''; Rstr = ''; clnpos = -1;
		return
	end
	%Check for comments
 	isC = regexp(TestLine,'\s*%.*','once');
	if (isC == 1) % If is is a comment set outputs and return
		isC = 1; % For when line was empty
		clnpos = -1;
		Lstr = TestLine;
		Rstr = '';
		return
	else % There is some content to the line
		if ~isempty(isC) %Remove Anything after a '%' from content
			TestLine = TestLine(1:isC);
		end;
		isC = 0;
		% Find Colon Position to parse content
		clnpos = findstr(':',TestLine);
        if isempty(clnpos)
            Lstr = TestLine; %strtrim has already been called
            Rstr = '';
		else %there is at least one colon in TestLine
			clnpos = clnpos(1); % be careful incase there are >1 colon! 
            Lstr = strtrim(TestLine(1:clnpos-1));
            Rstr = strtrim(TestLine(clnpos+1:end));
        end
	end
return;
 
%% SubFunction: GetUnitStr
function [UnitStr] = GetUnitStr(str)
%Pass this function whatever is to the right of the colon and it will
%return the string between the '()'
	try 
        openparen = strfind(str,'(');
        closeparen = strfind(str, ')');
        UnitStr = str(openparen+1:closeparen-1);
    catch
        UnitStr = 'Unk';
	end	
return;
% 
% end % << End of function aserd >>

%% REVISION HISTORY
%Hard Data Check: on ASEData
%Hard Data Check: on GUST Data is imperative

% NEW REVISION NOTES GO ON TOP OF LIST!!!!

% YYMMDD INI: note
% 101021 JPG: Copied over information from the old function.
% 101021 CNF: Function template created using CreateNewFunc
% 070530 TKV: BugFix Added Default value to RBIM_modes -1 
%           : No Longer reads file if no tags found -> Calls aserd_old
%			: updated warning and outputs in call aserd_old case.  
% 070525 TKV: Added Blank Cust Tags output and modified other ouptu names for
% better compatibility with GetASEModel
%			: Added RBMOdeRB_Names to output structure
%			: Added a Mode Map Check (only on verbose)
%			: Corrected bug to allow output of CustTags
%           : Delineated between "empty fields and "not found" in verbose output
%           : Added ModeMapNotes Tag and comment to assumed tags
% 070219 TKV: updated Help and added Enhancment list
% 070219 TKV: Added Feature to call old version if no tags are found
% 070216 TKV: Added Feature to tage Custom Tags
% 070216 TKV: Beta 1 of new format...
% 070204 TKV: MASSIVE REVISION to new *.ase format (backward compatibility
%              through conversion utility (not yet written))
% 061128 TKV: Revision to append .ase if no extension givin 
% 061128 TKV: Revision to accept comment lines as not counting! NGC header
% 060926 TKV: Optimization improvements to reduce MLINT notes (should only be
%				index growth.
% 060926 TKV: Dramatic mods to unit handling, now includedin model! Also, output
%				Fieldnames have been updated and Weight is no longer included as
%				MASS is used instead. 'Units' Field added to output
% 060915 TKV: Dramatic modification to how Gust terms are read - Corrects error
%				if they weren't there... 
% 060830 TKV: Can now read any size square matrix for RigidBody Inertia
% 060829 TKV: Correcte and modified error output for can't find file
% 060829 TKV: Reorganized Revision History
% 060802 TKV: Corrected bug with output I -> changed to IM and initialized.
% 060728 TKV: Updated Error displays for no Appendix data
% 060727 TAQ: moved all unit conversions out of file...
% 060725 TAQ: Added Error outputs if string is not found  
% 060725 TAQ: Added ftell, fseek, and an error message to match line #50
% 060705 TAQ: Added Reference Axis, Vehicle Weight, Center of Gravity
%             Location, Moment of Inertia Matrix
% 060629 TAQ: Added RidgiBody Interia Matrix
% 060621 TKV: Added Directory to error file open error trap
% 060621 TKV: Added Error Trapping for file open error
% 060602 TKV: Changed to aserd and only outputs LTI System 
% Revised 060602 TKV: Outputs Mach at end of outputs, uses str2double instead of
%			str2num
% Revised 1/13/06 Travis Vetter - Made to output calling directory.
% Revised 3/02/05 Travis Vetter - Allowed for outputs ABCD to be in LTI form
% Revised 3/01/05 Travis Vetter - Cleaned up text to make sense...
% Revised 1/13/05 Robert Miller - cleaned up to conform to Matlab style
% guide
%
% Original Author Eric Vartio
% Converted by Travis Vetter

%**Add New Revision notes to TOP of list**

% Initials Identification: 
% INI: FullName             :  Email                :  NGGN Username 
% JPG: James Patrick Gray   :  james.gray2@ngc.com  :  g61720
% TAQ: Teresa Quinliven     :  
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
