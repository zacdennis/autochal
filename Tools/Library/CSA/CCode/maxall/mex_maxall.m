% mex_maxall Mex for maxall
clear mex;

try
HD = pwd;   % Record Home Directory
cd(fileparts(mfilename('fullpath')));

copyfile( which('CSA_LIB.c'), pwd );
copyfile( which('CSA_LIB.h'), pwd );

disp(['Running ' mfilename '...']);
mex c_maxall.c CSA_LIB.c

delete CSA_LIB.c;
delete CSA_LIB.h;

cd(HD);
clear HD;

catch
end