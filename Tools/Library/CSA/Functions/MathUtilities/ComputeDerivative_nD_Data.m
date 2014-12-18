% COMPUTEDERIVATIVE_ND_DATA Computes derivatives for Generic 1 to 6-D table
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% ComputeDerivative_nD_Data:
%   This is computes the derivative of a 1 to 6-dimensional table
%
% SYNTAX:
%	TableND = ComputeDerivative_nD_Data(TableND, lstIDV, lstDeriv, strType)
%	TableND = ComputeDerivative_nD_Data(TableND, lstIDV, lstDeriv)
%
% INPUTS:
%	Name    	Size		Units		Description
%	TableND		{struct}    N/A         Structure with 1 to 6-D Table Data
%	lstIDV		{Nx1}       'string'	Cell array list of Independent
%                                        Variables (IV)
%    lstIDV{:,1}            'string'    Name of IV in TableND
%    lstIDV{:,2}            'string'    Units for IV in TableND
%	lstDeriv    {Mx3}       'string'    Cell array of DV/IV Combos to use
%                                        to compute derivatives 
%    lstDeriv{:,1}          'string'    Name of DV in TableND
%    lstDeriv{:,2}          'string'    Name of IDV in TableND
%    lstDeriv{:,3}          'string'    Name of Derivative {Optional}
%                                         Default: [DV '_' IDV]
%   strType     'string'    [char]      Type of derivative to perform. Options:
%                                        'uniform'
%                                        'nonuniform' <-- Default
% OUTPUTS:
%	Name		Size		Units		Description
%	TableND		{struct}    N/A         Structure with 1 to 6-D Table Data
%                                        which will now include desired
%                                        derivative tables
%
% NOTES:
%   'uniform' Method: 
%       Computes the linear derivative of some function y = f(x) using a 
%       tangent line approximation. The function grabs 20*(number of 
%       y-points) number of points between points using a spline fit and 
%       then computes the forward, central, and backward difference for 
%       derivatives. This is then interpolated for each x-point. It is 
%       recommended that this only be used on data which is uniformly 
%       distributed in x.
%
%   'nonuniform' Method:
%       Computes the linear derivative of some function y = f(x) using a 
%       tangent line approximation. Unlike 'uniform', this method does NOT 
%       do any curve fitting of the data. It merely does a forward 
%       difference on the first point, central differences on the 
%       midpoints, and backward difference on the end point. This is better
%       suited for use on data which is not uniform distributed in x.
%
% EXAMPLES:
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit ComputeDerivatives_nD_Data.m">ComputeDerivatives_nD_Data.m</a>
%	  Driver script: <a href="matlab:edit Driver_ComputeDerivatives_nD_Data.m">Driver_ComputeDerivatives_nD_Data.m</a>
%	  Documentation: <a href="matlab:winopen(which('ComputeDerivatives_nD_Data_Function_Documentation.pptx'));">ComputeDerivatives_nD_Data_Function_Documentation.pptx</a>
%
% See also Interp1D, Interp2D, Interp3D, Interp4D, Interp5D, Interp6D,
% ComputeDerivatives
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://trac.ngst.northgrum.com/CSA/ticket/775
%
% Copyright Northrop Grumman Corp 2012
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://trac.ngst.northgrum.com/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/MathUtilities/ComputeDerivative_nD_Data.m $
% $Rev: 2755 $
% $Date: 2012-12-06 19:53:55 -0600 (Thu, 06 Dec 2012) $
% $Author: sufanmi $

function TableND = ComputeDerivative_nD_Data(TableND, lstIDV, lstDeriv, strType)

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
% Pick out Properties Entered via varargin
if(nargin < 4)
    strType = '';
end

if(isempty(strType))
    strType = 'nonuniform';
end

if(ischar(lstIDV))
    lstIDV = { lstIDV };
end


%% Main Function:
numIDV = size(lstIDV, 1);
[numDeriv, numDerivCol] = size(lstDeriv);

for iIDV = 1:numIDV
    curIDV = lstIDV{iIDV, 1};
    curIDV = strtok(curIDV);    % Shave off any units, if provided
    eval(sprintf('ID%d = curIDV;', iIDV));
    eval(sprintf('DataX%d = TableND.%s;', iIDV, curIDV));
end

% Initialize:
num_Lookup_SO2 = 1;
num_Lookup_SO3 = 1;
num_Lookup_SO4 = 1;
num_Lookup_SO5 = 1;
num_Lookup_SO6 = 1;

for iDeriv = 1:numDeriv
    
    % Extract desired DV to use for derivative (e.g. 'CL')
    curDV = lstDeriv{iDeriv, 1};
    
    % Initialize tbl_DX_DY:
    tbl_DX_DY = TableND.(curDV) * 0;
    
    % Extract desired IDV to use for derivative (e.g. 'Alpha_deg')
    cur_IDV_for_Deriv = lstDeriv{iDeriv,2};
    
    % Extract desired string to use for deriviative string (e.g. 'CL_Alpha')
    if(numDerivCol > 2)
        cur_DV_Deriv = lstDeriv{iDeriv, 3};
    else
        cur_DV_Deriv = [curDV '_' cur_IDV_for_Deriv];    
    end
    
    % Figure out the order in which to process the data:
    iIDV_Deriv = 0;
    for iIDV = 1:numIDV
        curIDV = lstIDV{iIDV, 1};
        if(strcmp(curIDV, cur_IDV_for_Deriv))
            iIDV_Deriv = iIDV;
            eval(sprintf('arr_Y = DataX%d;', iIDV_Deriv));
            break;
        end
    end
    sortOrder = [iIDV_Deriv setxor([1:numIDV],iIDV_Deriv)];
    
    %%
    for iIDV = 1:numIDV
        eval(sprintf('Lookup_SO%d = DataX%d;', iIDV, sortOrder(iIDV)));
        eval(sprintf('ID_SO%d = ID%d;', iIDV, sortOrder(iIDV)));
        eval(sprintf('num_Lookup_SO%d = length(Lookup_SO%d);', iIDV, iIDV));
    end

    % Loop through the 6th plot order point
    for iID_SO6 = 1:num_Lookup_SO6
        if(numIDV > 5)
            cur_SO6 = Lookup_SO6(iID_SO6);
        end
        
        % Loop through the 5th plot order point
        for iID_SO5 = 1:num_Lookup_SO5
            if(numIDV > 4)
                cur_SO5 = Lookup_SO5(iID_SO5);
            end
            
            % Loop through the 4th plot order point
            for iID_SO4 = 1:num_Lookup_SO4
                if(numIDV > 3)
                    cur_SO4 = Lookup_SO4(iID_SO4);
                end
                
                % Loop through the 3rd plot order point
                for iID_SO3 = 1:num_Lookup_SO3
                    if(numIDV > 2)
                        cur_SO3 = Lookup_SO3(iID_SO3);
                    end
                    
                    % Loop through the 2nd sorted order point
                    for iID_SO2 = 1:num_Lookup_SO2
                        if(numIDV > 1)
                            cur_SO2 = Lookup_SO2(iID_SO2);
                        end

                        % Set the 1st sorted order points
                        cur_SO1 = Lookup_SO1;

                        for iIDV = 1:numIDV
                            eval(sprintf('curID%d = cur_SO%d;', sortOrder(iIDV), iIDV));
                            eval(sprintf('idxID%d = find(DataX%d == curID%d);', sortOrder(iIDV), sortOrder(iIDV), sortOrder(iIDV)));
                        end
                        
                        switch numIDV
                            case 1
                                arr_X = squeeze(Interp1D(DataX1, ...
                                    TableND.(curDV), curID1));
                            case 2
                                arr_X = squeeze(Interp2D(DataX1, DataX2, ...
                                    TableND.(curDV), ...
                                    curID1, curID2));
                            case 3
                                arr_X = squeeze(Interp3D(DataX1, DataX2, ...
                                    DataX3, TableND.(curDV), ...
                                    curID1, curID2, curID3));
                            case 4
                                arr_X = squeeze(Interp4D(DataX1, DataX2, ...
                                    DataX3, DataX4, TableND.(curDV), ...
                                    curID1, curID2, curID3, curID4));
                            case 5
                                arr_X = squeeze(Interp5D(DataX1, DataX2, ...
                                    DataX3, DataX4, DataX5, TableND.(curDV), ...
                                    curID1, curID2, curID3, curID4, curID5));
                            case 6
                                arr_X = squeeze(Interp6D(DataX1, DataX2, ...
                                    DataX3, DataX4, DataX5, DataX6, TableND.(curDV), ...
                                    curID1, curID2, curID3, curID4, curID5, curID6));
                        end
                        
                        % Compute the derivative:
                        arr_DY_DX = ComputeDerivatives(arr_Y, arr_X, strType);
                        
                        % Place the array back in the reference table:
                        switch numIDV
                            case 1
                                tbl_DX_DY(idxID1) = arr_DY_DX;
                                
                            case 2
                                tbl_DX_DY(idxID1, idxID2) = arr_DY_DX;
                                
                            case 3
                                tbl_DX_DY(idxID1, idxID2, idxID3) = arr_DY_DX;
                                
                            case 4
                                tbl_DX_DY(idxID1, idxID2, idxID3, idxID4) = arr_DY_DX;
                                
                            case 5
                                tbl_DX_DY(idxID1, idxID2, idxID3, idxID4, idxID5) = arr_DY_DX;
                                
                            case 6
                                tbl_DX_DY(idxID1, idxID2, idxID3, idxID4, idxID5, idxID6) = arr_DY_DX;
                        end
                    end
                end
            end
        end
    end
    
    TableND.(cur_DV_Deriv) = tbl_DX_DY;
    
end



end

%% Compile Outputs:

% << End of function PComputeDerivatives_nD_Data >>

%% REVISION HISTORY
% YYMMDD INI: note
% 121102 MWS: Created function based on Plot_nD_Data
%**Add New Revision notes to TOP of list**

% Initials Identification:
% INI: FullName             :  Email                :  NGGN Username
% MWS: Mike Sufana          : mike.sufana@ngc.com   :  sufanmi

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
