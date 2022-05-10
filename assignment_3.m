clc 
clear all
%Panel temperature calculator, Finding Tm over time
%Assuming Steady State

%% ---- Constants ---- %%
%Model parameters
eff = 0.18; %Efficiency of the panel
R = 0.1; %Reflectivity
t_inoct = 54 + 273; %Temperature in INOCT conditions [Kelvin]
Tm = 293.15; %Initial Tm value [Kelvin]
theta_m = deg2rad(30); %Angle of the panel [degrees]
length = 1.5; %Length of the panel [m]
width = 1; %Width of the panel [m]
epsilon_t = 0.84; %Emissivity of the top
epsilon_b = 0.89; %Emissivity of the back

%Environmental conditions
Gm = 750; %Irradiance [W m-2]
Ta = 20+273; %Ambient Temperature [Kelvin]
t_sky = 0.0552*(Ta^(3/2)); %Temperature of the sky
beta = 1/Ta;
t_gr = 30+273; %Temperature of the ground
w = 4; %Wind speed [m s-1]

%Air Propoerties and Other Consts
cp_air = 1005; %Heat capacity [J kg-1 K-1]
k_air = 0.026; %Conductivity of air [W m-1 K-1]
roh_air = 1.204; %Density of air [kg m-3]
mu_air = 1.837e-5; %Viscosity of air [kg m-1 s-1]
pr_air = 0.708; %Prandlt number
g = 9.8; %Gravity [m s-2]
sigma_b = 5.6704e-8; %Boltzmann constant [W m-2 K-4]


%% --- Calculated Values --- %%

alpha = (1-R)*(1-eff); %Absorbtivity of the panel

Dh = (2*length*width)/(length+width); % Effective Diameter

visc_k = mu_air/roh_air; %Kinematic viscosity

Re = (w*Dh)/visc_k; %Reynolds number

h_forced_lam = ((0.86*(Re^-0.5))/(pr_air^0.67))*roh_air*cp_air*w;
h_forced_turb = ((0.028*(Re^-0.2))/(pr_air^0.4))*roh_air*cp_air*w;

if w >= 3
    h_forced = h_forced_turb;
else
    hforced = h_forced_lam;
end

i=0;
while i < 6
    Gr = ((g*beta*(Tm - Ta)*(Dh^3))/visc_k^2)*sin(theta_m);

    if Gr <= 0
        Gr = 0;
    end

    h_free = (0.21*((Gr*pr_air)^0.32)*k_air)/Dh;

    h_top = ((h_forced^3) + (h_free^3))^(1/3);

    %R is the ratio of the actual to the ideal heat loss from the back side
    justR = ((alpha*Gm) - (h_top*(t_inoct-Ta)) - (epsilon_t*sigma_b*((t_inoct^4)-(t_sky^4)))) / ((h_top*(t_inoct - Ta)) + (epsilon_b*sigma_b*((t_inoct^4)-(Ta^4))));
    justR = 0.29; %TEMPORARY BECAYSE THE REAL R DOESN"T WORK ADN WE DONT KNO W WHY!!!!
    
    h_bottom = justR * h_top; % Is h_top the same?

    hc = h_top + h_bottom; 

    hr_sky = epsilon_t * sigma_b * (Tm^2 + t_sky^2) * (Tm + t_sky);
    hr_gr = epsilon_b * sigma_b * (Tm^2 + t_gr^2) * (Tm + t_gr);

    Tm = ((alpha * Gm) + (hc*Ta) + (hr_sky*t_sky) + (hr_gr*t_gr))/(hc+hr_sky+hr_gr);
    fprintf('At iteration %d\n, Tm = %f\n', i, Tm);

    i = i+1;
end
