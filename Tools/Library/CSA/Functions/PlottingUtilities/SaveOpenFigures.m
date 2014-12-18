% SAVEOPENFIGURES Saves open figures to a Microsoft Word Document
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% SaveOpenFigures:
%     Saves open figures to a Microsoft Word Document 
% 
% SYNTAX:
%	[hout] = SaveOpenFigures(filename, list_figure_handles, str_orientation)
%	[hout] = SaveOpenFigures(filename, list_figure_handles)
%	[hout] = SaveOpenFigures(filename)
%
% INPUTS: 
%	Name                Size    Units	Description
%   filename            [string]        Full filename to save figures to
%   list_figure_handles [array]         Array of figure numbers to save
%   str_orientation     [string]        Desired Orientation of document
%                                           'Portrait' {default}
%                                           'Landscape'
%	varargin	[N/A]		[varies]	Optional function inputs that
%	     		        				 should be entered in pairs.
%	     		        				 See the 'VARARGIN' section
%	     		        				 below for more details
%
% OUTPUTS: 
%	Name               	Size		Units		Description
%	hout	               <size>		<units>		<Description> 
%
% NOTES:
%  -If a complete filename is not provided (e.g. 'TestResults.doc'), then
%     the figures will be saved to the user's local 'My Documents' folder.
%
%  -For best results, use the 'pwd' expression with the name of the file
%     (e.g. [pwd '\TestResults.doc']).  This will prevent the user from
%     having to hunt for the file after function execution.
%
%  -If list_figure_handles is not defined then the function saves ALL of
%     the open figures
%
%  -If the orientation is not defined then the default is 'Portrait'
%
%  -This function uses the save2openword function.
%
%	VARARGIN PROPERTIES:
%	PropertyName		PropertyValue	Default		Description
%	<PropertyName>		<units>			<Default>	<Description>
%
% EXAMPLES:
%	% <Enter Description of Example #1>
%	[hout] = SaveOpenFigures(filename, list_figure_handles, str_orientation, varargin)
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[hout] = SaveOpenFigures(filename, list_figure_handles, str_orientation)
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
%	Source function: <a href="matlab:edit SaveOpenFigures.m">SaveOpenFigures.m</a>
%	  Driver script: <a href="matlab:edit Driver_SaveOpenFigures.m">Driver_SaveOpenFigures.m</a>
%	  Documentation: <a href="matlab:pptOpen('SaveOpenFigures_Function_Documentation.pptx');">SaveOpenFigures_Function_Documentation.pptx</a>
%
% See also save2openword
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/507
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/PlottingUtilities/SaveOpenFigures.m $
% $Rev: 1724 $
% $Date: 2011-05-11 18:34:55 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [hout] = SaveOpenFigures(filename, list_figure_handles, str_orientation, varargin)

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
% hout= -1;

%% Input Argument Conditioning:
% Pick out Properties Entered via varargin
% [<PropertyValue>, varargin]  = format_varargin('<PropertyValue', <Default>, 2, varargin);

%  switch(nargin)
%       case 0
%        str_orientation= ''; list_figure_handles= ''; filename= ''; 
%       case 1
%        str_orientation= ''; list_figure_handles= ''; 
%       case 2
%        str_orientation= ''; 
%       case 3
%        
%       case 4
%        
%  end
%
%  if(isempty(str_orientation))
%		str_orientation = -1;
%  end
%% Main Function:
%% Retrieve Handles of all open figure windows:
if nargin == 3
    if(isempty(list_figure_handles));
        list_figure_handles = sort(allchild(0));
    end
end
   
if nargin < 2
     list_figure_handles = sort(allchild(0));
end

if(isempty(list_figure_handles))
    %% No figures Exist, Exit Program
    disp('ERROR : SaveOpenFigures : No Figures Exist! Ignoring Function Call.');
else
              
    % Start an ActiveX session with Word:
    word = actxserver('Word.Application');

    % Create new file:
    op = invoke(word.Documents, 'Add');
    
    % Determine Word Orientation:
    if nargin < 3
        str_orientation = 'portrait';
    end

    switch str_orientation
        case {'LANDSCAPE', 'Landscape', 'landscape', 'l', 'L'}
            % Desired Orientation is Landscape:
            size_figure = [350 100 1150 800];
            word.activeDocument.pageSetup.orientation = 'wdOrientLandscape';
            
        otherwise
            % Desired Orientation is Portrait:
            size_figure = [100 350 768 770];
            word.activeDocument.pageSetup.orientation = 'wdOrientPortrait';
    end
        
    %% Loop Through Each Open Figure
    for i = 1:length(list_figure_handles);

        %% Retrieve Figure Handle:
        fig_handle = list_figure_handles(i);
        
        %% Move Handle Focus to Figure:
        figure(fig_handle);
        
        %% Retrieve Position of Current Figure
        figSizeOrig = get(fig_handle, 'position');

        %% Set the Size of the Figure for a 1600x1200 screen
        %   (good resolution for copying to Word):
        set(fig_handle, 'position', size_figure);

        %% Copy the figure to Word:
        save2openword(word);

        %% Return Figure to Original Size:
        set(fig_handle, 'position', figSizeOrig);
    end
    
    %% Check filename:
    %   Ensure that the filename has a .doc extension
    ptrDoc = strfind(filename, '.doc');
    if(isempty(ptrDoc))
        filename = [filename '.doc'];
    end
    
    %% Delete Existing File of same filename:
    if(exist(filename) == 2)
        delete(filename);
    end
        
    %% Save File:
    invoke(op,'SaveAs', filename, 1);

    %% Close the presentation window:
    invoke(op,'Close');

    %% Quit MS Word
    invoke(word,'Quit');

    %% Close Word and terminate ActiveX:
    delete(word);

    disp(' ');
    disp('SaveOpenFigures : Saving Complete.  Figures were saved to:');
    disp(['   ' filename '.']);
end


%% Compile Outputs:
%	hout= -1;

end % << End of function SaveOpenFigures >>

%% REVISION HISTORY
% YYMMDD INI: note
% 101026 JPG: Copied over information from the old function.
% 101026 CNF: Function template created using CreateNewFunc
% 061116 MWS: Added ability to save in landscape or portrait form
%             Added logic on filename generation
% 061107 MWS: Script Created
%**Add New Revision notes to TOP of list**

% Initials Identification: 
% INI: FullName             :  Email                :  NGGN Username 
% JPG: James Patrick Gray   :  james.gray2@ngc.com  :  g61720 
% MWS: Mike Sufana          :  mike.sufana@ngc.com  :  sufanmi

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
