% BIN2MAT Reads in 2-D table data from a binary file
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% bin2mat:
%     Reads a 2-D matrix from a binary file.  Currently assumes that data
%     is saved using 'double' precision.
% 
% SYNTAX:
%   [mat] = bin2mat(strFilename, numRefSig, arrColDes, arrRowDes, flgVerbose, flgTranspose)
%   [mat] = bin2mat(strFilename, numRefSig, arrColDes, arrRowDes, flgVerbose)
%	[mat] = bin2mat(strFilename, numRefSig, arrColDes, arrRowDes)
%	[mat] = bin2mat(strFilename, numRefSig, arrColDes)
%	[mat] = bin2mat(strFilename, numRefSig)
%
% INPUTS: 
%	Name            Size		Units       Description
%   strFilename     'string'    [char]      Filename of binary file
%   numRefSig       [1]         [int]       Number of Signals in recorded data
%   arrColDes       [1xM]       [idx]       Indices of desired columns to
%                                            extract (Default is -1: all)
%   arrRowDes      [1xM]       [idx]       Indices of desired rows to
%                                            extract (Default is -1: all)
%   flgVerbose      [1]         [bool]      Show loading?
%                                            Default is true
%   flgTranspose    [1]         [bool]      Transpose data after it has
%                                            been extracted? (Default is
%                                            true)
% OUTPUTS: 
%	Name            Size		Units       Description
%   mat             [N x M]     [varies]    Extracted data in column format.
%                                           Each signal has its own column.
%
% NOTES:
%   the size of 'mat' is based on 'flgTranspose'.  If...
%   flgTranspose = 1, 'mat' is [N x M]  <-- Default
%   flgTranspose = 0, 'mat' is [M x N]
%
% EXAMPLES:
% % Example 1a:
% % Create a table with 4 columns of data and save it to binary:
% t = [0:10]';
% tbl = [t t*2 sin(t) cos(t)]
% 
% % Save the data to binary:
% strFilename = 'test.bin';
% mat2bin(strFilename, tbl);
% 
% % Read the data from binary:
% [tbl2] = bin2mat(strFilename, 4)
% 
% % Double check that the data is correct
% deltaTbl = tbl2 - tbl
% flgGood = ~max(max(deltaTbl > 0))
%
% % Example 1b:
% % Load in only the 1st and 4th columns of 'tbl'
% [tbl_14col] = bin2mat(strFilename, 4, [1 4])
% deltaTbl = tbl_14col - tbl(:,[1 4])
% flgGood = ~max(max(deltaTbl > 0))
%
%  % Example 1c:
%  % Load in only selected rows of 'tbl'. Assume that the first column of 
%  % 'tbl' is time.  Pick off data at 2 second intervals
% arrTimeDes = find(mod(t,2)==0);
% [tbl_2sec] = bin2mat(strFilename, 4, -1, arrTimeDes)
% deltaTbl = tbl_2sec - tbl(arrTimeDes,:)
% flgGood = ~max(max(deltaTbl > 0))
%
% % Example 1d:
% %  Same as 1c but load in only the 1st and 4th columns
% [tbl_14col_2sec] = bin2mat(strFilename, 4, [1 4], arrTimeDes)
% deltaTbl = tbl_14col_2sec - tbl(arrTimeDes,[1 4])
% flgGood = ~max(max(deltaTbl > 0))
%
% SOURCE DOCUMENTATION:
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit bin2mat.m">bin2mat.m</a>
%	  Driver script: <a href="matlab:edit Driver_bin2mat.m">Driver_bin2mat.m</a>
%	  Documentation: <a href="matlab:pptOpen('bin2mat_Function_Documentation.pptx');">bin2mat_Function_Documentation.pptx</a>
%
% See also mat2bin
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/436
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/MatlabUtilities/bin2mat.m $
% $Rev: 2436 $
% $Date: 2012-07-26 17:03:53 -0500 (Thu, 26 Jul 2012) $
% $Author: sufanmi $

function [mat] = bin2mat(strFilename, numRefSig, arrColDes, arrRowDes, flgVerbose, flgTranspose)

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

%% Input Argument Conditioning:
if(nargin < 6)
    flgTranspose = true;
end

if(nargin < 5)
    flgVerbose = true;
end

if(nargin < 4)
    arrRowDes = [];
end

if(nargin < 3)
    arrColDes = [];
end

if( (nargin < 2) || isempty(numRefSig))
    errstr = [mfnam '>> ERROR: Number of Reference Signals MUST be specified. See ' mlink ' for more help.'];
    error([mfnam 'class:file:Identifier'], errstr);    % Call error function
end

if( (isempty(arrColDes)) || any(arrColDes == -1) )
    arrColDes = 1:numRefSig;
end
arrColDes = floor(abs(arrColDes));
arrColDes = max(arrColDes, 1);
arrColDes = min(arrColDes, numRefSig);
arrColDes = unique(arrColDes);

%% Main Function:
if(~exist(strFilename))
    disp(sprintf('%s : WARNING : ''%s'' does not exist.  Ignoring binary to matrix conversion.', ...
        mfilename, strFilename));
    mat = [];
else
    
    fid = fopen(strFilename, 'r');
    fseek(fid,0,'bof');
    fseek(fid,0,'eof');
    numDatapoints = ftell(fid);
    fseek(fid,0,'bof');
    
    lenDouble = 8;  % Number of bytes in a double
    numRows = (numDatapoints/lenDouble) / numRefSig;

    if( (isempty(arrRowDes)) || any(arrRowDes == -1) )
        arrRowDes = 1:numRows;
    end
    arrRowDes = unique(floor(abs(arrRowDes)));

    numDesSignals = length(arrColDes);
    numDesRow = length(arrRowDes);
    
    if(numDesSignals == numRefSig)
        % Use the Regular Full Version
        if(~flgTranspose)
            mat = zeros(numRows, numRefSig);
            mat = fread(fid, [numRefSig numRows], 'double');
            
        else
            matTransFull = zeros(numRows, numRefSig);
            matTransFull = fread(fid, [numRefSig numRows], 'double');
            
            mat = zeros(numDesRow, numDesSignals);
            mat =  matTransFull(arrColDes,arrRowDes)';
        end
        
        
    else
        numRowsDes = length(arrRowDes);
        
        if(flgTranspose)
            mat = zeros(numRowsDes, numDesSignals);
        else
            mat = zeros(numDesSignals, numRowsDes);
        end
        
        % Time to get creative for memory saving purposes:
        for iSig = 1:numDesSignals
            numSignal = arrColDes(iSig);
            
            if(flgVerbose)
                disp(sprintf('%s : %d/%d (%.2f%%) Extracting column %d/%d...', mfilename, iSig, ...
                    numDesSignals, (iSig/numDesSignals*100), numSignal, numRefSig ));
            end
            
            % Go to beginning of file
            fseek(fid,0,'bof');
            
            % Figure out starting index of desired signal
            ptrStart = (numSignal-1)*lenDouble;
            fseek(fid, ptrStart,'bof');
            
            % Faster Method? (This will result in slightly more memory usage)
            %   Picks off whole array 1st and then down-selectes
            if(1)
                % Pick off the whole array:
                
                arrMat = zeros(1, numRows);
                arrMat = fread(fid, [1 numRows], 'double', (numRefSig-1)*lenDouble);
                % Down-select:
                if(flgTranspose)
                    mat(:,iSig) = arrMat(arrRowDes)';
                else
                    mat(iSig,:) = arrMat(arrRowDes);
                end
            end
            
            if(0)
                % Slower method: Loops through the binary file and only
                % picks off desired members.  
                ictr = 0;
                
                % Loop through all time points
                for i = 1:numRows
                    newPt = fread(fid, 1, 'double');
                    
                    if(any(arrRowDes == i))
                        ictr = ictr + 1;
                        if(flgTranspose)
                            mat(ictr, iSig) = newPt;
                        else
                            mat(iSig, ictr) = newPt;
                        end
                    end
                    
                    if(i < numRows)
                        % Skip ahead through file by the number of reference
                        % signals, stoping right before the next data point
                        fseek(fid,(numRefSig-1)*lenDouble,'cof');
                    end
                end
            end
            
        end
    end
    
    fclose(fid);
    
end

end % << End of function bin2mat >>

%% REVISION HISTORY
% YYMMDD INI: note
% 110224 MWS: Added example using mat2bin
% 101025 JPG: Copied over information from the old function.
% 101025 CNF: Function template created using CreateNewFunc
%**Add New Revision notes to TOP of list**

% Initials Identification: 
% INI: FullName             : Email                 : NGGN Username 
% JPG: James Patrick Gray   : james.gray2@ngc.com   : g61720 
% MWS: Mike Sufana          : mike.sufana@ngc.com   : sufanmi

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
