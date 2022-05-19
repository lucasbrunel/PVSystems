%Assignment 7

%Delft
Location.latitude = 51.99;
Location.longitude = 4.35;
Location.altitude = 0; %placeholder value

%solar elevation and azimuth
DN = datenum(2022, 12, 21, 10, 0, 0):1/(24*60):datenum(2022, 12, 21, 15, 0, 0); 
Time = pvl_maketimestruct(DN, 1);
[SunAz1, SunE1, ApparentSunE1] = pvl_spa(Time, Location);

%optimal module azimuth and tilt
A_m = -3;
theta_m = 30;

%pv panel specs
l_m = .798; %length module in meters

%row spacing

d = zeros(1,301);
for i = 1:length(SunE1)
    
    d(i) = l_m*(cosd(theta_m)+(sind(theta_m)/tand(SunE1(i))*cosd(A_m - (SunAz1(i)-180))));

end

plot(d)


