clear all; close all; clc; format long;

name = 'Ryan Yamamoto'; 
id = 'A14478430'; 
hw_num = 'project';

global R G M m

R = 6.37e6;
G = 6.67408e-11;
M = 5.97e24;
m = 1500;

data = cell(6,7);
info = cell(6,3);

for i = 1:6
    [Xo, Yo, Zo, Uo, Vo, Wo, tstart, tend, maxthrust] = read_input(...
        'satellite_data.txt',i);
    [data{i,1}, data{i,2}, data{i,3}, data{i,4}, data{i,5}, data{i,6}, ...
        data{i,7}] = satellite(Xo, Yo, Zo, Uo, Vo, Wo, tstart, tend, maxthrust);
    
    info{i,1} = sqrt(data{i,2}.^2+data{i,3}.^2+data{i,4}.^2)-R;
    info{i,2} = sqrt(data{i,5}.^2+data{i,6}.^2+data{i,7}.^2);
    info{i,3} = diff(info{i,2});
    
    n = 1;
    for k = 2:length(info{i,1})-1
        if (info{i,1}(k) > info{i,1}(k-1))&&(info{i,1}(k) > info{i,1}(k+1))
            maxTime(n) = data{i,1}(info{i,1}==info{i,1}(k));
            n = n+1;
        end
    end
    
    stat(i) = struct('sat_id',i,'end_time',data{i,1}(end),'final_position',...
        [data{i,2}(end) data{i,3}(end) data{i,4}(end)],'final_velocity',...
        [data{i,5}(end) data{i,6}(end) data{i,7}(end)],'max_speed',...
        max(max(info{i,2})),'min_speed',min(min(info{i,2})),...
        'time_lmax_altitude',maxTime,'orbital_period_before',...
        maxTime(2)-maxTime(1),'orbital_period_after',...
        maxTime(end)-maxTime(end-1));
end

label = cell(1,6);
for i = 1:6
    label{i} = sprintf('Satellite %d',i);
    linespec = {'b','r','g','k','m','c'};
    load('earth_topo.mat');
    figure(1);
    subplot(2,3,i);
    plot3(data{i,2}/1e6,data{i,3}/1e6,data{i,4}/1e6,linespec{i});
    hold on;
    plot3(data{i,2}(end)/1e6,data{i,3}(end)/1e6,data{i,4}(end)/1e6,...
        strcat('*',linespec{i}),'MarkerSize', 8);
    [x,y,z] = sphere(50);
    s = surf(R*x/1e6,R*y/1e6,R*z/1e6);
    s.CData = topo;
    s.FaceColor = 'texturemap';
    s.EdgeColor = 'none';
    s.FaceLighting = 'gouraud';
    s.SpecularStrength = 0.4;
    grid on; box on; axis equal;
    xlabel('X'); ylabel('Y'); zlabel('Z');
    legend(label{i},'Final Position','location','south');
    title(sprintf('Satellite %d\n (10^6m)',i),'FontSize',14);
    set(gca,'LineWidth',1.75);
    
    figure(2);
    subplot(3,1,1); hold on;
    plot(data{i,1}/3600,info{i,1}/1e6,linespec{i});
    title('Change in Altitude','FontSize',14);
    set(gca,'XTick',[0:2:16]);
    ylabel('Altitude (10^6 m)');
    grid on; box on;xlim([-inf data{1,1}(end)/3600]);
    set(gca,'LineWidth',1.75);
    subplot(3,1,2); hold on;
    plot(data{i,1}/3600,info{i,2}/1000,linespec{i});
    title('Change in Speed','FontSize',14);
    set(gca,'XTick',[0:2:16]);
    ylabel('Speed (km/s)');
    grid on; box on; xlim([-inf data{1,1}(end)/3600]);
    set(gca,'LineWidth',1.75);
    subplot(3,1,3);hold on;
    plot(data{i,1}(1:end-1)/3600,info{i,3},linespec{i},'DisplayName',label{i});
    legend('show',[123 87.5 0 0]);
    title('Change in Acceleration','FontSize',14);
    xlabel('Time (hours)');ylabel('Acceleration (m/s^2)'); 
    grid on; box on; set(gca,'XTick',[0:2:16]);
    xlim([-inf data{1,1}(end)/3600]);ylim([-0.75 0.75]);
    set(gca,'LineWidth',1.75);
    
    figure(3); hold on;
    plot(info{i,2}(1:end-1)/1000,info{i,3},linespec{i},'Linewidth',1.5,...
        'DisplayName',label{i});
    title('Changes in Speed vs Changes in Acceleration','FontSize',14);
    xlabel('Speed (km/s)');ylabel('Acceleration (m/s^2)');
    legend('show','Location','best');
    grid on; box on;set(gca,'LineWidth',1.75);
end

fid = fopen('report.txt','w');
fprintf(fid,'Ryan Yamamoto\n');
fprintf(fid,'A14478430\n');
fprintf(fid,'sat_id max_speed min_speed orbital_period_before orbital_period_after\n');
for i = 1:6
    fprintf(fid,'%d %15.9e %15.9e %15.9e %15.9e\n',i,stat(i).max_speed,...
        stat(i).min_speed,stat(i).orbital_period_before,stat(i).orbital_period_after);
end
fclose(fid);

p1a =evalc('help read_input');
p1b =evalc('help satellite');
p1c ='See figure 1'; 
p1d ='See figure 2'; 
p1e ='See figure 3'; 

p2a = stat(1);
p2b = stat(2);
p2c = stat(3);
p2d = stat(4);
p2e = stat(5);
p2f = stat(6);

p3 = evalc('type report.txt');

p4a = 'The satellites move fastest when they are closest to earth.';
p4b = 'As the satellites travel away from earth, their velocities decrease.';