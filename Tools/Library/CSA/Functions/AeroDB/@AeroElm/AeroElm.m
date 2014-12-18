% AEROELM Virtual Class File for AeroXXX
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% AeroElm:
%     < Function Description > 
% 
% Inputs - IndepVars: {0,[1]}: <explain {options, [Default]}> 
%		 - Depvars: {0,[1]}: <explain {options, [Default]}> 
%		 
% Output - obj: <Explanation> 
%        
% <any additional informaton>
%
% Example:
%	[obj] = AeroElm(IndepVars,Depvars);
%
% See also <add relevant funcions> 
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/616
%
% Copyright Northrop Grumman Corp 2011

% Subversion Revision Informaton At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/AeroDB/@AeroElm/AeroElm.m $
% $Rev:: 1713                                                 $
% $Date:: 2011-05-11 15:12:26 -0500 (Wed, 11 May 2011)        $

classdef AeroElm < dynamicprops
    %file: @AeroElm\AeroElm.m
    properties
        Name = {''};
        Source = datestr(now,31)
        Notes = '';
        Version = '';
        UserData =[];
        Caveat = {''};
        
    end % of Public Properties
    
    properties (SetAccess = protected)
        IndepVars = {};         % Independent variable names
        IndepVarsUnits = {};    % Independent variable units
        DepVars = {};           % Dependent variable names
        DepVarsUnits = {};      % Dependent variable units
        Modified = 0;       %Has the data been modified since construction
        Locked   = 0;       %Is the class currently locked
    end %of Properties (Setaccess= protected)
    
    %% Abstraction layer
    methods(Abstract)
        disp(obj);                      %Method for displaying the AeroElm
        [output,dim] = GetVal(obj,name) %Method for geting IndepVars
        outval = eval(obj,varargin);    %Method for evaluation of values
        outval = size(obj,dim);         %Method for determining size
        outval = plot(obj,varargin);  %TKV
%         outval = deriv(obj);            %Method for calculating the derivative
    end
    
    %% Ordinary Methods
    methods
        %Constructor
        function obj = AeroElm(IndepVars,DepVars)
                
            % Parse out Indepedent Variables and Units
            nIV = length(IndepVars);
            for iIV = 1:nIV
                curIV = IndepVars{iIV,1};
                ptrSpace = strfind(curIV, ' ');
                strIV = curIV;
                strIVUnits = '';
                if(~isempty(ptrSpace))
                    strIV = curIV(1:ptrSpace-1);
                    strIVUnits = curIV(ptrSpace+1:end);
                end
                obj.IndepVars{iIV,1} = strIV;
                obj.IndepVarsUnits{iIV,1} = strIVUnits;
            end
            
            % Parse out Dependent Variables and Units
            nDV = length(DepVars);
            for iDV = 1:nDV
                curDV = DepVars{iDV,1};
                ptrSpace = strfind(curDV, ' ');
                strDV = curDV;
                strDVUnits = '';
                if(~isempty(ptrSpace))
                    strDV = curDV(1:ptrSpace-1);
                    strDVUnits = curDV(ptrSpace+1:end);
                end
                obj.DepVars{iDV,1} = strDV;
                obj.DepVarsUnits{iDV,1} = strDVUnits;
            end
            
        end % of Constructor

    end %of methods 
     
    
    %% Static methods 
    methods (Static)
        %% Method(static): Find Closest index
        function [index,dif] = GetNearestIdx(vect,val)
            [dif,index] = min(abs(vect-val));
            if dif>sqrt(eps)
                warning('GetNearestIdx:NearestIndex','Nearest Index Found, not an exact value match');
            end
        end
        
        %% Method(static): GetIndexsInRange
        function indexes = GetIndexRange(vect,vals)
            %TODO: Make sure Indepvalues are Column vectors
            if length(vals) == 1
%                 [trash,indexes] = GetNearestIdx(vect,vals); % Can't get
%                 this to work... 
                error('GetIndexReange: Lengthof Vect is too long');
            elseif length(vals) == 2
                indexes = find(vect>=vals(1) & vect<=vals(2)); 
%                 indexes = [indexes(1)-1 indexes indexes(2)+1]; TODO:
%                 think about how to get current request plus one without
%                 grabing extra or getting an index out of range.
            else
                error('GetIndexReange: Lengthof Vect is too long');
            end
            if length(indexes) < 1
                error('GetIndexRange: no indexes found');
            end
        end
            
    end %Static methods
end %of class

%% Revision History
% YYMMDD INI: note
% 100305 TKV: Moved from previous file to this format.  Moved almost all
% the actual computations to the AeroTbl class since, beyond the names, the
% methods and subdata will be much different. 
% 100305 CNF: File Created by CreateNewFunc
%**Add New Revision notes to TOP of list**

% Initials Identification: 
% INI: FullName  :  Email  :  NGGN Username 
% MWS: Mike Sufana   : mike.sufana@ngc.com   sufanmi
% TKV: Travis Vetter : travis.vetter@ngc.com vettetr

%% Footer
% Distribuiton DUH

% WARNING - This document contains technical data whose export is
%   restricted by the Arms Export Control Act (Title 22, U.S.C. 2751 et 
%   seq.) or the Export Administration Act of 1979, as amended, Title 50,
%   U.S.C., App.2401et seq. Violation of these export-control laws is 
%   subject to severe civil and/or criminal penalties.

% -------------- Northrop Grumman Proprietary Level 1 ---------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------------------- UNCLASSIFIED ---------------------------
