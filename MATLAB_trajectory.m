clear
tic
%% za³adowanie danych
load('coords2.mat')
%% kolorowanie ze wzglêdu na wysokoœæ
n = size(wspolrzedne,1);

%sprawdzenie parzystoœci
if floor(n/2) ~= n/2    %przyrównanie w dó³ do najbli¿szej ca³kowitej
wspolrzedne(end,:) = [];
n = n-1;
end
% skrajne wysokoœci
max_wys = max(wspolrzedne(:,3));
min_wys = min(wspolrzedne(:,3));

delta_h = max_wys-min_wys;

k=n/2;
%kolory od czerwonego do ¿ó³tego
mymap = zeros(size(wspolrzedne,1),3); 
   for i=1:k
      mymap(i,:) = [1 ((i-1)/k) 0];  
   end
%kolory od ¿ó³tego do zielonego
   for i=1:k
      mymap(k+i,:)=[((k-(i-1))/k) 1  0];  
   end

mymap2 = zeros(size(wspolrzedne,1),8);   
ilosc_kolorow = size(mymap,1);
for i=1:ilosc_kolorow
mymap2(i,:) = rgb2hex(mymap(i,:));
end

przedzial_wysokosci_na_kolor = delta_h/ilosc_kolorow+1;

x = zeros(1,2);
y = zeros(1,2);
z = zeros(1,2);
kolor_odcinka = zeros(size(wspolrzedne,1),3);

skala_dlugosci_geo = abs(cos(deg2rad(wspolrzedne(1,2))));

figh = figure; %figure handle
for i=1:1:n-1
    j = 1;
    check = 1;
    while check <= wspolrzedne(i,3)
        check = przedzial_wysokosci_na_kolor * j;
        j = j+1;
    end
    kolor_odcinka(i,:) = mymap(j,:);
    plot3([wspolrzedne(i,1), wspolrzedne(i+1,1)], [wspolrzedne(i,2), wspolrzedne(i+1,2)], [wspolrzedne(i,3), wspolrzedne(i+1,3)],'color' ,kolor_odcinka(i,:),'linewidth',2) %,'color' ,mymap(i,:) 
    hold on
    grid
    
    m=1;
    for m=1:m+1
     x(m) = wspolrzedne(i+m-1,1); 
     y(m) = wspolrzedne(i+m-1,2); 
     z(m) = wspolrzedne(i+m-1,3); 
    end
    z2=[z;
    zeros(size(x))];
    surf(repmat(x,size(z2,1),1), repmat(y,size(z2,1),1), z2, 'FaceColor',kolor_odcinka(i,:),'FaceAlpha',0.5, 'EdgeColor','none')
end

set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.96]);% Enlarge figure to full screen.
title('\color{white}trajectory')
ylabel('\color{green}Latitude [deg]', 'interpreter', 'tex')
xlabel('\color{green}Longitude [deg]')
zlabel('\color{green}Altitude [m]')
%axis([-2.17 -1.44 53.25 54.09 0 23000])
set(gca,'DataAspectRatio',[1 skala_dlugosci_geo 111000])
set(gca, 'XColor', 'w')     %kolory osi gridu
set(gca, 'YColor', 'w')
set(gca, 'ZColor', 'w')
set(gcf,'color',[0.22 0.22 0.22]); %background figure
set(gca,'Color',[0.22 0.22 0.22])  %kolor œcianek plota

%% uproszczony wykres
% for i=1:n
% x(i) = wspolrzedne(i,1);
% y(i) = wspolrzedne(i,2);
% z(i) = wspolrzedne(i,3);
% end
% figh = figure; %figure handle
% % Enlarge figure to full screen.
% set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.96]);
% %wykres
% plot3(x,y,z, 'color' ,'white','linewidth',2)
% axis([-2.17 -1.44 53.25 54.09 0 23000])
% grid
% title('\color{white}trajectory')
%ylabel('\color{green}Latitude [deg]', 'interpreter', 'tex')
%xlabel('\color{green}Longitude [deg]')
%zlabel('\color{green}Altitude [m]')
%set(gca,'DataAspectRatio',[1 skala_dlugosci_geo 111000])
% set(gca, 'XColor', 'w')     %kolory osi gridu
% set(gca, 'YColor', 'w')
% set(gca, 'ZColor', 'w')
% set(gcf,'color',[0.22 0.22 0.22]); %background figure
% %set(gcf,'color','r');          %background figure
% set(gca,'Color',[0.22 0.22 0.22])  %kolor œcianek plota
% % ax = gca;
% % ax.ZGrid = 'off';             %widzialnoœæ poszczególnych osi gridu
% % ax.XGrid = 'on';
% % ax.YGrid = 'on';
% hold on
% z2=[z;
% zeros(size(x))];
% %p³aszczyzna pod wykresem
% surf(repmat(x,size(z2,1),1), repmat(y,size(z2,1),1), z2, 'FaceColor','g','FaceAlpha',0.5, 'EdgeColor','none')
%% obrót kamery
%warunki pocz¹tkowe
az = 15;    %azymut pocz¹tkowy
el = 15;    %elewacja pocz¹tkowa

%koñcowy k¹t obrotu
angle = 375;

view([az,el])
for i = az:1:angle
  view([i,el]);
  movieVector(i) = getframe(figh, [10 10 1340 620]);
end

%% nagranie pliku .mp4
for i = 1:angle-14
    movieVector2(i) = movieVector(i+14);
end
myWriter = VideoWriter('trajectory', 'MPEG-4')
myWriter.FrameRate = 30;

open(myWriter);
writeVideo(myWriter, movieVector2)
close(myWriter);
toc

