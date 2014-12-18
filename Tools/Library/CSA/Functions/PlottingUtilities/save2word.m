% SAVE2WORD saves plots to Microsoft Word.
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% save2word:
%     saves the current Matlab figure window or Simulink model window to a 
%   Word file designated by filespec.  If filespec is omitted, the user is 
%   prompted to enter one via UIPUTFILE.  If the path is omitted from 
%   filespec, the Word file is created in the current Matlab working 
%   directory.
%
%  Optional input argument prnopt is used to specify additional save
%  options:
%    -fHandle   Handle of figure window to save
%    -sName     Name of Simulink model window to save
% 
% SYNTAX:
%	[out] = save2word(filespec, prnopt)
%	[out] = save2word(filespec)
%
% INPUTS: 
%	Name    	Size		Units		Description
%	filespec	<size>		<units>		<Description>
%	prnopt	  <size>		<units>		<Description>
%	varargin	[N/A]		[varies]	Optional function inputs that
%	     		        				 should be entered in pairs.
%	     		        				 See the 'VARARGIN' section
%	     		        				 below for more details
%
% OUTPUTS: 
%	Name    	Size		Units		Description
%	out 	     <size>		<units>		<Description> 
%
% NOTES:
%  If the figure has to be pasted as a smaller size bitmap, go to 
%  File->preferences->Figure Copy Template->Copy Options and 
%  check "Match Figure Screen Size" checkbox.
%  Then make the figure small before by setting the position 
%  of the figure to a smaller size using
%  set(gca,'Position',[xpos,ypos,width,height])
%
%	VARARGIN PROPERTIES:
%	PropertyName		PropertyValue	Default		Description
%	<PropertyName>		<units>			<Default>	<Description>
%
% EXAMPLES:
%
%  >> save2word
%       Prompts user for valid filename and saves current figure
%  >> save2word('junk.doc')
%       Saves current figure to MS Word file called junk.doc
%  >> save2word('junk.doc','-f3')
%       Saves figure #3 to MS Word file called junk.doc 
%  >> save2word('models.doc','-sMainBlock')
%       Saves Simulink model named "MainBlock" to file called models.doc
%
%  The command-line method of invoking SAVEPPT will also work:
%  >> save2word models.doc -sMainBlock
%
%	% <Enter Description of Example #1>
%	[out] = save2word(filespec, prnopt, varargin)
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[out] = save2word(filespec, prnopt)
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
%	Source function: <a href="matlab:edit save2word.m">save2word.m</a>
%	  Driver script: <a href="matlab:edit Driver_save2word.m">Driver_save2word.m</a>
%	  Documentation: <a href="matlab:pptOpen('save2word_Function_Documentation.pptx');">save2word_Function_Documentation.pptx</a>
%
% See also saveppt in Mathworks fileexchange
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/506
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/PlottingUtilities/save2word.m $
% $Rev: 1724 $
% $Date: 2011-05-11 18:34:55 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [out] = save2word(filespec, prnopt, varargin)

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
% out= -1;

%% Input Argument Conditioning:
% Pick out Properties Entered via varargin
% [<PropertyValue>, varargin]  = format_varargin('<PropertyValue', <Default>, 2, varargin);

%  switch(nargin)
%       case 0
%        prnopt= ''; filespec= ''; 
%       case 1
%        prnopt= ''; 
%       case 2
%        
%       case 3
%        
%  end
%
%  if(isempty(prnopt))
%		prnopt = -1;
%  end
%% Main Function:
% Establish valid file name:
if nargin<1 | isempty(filespec);
  [fname, fpath] = uiputfile('*.doc');
  if fpath == 0; return; end
  filespec = fullfile(fpath,fname);
else
  [fpath,fname,fext] = fileparts(filespec);
  if isempty(fpath); fpath = pwd; end
  if isempty(fext); fext = '.doc'; end
  filespec = fullfile(fpath,[fname,fext]);
end

% Capture current figure/model into clipboard:
if nargin<2
  print -dmeta
else
  print('-dmeta',prnopt)
end

% Start an ActiveX session with PowerPoint:
word = actxserver('Word.Application');
%word.Visible = 1;

if ~exist(filespec,'file');
   % Create new presentation:
  op = invoke(word.Documents,'Add');
else
   % Open existing presentation:
  op = invoke(word.Documents,'Open',filespec);
end

% Find end of document and make it the insertion point:
end_of_doc = get(word.activedocument.content,'end');
set(word.application.selection,'Start',end_of_doc);
set(word.application.selection,'End',end_of_doc);

% Paste the contents of the Clipboard:
invoke(word.Selection,'Paste');

if ~exist(filespec,'file')
  % Save file as new:
  invoke(op,'SaveAs',filespec,1);
else
  % Save existing file:
  invoke(op,'Save');
end

% Close the presentation window:
invoke(op,'Close');

% Quit MS Word
invoke(word,'Quit');

% Close Word and terminate ActiveX:
delete(word);

%% Compile Outputs:
%	out= -1;

end % << End of function save2word >>

%% REVISION HISTORY
% YYMMDD INI: note
% 101026 JPG: Copied over information from the old function.
% 101026 CNF: Function template created using CreateNewFunc
% 030306 SEJ: Modified from 'saveppt' in Mathworks File Exchange
% ?????? MWB: Creator of 'saveppt'
%**Add New Revision notes to TOP of list**

% Initials Identification: 
% INI: FullName             :  Email                :  NGGN Username 
% JPG: James Patrick Gray   :  james.gray2@ngc.com  :  g61720
% MWB: Mark W. Brown        :  mwbrown@ieee.org
% SEJ: Suresh E Joel        

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
