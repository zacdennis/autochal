%% Plot worst case - Velocity Feb (set 44):
alt = ETR_Wind.jan.altitude(44,:)';
azimuth = ETR_Wind.feb.azimuth(44,:)';
velocity = ETR_Wind.feb.velocity(44,:)';

close all;

figure;
plotg(azimuth, alt)
title({'Eastern Test Range Azimuth'; 'Worst Case Velocity - February'});
xlabel('Wind Azimuth [deg]')
ylabel('Altitude [m]')
set(gcf, 'position', [100   350   768   770]);

figure;
plotg(velocity, alt)
title({'Eastern Test Range Velocity'; 'Worst Case Max Velocity - February'});
xlabel('Wind Velocity [m/s]')
ylabel('Altitude [m]')
set(gcf, 'position', [100   350   768   770]);

%% Write values to Excel:
xlswrite('WorstCaseVelocityFeb.xls', alt, 'Sheet1', 'A3')
xlswrite('WorstCaseVelocityFeb.xls', velocity, 'Sheet1', 'B3')
xlswrite('WorstCaseVelocityFeb.xls', azimuth, 'Sheet1', 'C3')

