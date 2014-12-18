% mex_c_CheckLatLon Mex for c_CheckLatLon
clear mex;

try
    HD = pwd;   % Record Home Directory
    cd(fileparts(mfilename('fullpath')));
    
    copyfile( which('CSA_LIB.c'), pwd );
    copyfile( which('CSA_LIB.h'), pwd );
    
    disp(['Running ' mfilename '...']);
    mex c_CheckLatLon.c CSA_LIB.c
    
    delete CSA_LIB.c;
    delete CSA_LIB.h;
    
    cd(HD);
    clear HD;
    disp(['Done.']);
    
catch
end