% DIGITIZE2 Digitizes data from image.
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% digitize2:
%   DIGITIZE with no input or output arguments allows the user to
%   select an image file to load;  only IMREAD-compatible image 
%   files are supported.  The function then prompts the user
%   to graphically identify the location of the origin and the X-
%   and Y- axes of the plot.  The user may then graphically select
%   an arbitrary number of data points from anywhere on the image
%   using the left mouse button.  Data acquisition is terminated
%   by clicking the right mouse button.  The function then prompts
%   the user to save the acquired data to file.
%   
%   ACQDATA = DIGITIZE with one output argument returns the X- and
%   Y- values of the graphically selected data in the array ACQDATA.
%   The user is not prompted to save the data to file.
%
%   DIGITIZE(FILENAME) with one input argument FILENAME is used to 
%   directly specify the image file to load.  As above, the user is
%   prompted to graphically set up the coordinate system and select
%   target data points.
%
% ************************************************************************
% * #NOTE: To future CoSMO'r The following warning occured during CNF
% * CreateNewFunc>>WARNING: Selected Ouput argument name: "varargout" is a
% * function name!
% * -JPG
% ************************************************************************
% SYNTAX:
%	[varargout] = digitize2(varargin, 'PropertyName', PropertyValue)
%	[varargout] = digitize2(varargin)
%
% INPUTS: 
%	Name     	Size		Units		Description
%	varargin	[N/A]		[varies]	Optional function inputs that
%	     		        				 should be entered in pairs.
%	     		        				 See the 'VARARGIN' section
%	     		        				 below for more details
%
% OUTPUTS: 
%	Name     	Size		Units		Description
%	varargout	<size>		<units>		<Description> 
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
%	[varargout] = digitize2(varargin)
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[varargout] = digitize2(varargin)
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
%	Source function: <a href="matlab:edit digitize2.m">digitize2.m</a>
%	  Driver script: <a href="matlab:edit Driver_digitize2.m">Driver_digitize2.m</a>
%	  Documentation: <a href="matlab:pptOpen('digitize2_Function_Documentation.pptx');">digitize2_Function_Documentation.pptx</a>
%
% See also IMREAD, IMFINFO
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/441
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/MatlabUtilities/digitize2.m $
% $Rev: 1718 $
% $Date: 2011-05-11 18:07:49 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [varargout] = digitize2(varargin)

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
% varargout= -1;

%% Input Argument Conditioning:
% Pick out Properties Entered via varargin
% [<PropertyValue>, varargin]  = format_varargin('<PropertyValue', <Default>, 2, varargin);

%  switch(nargin)
%       case 0
%        
%       case 1
%        
%  end
%
%% Main Function:
% Check for proper number of input arguments
error(nargchk(0,1,nargin));

% Identify image filename
if (nargin == 0),
     [filename, pathname] = uigetfile( ...
	       {'*.jpg;*.tif;*.gif;*.png;*.bmp', ...
		'All MATLAB Image Files (*.jpg,*.tif,*.gif,*.png,*.bmp)'; ...
		'*.jpg;*.jpeg', ...
		'JPEG Files (*.jpg,*.jpeg)'; ...
		'*.tif;*.tiff', ...
		'TIFF Files (*.tif,*.tiff)'; ...
		'*.gif', ...
		'GIF Files (*.gif)'; ...
		'*.png', ...
		'PNG Files (*.png)'; ...
		'*.bmp', ...
		'Bitmap Files (*.bmp)'; ...
		'*.*', ...
		'All Files (*.*)'}, ...
	       'Select image file');
     if isequal(filename,0) | isequal(pathname,0)
	  return
     else
	  imagename = fullfile(pathname, filename);
     end
elseif nargin == 1,
     imagename = varargin{1};
     [path, file,ext] = fileparts(imagename);
     filename = strcat(file,ext);
end   

% Read image from target filename
pic = imread(imagename);
image(pic)
FigName = ['IMAGE: ' filename];
set(gcf,'Units', 'normalized', ...
	'Position', [0 0.125 1 0.85], ...
	'Name', FigName, ...
	'NumberTitle', 'Off', ...
	'MenuBar','None')
set(gca,'Units','normalized','Position',[0   0 1   1]);

% Determine location of origin with mouse click
OriginButton = questdlg('Select the ORIGIN with left mouse button click', ...
			'DIGITIZE: user input required', ...
			'OK','Cancel','OK');
switch OriginButton,
     case 'OK',
	  drawnow
	  [Xopixels,Yopixels] = ginput(1);
	  line(Xopixels,Yopixels,...
	       'Marker','o','Color','g','MarkerSize',14)
	  line(Xopixels,Yopixels,...
	       'Marker','x','Color','g','MarkerSize',14)
     case 'Cancel',
	  close(FigName)
	  return
end % switch OriginButton

% Prompt user for X- & Y- values at origin
prompt={'Enter the abcissa (X value) at the origin',...
        'Enter the ordinate (Y value) at the origin:'};
def={'0','0'};
dlgTitle='DIGITIZE: user input required';
lineNo=1;
answer=inputdlg(prompt,dlgTitle,lineNo,def);
if (isempty(char(answer{:})) == 1),
     close(FigName)
     return
else
    OriginXYdata = str2num(char(answer{:}));
end

% Define X-axis
XLimButton = questdlg(...
	  'Select a point on the X-axis with left mouse button click ', ...
	  'DIGITIZE: user input required', ...
	  'OK','Cancel','OK');
switch XLimButton,
     case 'OK',
	  drawnow
	  [XAxisXpixels,XAxisYpixels] = ginput(1);
	  line(XAxisXpixels,XAxisYpixels,...
	       'Marker','*','Color','b','MarkerSize',14)
	  line(XAxisXpixels,XAxisYpixels,...
	       'Marker','s','Color','b','MarkerSize',14)
     case 'Cancel',
	  close(FigName)
	  return
end % switch XLimButton

% Prompt user for XLim value
prompt={'Enter the abcissa (X value) at the selected point'};
def={'1'};
dlgTitle='DIGITIZE: user input required';
lineNo=1;
answer=inputdlg(prompt,dlgTitle,lineNo,def);
if (isempty(char(answer{:})) == 1),
     close(FigName)
     return
else
     XAxisXdata = str2num(char(answer{:}));
end

% Determine X-axis scaling
Xtype = questdlg(...
	  'Select axis type for absicca (X)', ...
	  'DIGITIZE: user input required', ...
	  'LINEAR','LOGARITHMIC','Cancel');
drawnow
switch upper(Xtype),
     case 'LINEAR',
	  logx = 0;
	  scalefactorXdata = XAxisXdata - OriginXYdata(1);
     case 'LOGARITHMIC',
	  logx = 1;
	  scalefactorXdata = log10(XAxisXdata/OriginXYdata(1));
     case 'CANCEL',
	  close(FigName)
	  return
end % switch Xtype

% Rotate image if necessary
% note image file line 1 is at top
th = atan((XAxisYpixels-Yopixels)/(XAxisXpixels-Xopixels));  
% axis rotation matrix
rotmat = [cos(th) sin(th); -sin(th) cos(th)];    

% Define Y-axis
YLimButton = questdlg(...
	  'Select a point on the Y-axis with left mouse button click', ...
	  'DIGITIZE: user input required', ...
	  'OK','Cancel','OK');
switch YLimButton,
     case 'OK',
	  drawnow
	  [YAxisXpixels,YAxisYpixels] = ginput(1);
	  line(YAxisXpixels,YAxisYpixels,...
	       'Marker','*','Color','b','MarkerSize',14)
	  line(YAxisXpixels,YAxisYpixels,...
	       'Marker','s','Color','b','MarkerSize',14)
     case 'Cancel',
	  close(FigName)
	  return
end % switch YLimButton

% Prompt user for YLim value
prompt={'Enter the ordinate (Y value) at the selected point'};
def={'1'};
dlgTitle='DIGITIZE: user input required';
lineNo=1;
answer=inputdlg(prompt,dlgTitle,lineNo,def);
if (isempty(char(answer{:})) == 1),
     close(FigName)
     return
else
     YAxisYdata = str2num(char(answer{:}));
end

% Determine Y-axis scaling
Ytype = questdlg('Select axis type for ordinate (Y)', ...
		 'DIGITIZE: user input required', ...
		 'LINEAR','LOGARITHMIC','Cancel');
drawnow
switch upper(Ytype),
     case 'LINEAR',
	  logy = 0;
	  scalefactorYdata = YAxisYdata - OriginXYdata(2);
     case 'LOGARITHMIC',
	  logy = 1;
	  scalefactorYdata = log10(YAxisYdata/OriginXYdata(2));
     case 'CANCEL',
	  close(FigName)
	  return
end % switch Ytype

% Complete rotation matrix definition as necessary
delxyx = rotmat*[(XAxisXpixels-Xopixels);(XAxisYpixels-Yopixels)];
delxyy = rotmat*[(YAxisXpixels-Xopixels);(YAxisYpixels-Yopixels)];
delXcal = delxyx(1);
delYcal = delxyy(2);

% Commence Data Acquisition from image
msgStr{1} = 'Click with LEFT mouse button to ACQUIRE';
msgStr{2} = ' ';
msgStr{3} = 'Click with RIGHT mouse button to QUIT';
titleStr = 'Ready for data acquisition';
uiwait(msgbox(msgStr,titleStr,'warn','modal'));
drawnow

numberformat = '%6.2f';
nXY = [];
ng = 0;
while 1,
     fprintf(['\n INFO >> Click with RIGHT mouse button to QUIT \n\n']);
     n = 0;
     disp(sprintf('\n %s \n',' Index          X            Y'))
     
% %%%%%%%%%%%%%% DATA ACQUISITION LOOP %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     while 1
	  [x,y, buttonNumber] = ginput(1);                       
	  xy = rotmat*[(x-Xopixels);(y-Yopixels)];
	  delXpoint = xy(1);
	  delYpoint = xy(2);
	  if buttonNumber == 1, 
	       line(x,y,'Marker','.','Color','r','MarkerSize',12)
	       if logx,
		    x = OriginXYdata(1)*10^(delXpoint/delXcal*scalefactorXdata);
	       else
		    x = OriginXYdata(1) + delXpoint/delXcal*scalefactorXdata;
	       end
	       if logy, 
		    y = OriginXYdata(2)*10^(delYpoint/delYcal*scalefactorYdata);
	       else  
		    y = OriginXYdata(2) + delYpoint/delYcal*scalefactorYdata;
	       end
	       n = n+1;
	       xpt(n) = x;
	       ypt(n) = y;
	       disp(sprintf(' %4d         %f      %f',n, x, y))
	       ng = ng+1;
	       nXY(ng,:) = [n x y];
	  else
	       query = questdlg('STOP digitizing and QUIT ?', ...
				'DIGITIZE: confirmation', ...
				'YES', 'NO', 'NO');
	       drawnow
	       switch upper(query),
		    case 'YES',
			 disp(sprintf('\n'))
			 break
		    case 'NO',
			 
	       end % switch query
	  end
     end
% %%%%%%%%%%%%%% DATA ACQUISITION LOOP %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

     if nargout  == 0,
	  % Save data to file
	  [writefname, writepname] = uiputfile('*.dat','Save data as');
%	  if (writefname == 0) | (writepname == 0),
if (writefname == 0),
	       close(FigName)
	       break
	       return
	  end
	  writepfname = fullfile(writepname, writefname);
	  writedata = [xpt' ypt'];
	  fid = fopen(writepfname,'w');
	  fprintf(fid,'  %g     %g\n',writedata');
	  fclose(fid);
	  close(FigName)
	  disp(sprintf('\n'))
     elseif nargout == 1,
	  outputdata = [xpt' ypt'];
	  varargout{1} = outputdata;
	  close(FigName);
     end
     break
end

%% Compile Outputs:
%	varargout= -1;

end % << End of function digitize2 >>

%% REVISION HISTORY
% YYMMDD INI: note
% 101102 JPG: Copied over information from the old function.
% 101102 CNF: Function template created using CreateNewFunc
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
