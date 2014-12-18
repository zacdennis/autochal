% PLOTND plots a 3 dimensional function y = f(x,y,z)
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% PlotnD:
%     Plots a 3 dimensional function y = f(x,y,z), where the plot displays
%     y = f(x,y) and z is a constant.  z is varied via a slider bar on the
%     bottom of the figure.
% 
% Inputs - indepVars: cell array of names of independent variables, x,y,z
%                     correspond to the 1st, 2nd, and 3rd variables listed
%        - indepData: cell array of vectors of data corresponding to
%                     independent variables
%		 -    depVar: string containing dependent variable
%        -   depData: matrix containing data for dependent variable
%		 
% Output - nDplotH : figure handle for plot
% 
% SYNTAX:
%	[nDplotH] = PlotnD(indepVars, indepData, depVar, depData, figH, varargin, 'PropertyName', PropertyValue)
%	[nDplotH] = PlotnD(indepVars, indepData, depVar, depData, figH, varargin)
%	[nDplotH] = PlotnD(indepVars, indepData, depVar, depData, figH)
%	[nDplotH] = PlotnD(indepVars, indepData, depVar, depData)
%
% INPUTS: 
%	Name     	Size		Units		Description
%	indepVars	<size>		<units>		<Description>
%	indepData	<size>		<units>		<Description>
%	depVar	   <size>		<units>		<Description>
%	depData	  <size>		<units>		<Description>
%	figH	     <size>		<units>		<Description>
%	varargin	[N/A]		[varies]	Optional function inputs that
%	     		        				 should be entered in pairs.
%	     		        				 See the 'VARARGIN' section
%	     		        				 below for more details
%
% OUTPUTS: 
%	Name     	Size		Units		Description
%	nDplotH	  <size>		<units>		<Description> 
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
%	[nDplotH] = PlotnD(indepVars, indepData, depVar, depData, figH, varargin)
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[nDplotH] = PlotnD(indepVars, indepData, depVar, depData, figH)
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
%	Source function: <a href="matlab:edit PlotnD.m">PlotnD.m</a>
%	  Driver script: <a href="matlab:edit Driver_PlotnD.m">Driver_PlotnD.m</a>
%	  Documentation: <a href="matlab:pptOpen('PlotnD_Function_Documentation.pptx');">PlotnD_Function_Documentation.pptx</a>
%
% See also <add relevant functions> 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/61
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/PlottingUtilities/PlotnD.m $
% $Rev: 1724 $
% $Date: 2011-05-11 18:34:55 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [nDplotH] = PlotnD(indepVars, indepData, depVar, depData, figH, varargin)

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
% nDplotH= -1;

%% Input Argument Conditioning:
% Pick out Properties Entered via varargin
% [<PropertyValue>, varargin]  = format_varargin('<PropertyValue', <Default>, 2, varargin);

%  switch(nargin)
%       case 0
%        figH= ''; depData= ''; depVar= ''; indepData= ''; indepVars= ''; 
%       case 1
%        figH= ''; depData= ''; depVar= ''; indepData= ''; 
%       case 2
%        figH= ''; depData= ''; depVar= ''; 
%       case 3
%        figH= ''; depData= ''; 
%       case 4
%        figH= ''; 
%       case 5
%        
%       case 6
%        
%  end
%
%  if(isempty(figH))
%		figH = -1;
%  end
if nargin == 5
    nDplotH = figure(figH);
else
    nDplotH = figure();
end

xvect = indepData{1};
yvect = indepData{2};
zmtrx = depData;
%% Main Function:
subH = subplot('position',[.2 .35 .6 .55]);
SurfH = surf(xvect,yvect,zmtrx(:,:,1)');
xlabel(indepVars{1}); ylabel(indepVars{2});zlabel(depVar);
xlim([min(xvect) max(xvect)]);ylim([min(yvect) max(yvect)]);zlim([min(min(min(zmtrx))) max(max(max(zmtrx)))]);
editP = uipanel('Parent',nDplotH,'Title',indepVars{3},'Position',[.5 0 .5 .25]);
indexH = uicontrol('Parent',editP,'Style','edit','Position',[20 20 60 20],...
    'String','1','Callback',{@updatePlot SurfH zmtrx indepVars{3} indepData{3}});
sliderP = uipanel('Parent',nDplotH,'Title','Slider','Position',[0 0 .5 .25]);
sliderH = uicontrol('Parent',sliderP,'Style','slider',...
    'Min',1,'Max',length(indepData{3}),...
    'SliderStep',[1/length(indepData{3}) 1/length(indepData{3})],...
    'Value',1,'Position',[20 20 120 20],...
    'Callback',{@updateIndex indexH SurfH zmtrx indepVars{3} indepData{3}});

%% Compile Outputs:
%	nDplotH= -1;

end % << End of function PlotnD >>

%% Callback for edit box
function updatePlot(hObject,eventInfo,SurfH,zmtrx,indexVar,indexVal)
index = floor(str2num(get(hObject,'String')));
set(SurfH,'ZData',zmtrx(:,:,index)');
parentH = get(hObject,'Parent');
set(parentH,'Title',[indexVar '= ' num2str(indexVal(index))])
end

%% Callback for slider
function updateIndex(hObject,eventInfo,indexH,SurfH,zmtrx,indexVar,indexVal)
index = floor(get(hObject,'Value'));
set(indexH,'String',num2str(index));
set(SurfH,'ZData',zmtrx(:,:,index)');
parentH = get(indexH,'Parent');
set(parentH,'Title',[indexVar '= ' num2str(indexVal(index))])
end

%% REVISION HISTORY
% YYMMDD INI: note
% 101101 JPG: Copied over information from the old function.
% 101101 CNF: Function template created using CreateNewFunc
% 081209 HCP: 1st draft working version for 3-D arrays
              %TODO: make compatible with n-D arrays
% 081208 HCP: Original Author
% 081208 CNF: File Created by CreateNewFunc
%**Add New Revision notes to TOP of list**

% Initials Identification: 
% INI: FullName             :  Email                :  NGGN Username 
% HCP: Hien Pham            : hien.pham2@ngc.com    : phamhi2
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
