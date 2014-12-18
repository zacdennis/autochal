% FINDARGS Returns the names of a function's inputs and outputs
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% findArgs:
%     Returns the names of a function's internal input and output
%     arguments.  Inputs and outputs are determined by opening the file 
%     and parsing through every line looking for the 'function' 
%     declaration, which is assumed to be the first word on the line.
%     Careful consideration has been given for functions that have one or
%     no inputs and or output arguments.
%
% SYNTAX:
%	[inputArgs, outputArgs, refLine] = findArgs(funName, flgVerbose)
%	[inputArgs, outputArgs, refLine] = findArgs(funName)
%
% INPUTS:
%	Name        Size        Units	Description
%	 funName	'string'    N/A     Partial or full name of function
%    flgVerbose [1]         [bool]  Show warning messages?
%                                    Default: true
%
% OUTPUTS:
%	Name        Size        Units	Description
%	 inputArgs	{nx1}       N/A     Cell array of strings with the names
%                                    of the function's input arguments
%	 outputArgs	{mx1}       N/A     Cell array of strings with the names
%                                    of the function's output arguments
%    refLine    [r]         [int]   Line #s with the function's
%                                    input/output arguments
%
% NOTES:
%	This is similar to MATLAB's nargin() and nargout() functions.  Those
%	functions will return the number of input or output arguments.  This
%	function will return the names of the function's inputs and outputs.
%
% EXAMPLES:
%   % Retrieves the input and output arguments of the 'meshgrid' function
%   [inputArgs,outputArgs] = findArgs('meshgrid')
%   % inputArgs =
%   %     'x'
%   %     'y'
%   %     'z'
%   % outputArgs =
%   %     'xx'
%   %     'yy'
%   %     'zz'
%   
%   % Retrieves the input and output arguments of the 'gcs' function
%   [inputArgs,outputArgs] = findArgs('gcs')
%   % inputArgs =
%   % {}
%   % outputArgs =
%   % 'cursys'
%
%   % Retrieves the input and output arguments of the 'plot' function
%   % Note: 'plot' is a MATLAB built-in function whose arguments are not externally visible
%   [inputArgs,outputArgs] = findArgs('plot')
%   %   findArgs>> WARNING: Could not find function declaration.  This looks to be a MATLAB built-in function.
%   % inputArgs = 
%   %     {}
%   % outputArgs = 
%   %     {}
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit findArgs.m">findArgs.m</a>
%	  Driver script: <a href="matlab:edit DRIVER_findArgs.m">DRIVER_findArgs.m</a>
%	  Documentation: <a href="matlab:pptOpen('findArgs Documentation.pptx');">findArgs Documentation.pptx</a>
%
% See also nargin, nargout
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://trac.ngst.northgrum.com/CSA/ticket/666
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21) - Aerospace Systems - Redondo Beach, CA
% http://trac.ngst.northgrum.com/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/MatlabUtilities/findArgs.m $
% $Rev: 3247 $
% $Date: 2014-09-04 13:14:33 -0500 (Thu, 04 Sep 2014) $
% $Author: sufanmi $

function [inputArgs,outputArgs,refLine] = findArgs(funName, flgVerbose)

%% Debugging & Display Utilities
spc  = sprintf(' ');                                % One Single Space
tab  = sprintf('\t');                               % One Tab
endl = sprintf('\n');                               % Line Return
[mfpath,mfnam] = fileparts(mfilename('fullpath'));  % Full Path to Function, Name of Function
mfspc = char(ones(1,length(mfnam))*spc);            % String of Spaces the length of the function name
% Example of Display formats ...
% disp([mfnam '>> Output with filename included...' ]);
% disp([mfspc '>> further outputs will be justified the same']);
% disp([mfspc '>> CAUTION: or mfnam: note lack of space after">>"']);
% disp([mfnam '>> WARNING: <- Very important warning (does not terminate)']);
% disp([mfnam '>> ERROR: <-if followed by "return" used if continued exit desired']);
% errstr = [mfname >> ERROR: <define error here> ]; will term with error; "doc Error" ';
% error([mfnam 'class:file:Identifier'],errstr);

%% Initialize Outputs
inputArgs ={};
outputArgs ={};

if(nargin < 2)
    flgVerbose = '';
end

if(isempty(flgVerbose))
    flgVerbose = 1;
end

%% Main Function
[filePath, fileName, fileExt] = fileparts(funName);
if( ~isempty(fileExt) && ~isempty(fileName) && ~isempty(fileExt) )
    % It's a full pathname
    fileName = funName;
else
    % Got to get a little more creative
    if(isempty(fileExt))
        fileExt = '.m';
    end
    fileName = which([funName fileExt]);
    
    if(~isempty(fileName))
        % Now you really need to be smart...
        % TBD
    end
end


[fileID, message] = fopen(fileName);
refLine = [];

if isempty(message) %a .m file exists
    %capture the 1st line of the .m file
    %this is where a function definition will likely exist
    flgMatch = 0;
    fcn_line = '';
    iLine = 0;
    
    while 1
        line = fgetl(fileID);
        if ~ischar(line)
            break
        else
            iLine = iLine + 1;
            
            % Loop Through all the file's lines and look for 'function' as
            % the first word
            firstWord = strtok(line);
            if strcmp(lower(firstWord),'function')
                flgMatch = 1;
                fcn_line = line;
                fcn_line = strrep(fcn_line, ' ', '');   % Remove all spaces
                refLine = [refLine iLine];
                
                while(strcmp(fcn_line(end-2:end), '...'))
                    % Function declaration spans more than one line
                    line = fgetl(fileID);
                    if ~ischar(line)
                        break
                    else
                        iLine = iLine + 1;
                        refLine = [refLine iLine];
                        fcn_line = strrep(fcn_line, ' ', '');   % Remove all spaces
                        fcn_line = [fcn_line line];
                    end
                end
                break
            end
        end
    end
    
    if(flgMatch == 0)
        strHelp = help(funName);
        if(~isempty(strHelp));
            if(flgVerbose)
                disp([mfnam '>> WARNING: Could not find function declaration.  This looks to be a MATLAB built-in function.']);
            end
        else
            if(flgVerbose)
                disp([mfnam '>> WARNING: Could not find function declaration.  Are you sure this is a MATLAB function?']);
            end
        end
        
    else
        fcn_line = strrep(fcn_line, '...', '');             % Remove Any Line Continuations
        fcn_line = strrep(fcn_line, ' ', '');               % Remove All Spaces
        fcn_line = fcn_line((length('function')+1):end);    % Remove the function declaration
        
        %find the function's input and output arguments
        fcn_info = regexp(fcn_line, '=', 'split');
        if(size(fcn_info, 2) == 1)
            % Assumes there is no '=' sign (e.g. there are no outputs)
            outputStr = '';
            inputStr = fcn_info{1};
        else
            outputStr = fcn_info{1};
            inputStr = fcn_info{2};
        end
        
        if(~isempty(outputStr))
            % At least 1 output exists
            outputArgs = regexp(outputStr, '\[(.*)\]', 'tokens');
            if isempty(outputArgs)
                outputArgs={outputStr};
            else
                outputArgs = outputArgs{:};
                outputArgs = outputArgs{:};
                outputArgs = strrep(outputArgs, ' ', '');
                outputArgs = regexp(outputArgs, ',', 'split')';
            end
        end
        
        % Support misnamed functions (ie the actual .m file is different
        % than the name in the function declaration
        ptrParen = findstr(inputStr, '(');
        if(isempty(ptrParen))
            funcName = inputStr;
            inputArgs = {};
        else
            funcName = inputStr(1:ptrParen(1)-1);
            inputStr = inputStr(ptrParen(1):end);
            
            inputStr = inputStr((length(funName)+1):end);   % Remove the Function name, leaving just the inputs
            
            % At least 1 input exists
            inputArgs = regexp(fcn_line, '\((.*)\)', 'tokens');
            
            if isempty(inputArgs)
                inputArgs={inputStr};
            else
                inputArgs = inputArgs{:};
                inputArgs = inputArgs{:};
                inputArgs = strrep(inputArgs, ' ', '');
                inputArgs = regexp(inputArgs, ',', 'split')';
            end
        end
        
        [~, funNameShort] = fileparts(funName);
        if(~strcmp(funNameShort, funcName))
            disp(sprintf('%s : WARNING : The filename ''%s'' and function declaration ''%s'' differ!  Update the function declaration', ...
                mfilename, funNameShort, funcName));
            disp(sprintf('%s             in %s...', spaces(length(mfilename)), funName));
        end
    end
    %close the file
    fclose(fileID);
end

if ~isempty(message) % a .m file does not exist
    if(flgVerbose)
        disp([mfnam '>> ERROR: ' funName '.m was not found!']);
    end
end

end % << End of function findArgs >>

%% REVISION HISTORY
% YYMMDD INI: note
% 101013 MWS: Added flgVerbose
% 100816 MWS: Created function with help from Craig DeLuccia at the
%               Mathworks
% 100816 CNF: Function template created using CreateNewFunc.m
%**Add New Revision notes to TOP of list**

% Initials Identification:
% INI: FullName     :  Email                : NGGN Username
% MWS: Mike Sufana  : mike.sufana@ngc.com   : sufanmi

%% FOOTER
% Distribution
% WARNING - This document contains technical data whose export is
%   restricted by the Arms Export Control Act (Title 22, U.S.C. 2751 et 
%   seq.) or the Export Administration Act of 1979, as amended, Title 50,
%   U.S.C., App.2401et seq. Violation of these export-control laws is 
%   subject to severe civil and/or criminal penalties.
%
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------------------- UNCLASSIFIED ---------------------------
