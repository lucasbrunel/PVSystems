%% Task 2 - Irradiance Calculation
% Variables
meteodata = load('Santiago.mat');
GHI = meteodata.G_Gh;   %Global horizontal Irradiance
DHI = meteodata.G_Dh;   %Diffuse horizontal Irradiance
%DNI = meteodata.G_Bh;   %Direct normal irradiance
meteodata2 = importdata('Santiago-hour.dat');
DNI = meteodata2(:,9);
sun_azim_fix = meteodata.Az;
sun_alt = meteodata.hs;
albedo = 0.15;

% Angle corrections
sun_azim = sun_azim_fix+180;  % Correction on Meteonorm's azimuth convention
sun_Zen = 90-sun_alt; 	      % Correct calculation of Sun Zenith

portrait_modules = load('portrait_modules.mat');
landscape_modules = load('landscape_modules.mat');
skyline_landscape = load('landscape_skylines.mat');
skyline_portrait = load('portrait_skylines.mat');
load('building2020.mat','building_faces','building_vertices');
cb_limits = [1.0 1.3];


%Landscape
%title('Landscape')
plot3DBuildings(building_vertices,building_faces);
irradiance_perhour_l1 = zeros(40,8760);
irradiance_perhour_l2 = zeros(40,8760);
irrs_perhour = zeros(1,8760);
G_dir = zeros(1,8760);
G_dif = zeros(1,8760);
G_ref = zeros(1,8760);
cos_aoi = zeros(1,8760);
sf = zeros(1,8760);
roof_irradiance_l = zeros(1,8); % Calculating total Irradiance on each roof section
svf_check = zeros(1,40);
for i = 1:2
    skyline = skyline_landscape;
    if i == 1 || i == 2
        s_ix = i;
        m_ix = [1:40];
        m_tilt = 14.14111023;
        
        if i == 1 
            m_azim = 90;
        else
            m_azim = 270;
        end
       
        irrs = zeros(1,length(m_ix));
        for j = 1:length(m_ix)
            for t = 1:8760
            %calculate yearly irradiation
                sf(t) = calculateShadingFactor(skyline.skylines{i, 1}{1, j}, sun_azim(t), sun_alt(t));
                svf = skyline.svf{i,1}(j,1);
                if i == 1
                   svf_check(j) = svf;
                end
                G_dif(t) = svf*DHI(t);
                G_ref(t) = albedo*(1-svf)*GHI(t);
                cos_aoi(t) = cosd(sun_Zen(t)).*cosd(m_tilt)+sind(m_tilt).*sind(sun_Zen(t)).*cosd(sun_azim(t)-m_azim);
                %cos_aoi(cos_aoi(t)<0) = 0;
                if cos_aoi(t)<0
                    cos_aoi(t) = 0;
                end
                G_dir(t) = DNI(t).*cos_aoi(t).*sf(t)';

                irrs(j) = sum(G_dir+G_dif+G_ref)/1e6;    
                irrs_perhour(t) = sum(G_dir(t)+G_dif(t)+G_ref(t));
                roof_irradiance_l(i) = roof_irradiance_l(i) + irrs(j);
                if i==1
                    irradiance_perhour_l1(j,t) = irrs_perhour(t);
                end
                if i==2
                    irradiance_perhour_l2(j,t) = irrs_perhour(t);
                end
            end
        end
        
        plotModulesOnRoof('landscape_modules',s_ix,m_ix,'irradiation',irrs,cb_limits); 
        if i==1
            %irr_1_l=sum(irrs)/length(irrs);
            irr_1_l = irrs;
        elseif i==2
            %irr_2_l=sum(irrs)/length(irrs);
            irr_2_l = irrs;
        elseif i==5
            irr_5_l=zeros(1,length(irrs));
            irr_5_l=sum(irrs)/length(irrs);
        else
            irr_6_l=sum(irrs)/length(irrs);
        end
        
    end
end

%Temp calc
a = -3.47;
b = -0.0594;
windspeed = meteodata.FF;
T_a = meteodata.Ta;
T_m1 = zeros(40,8760);
T_m2 = zeros(40,8760);
for i = 1:40
    for t = 1:8760
        T_m1(i,t) = irradiance_perhour_l1(i,t)*exp(a+b*windspeed(t))+T_a(t);
        T_m2(i,t) = irradiance_perhour_l2(i,t)*exp(a+b*windspeed(t))+T_a(t);
    end
end

T_m_avg=zeros(1,8760);
for t=1:8760
    T_m_avg(t)=(sum(T_m1(t,:),1)+sum(T_m2(t,:),1))/80;
end