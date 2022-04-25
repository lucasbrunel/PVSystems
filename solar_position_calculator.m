%Solar Position Calculator

%Sun Paths
%Delft
Location.latitude = 51.99;
Location.longitude = 4.35;
Location.altitude = 0;          %placeholder value

%March 21, 2022
DN = datenum(2022, 3, 21):1/(24*60):datenum(2022, 3, 21, 23, 59, 59); 
Time = pvl_maketimestruct(DN, 1);
[SunAz1, SunE1, ApparentSunE1] = pvl_spa(Time, Location);
dHr = Time.hour+Time.minute./60+Time.second./3600;

%June 21, 2022
DN = datenum(2022, 6, 21):1/(24*60):datenum(2022, 6, 21, 23, 59, 59); 
Time = pvl_maketimestruct(DN, 1);
[SunAz2, SunE2, ApparentSunE2] = pvl_spa(Time, Location);

%December 21, 2022
DN = datenum(2022, 12, 21):1/(24*60):datenum(2022, 12, 21, 23, 59, 59); 
Time = pvl_maketimestruct(DN, 1);
[SunAz3, SunE3, ApparentSunE3] = pvl_spa(Time, Location);

%September 21, 2022
DN = datenum(2022, 9, 21):1/(24*60):datenum(2022, 9, 21, 23, 59, 59); 
Time = pvl_maketimestruct(DN, 1);
[SunAz4, SunE4, ApparentSunE4] = pvl_spa(Time, Location);
plot(SunAz1, SunE1)
hold all
plot(SunAz2, SunE2)
plot(SunAz3, SunE3)
plot(SunAz4, SunE4)
ylim([0, 90])
xlim([0,360])
legend('Mar 21', 'Jun 21', 'Dec 21', 'Sep 21')
title('Delft')
ylabel('Solar Altitude (deg)')
xlabel('Solar Azimuth (deg)')