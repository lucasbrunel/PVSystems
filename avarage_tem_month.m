%% Task 2 - Irradiance Calculation
% Variables
meteodata = load('Santiago.mat');
meteodata2 = importdata('Santiago-hour.dat');
GHI = meteodata2(:,7);   %Global horizontal Irradiance
DHI = meteodata2(:,8);   %Diffuse horizontal Irradiance
DNI = meteodata2(:,9);
sun_azim_fix = meteodata2(:,5);
sun_alt = meteodata2(:,6);
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
        if irradiance_perhour_l1(i,t) == 0
            T_m1(i,t)=0;
        else
            T_m1(i,t) = irradiance_perhour_l1(i,t)*exp(a+b*windspeed(t))+T_a(t);
        end
    end
end

for i =1:40
    for t=1:8760
        if irradiance_perhour_l2(i,t)==0
             T_m2(i,t)=0;
        else
            T_m2(i,t) = irradiance_perhour_l2(i,t)*exp(a+b*windspeed(t))+T_a(t);
        end
    end
end


T_m_avg=zeros(1,8760);
T_m_avg_2=zeros(1,8760);
T_m_avg_1_1=zeros(1,8760);
T_m_avg_1_2=zeros(1,8760);
for t=1:8760
    for i=1:40
        T_m_avg_a=T_m2(i,t);
        T_m_avg_2(t)=T_m_avg_2(t)+T_m_avg_a;  
    end
end 
for t=1:8760
    for i=1:5:36
        T_m_avg_a=T_m1(i,t);
        T_m_avg_1_1(t)=T_m_avg_1_1(t)+T_m_avg_a;  
    end
end 

for t=1:8760
    for i=2:5:37
        T_m_avg_a=T_m2(i,t);
        T_m_avg_1_2(t)=T_m_avg_1_2(t)+T_m_avg_a;  
    end
end 
for t=1:8760
    T_m_avg(t)=(T_m_avg_2(t)+T_m_avg_1_1(t)+T_m_avg_1_2(t))/56;
end

tm_jan=zeros(1,744);
tm_feb=zeros(1,672);
tm_mar=zeros(1,744);
tm_apr=zeros(1,720);
tm_may=zeros(1,744);
tm_jun=zeros(1,720);
tm_jul=zeros(1,744);
tm_aug=zeros(1,744);
tm_sep=zeros(1,720);
tm_oct=zeros(1,744);
tm_nov=zeros(1,720);
tm_dec=zeros(1,744);
zc_jan=0;zc_feb=0;zc_mar=0;zc_apr=0;zc_may=0;zc_jun=0;zc_jul=0;zc_aug=0;zc_sep=0;zc_oct=0;zc_nov=0;zc_dec=0;
for i=1:744
     tm_jan(i)=T_m_avg(i);
     if tm_jan(i)==0
         zc_jan=zc_jan+1;
     end
end
tm_jan_avg=sum(tm_jan)/(length(tm_jan)-zc_jan);
for i=745:1416
     tm_feb(i-744)=T_m_avg(i);
     if tm_feb(i-744)==0
         zc_feb=zc_feb+1;
     end
end
tm_feb_avg=sum(tm_feb)/(length(tm_feb)-zc_feb);
for i=1417:2160
     tm_mar(i-1416)=T_m_avg(i);
     if tm_mar(i-1416)==0
         zc_mar=zc_mar+1;
     end
end
tm_mar_avg=sum(tm_mar)/(length(tm_mar)-zc_mar);
for i=2161:2880
     tm_apr(i-2160)=T_m_avg(i);
     if tm_apr(i-2160)==0
         zc_apr=zc_apr+1;
     end
end
tm_apr_avg=sum(tm_apr)/(length(tm_apr)-zc_apr);
for i=2881:3624
     tm_may(i-2880)=T_m_avg(i);
     if tm_may(i-2880)==0
         zc_may=zc_may+1;
     end
end
tm_may_avg=sum(tm_may)/(length(tm_may)-zc_may);
for i=3625:4344
     tm_jun(i-3624)=T_m_avg(i);
     if tm_jun(i-3624)==0
         zc_jun=zc_jun+1;
     end
end
tm_jun_avg=sum(tm_jun)/(length(tm_jun)-zc_jun);
for i=4345:5088
     tm_jul(i-4344)=T_m_avg(i);
     if tm_jul(i-4344)==0
         zc_jul=zc_jul+1;
     end
end
tm_jul_avg=sum(tm_jul)/(length(tm_jul)-zc_jul);
for i=5089:5832
     tm_aug(i-5088)=T_m_avg(i);
     if tm_aug(i-5088)==0
         zc_aug=zc_aug+1;
     end
end
tm_aug_avg=sum(tm_aug)/(length(tm_aug)-zc_aug);
for i=5833:6552
     tm_sep(i-5832)=T_m_avg(i);
     if tm_sep(i-5832)==0
         zc_sep=zc_sep+1;
     end
end
tm_sep_avg=sum(tm_sep)/(length(tm_sep)-zc_sep);
for i=6553:7296
     tm_oct(i-6552)=T_m_avg(i);
     if tm_oct(i-6552)==0
         zc_oct=zc_oct+1;
     end
end
tm_oct_avg=sum(tm_oct)/(length(tm_oct)-zc_oct);
for i=7297:8016
     tm_nov(i-7296)=T_m_avg(i);
     if tm_nov(i-7296)==0
         zc_nov=zc_nov+1;
     end
end
tm_nov_avg=sum(tm_nov)/(length(tm_nov)-zc_nov);
for i=8017:8760
     tm_dec(i-8016)=T_m_avg(i);
     if tm_dec(i-8016)==0
         zc_dec=zc_dec+1;
     end
end
tm_dec_avg=sum(tm_dec)/(length(tm_dec)-zc_dec);