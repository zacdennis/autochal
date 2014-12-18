% MEX_CRANKACTUATORMAPPING_THETATOX Mex for Crank Actuator Mapping S-function (Rotational Theta to Linear X)
clear mex;

HD = pwd;   % Record Home Directory
cd(fileparts(mfilename('fullpath')));

copyfile( which('CSA_LIB.c'), pwd );
copyfile( which('CSA_LIB.h'), pwd );

disp(['Running ' mfilename '...']);
mex c_CrankActuatorMapping_ThetaToX.c CSA_LIB.c

delete CSA_LIB.c;
delete CSA_LIB.h;

cd(HD);
clear HD;