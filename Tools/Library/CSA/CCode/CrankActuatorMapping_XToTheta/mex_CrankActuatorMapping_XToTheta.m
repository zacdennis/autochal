% MEX_CRANKACTUATORMAPPING_XTOTHETA Mex for Crank Actuator Mapping S-function (Linear X to Rotational Theta)
clear mex;

HD = pwd;   % Record Home Directory
cd(fileparts(mfilename('fullpath')));

copyfile( which('CSA_LIB.c'), pwd );
copyfile( which('CSA_LIB.h'), pwd );

disp(['Running ' mfilename '...']);
mex c_CrankActuatorMapping_XToTheta.c CSA_LIB.c

delete CSA_LIB.c;
delete CSA_LIB.h;

cd(HD);
clear HD;