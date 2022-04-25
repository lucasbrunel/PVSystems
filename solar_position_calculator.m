%Solar Position Calculator

%Sun Paths
%Delft
Location.latitude = 51.99;
Location.longitude = 4.35;
Location.altitude = 0;          %placeholder value

%March 21, 2022
DN = datenum(2022, 3, 21):1/(24*60):datenum(2022, 3, 21, 23, 59, 59); 
Time = pvl_maketimestruct(DN, 1);
%dHr = Time.hour+Time.minute./60+Time.second./3600;  %use for plotting vs time
[SunAz1, SunE1, ApparentSunE1] = pvl_spa(Time, Location);

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
subplot(1,2,1)
scatter(SunAz1, SunE1, '.')
hold all
scatter(SunAz2, SunE2, '.')
scatter(SunAz3, SunE3, '.')
scatter(SunAz4, SunE4, '.')
ylim([0, 90])
xlim([0,360])
legend('Mar 21', 'Jun 21', 'Dec 21', 'Sep 21')
title('Delft')
ylabel('Solar Altitude (deg)')
xlabel('Solar Azimuth (deg)')

%Lima
Location.latitude = -12.07;
Location.longitude = -77.07;
Location.altitude = 0;          %placeholder value

%March 21, 2022
DN = datenum(2022, 3, 21):1/(24*60):datenum(2022, 3, 21, 23, 59, 59); 
Time = pvl_maketimestruct(DN, 1);
[SunAz5, SunE5, ApparentSunE5] = pvl_spa(Time, Location);
dHr = Time.hour+Time.minute./60+Time.second./3600;

%June 21, 2022
DN = datenum(2022, 6, 21):1/(24*60):datenum(2022, 6, 21, 23, 59, 59); 
Time = pvl_maketimestruct(DN, 1);
[SunAz6, SunE6, ApparentSunE6] = pvl_spa(Time, Location);

%December 21, 2022
DN = datenum(2022, 12, 21):1/(24*60):datenum(2022, 12, 21, 23, 59, 59); 
Time = pvl_maketimestruct(DN, 1);
[SunAz7, SunE7, ApparentSunE7] = pvl_spa(Time, Location);

%September 21, 2022
DN = datenum(2022, 9, 21):1/(24*60):datenum(2022, 9, 21, 23, 59, 59); 
Time = pvl_maketimestruct(DN, 1);
[SunAz8, SunE8, ApparentSunE8] = pvl_spa(Time, Location);
subplot(1,2,2)
scatter(SunAz5, SunE5, '.')
hold all
scatter(SunAz6, SunE6, '.')
scatter(SunAz7, SunE7, '.')
scatter(SunAz8, SunE8, '.')
ylim([0, 90])
xlim([0,360])
legend('Mar 21', 'Jun 21', 'Dec 21', 'Sep 21')
title('Lima')
ylabel('Solar Altitude (deg)')
xlabel('Solar Azimuth (deg)')