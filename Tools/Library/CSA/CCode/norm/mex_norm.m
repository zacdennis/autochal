% mex_norm Mex for norm
clear mex;

try
    HD = pwd;   % Record Home Directory
    cd(fileparts(mfilename('fullpath')));
    
    copyfile( which('CSA_LIB.c'), pwd );
    copyfile( which('CSA_LIB.h'), pwd );
    
    disp(['Running ' mfilename '...']);
    mex c_norm.c CSA_LIB.c
    
    delete CSA_LIB.c;
    delete CSA_LIB.h;
    
    cd(HD);
    clear HD;
    
catch
    delete CSA_LIB.c;
    delete CSA_LIB.h;
    cd(HD);
    clear HD;
end