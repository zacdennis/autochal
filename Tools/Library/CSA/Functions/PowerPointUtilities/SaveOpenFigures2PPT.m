% SAVEOPENFIGURES2PPT Saves open figures to a Microsoft PowerPoint
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% SaveOpenFigures2PPT:
%     Saves open figures to a Microsoft PowerPoint
% 
% SYNTAX:
%	[] = SaveOpenFigures2PPT(pptFilename, strTitle, flgDoubleUp, list_figure_handles, flgClose, strTemplate, varargin, 'PropertyName', PropertyValue)
%	[] = SaveOpenFigures2PPT(pptFilename, strTitle, flgDoubleUp, list_figure_handles, flgClose, strTemplate, varargin)
%	[] = SaveOpenFigures2PPT(pptFilename, strTitle, flgDoubleUp, list_figure_handles, flgClose, strTemplate)
%	[] = SaveOpenFigures2PPT(pptFilename, strTitle, flgDoubleUp, list_figure_handles, flgClose)
%   SaveOpenFigures( pptFilename, strTitle, flgDoubleUp )
%   SaveOpenFigures( pptFilename, strTitle )
%   SaveOpenFigures( pptFilename )
%
% INPUTS: 
%	Name               	Size		Units		Description
%   pptFilename             [string]    Full filename to save figures to
%   strTitle                [string]    Title String (Default is '')
%   flgDoubleUp             [bool]      Plot figures side by side in [1x2]
%                                        arrangement (Default is 0)
%   list_figure_handles     [array]     Array of figure numbers to save
%   flgClose                [bool]     Close ppt after adding figures?
%                                       (Default is 0)
%	varargin	[N/A]		[varies]	Optional function inputs that
%	     		        				 should be entered in pairs.
%	     		        				 See the 'VARARGIN' section
%	     		        				 below for more details
%
% OUTPUTS: 
%	Name               	Size		Units		Description
%	    	                   <size>		<units>		<Description> 
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
%  -This function uses the save2ppt function.
%
%	VARARGIN PROPERTIES:
%	PropertyName		PropertyValue	Default		Description
%	<PropertyName>		<units>			<Default>	<Description>
%
% EXAMPLES:
%	% <Enter Description of Example #1>
%	[] = SaveOpenFigures2PPT(pptFilename, strTitle, flgDoubleUp, list_figure_handles, flgClose, strTemplate, varargin)
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[] = SaveOpenFigures2PPT(pptFilename, strTitle, flgDoubleUp, list_figure_handles, flgClose, strTemplate)
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
%	Source function: <a href="matlab:edit SaveOpenFigures2PPT.m">SaveOpenFigures2PPT.m</a>
%	  Driver script: <a href="matlab:edit Driver_SaveOpenFigures2PPT.m">Driver_SaveOpenFigures2PPT.m</a>
%	  Documentation: <a href="matlab:pptOpen('SaveOpenFigures2PPT_Function_Documentation.pptx');">SaveOpenFigures2PPT_Function_Documentation.pptx</a>
%
% See also save2ppt
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/508
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/PowerPointUtilities/SaveOpenFigures2PPT.m $
% $Rev: 1854 $
% $Date: 2011-06-01 18:23:41 -0500 (Wed, 01 Jun 2011) $
% $Author: sufanmi $

function [] = SaveOpenFigures2PPT(pptFilename, strTitle, flgDoubleUp, list_figure_handles, flgClose, strTemplate, varargin)

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

%% Input Argument Conditioning:
if nargin < 6
    strTemplate = '';
end

if nargin < 5
    flgClose = 0;
end

if nargin < 4
     list_figure_handles_raw = sort(allchild(0)); j = 0;
     for i = 1:length(list_figure_handles_raw);
         cur_fig_handle = list_figure_handles_raw(i);
         if(isfig(cur_fig_handle))
             j = j + 1;
             list_figure_handles(j) = cur_fig_handle;
         end
     end
end

if nargin < 3
    flgDoubleUp = 0;
end

if nargin < 2
    strTitle = '';
end

%% Retrieve Handles of all open figure windows:
if(isempty(list_figure_handles))
     list_figure_handles = sort(allchild(0));   
end

%% Check to see if it is indeed a figure:
list_figure_handles_raw = list_figure_handles;
arr_isfig = isfig(list_figure_handles_raw);
if (size(arr_isfig, 2) > 1)
    idx_isfig = (1:length(arr_isfig))' .* arr_isfig';
else
    idx_isfig = (1:length(arr_isfig))' .* arr_isfig;
end
list_figure_handles = list_figure_handles_raw(idx_isfig);

%% Main Function:
if(isempty(list_figure_handles))
    %% No figures Exist, Exit Program
    disp('ERROR : SaveOpenFigures : No Figures Exist! Ignoring Function Call.');
else
    
    numFigs = length(list_figure_handles);

    if(flgDoubleUp)
        for iFig = 1:2:numFigs;
            
            curFig(1) = list_figure_handles(iFig);
            if(iFig == numFigs)
                curFig(2) = 0;
            else
                curFig(2) = list_figure_handles(iFig+1);
            end
            disp(sprintf('[%d/%d] Saving Figures %d & %d to PPT', ...
                (iFig+1)/2, ceil(numFigs/2), curFig(1), curFig(2)));
            save2ppt(pptFilename, curFig, strTitle, [], flgClose, strTemplate);
        end
        
    else
        for iFig = 1:numFigs;
            curFig = list_figure_handles(iFig);
            disp(sprintf('[%d/%d] Saving Figure %d to PPT', iFig, numFigs, curFig));
            save2ppt(pptFilename, curFig, strTitle, [], flgClose, strTemplate);
        end
    end

    disp(' ');
    disp(sprintf('%s : Saving Complete.  Figures were saved to:', mfilename));
    disp(sprintf('     %s.', pptFilename));
end


%% Compile Outputs:
%	= -1;

end % << End of function SaveOpenFigures2PPT >>

%% REVISION HISTORY
% YYMMDD INI: note
% 101026 JPG: Copied over information from the old function.
% 101026 CNF: Function template created using CreateNewFunc
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
