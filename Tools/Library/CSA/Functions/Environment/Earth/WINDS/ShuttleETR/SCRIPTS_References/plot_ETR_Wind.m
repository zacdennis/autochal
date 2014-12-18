%load([SimSetup.RootFolder '/Library/CSA/Functions/Environment/Earth/ETR_Wind_Year.mat']);
load ETR_Wind_Year.mat
plot_Az = 0;
plot_V  = 1;

%% Calculate Stats on Velocities
for i = 1 : size(ETR_Wind.jan.velocity, 1)
    %% Max:
    maxV.jan(i) = max(ETR_Wind.jan.velocity(i,:));
    maxV.feb(i) = max(ETR_Wind.feb.velocity(i,:));
    maxV.mar(i) = max(ETR_Wind.mar.velocity(i,:));
    maxV.apr(i) = max(ETR_Wind.apr.velocity(i,:));
    maxV.may(i) = max(ETR_Wind.may.velocity(i,:));
    maxV.jun(i) = max(ETR_Wind.jun.velocity(i,:));
    maxV.jul(i) = max(ETR_Wind.jul.velocity(i,:));
    maxV.aug(i) = max(ETR_Wind.aug.velocity(i,:));
    maxV.sep(i) = max(ETR_Wind.sep.velocity(i,:));
    maxV.oct(i) = max(ETR_Wind.oct.velocity(i,:));
    maxV.nov(i) = max(ETR_Wind.nov.velocity(i,:));
    maxV.dec(i) = max(ETR_Wind.dec.velocity(i,:));
    
    %% Mean:
    averageV.jan(i) = mean(ETR_Wind.jan.velocity(i,:));
    averageV.feb(i) = mean(ETR_Wind.feb.velocity(i,:));
    averageV.mar(i) = mean(ETR_Wind.mar.velocity(i,:));
    averageV.apr(i) = mean(ETR_Wind.apr.velocity(i,:));
    averageV.may(i) = mean(ETR_Wind.may.velocity(i,:));
    averageV.jun(i) = mean(ETR_Wind.jun.velocity(i,:));
    averageV.jul(i) = mean(ETR_Wind.jul.velocity(i,:));
    averageV.aug(i) = mean(ETR_Wind.aug.velocity(i,:));
    averageV.sep(i) = mean(ETR_Wind.sep.velocity(i,:));
    averageV.oct(i) = mean(ETR_Wind.oct.velocity(i,:));
    averageV.nov(i) = mean(ETR_Wind.nov.velocity(i,:));
    averageV.dec(i) = mean(ETR_Wind.dec.velocity(i,:));

    averageAz.jan(i) = mean(ETR_Wind.jan.azimuth(i,:));
    averageAz.feb(i) = mean(ETR_Wind.feb.azimuth(i,:));
    averageAz.mar(i) = mean(ETR_Wind.mar.azimuth(i,:));
    averageAz.apr(i) = mean(ETR_Wind.apr.azimuth(i,:));
    averageAz.may(i) = mean(ETR_Wind.may.azimuth(i,:));
    averageAz.jun(i) = mean(ETR_Wind.jun.azimuth(i,:));
    averageAz.jul(i) = mean(ETR_Wind.jul.azimuth(i,:));
    averageAz.aug(i) = mean(ETR_Wind.aug.azimuth(i,:));
    averageAz.sep(i) = mean(ETR_Wind.sep.azimuth(i,:));
    averageAz.oct(i) = mean(ETR_Wind.oct.azimuth(i,:));
    averageAz.nov(i) = mean(ETR_Wind.nov.azimuth(i,:));
    averageAz.dec(i) = mean(ETR_Wind.dec.azimuth(i,:));

    %% Standard Deviation:
    stdV.jan(i) = std(ETR_Wind.jan.velocity(i,:));
    stdV.feb(i) = std(ETR_Wind.feb.velocity(i,:));
    stdV.mar(i) = std(ETR_Wind.mar.velocity(i,:));
    stdV.apr(i) = std(ETR_Wind.apr.velocity(i,:));
    stdV.may(i) = std(ETR_Wind.may.velocity(i,:));
    stdV.jun(i) = std(ETR_Wind.jun.velocity(i,:));
    stdV.jul(i) = std(ETR_Wind.jul.velocity(i,:));
    stdV.aug(i) = std(ETR_Wind.aug.velocity(i,:));
    stdV.sep(i) = std(ETR_Wind.sep.velocity(i,:));
    stdV.oct(i) = std(ETR_Wind.oct.velocity(i,:));
    stdV.nov(i) = std(ETR_Wind.nov.velocity(i,:));
    stdV.dec(i) = std(ETR_Wind.dec.velocity(i,:));

    stdAz.jan(i) = std(ETR_Wind.jan.azimuth(i,:));
    stdAz.feb(i) = std(ETR_Wind.feb.azimuth(i,:));
    stdAz.mar(i) = std(ETR_Wind.mar.azimuth(i,:));
    stdAz.apr(i) = std(ETR_Wind.apr.azimuth(i,:));
    stdAz.may(i) = std(ETR_Wind.may.azimuth(i,:));
    stdAz.jun(i) = std(ETR_Wind.jun.azimuth(i,:));
    stdAz.jul(i) = std(ETR_Wind.jul.azimuth(i,:));
    stdAz.aug(i) = std(ETR_Wind.aug.azimuth(i,:));
    stdAz.sep(i) = std(ETR_Wind.sep.azimuth(i,:));
    stdAz.oct(i) = std(ETR_Wind.oct.azimuth(i,:));
    stdAz.nov(i) = std(ETR_Wind.nov.azimuth(i,:));
    stdAz.dec(i) = std(ETR_Wind.dec.azimuth(i,:));
end
% close all;

%% Plot ETR_Wind Data
if(plot_V)
    figure('Name','Jan');
    plot(averageV.jan, ETR_Wind.altitude, 'k', 'LineWidth', 3);
    hold on;
    plot(stdV.jan, ETR_Wind.altitude, 'r', 'LineWidth', 3);
    legend('Mean Velocity of Sets', 'Standard Deviation across Sets')
    plot(ETR_Wind.jan.velocity, ETR_Wind.altitude, 'LineWidth', 0.5)
    plot(averageV.jan, ETR_Wind.altitude, 'k', 'LineWidth', 3);
    plot(stdV.jan, ETR_Wind.altitude, 'r', 'LineWidth', 3);
    grid on;
    title({'Eastern Test Range Velocity'; 'January'});
    xlabel('Wind Velocity [m/s]')
    ylabel('Altitude [m]')
    set(gcf, 'position', [375   50   900   900]);
    % % save2word('ETR_Wind_Plots.doc');
    % close all;

    figure('Name','Feb');
    plot(averageV.feb, ETR_Wind.altitude, 'k', 'LineWidth', 3);
    hold on;
    plot(stdV.feb, ETR_Wind.altitude, 'r', 'LineWidth', 3);
    legend('Mean Velocity of Sets', 'Standard Deviation across Sets')
    plot(ETR_Wind.feb.velocity, ETR_Wind.altitude, 'LineWidth', 0.5)
    plot(averageV.feb, ETR_Wind.altitude, 'k', 'LineWidth', 3);
    plot(stdV.feb, ETR_Wind.altitude, 'r', 'LineWidth', 3);
    grid on;
    title({'Eastern Test Range Velocity'; 'February'});
    xlabel('Wind Velocity [m/s]')
    ylabel('Altitude [m]')
    set(gcf, 'position', [375   50   900   900]);
    % % save2word('ETR_Wind_Plots.doc');
    % close all;

    figure('Name','Mar');
    plot(averageV.mar, ETR_Wind.altitude, 'k', 'LineWidth', 3);
    hold on;
    plot(stdV.mar, ETR_Wind.altitude, 'r', 'LineWidth', 3);
    legend('Mean Velocity of Sets', 'Standard Deviation across Sets')
    plot(ETR_Wind.mar.velocity, ETR_Wind.altitude, 'LineWidth', 0.5)
    plot(averageV.mar, ETR_Wind.altitude, 'k', 'LineWidth', 3);
    plot(stdV.mar, ETR_Wind.altitude, 'r', 'LineWidth', 3);
    grid on;
    title({'Eastern Test Range Velocity'; 'March'});
    xlabel('Wind Velocity [m/s]')
    ylabel('Altitude [m]')
    set(gcf, 'position', [375   50   900   900]);
    % % save2word('ETR_Wind_Plots.doc');
    % close all;

    figure('Name','Apr');
    plot(averageV.apr, ETR_Wind.altitude, 'k', 'LineWidth', 3);
    hold on;
    plot(stdV.apr, ETR_Wind.altitude, 'r', 'LineWidth', 3);
    legend('Mean Velocity of Sets', 'Standard Deviation across Sets')
    plot(ETR_Wind.apr.velocity, ETR_Wind.altitude, 'LineWidth', 0.5)
    plot(averageV.apr, ETR_Wind.altitude, 'k', 'LineWidth', 3);
    plot(stdV.apr, ETR_Wind.altitude, 'r', 'LineWidth', 3);
    grid on;
    title({'Eastern Test Range Velocity'; 'April'});
    xlabel('Wind Velocity [m/s]')
    ylabel('Altitude [m]')
    set(gcf, 'position', [375   50   900   900]);
    % save2word('ETR_Wind_Plots.doc');
    % close all;

    figure('Name','May');
    plot(averageV.may, ETR_Wind.altitude, 'k', 'LineWidth', 3);
    hold on;
    plot(stdV.may, ETR_Wind.altitude, 'r', 'LineWidth', 3);
    legend('Mean Velocity of Sets', 'Standard Deviation across Sets')
    plot(ETR_Wind.may.velocity, ETR_Wind.altitude, 'LineWidth', 0.5)
    plot(averageV.may, ETR_Wind.altitude, 'k', 'LineWidth', 3);
    plot(stdV.may, ETR_Wind.altitude, 'r', 'LineWidth', 3);
    grid on;
    title({'Eastern Test Range Velocity'; 'May'});
    xlabel('Wind Velocity [m/s]')
    ylabel('Altitude [m]')
    set(gcf, 'position', [375   50   900   900]);
    % save2word('ETR_Wind_Plots.doc');
    % close all;

    figure('Name','Jun');
    plot(averageV.jun, ETR_Wind.altitude, 'k', 'LineWidth', 3);
    hold on;
    plot(stdV.jun, ETR_Wind.altitude, 'r', 'LineWidth', 3);
    legend('Mean Velocity of Sets', 'Standard Deviation across Sets')
    plot(ETR_Wind.jun.velocity, ETR_Wind.altitude, 'LineWidth', 0.5)
    plot(averageV.jun, ETR_Wind.altitude, 'k', 'LineWidth', 3);
    plot(stdV.jun, ETR_Wind.altitude, 'r', 'LineWidth', 3);
    grid on;
    title({'Eastern Test Range Velocity'; 'June'});
    xlabel('Wind Velocity [m/s]')
    ylabel('Altitude [m]')
    set(gcf, 'position', [375   50   900   900]);
    % save2word('ETR_Wind_Plots.doc');
    % close all;

    figure('Name','Jul');
    plot(averageV.jul, ETR_Wind.altitude, 'k', 'LineWidth', 3);
    hold on;
    plot(stdV.jul, ETR_Wind.altitude, 'r', 'LineWidth', 3);
    legend('Mean Velocity of Sets', 'Standard Deviation across Sets')
    plot(ETR_Wind.jul.velocity, ETR_Wind.altitude, 'LineWidth', 0.5)
    plot(averageV.jul, ETR_Wind.altitude, 'k', 'LineWidth', 3);
    plot(stdV.jul, ETR_Wind.altitude, 'r', 'LineWidth', 3);
    grid on;
    title({'Eastern Test Range Velocity'; 'July'});
    xlabel('Wind Velocity [m/s]')
    ylabel('Altitude [m]')
    set(gcf, 'position', [375   50   900   900]);
    % save2word('ETR_Wind_Plots.doc');
    % close all;

    figure('Name','Aug');
    plot(averageV.aug, ETR_Wind.altitude, 'k', 'LineWidth', 3);
    hold on;
    plot(stdV.aug, ETR_Wind.altitude, 'r', 'LineWidth', 3);
    legend('Mean Velocity of Sets', 'Standard Deviation across Sets')
    plot(ETR_Wind.aug.velocity, ETR_Wind.altitude, 'LineWidth', 0.5)
    plot(averageV.aug, ETR_Wind.altitude, 'k', 'LineWidth', 3);
    plot(stdV.aug, ETR_Wind.altitude, 'r', 'LineWidth', 3);
    grid on;
    title({'Eastern Test Range Velocity'; 'August'});
    xlabel('Wind Velocity [m/s]')
    ylabel('Altitude [m]')
    set(gcf, 'position', [375   50   900   900]);
    % save2word('ETR_Wind_Plots.doc');
    % close all;

    figure('Name','Sep');
    plot(averageV.sep, ETR_Wind.altitude, 'k', 'LineWidth', 3);
    hold on;
    plot(stdV.sep, ETR_Wind.altitude, 'r', 'LineWidth', 3);
    legend('Mean Velocity of Sets', 'Standard Deviation across Sets')
    plot(ETR_Wind.sep.velocity, ETR_Wind.altitude, 'LineWidth', 0.5)
    plot(averageV.sep, ETR_Wind.altitude, 'k', 'LineWidth', 3);
    plot(stdV.sep, ETR_Wind.altitude, 'r', 'LineWidth', 3);
    grid on;
    title({'Eastern Test Range Velocity'; 'September'});
    xlabel('Wind Velocity [m/s]')
    ylabel('Altitude [m]')
    set(gcf, 'position', [375   50   900   900]);
    % save2word('ETR_Wind_Plots.doc');
    % close all;

    figure('Name','Oct');
    plot(averageV.oct, ETR_Wind.altitude, 'k', 'LineWidth', 3);
    hold on;
    plot(stdV.oct, ETR_Wind.altitude, 'r', 'LineWidth', 3);
    legend('Mean Velocity of Sets', 'Standard Deviation across Sets')
    plot(ETR_Wind.oct.velocity, ETR_Wind.altitude, 'LineWidth', 0.5)
    plot(averageV.oct, ETR_Wind.altitude, 'k', 'LineWidth', 3);
    plot(stdV.oct, ETR_Wind.altitude, 'r', 'LineWidth', 3);
    grid on;
    title({'Eastern Test Range Velocity'; 'October'});
    xlabel('Wind Velocity [m/s]')
    ylabel('Altitude [m]')
    set(gcf, 'position', [375   50   900   900]);
    % save2word('ETR_Wind_Plots.doc');
    % close all;

    figure('Name','Nov');
    plot(averageV.nov, ETR_Wind.altitude, 'k', 'LineWidth', 3);
    hold on;
    plot(stdV.nov, ETR_Wind.altitude, 'r', 'LineWidth', 3);
    legend('Mean Velocity of Sets', 'Standard Deviation across Sets')
    plot(ETR_Wind.nov.velocity, ETR_Wind.altitude, 'LineWidth', 0.5)
    plot(averageV.nov, ETR_Wind.altitude, 'k', 'LineWidth', 3);
    plot(stdV.nov, ETR_Wind.altitude, 'r', 'LineWidth', 3);
    grid on;
    title({'Eastern Test Range Velocity'; 'November'});
    xlabel('Wind Velocity [m/s]')
    ylabel('Altitude [m]')
    set(gcf, 'position', [375   50   900   900]);
    % save2word('ETR_Wind_Plots.doc');
    % close all;

    figure('Name','Dec');
    plot(averageV.dec, ETR_Wind.altitude, 'k', 'LineWidth', 3);
    hold on;
    plot(stdV.dec, ETR_Wind.altitude, 'r', 'LineWidth', 3);
    legend('Mean Velocity of Sets', 'Standard Deviation across Sets')
    plot(ETR_Wind.dec.velocity, ETR_Wind.altitude, 'LineWidth', 0.5)
    plot(averageV.dec, ETR_Wind.altitude, 'k', 'LineWidth', 3);
    plot(stdV.dec, ETR_Wind.altitude, 'r', 'LineWidth', 3);
    grid on;
    title({'Eastern Test Range Velocity'; 'December'});
    xlabel('Wind Velocity [m/s]')
    ylabel('Altitude [m]')
    set(gcf, 'position', [375   50   900   900]);
    % save2word('ETR_Wind_Plots.doc');
    % close all;
end

if(plot_Az)
    figure('Name','Jan');
    plot(averageAz.jan, ETR_Wind.altitude, 'k', 'LineWidth', 3);
    hold on;
    plot(stdAz.jan, ETR_Wind.altitude, 'r', 'LineWidth', 3);
    legend('Mean Azimuth of Sets', 'Standard Deviation across Sets', 'Location','SouthOutside')
    plot(ETR_Wind.jan.azimuth, ETR_Wind.altitude)
    plot(averageAz.jan, ETR_Wind.altitude, 'k', 'LineWidth', 3);
    plot(stdAz.jan, ETR_Wind.altitude, 'r', 'LineWidth', 3);
    grid on;
    title({'Eastern Test Range Azimuth'; 'January'});
    xlabel('Wind Azimuth [deg]')
    ylabel('Altitude [m]')
    set(gcf, 'position', [375   50   900   900]);
    % save2word('ETR_Wind_Plots.doc');
    % close all;

    figure('Name','Feb');
    plot(averageAz.feb, ETR_Wind.altitude, 'k', 'LineWidth', 3);
    hold on;
    plot(stdAz.feb, ETR_Wind.altitude, 'r', 'LineWidth', 3);
    legend('Mean Azimuth of Sets', 'Standard Deviation across Sets', 'Location','SouthOutside')
    plot(ETR_Wind.feb.azimuth, ETR_Wind.altitude)
    plot(averageAz.feb, ETR_Wind.altitude, 'k', 'LineWidth', 3);
    plot(stdAz.feb, ETR_Wind.altitude, 'r', 'LineWidth', 3);
    grid on;
    title({'Eastern Test Range Azimuth'; 'February'});
    xlabel('Wind Azimuth [deg]')
    ylabel('Altitude [m]')
    set(gcf, 'position', [375   50   900   900]);
    % save2word('ETR_Wind_Plots.doc');
    % close all;

    figure('Name','Mar');
    plot(averageAz.mar, ETR_Wind.altitude, 'k', 'LineWidth', 3);
    hold on;
    plot(stdAz.mar, ETR_Wind.altitude, 'r', 'LineWidth', 3);
    legend('Mean Azimuth of Sets', 'Standard Deviation across Sets', 'Location','SouthOutside')
    plot(ETR_Wind.mar.azimuth, ETR_Wind.altitude)
    plot(averageAz.mar, ETR_Wind.altitude, 'k', 'LineWidth', 3);
    plot(stdAz.mar, ETR_Wind.altitude, 'r', 'LineWidth', 3);
    grid on;
    title({'Eastern Test Range Azimuth'; 'March'});
    xlabel('Wind Azimuth [deg]')
    ylabel('Altitude [m]')
    set(gcf, 'position', [375   50   900   900]);
    % save2word('ETR_Wind_Plots.doc');
    % close all;

    figure('Name','Apr');
    plot(averageAz.apr, ETR_Wind.altitude, 'k', 'LineWidth', 3);
    hold on;
    plot(stdAz.apr, ETR_Wind.altitude, 'r', 'LineWidth', 3);
    legend('Mean Azimuth of Sets', 'Standard Deviation across Sets', 'Location','SouthOutside')
    plot(ETR_Wind.apr.azimuth, ETR_Wind.altitude)
    plot(averageAz.apr, ETR_Wind.altitude, 'k', 'LineWidth', 3);
    plot(stdAz.apr, ETR_Wind.altitude, 'r', 'LineWidth', 3);
    grid on;
    title({'Eastern Test Range Azimuth'; 'April'});
    xlabel('Wind Azimuth [deg]')
    ylabel('Altitude [m]')
    set(gcf, 'position', [375   50   900   900]);
    % save2word('ETR_Wind_Plots.doc');
    % close all;

    figure('Name','May');
    plot(averageAz.may, ETR_Wind.altitude, 'k', 'LineWidth', 3);
    hold on;
    plot(stdAz.may, ETR_Wind.altitude, 'r', 'LineWidth', 3);
    legend('Mean Azimuth of Sets', 'Standard Deviation across Sets', 'Location','SouthOutside')
    plot(ETR_Wind.may.azimuth, ETR_Wind.altitude)
    plot(averageAz.may, ETR_Wind.altitude, 'k', 'LineWidth', 3);
    plot(stdAz.may, ETR_Wind.altitude, 'r', 'LineWidth', 3);
    grid on;
    title({'Eastern Test Range Azimuth'; 'May'});
    xlabel('Wind Azimuth [deg]')
    ylabel('Altitude [m]')
    set(gcf, 'position', [375   50   900   900]);
    % save2word('ETR_Wind_Plots.doc');
    % close all;

    figure('Name','Jun');
    plot(averageAz.jun, ETR_Wind.altitude, 'k', 'LineWidth', 3);
    hold on;
    plot(stdAz.jun, ETR_Wind.altitude, 'r', 'LineWidth', 3);
    legend('Mean Azimuth of Sets', 'Standard Deviation across Sets', 'Location','SouthOutside')
    plot(ETR_Wind.jun.azimuth, ETR_Wind.altitude)
    plot(averageAz.jun, ETR_Wind.altitude, 'k', 'LineWidth', 3);
    plot(stdAz.jun, ETR_Wind.altitude, 'r', 'LineWidth', 3);
    grid on;
    title({'Eastern Test Range Azimuth'; 'June'});
    xlabel('Wind Azimuth [deg]')
    ylabel('Altitude [m]')
    set(gcf, 'position', [375   50   900   900]);
    % save2word('ETR_Wind_Plots.doc');
    % close all;

    figure('Name','Jul');
    plot(averageAz.jul, ETR_Wind.altitude, 'k', 'LineWidth', 3);
    hold on;
    plot(stdAz.jul, ETR_Wind.altitude, 'r', 'LineWidth', 3);
    legend('Mean Azimuth of Sets', 'Standard Deviation across Sets', 'Location','SouthOutside')
    plot(ETR_Wind.jul.azimuth, ETR_Wind.altitude)
    plot(averageAz.jul, ETR_Wind.altitude, 'k', 'LineWidth', 3);
    plot(stdAz.jul, ETR_Wind.altitude, 'r', 'LineWidth', 3);
    grid on;
    title({'Eastern Test Range Azimuth'; 'July'});
    xlabel('Wind Azimuth [deg]')
    ylabel('Altitude [m]')
    set(gcf, 'position', [375   50   900   900]);
    % save2word('ETR_Wind_Plots.doc');
    % close all;

    figure('Name','Aug');
    plot(averageAz.aug, ETR_Wind.altitude, 'k', 'LineWidth', 3);
    hold on;
    plot(stdAz.aug, ETR_Wind.altitude, 'r', 'LineWidth', 3);
    legend('Mean Azimuth of Sets', 'Standard Deviation across Sets', 'Location','SouthOutside')
    plot(ETR_Wind.aug.azimuth, ETR_Wind.altitude)
    plot(averageAz.aug, ETR_Wind.altitude, 'k', 'LineWidth', 3);
    plot(stdAz.aug, ETR_Wind.altitude, 'r', 'LineWidth', 3);
    grid on;
    title({'Eastern Test Range Azimuth'; 'August'});
    xlabel('Wind Azimuth [deg]')
    ylabel('Altitude [m]')
    set(gcf, 'position', [375   50   900   900]);
    % save2word('ETR_Wind_Plots.doc');
    % close all;

    figure('Name','Sep');
    plot(averageAz.sep, ETR_Wind.altitude, 'k', 'LineWidth', 3);
    hold on;
    plot(stdAz.sep, ETR_Wind.altitude, 'r', 'LineWidth', 3);
    legend('Mean Azimuth of Sets', 'Standard Deviation across Sets', 'Location','SouthOutside')
    plot(ETR_Wind.sep.azimuth, ETR_Wind.altitude)
    plot(averageAz.sep, ETR_Wind.altitude, 'k', 'LineWidth', 3);
    plot(stdAz.sep, ETR_Wind.altitude, 'r', 'LineWidth', 3);
    grid on;
    title({'Eastern Test Range Azimuth'; 'September'});
    xlabel('Wind Azimuth [deg]')
    ylabel('Altitude [m]')
    set(gcf, 'position', [375   50   900   900]);
    % save2word('ETR_Wind_Plots.doc');
    % close all;

    figure('Name','Oct');
    plot(averageAz.oct, ETR_Wind.altitude, 'k', 'LineWidth', 3);
    hold on;
    plot(stdAz.oct, ETR_Wind.altitude, 'r', 'LineWidth', 3);
    legend('Mean Azimuth of Sets', 'Standard Deviation across Sets', 'Location','SouthOutside')
    plot(ETR_Wind.oct.azimuth, ETR_Wind.altitude)
    plot(averageAz.oct, ETR_Wind.altitude, 'k', 'LineWidth', 3);
    plot(stdAz.oct, ETR_Wind.altitude, 'r', 'LineWidth', 3);
    grid on;
    title({'Eastern Test Range Azimuth'; 'October'});
    xlabel('Wind Azimuth [deg]')
    ylabel('Altitude [m]')
    set(gcf, 'position', [375   50   900   900]);
    % save2word('ETR_Wind_Plots.doc');
    % close all;

    figure('Name','Nov');
    plot(averageAz.nov, ETR_Wind.altitude, 'k', 'LineWidth', 3);
    hold on;
    plot(stdAz.nov, ETR_Wind.altitude, 'r', 'LineWidth', 3);
    legend('Mean Azimuth of Sets', 'Standard Deviation across Sets', 'Location','SouthOutside')
    plot(ETR_Wind.nov.azimuth, ETR_Wind.altitude)
    plot(averageAz.nov, ETR_Wind.altitude, 'k', 'LineWidth', 3);
    plot(stdAz.nov, ETR_Wind.altitude, 'r', 'LineWidth', 3);
    grid on;
    title({'Eastern Test Range Azimuth'; 'November'});
    xlabel('Wind Azimuth [deg]')
    ylabel('Altitude [m]')
    set(gcf, 'position', [375   50   900   900]);
    % save2word('ETR_Wind_Plots.doc');
    % close all;
    
    figure('Name','Dec');
    plot(averageAz.dec, ETR_Wind.altitude, 'k', 'LineWidth', 3);
    hold on;
    plot(stdAz.dec, ETR_Wind.altitude, 'r', 'LineWidth', 3);
    legend('Mean Azimuth of Sets', 'Standard Deviation across Sets', 'Location','SouthOutside')
    plot(ETR_Wind.dec.azimuth, ETR_Wind.altitude)
    plot(averageAz.dec, ETR_Wind.altitude, 'k', 'LineWidth', 3);
    plot(stdAz.dec, ETR_Wind.altitude, 'r', 'LineWidth', 3);
    grid on;
    title({'Eastern Test Range Azimuth'; 'December'});
    xlabel('Wind Azimuth [deg]')
    ylabel('Altitude [m]')
    set(gcf, 'position', [375   50   900   900]);
    % save2word('ETR_Wind_Plots.doc');
    % close all;
end
