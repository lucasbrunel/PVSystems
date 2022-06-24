%Plot DC Yield
months = [1:12];
months(1) = sum(P_DC_tot(1:744));
months(2) = sum(P_DC_tot(745:1416));
months(3) = sum(P_DC_tot(1417:2160));
months(4) = sum(P_DC_tot(2161:2880));
months(5) = sum(P_DC_tot(2881:3624));
months(6) = sum(P_DC_tot(3625:4344));
months(7) = sum(P_DC_tot(4345:5088));
months(8) = sum(P_DC_tot(5089:5832));
months(9) = sum(P_DC_tot(5833:6552));
months(10) = sum(P_DC_tot(6553:7296));
months(11) = sum(P_DC_tot(7297:8016));
months(12) = sum(P_DC_tot(8017:8760));

for i = 1:12
    months(i) = months(i)/1e6;
end

%% BAR PLOT
figure
name = {'Jan' ; 'Feb' ; 'Mar' ; 'Apr' ; 'May' ; 'Jun' ; 'Jul' ; 'Aug' ; 'Sep' ;'Oct' ; 'Nov' ; 'Dec'};
x_axis = [1:12];
y_axis = months(1:12);
bar(x_axis,y_axis)
set(gca,'xticklabel',name)
xlabel('Months') 
ylabel('DC Yield (MWh)') 

%AC Yield
