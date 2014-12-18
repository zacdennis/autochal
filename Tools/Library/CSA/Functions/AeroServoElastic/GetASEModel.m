% GETASEMODEL Reads and scales an ASEFile into MATLAB
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% GetASEModel:
% Uses the local(directory) of the ASE file) copies of GetInputNamesCell
% and GetOutputNamesCell as well as a local copy of aserd if possible.  
% The filename must include the path and filename from the current 
% working directory.
%
%**************************************************************************
%#NOTE: Header Copied directly from old file.
%**************************************************************************
% Inputs - Filaname(*)- Filename of ase files
%		 -(opt)CreatOutputNames(s,c)- Name of Function to create Output Names
%		 Cell or the ONC
%        -(opt)CreatInputNames(s,c)- Name of Function to create Input Names
%        Cell or the INC
%		 -(opt)FnameMF - string {['FD'],'ST','0','1'} in what frame/ units to put
%			mass / velocity / inertia data
%		 -(opt)AugGust {0,[1]} - assumes that you want to augment with 2 gust
%			inputs if they don't already exist. 
%        -(opt*)verbose {0,[1]} - verbose tag for plotting.  
%     opt*> Requires all previous inputs
%
% Outputs - outsys OUtput system scaled and everything.  
%					note: outsys.UserData = info!
%         - info  Information related to the last execution
% 
% 1-arg = (Filename)
% 2-arg = (Filename, AugGust)
% 3-arg = (Filename,CreatOutputNames,CreatInputNames)
% 4-arg = (Filename,CreatOutputNames,CreatInputNames,FnameMF<string>)
% 4-arg = (Filename,CreatOutputNames,CreatInputNames,AugGust<numeric>)
% 5-arg = (Filename,CreatOutputNames,CreatInputNames,FnameMF,AugGust)
% 6-arg = (Filename,CreatOutputNames,CreatInputNames,FnameMF,AugGust,verbose)
% Filename input can have one of 4 input formats
%		1 - a string wich contains path and file locations
%		2 - a string which contains a path with a zip file and file name
%				-> '.\dir1\dir2\bla.zip\blabla.ase'
%		3 - a string wich is a zip file ->  '.\dir1\dir2\bla.zip'
%		4 - a cell array of strings containing input 1 formats... 
% Each input outputs differently 
%		1 reads file from specified directory 
%		2 outputs to .\Models_Working
%		3 creates a directory named the zip file name and extracts into it 
%		4 uses the directory of each file when looking for sysrd, INC and ONC
%
% Ziped files: the following copyies a ziped subfile to the
% .\Models_Working folder and proceedes... the file is not removed. 
% Example:
% [Sys,info] = GetASEModel(.\Models\FreeFree\h40b_gstudy_SymAsym_M0230_qx0_5kft_nofuel_cg456.zip\h40b_min_asy_M0230_q70_5kft_nofuel_cg456.ase');
% [Sys,info]=GetASEModel('aei_papa2a_full_hg70q.ase','CreateONC_WT05fd','CreateINC_WT05fd','FD',1);
% See also: aserd 
%**************************************************************************
%#NOTE: End old header
%**************************************************************************
% SYNTAX:
%	[outsys, info] = GetASEModel(ASEFilesIn, FnameONC, FnameINC, FnameMF, AugGust, verbose, varargin, 'PropertyName', PropertyValue)
%	[outsys, info] = GetASEModel(ASEFilesIn, FnameONC, FnameINC, FnameMF, AugGust, verbose, varargin)
%	[outsys, info] = GetASEModel(ASEFilesIn, FnameONC, FnameINC, FnameMF, AugGust, verbose)
%	[outsys, info] = GetASEModel(ASEFilesIn, FnameONC, FnameINC, FnameMF, AugGust)
%
% INPUTS: 
%	Name      	Size		Units		Description
%	ASEFilesIn	<size>		<units>		<Description>
%	FnameONC	  <size>		<units>		<Description>
%	FnameINC	  <size>		<units>		<Description>
%	FnameMF	   <size>		<units>		<Description>
%	AugGust	   <size>		<units>		<Description>
%	verbose	   <size>		<units>		<Description>
%	varargin	[N/A]		[varies]	Optional function inputs that
%	     		        				 should be entered in pairs.
%	     		        				 See the 'VARARGIN' section
%	     		        				 below for more details
%
% OUTPUTS: 
%	Name      	Size		Units		Description
%	outsys	    <size>		<units>		<Description> 
%	info	      <size>		<units>		<Description> 
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
%	[outsys, info] = GetASEModel(ASEFilesIn, FnameONC, FnameINC, FnameMF, AugGust, verbose, varargin)
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[outsys, info] = GetASEModel(ASEFilesIn, FnameONC, FnameINC, FnameMF, AugGust, verbose)
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
%	Source function: <a href="matlab:edit GetASEModel.m">GetASEModel.m</a>
%	  Driver script: <a href="matlab:edit Driver_GetASEModel.m">Driver_GetASEModel.m</a>
%	  Documentation: <a href="matlab:pptOpen('GetASEModel_Function_Documentation.pptx');">GetASEModel_Function_Documentation.pptx</a>
%
% See also <add relevant functions> 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/29
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/AeroServoElastic/GetASEModel.m $
% $Rev: 1715 $
% $Date: 2011-05-11 16:30:05 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [outsys, info] = GetASEModel(ASEFilesIn, FnameONC, FnameINC, FnameMF, AugGust, verbose, varargin)

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
outsys= -1;
info= -1;

%% Input Argument Conditioning:
% Pick out Properties Entered via varargin
% [<PropertyValue>, varargin]  = format_varargin('<PropertyValue', <Default>, 2, varargin);

%  switch(nargin)
%       case 0
%        verbose= ''; AugGust= ''; FnameMF= ''; FnameINC= ''; FnameONC= ''; ASEFilesIn= ''; 
%       case 1
%        verbose= ''; AugGust= ''; FnameMF= ''; FnameINC= ''; FnameONC= ''; 
%       case 2
%        verbose= ''; AugGust= ''; FnameMF= ''; FnameINC= ''; 
%       case 3
%        verbose= ''; AugGust= ''; FnameMF= ''; 
%       case 4
%        verbose= ''; AugGust= ''; 
%       case 5
%        verbose= ''; 
%       case 6
%        
%       case 7
%        
%  end
%
%  if(isempty(verbose))
%		verbose = -1;
%  end
%List of Frames to Convert to: First In List is default! 
FnameMFList = {'FD','1','UN','ST'}; 

if nargin >= 1 %For any input >=1
	if ~(ischar(ASEFilesIn) || iscell(ASEFilesIn))
		disp([mfnam '>> First argument must be a string or a cell!']);
		info.error = 'Improper first arugment';
		outsys = ss([],[],[],[]);
		return;
	end;
end;

switch nargin
	case 0 % Error Case
		disp([mfnam '>> You must include a filename']);
		info.error = 'Not enough input arguments';
		outsys = ss([],[],[],[]);
		return;
	case 1 %default settings
		% 1-arg = (Filename)
		FnameONC = 'CreateOutputNamesCell';
		FnameINC = 'CreateInputNamesCell';
		FnameMF = FnameMFList{1};
		AugGust = 1;
		verbose = 1;
	case 2 %then we really have the 2arg version
		% 2-arg = (Filename, AugGust)
		AugGust = FnameONC;
		FnameONC = 'CreateOutputNamesCell';
		FnameINC = 'CreateInputNamesCell';
		FnameMF  = FnameMFList{1};
		verbose = 1;
	case 3 % 3 Arguemnt version must be file, string, string
		% 3-arg = (Filename,CreatOutputNames,CreatInputNames)
		if ~(ischar(FnameONC)||iscell(FnameONC)) || ~(ischar(FnameINC)||iscell(FnameONC))
			info.error = 'Review 3-arg input case (no GustAug input allowed)';
			disp([mfnam '>> ' info.error]);
			outsys = ss([],[],[],[]);
			return;
		else
			FnameMF = FnameMFList{1}; %Set default flight frame
			AugGust = 1; %set default
			verbose = 1;
		end;
	case 4
		if ischar(FnameMF)
			% 4-arg = (Filename,CreatOutputNames,CreatInputNames,FnameMF<string>)
			strtest = any(strcmpi(FnameMF,FnameMFList));
			AugGust = 1; %use default
			verbose = 1;
			numtest = 1;
		elseif isnumeric(FnameMF)
			% 4-arg = (Filename,CreatOutputNames,CreatInputNames,AugGust<numeric>)
			AugGust = FnameMF; %Was really AugGust
			verbose = 1;
			numtest = any(AugGust==[1 0]);
			FnameMF = FnameMFList{1};
			strtest = 1;
		else %this is an ERROR! 
			strtest = 0;
			numtest = 0;
		end;
		if ~strtest && ~numtest
			info.error = '4 arg version must be appropriate frame or a 1 or 0!';
			disp([mfnam '>>' info.error]);
			outsys = ss([],[],[],[]);
			return;
		end
	case 5 %Five arguemnt version
		% 5-arg = (Filename,CreatOutputNames,CreatInputNames,FnameMF,AugGust)
		if ~(ischar(FnameONC)||iscell(FnameONC)) || ~(ischar(FnameINC)||iscell(FnameONC)) || ~ischar(FnameMF) || ~isnumeric(AugGust)
			info.error = 'Improper type on 5 arg input form!' ;
			disp([mfnam '>>ERROR: ' info.error]);
			outsys = ss([],[],[],[]);
			return;
		end;
		verbose = 1;
	case 6 %six arguemnt version
		% 6-arg =(Filename,CreatOutputNames,CreatInputNames,FnameMF,AugGust,verbose)
		if ~(ischar(FnameONC)||iscell(FnameONC)) || ~(ischar(FnameINC)||iscell(FnameONC)) || ~ischar(FnameMF) || ~isnumeric(AugGust) || ~isnumeric(verbose)
			info.error = 'Improper type on 6 arg input form!' ;
			disp([mfnam '>>ERROR: ' info.error]);
			outsys = ss([],[],[],[]);
			return;
		end;
	otherwise % 
		info.error = 'Too Many Input Arguments!!';
		disp([mfnam '>>ERROR: ' info.error]);
		outsys = ss([],[],[],[]);
		return;
end

%%  look into requested name make cell list...
if ischar(ASEFilesIn)	%if is a string (may or may not be .zip or dir)
	[pathstr, ASEfname, ext] = fileparts(ASEFilesIn);
	%check to see if it is buried in a .zip file or is a zip file
	if  strcmpi(ext,'.zip')%you want the whole file extracted and run on *.ase
		UnZipPath=[pathstr '\' ASEfname];
		disp([mfilename '>> Found Zip file... extracting to: "' UnZipPath '\" ...']);
		unzip([pathstr '\' ASEfname ext],UnZipPath);
		ASEFilesStruct = dir([UnZipPath '\*.ase']); %retrieve all ase files
		for i=1:length(ASEFilesStruct)
			ASEFiles{i,1} = [UnZipPath '\' ASEFilesStruct(i).name];
		end
		RemoveDir = UnZipPath;
	elseif (length(pathstr) > 4) && strcmpi(pathstr(end-3:end),'.zip') % pick out one file from the bunch
		WorkDir = '.\Models_Working';
		if verbose
			disp([mfnam '>> Found Zip file in directory path... extracting to: ' WorkDir ' ...']);
			disp([mfspc '>> will overwrite existing files in the target directory.!']);
		end
		TdirName = ['.\xUnzipDir' num2str(floor(rand*10000))];
		%[zippathstr,zipFname, zipext, versn]  = fileparts(pathstr);
		unzip(pathstr,TdirName);
		%[status1,msg1] = movefile(['.\' TdirName '\' ASEfname ext],WorkDir);
		movefile(['.\' TdirName '\' ASEfname ext],WorkDir,'f');
		try
			movefile(['.\' TdirName '\aserd.m'], WorkDir,'f');
			if verbose; disp([mfspc '>> aserd, found in .zip ']);
			end
		catch 
			if verbose; disp([mfspc '>> NOTE: aserd not found in zip file... Will try to find a reader...'])
			end
		end;
		try
			movefile(['.\' TdirName '\' FnameONC '.m'],WorkDir,'f');
			if verbose; disp([mfspc '>> OutputNameFile: ' FnameONC '.m  found.']); 
			end		
		catch
			if verbose; disp([mfspc '>>CAUTION: Could not find OutputFileName named: ' FnameONC '.m']); 
			end
		end
		try
			movefile(['.\' TdirName '\' FnameINC '.m'], WorkDir,'f');
			if verbose; disp([mfspc '>> InputNameFile : ' FnameINC '.m  found.']); 
			end
		catch
			if verbose; disp([mfspc '>>CAUTION: Could not find file named: ' FnameINC '.m']); 
			end
		end
		rmdir(TdirName,'s');
		ASEFiles{1} = [WorkDir '\' ASEfname ext];
	else%it is a single file name no cell no zip
		ASEFiles{1} = ASEFilesIn;		
	end
else %it was a cell array already... 
	ASEFiles = ASEFilesIn;
end
%Correct for the shape of the ASEFiles if there is a problem
if size(ASEFiles,2)>size(ASEFiles,1)
	ASEFiles=ASEFiles';
end
%% Main Function:
%% Perform Extractions / Builds
%at this point ASEFiles should be a cell array, no zip files and all directories
% should be included
for i=1:length(ASEFiles)	
	%extract file information
	[pathstr, ASEfname ext] = fileparts(ASEFiles{i});
	% change to directory
	OrigPath = path;
	try
		path(pathstr,OrigPath)
	catch
		disp([mfnam '>> Could not modify path directory to : ' pathstr]);
		outsys = ss([],[],[],[]);
		info.error = 'Could not change directory';
		return;
	end;
	
	% read file
	if exist('aserd','file') == 2
		[Sys,Mach,V,rho,n,m,l,g,bg,dg] = aserd([ASEfname ext],verbose);
	elseif ~any(strfind(path,'.\SupportFunctions'))
		addpath('./SupportFunctions')
		if exist('aserd','file') == 2
			[Sys,Mach,V,rho,n,m,l,g,bg,dg]=aserd([ASEfname ext],verbose);
			rmpath('./SupportFunctions');
		else
			rmpath('./SupportFunctions');
			info.error = 'Cant''t find a copy of aserd!';
			error([mfnam '>>(172)' info.error]);
			outsys = [];
			return;
		end
	end
			
	 %Vele, Rho, order, 
   % check for gust inputs and add a null 2 inputs if missing
	if isempty(bg) && AugGust==1; 
		bg = zeros(n,2);
		dg = zeros(l,2);
		if verbose; disp([mfnam '>> Null Gust inputs found. Adding 2 null gust inputs!']); 
		end
		WasAugGust = 1;
	else 
		WasAugGust = 0;
	end;
	
    % Error Check on Gust size!
	% Bg first
	if ~isempty(bg) && (size(Sys.b,1) ~= size(bg,1))
        info.error = 'Improper size of B gust matrix!';
        error([mfnam '>>(200)' info.error]);
        outsys =[];
	else  
		B = [Sys.b bg]; %this works on empty bg's and properly sized ones too
	end
	% Dg next
    if ~isempty(dg) && (size(Sys.d,1) ~= size(dg,1))
        info.error = 'Improper size of Dgust matrix!';
        error([mfnam '>>(204)' info.error]);
        outsys = [];
	else
		D = [Sys.d dg]; % works if dg is empty or properly sized.
	end
	SysG = ss(Sys.a, B, Sys.c, D); %append Gust terms

 %note return to base path happen in a few lines! 
	 	 
%% scale output equatons 
	%What are teh modle inputs and output names
    %these functions must reside in the matlab path (the will be take from the
    %op of the path so will probably come from the last directory added
	
	if ischar(FnameONC)
		[OutputNamesCell]= eval([FnameONC '()']);%CreateOutputNamesCell(); 
	elseif iscell(FnameONC)
		OutputNamesCell = FnameONC;
	else
		disp([mfnam '>>ERROR: FnameONC must be a function name or cell.']);
		return;
	end
	if ischar(FnameINC)
		[InputNamesCell] = eval([FnameINC '()']);%CreateInputNamesCell();
	elseif iscell(FnameINC)
		InputNamesCell = FnameINC;
	else
		disp([mfnam '>>ERROR: FnameINC must be a function name or cell.']);
		return;
	end
   	%change Directory back to parent...
    rmpath(pathstr); 
	
    % perhaps teh data to do this part could be another functin argument?
	 if exist('ScaleSystem','file') == 2
		 SysGnom = ScaleSystem(SysG,OutputNamesCell,InputNamesCell);
		 SysGnom.Notes = 'Full System from ASE scaled to proper units';
	 else
		 addpath('.\SupportFunctions');
		 if exist('ScaleSystem','file') == 2
			SysGnom = ScaleSystem(SysG,OutputNamesCell,InputNamesCell);
			SysGnom.Notes = 'Full System from ASE scaled to proper units';
			rmpath('.\SupportFunctions');
		 else
			rmpath('.\SupportFunctions');
			info.error = 'ERROR: Can''t find ScaleSytem function!';
			disp([mfnam '>>' info.error]);
			outsys = ss([],[],[],[]);
			return; 
		 end
	 end

%% FNAMMF create output variables of this loop
%Default FnameMF is 'FD"!  
	switch FnameMF
		case '0' %I dont' think you need this case!
			if verbose; disp([mfnam '>> Using Data somewhere else...']);
			end
			UnitString			= '-1';
			RefAxis				= -1;
			FlexModeRBInert_Ref = -1;
			Mass				= -1;
			CGpos				= -1;
			InertiaMatrix_CG	= -1;
			rho = -1; %
			V	= -1; %
			Mach= -1;
		case '1'
			if verbose; disp([mfnam '>> Converting to: UNITY GAIN ON INPUTS!']);
			end
			UnitString	= Sys.UserData.Units;
			RefAxis		= Sys.UserData.RefAxis;
			FlexModeRBInert_Ref = Sys.UserData.FlexModeRBInert_Ref;
			Mass		= Sys.UserData.Mass;
			CGpos		= Sys.UserData.CGpos;
			InertiaMatrix_CG = Sys.UserData.InertiaMatrix_CG;
			rho		= Sys.UserData.rho; %slug/ft^3
			V		= Sys.UserData.V; %ft/sec
			Mach	= Sys.UserData.Mach;

		case {'FD','fd','Fd','fD'}
			if verbose; disp([mfnam '>> Converting to: FLIGHT DYNAMICS FRAME!']);	
			end
			UnitString = '';
			%ReferenceAxis
			RefAxis = -1;
			if Sys.UserData.RefAxis ~= -1
				RefAxis = Sys.UserData.RefAxis*(1/12); %ft
				UnitString = [UnitString ' RefAx:ft'];
			end
			%RigidBody Inertia Matrix
			FlexModeRBInert_Ref = -1;
			if Sys.UserData.FlexModeRBInert_Ref ~= -1;
			  disp([mfnam '>>WARNING!  FlexModeRBInert has structure frame units ->User must convert!']);
				FlexModeRBInert_Ref = Sys.UserData.FlexModeRBInert_Ref;      %combination of masses and with Iyy
				UnitString = [UnitString ' RefAx:Slug/Slug-Ft^2'];
			end
			%Inertia Mass
			Mass = -1;
			if Sys.UserData.Mass ~= -1
				Mass = Sys.UserData.Mass*(12);  % lb-force for full Vehicle
				UnitString = [UnitString ' Mass:Slug'];
			end
			%Center of Gravity
			CGpos = -1;
			if Sys.UserData.CGpos ~= -1
				CGpos = Sys.UserData.CGpos*(1/12);    %ft
				UnitString = [UnitString ' CGpos:ft'];
			end
			%Moment of Inertia Matrix
			InertiaMatrix_CG = -1;
			if Sys.UserData.InertiaMatrix_CG ~= -1
				InertiaMatrix_CG = Sys.UserData.InertiaMatrix_CG*(1/12); %slug-ft^2
				UnitString = [UnitString ' IM_CG:Slug-Ft^2'];
			end

			rho = Sys.UserData.rho*(12^4); %slug/ft^3
			UnitString = [UnitString ' rho:slug/ft^3'];
			V = Sys.UserData.V* (1/12); %ft/sec;
			UnitString = [UnitString ' V:ft/s'];
			Mach = Sys.UserData.Mach; 

		case {'ST','st','St','sT'}
			%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
			if verbose; disp([mfnam '>> Converting to: STRUCTURE FRAME!']);
			end
			UnitString = Sys.UserData.Units;

			%ReferenceAxis
			RefAxis = -1;
			if Sys.UserData.RefAxis ~= -1
				RefAxis = Sys.UserData.RefAxis; %in
			end
			%RigidBody Inertia Matrix
			FlexModeRBInert_Ref = -1;
			if Sys.UserData.FlexModeRBInert_Ref ~= -1;
				FlexModeRBInert_Ref = Sys.UserData.FlexModeRBInert_Ref;      %combination of masses and with Iyy
			end
			%Inertia Mass
			Mass = -1;
			if Sys.UserData.Mass ~= -1
				Mass = Sys.UserData.Mass;    % lb-force for full Vehicle
			end
			%Center of Gravity
			CGpos = -1;
			if Sys.UserData.CGpos ~= -1
				CGpos = Sys.UserData.CGpos;    %in
			end
			%Moment of Inertia Matrix
			InertiaMatrix_CG = -1;
			if Sys.UserData.InertiaMatrix_CG ~= -1
				InertiaMatrix_CG = Sys.UserData.InertiaMatrix_CG; %snail-in^2	
			end

			rho = Sys.UserData.rho; %??
			UnitString = [UnitString ' rho:snail/in^3'];
			V = Sys.UserData.V; %in/sec
			UnitString = [UnitString ' V:in/ft'];
			Mach = Sys.UserData.Mach; 

		otherwise
			info.error =['ERROR ENDING... Inproprer parameter conversion...: ' FnameMF];
			disp([mfnam '>> ' info.error]);
			return;
	end; %switch
  

	
	outsys.(ASEfname).Nom = SysGnom;
	outsys.(ASEfname).Nom.notes = SysGnom.Notes;
	
	%Write Info to SysGnom.UserData
	info.SrcFile = ASEFiles{i};
	info.Desc = Sys.UserData.Desc;
	info.Interface = Sys.UserData.Interface;
	info.Interface.FnameONC = FnameONC;
	info.Interface.FnameINC = FnameINC;
	info.Interface.FnameMF = FnameMF;
	info.Interface.OutputNamesCell = OutputNamesCell;
	info.Interface.InputNamesCell = InputNamesCell;
	info.Modes = Sys.UserData.Modes;
	info.Mach = Mach;
	info.V = V;
	info.rho = rho;
	%Mass Properties 
	info.RefAxis = RefAxis;
	info.FlexModeRB_Names = Sys.UserData.FlexModeRB_Names;
	info.FlexModeRBInert_Ref = FlexModeRBInert_Ref;
	info.Mass = Mass;
	info.CGpos = CGpos;
	info.InertiaMatrix_CG = InertiaMatrix_CG;
	% Units
	info.Units = UnitString;
	% Source file
	info.SrcFileInfo = Sys.UserData.SrcFileInfo;
	% Transfer Custom Tags
	info.CustTags = Sys.UserData.CustTags;
	% Junk
	info.G  = Sys.UserData.G;
	info.bg = Sys.UserData.bg;
	info.dg = Sys.UserData.dg;
	% Copy to UserData
	outsys.(ASEfname).Nom.UserData = info;
	
	%Old list
% 	info.Mach = Mach; 
% 	info.V = V;    %ft/sec
% 	info.rho = rho;  %slug/ft^3
% 	info.nStates  = n;
% 	info.mInputs  = m;
% 	info.lOutputs = l;
% 	info.RefAxis = RefAxis; %feet
% 	info.FlexModeRBInert_Ref = FlexModeRBInert_Ref;      %combination of masses and with Iyy (not converted)
% 	info.Mass = Mass;  %lbs
% 	info.CGpos = CGpos;    %feet
% 	info.InertiaMatrix_CG = InertiaMatrix_CG;    %slug-ft^2
% 	info.Units = UnitString;
% 	info.AugGust = WasAugGust;	
% 	info.FnameONC = FnameONC;
% 	info.FnameINC = FnameINC;
% 	info.FnameMF  = FnameMF;
% 	info.OutputNamesCell = OutputNamesCell;
% 	info.InputNamesCell = InputNamesCell;
% 	info.SourceDir = pathstr;
% 	info.SourceFile = [ASEfname ext];
% 	%Copy Info to UserData!
% 	outsys.(ASEfname).Nom.UserData = info;

end % file loop   
%% make single system output as state space 
if length(ASEFiles)==1
	outsys = outsys.(ASEfname).Nom;
end;

if exist('RemoveDir','var')
	try
	%[status3,msg3] = rmdir(RemoveDir,'s');
	rmdir(RemoveDir,'s');
	if verbose; disp([mfnam '>> Source Directory Cleaned: ' RemoveDir]);
	end
	catch
		disp([mfnam '>> Couldn''t remove directory: ' RemoveDir]);
	end
end

%% Return
return

%% Compile Outputs:
%	outsys= -1;
%	info= -1;

% << End of function GetASEModel >>

%% REVISION HISTORY
% YYMMDD INI: note
% 101021 JPG: Copied over information from the old function.
% 101021 CNF: Function template created using CreateNewFunc
% 070525 TKV: Added Verbose input to end of list
%			: Corrected bug for multi file case... 
% 070125 TKV: Corrected Unit conversions for 'fd' case
% 070124 TKV: Added Warning to FD usage on FlexModeRBInert - 
% 061205 TKV: Corrected rempath and pathsstr terms
% 060926 TKV: Added input for changing the output frame (i don't like it but??)
%				This allows for outputing different units from this file
%				Takes units from aserd and defaults to FD->flight dynamics frame
%				for backward compatibility.
% 060926 TKV: Changed teh names of the UserData STruct to match aserd. 
%			NOTE: Weight is GONE, now it is MASS and all consistent units!
% 060913 TKV: Added Error Checking to gust matrix addition
% 060901 TKV: Changed .zip/file behavior to better articulate what is happening
% 060808 TKV: Changed Internal Function Name to match File Name
% 060802 TKV: Changed to allow specification of INC and ONC file... big change!
% 060731 TAQ: Added Unit conversions for V,Mach,Rho to 'No' Case...
% 060727 TAQ: Formed outputs to be in slugs/ft/lbf   
% 060725 TKV: Made Notes and Suggestions for Next Revision.
% 060707 TAQ: Output created for CG, Weight, and Mass Moment of Inertia's
% 060706 TAQ: Output created for RigidBody Inertia Matrix and RigidBody
%	Reference Axis
% 060602 TKV: Calls the new funciton aserd instead of sysrd 
% 060531 TKV: Corrected isnumeric bug and Rev History order
% 060302 TKV: Made work with files and input formats including zip files
%		Output is either alibrary or a single LTI object
% 060215 TKV: added second output argument into outsys.UserData field
% 060113 TKV: Added ability to read zip files as the parent directory to
%	the ASE File...
% 060112 TKV: If now gusts are included, creates the gust inputs unless a
%	second argument of <0> is used.  
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
