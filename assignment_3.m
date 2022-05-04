clc 
clear all
%Panel temperature calculator, Finding Tm over time
%Assuming Steady State

%% ---- Constants ---- %%
%Model parameters
eff = 0.18; %Efficiency of the panel
R = 0.1; %Reflectivity
t_inoct = 54 + 273; %Temperature in INOCT conditions [Kelvin]
beta = 1/t_inoct;
theta_m = deg2rad(40); %Angle of the panel [degrees]
length = 1.5; %Length of the panel [m]
width = 1; %Width of the panel [m]
epsilon_t = 0.84; %Emissivity of the top
epsilon_b = 0.89; %Emissivity of the back

%Environmental conditions
Gm = 750; %Irradiance [W m-2]
Ta = 20+273; %Ambient Temperature [Kelvin]
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

h_forced_lam = ((0.86*(Re^-0.5))/(pr_air^0.67))*roh_air*cp_air * w;
h_forced_turb = ((0.028*(Re^-0.2))/(pr_air^0.4))*roh_air*cp_air * w;

Gr = ((g*beta*(t_inoct - Ta)*(Dh^3))/w^2)*sin(theta_m);% Is w really wind speed?

if Gr <= 0
    Gr = 0;
end

h_free = (0.21*((Gr*pr_air)^0.32)*k_air)/Dh;

h_top = ((h_forced_lam^3) * (h_free^3))^(1/3); %Using Laminar turbulence
%Above gives a complex number...




Tm = 0;