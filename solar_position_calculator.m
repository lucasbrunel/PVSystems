%Creating a Solar position Calculator
%{
The goal of this assignment is to plot sun paths for specifics dates and analemmas for
given time instants in an arbitrary location. First, you need to be able to calculate
the sun position (in terms of altitude/elevation/zenith and azimuth) given a time
instant and a pair of geographical coordinates.
%}

%% ----- Base variables ------ %%
Pressure = 101325; %Pa
Temp = 12; %Degrees C

%Sun location
location.longitude = 0; %Degrees, from the equator (+ve North)
location.latitude = 0; %Degrees, from meridian (+ve East)

%Time with reference of
time.year = 0;
time.day = 0;
time.hour = 0;
time.minute = 0;
time.second = 0;

%% ------ Calculations ------ %%




%% ------ Final output ------- %%
azimuth_ang = 0; %Degrees from North (East = 90degrees)
elevation_ang = 0; %Degrees from the horizon (-ve is below horizon)x1