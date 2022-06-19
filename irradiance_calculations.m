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
        T_m1(i,t) = irradiance_perhour_l1(i,t)*exp(a+b*windspeed(t))+T_a(t);
        T_m2(i,t) = irradiance_perhour_l2(i,t)*exp(a+b*windspeed(t))+T_a(t);
    end
end

%Solar Tech TS60-6M3-280S 
Pnom = 280;     %W
Vmp_stc = 31.9;     %Vmp [V]
Imp_stc = 8.8;      %Imp [A]
Voc_stc = 39.56;    %V
Isc_stc = 9.46;     %A
eff_mod = 0.172;     %module efficiency under STC
eff_mod_est = 0.16;         %module estimate with svf, etc
price_mod = 0.41;      %euro/Wp
A_mod = 1.64*0.992;        %m2

%DC yield calculation
%constants
n = 1.2;    %ideality factor (CHECK THIS)
k_b = 1.38e-23; %boltzmann
q = 1.6e-19;     %charge e-
Ta = 25;    %ambient temp [degrees C]
FF = (Imp_stc*Vmp_stc)/(Isc_stc*Voc_stc);   %fill factor
k = -0.0035;        %(degrees C)^-1 (for c-Si)
G_stc = 1000;      %W/m2

%calculations
%P_DC at actual module temp
P_DC1 = zeros(40,8760);
P_DC2 = zeros(40,8760);
P_DC1_25C = zeros(40,8760);
P_DC2_25C = zeros(40,8760);

for i = 1:2
    if i == 1
        Tm = T_m1;
        G_aoi = irradiance_perhour_l1;
    else
        Tm = T_m2;
        G_aoi = irradiance_perhour_l2;
    end
    for j = 1:40
        for t = 1:8760
            Isc_25C = Isc_stc*(G_aoi(j,t)/G_stc);    %A
            if G_aoi(j,t) == 0
                Voc_25C = Voc_stc;
            else
                Voc_25C = Voc_stc + ((n*k_b*Ta)/q)*log(G_aoi(j,t)/G_stc)*n_mod;       %V
            end
            Pmpp_25C = FF*Voc_25C*Isc_25C;      %W
            eff_25C = max(Pmpp_25C/(A_mod*G_aoi(j,t)),0);   %efficiency at 25 C
            eff_Tm = eff_25C*(1 + k*(Tm(j,t) - Ta)); %efficiency at module temp
            if i == 1
                P_DC1(j,t) = eff_Tm*A_mod*G_aoi(j,t);          %DC output before BoS [W]
                P_DC1_25C(j,t) = eff_25C*A_mod*G_aoi(j,t);
            else
                P_DC2(j,t) = eff_Tm*A_mod*G_aoi(j,t); 
                P_DC2_25C(j,t) = eff_25C*A_mod*G_aoi(j,t);
            end
        end
    end
end

P_DC_tot = zeros(1,8760);
roof2_mat = zeros(1,40);
roof2_mat(6) = 1;
roof2_mat(11) = 1;
roof2_mat(16) = 1;
roof2_mat(21) = 1;
roof2_mat(26) = 1;
roof2_mat(31) = 1;
roof2_mat(36) = 1;
roof2_mat(7) = 1;
roof2_mat(12) = 1;
roof2_mat(17) = 1;
roof2_mat(22) = 1;
roof2_mat(27) = 1;
roof2_mat(32) = 1;
roof2_mat(37) = 1;
for t = 1:8760
    P_DC_tot = sum(P_DC1,1) + sum(roof2_mat*P_DC2,1);
end
P_DC_annual = sum(P_DC_tot);

P_DC_tot_25C = zeros(1,8760);
for t = 1:8760
    P_DC_tot_25C = sum(P_DC1_25C,1) + sum(roof2_mat*P_DC2,1);
end
P_DC_annual_25C = sum(P_DC_tot_25C);

maxi_count = 0;
for t = 1:8760
    if irradiance_perhour_l1(1,t) > 1000
        maxi_count = maxi_count + 1;
    end
end