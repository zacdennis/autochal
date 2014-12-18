%close all; clear all; clc;
load ETR_Wind_Year.mat

flgPlotAllMonths = 0;

searchmin = 50;
searchmax = 500;

alt = ETR_Wind.altitude(:,1);

if(flgPlotAllMonths)
    months = {'jan','feb','mar','apr','may','jun','jul','aug','sep','oct','nov','dec'};
else
    months = {'oct'}; % specify a subset of months to compute gradients for
end

for idxMth = 1:size(months,2)
    
    month = months{idxMth};
    
    %% Unwrap Azimuth:
    % for j = 1 : eval([size(ETR_Wind.' month '.azimuth, 1)']) % set
    %     for k = 1 : eval(['size(ETR_Wind.' month '.azimuth, 2)']) % alt
    %         if (eval(['ETR_Wind.' month '.azimuth(j, k)']) < 180)
    %             eval(['ETR_Wind.' month '.azimuth(j, k) = ETR_Wind.' month '.azimuth(j,k) + 360;']);
    %         end
    %     end
    % end
    
    for i = 1 : eval(['size(ETR_Wind.' month '.velocity, 2)'])
        azimuth = eval(['ETR_Wind.' month '.azimuth(searchmin:searchmax, i)']);
        velocity = eval(['ETR_Wind.' month '.velocity(searchmin:searchmax, i)']);
        
        [sheer(:,i), velocityfilt(:,i), azimuthfilt(:,i)] = maxsheer(azimuth, velocity);
        worstsheer(i)  = max(sheer(:,i)); % worst shear from each test
        
    end
    
    disp(['Worst shear for ' month ':']);
    [worstvelocity, worstset] = max(worstsheer)
    
    
    %% plot
    figure;
    plot(sheer(:, worstset), alt(searchmin:searchmax), 'LineWidth', 2);
    title({['\fontsize{14}' 'ETR Wind Velocity Gradient']; '6th Order Low Pass Filtered'; [month ' Set #' num2str(worstset)]})
    xlabel(['\fontsize{14}' 'Wind Gradient [m/s per m]'])
    ylabel(['\fontsize{14}' 'Altitude [m]'])
    grid on;
    set(gca,'fontsize', 14);
    set(gcf,'outerposition', [400 150 800 800])
    
    figure;
    plot(eval(['ETR_Wind.' month '.velocity(searchmin:searchmax, worstset)']), alt(searchmin:searchmax), velocityfilt(:, worstset)', alt(searchmin:searchmax), 'r')
    title({['\fontsize{14}' 'Eastern Test Range Velocity']; [month ' Set #' num2str(worstset)]})
    xlabel(['\fontsize{14}' 'Wind Velocity [m/s]'])
    ylabel(['\fontsize{14}' 'Altitude [m]'])
    legend('Measured', 'Filtered');
    set(gca,'fontsize', 14);
    set(gcf,'outerposition', [400 150 800 800])
    
    % figure
    % plot(ETR_Wind.sep.azimuth(searchmin:searchmax, worstset), alt(searchmin:searchmax), azimuthfilt(:, worstset), alt(searchmin:searchmax), 'r')
    % title({['\fontsize{14}' 'Eastern Test Range Azimuth']; ['sep Set #' num2str(worstset)]})
    % xlabel(['\fontsize{14}' 'Wind Azimuth [deg]'])
    % ylabel(['\fontsize{14}' 'Altitude [m]'])
    % legend('Measured', 'Filtered');
    % set(gca,'fontsize', 14);
    % set(gcf,'outerposition', [400 150 800 800])
    % grid on; 
    
    if(flgPlotAllMonths)
        SaveOpenFigures2PPT([SimSetup.RootFolder '\Library\CSA\Functions\Environment\Earth\WINDS\ShuttleETR\SCRIPTS_References\ETR Wind Data.pptx'])
        close all;
        clear azimuth velocity sheer velocityfilt azimuthfilt worstsheer
    end
end