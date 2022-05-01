%Assignment 2

meteodata = readmatrix('Delft-hour.csv');
GHI = meteodata(:,7);
DHI = meteodata(:,8);
DNI = meteodata(:,9);
sun_azim_fix = meteodata(:,5);
sun_alt = meteodata(:,6);

%%
sun_azim = sun_azim_fix+180;  % Correction on Meteonorm's azimuth convention
sun_Zen = 90-sun_alt; 	      % Correct calculation of Sun Zenith
ROWS = 91;
COLS = 361;
albedo = 0.15;
m_azim = repmat(linspace(0,360,COLS),ROWS,1); % A matrix of rows with values from 0 to 360 
m_tilt = repmat(linspace(0,90,ROWS)',1,COLS); % A matrix of columns with values from 0 to 90
m_irradiation = zeros(size(m_tilt));  % A matrix for the calculated irradiations (This way we avoid increasing its size on each calculation)
svf = 0.5 + cosd(m_tilt)/2;           % A matrix of SVF for each module tilt.

for k=1:numel(m_irradiation) % This is the only for loop you will need
    G_dif = svf(k)*DHI;
    G_ref = albedo*(1-svf(k))*GHI;
%   cos_aoi = sind(m_tilt(k))*cosd(sun_alt).*cosd(m_azim(k)-sun_azim)+cosd(m_tilt(k))*sind(sun_alt); % If you want to use sun altitude instead of sun zenith, use this equation
    cos_aoi = cosd(sun_Zen).*cosd(m_tilt(k))+sind(m_tilt(k)).*sind(sun_Zen).*cosd(sun_azim-m_azim(k));
    cos_aoi(cos_aoi<0) = 0;
    G_dir = DNI.*cos_aoi;
    m_irradiation(k) = sum(G_dir+G_dif+G_ref)/1e3;%in kWh/m2
end

contour(m_irradiation)