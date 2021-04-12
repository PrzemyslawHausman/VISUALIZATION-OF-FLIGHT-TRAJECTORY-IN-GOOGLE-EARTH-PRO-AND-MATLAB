clear
tic
%% FILE OPEN
data = 'GPS.TXT';
ID = fopen(data);
row = 1;
cellf = textscan(ID,'%s');
GPScell = cell(5000,1);
for counter = 1 : size(cellf{1},1)
    string1 = cellf{1,1}{counter,1};
    if size(string1,2) == 1
        continue;
    end
        GPScell{row} = string1;
        row = row + 1;
end
%% GPS DATA ANALYSIS

for counter4 = 1:size(GPScell)
    if isempty(GPScell{counter4}) == 0
       string_input_2 = GPScell{counter4};
       vector_2 = strsplit(string(string_input_2),',');
       GPScell{counter4} = vector_2;
    end
end

end_result_GPS = [];

for counter5 = 1:size(GPScell,1)
    if length(GPScell{counter5}) == 15
        GPScell{counter5} = GPScell{counter5}(1:14);
    end
    end_result_GPS = [end_result_GPS; GPScell{counter5}];
end

Time_GPS = str2double(end_result_GPS(:,2));
Latitude_1 = str2double(end_result_GPS(:,3)) ./ 100;
Latitude_2 = floor(str2double(end_result_GPS(:,3)) ./ 100);
degrees_1 = Latitude_2 + ((Latitude_1 - Latitude_2) .* 100 ./ 60);

Longitude_1 = -str2double(end_result_GPS(:,5)) ./ 100 .* -1;
Longitude_2 = -ceil(str2double(end_result_GPS(:,5)) ./ 100 .*-1);
degrees_2 = Longitude_2 + ((Longitude_1 - Longitude_2) .* 100 ./ 60);

Altitude = str2double(end_result_GPS(:,10));
earth_map_data = [degrees_2,degrees_1,Altitude];
%% wprowadzenie kolorów

 load('coords2.mat')
 earth_map_data = wspolrzedne;
 load date.mat
n = size(earth_map_data,1);

%sprawdzenie parzystoœci
if floor(n/2) ~= n/2    %przyrównanie w dó³ do najbli¿szej ca³kowitej
earth_map_data(end,:) = [];
data(:,end) = [];
n = n-1;
end

k=256;%n/2  %bo kolorów od czerwonego do zielonego bêdzie ³¹cznie dwa razy tyle czyli n
%kolory od czerwonego do ¿ó³tego
mymap = zeros(2*k,3); 
   for i=1:k
      mymap(i,:) = [1 ((i-1)/k) 0];  
   end
%kolory od ¿ó³tego do zielonego
   for i=1:k
      mymap(k+i,:)=[((k-(i-1))/k) 1  0];  
   end
%tutaj zaaplikowaæ w³asn¹ mapê kolorów
%mymap2 = table(size(earth_map_data,1),8);   
ilosc_kolorow = size(mymap,1);
for i=1:ilosc_kolorow
mymap2(i,:) = rgb2hex(mymap(i,1:3));
end
%zamiana stron bo w KML jest standard aabbggrr (alfa blue green red)
ff = mymap2(:,1:2);
rr = mymap2(:,3:4);
gg = mymap2(:,5:6);
bb = mymap2(:,7:8);

mymap25 = [ff bb gg rr];
%konwersja char na string
mymap3 = strings(1, size(mymap25,1));
for i=1:ilosc_kolorow
   mymap3(i) = convertCharsToStrings(mymap25(i,:));  
end
%% GOOGLE EARTH

copyfile('header.txt', 'GE_Path.kml','f');
fileID_earth = fopen('GE_Path.kml','a');

%% style
string_style1 = '<Style id="';
string_style3 = '">';
string_style4 = '<LineStyle>';
string_style5 = '<color>';
string_style7 = '</color>';
string_style8 = '<width>2</width>';
string_style9 = '</LineStyle>';
string_12B = '        <PolyStyle>';
string_13B = '            <color>';
string_15B = '</color>';
string_16B = '        </PolyStyle>';
string_style10 = '</Style>';

for i=1:ilosc_kolorow
    fprintf(fileID_earth,'%s',string_style1);
    string_style2 = mymap3(i);
    fprintf(fileID_earth,'%s%s\n%s\n%s',string_style2,string_style3,string_style4,string_style5);
    string_style6 = mymap3(i);
    fprintf(fileID_earth,'%s%s\n%s\n%s\n%s\n%s%s%s\n%s\n%s\n',string_style6,string_style7,string_style8,string_style9,string_12B,string_13B,string_style6,string_15B,string_16B,string_style10);
end
%% Point style
string_style3 = 'p">';
string_style4p = '<BalloonStyle><text>$[description]</text></BalloonStyle>';
string_style5 = '<IconStyle>';
string_style6 = '<Icon><href>http://maps.google.com/mapfiles/kml/pal4/icon25.png</href></Icon>';
string_style7 = '<color>';
string_style9 = '</color>';
string_style10 = '<scale>0.774596669241</scale>';
string_style11 = '</IconStyle>';
string_style12 = '        <LabelStyle>';
string_style13 = '            <color>';
string_style15 = '</color>';
string_style16 = '<scale>0.774596669241</scale>';
string_style17 = '        </LabelStyle>';
string_style18 = '</Style>';

for i=1:ilosc_kolorow
    fprintf(fileID_earth,'%s',string_style1);
    string_style2 = mymap3(i);
    fprintf(fileID_earth,'%s%s\n%s\n%s\n%s\n%s',string_style2,string_style3,string_style4p,string_style5,string_style6,string_style7);
    string_style8 = mymap3(i);
    fprintf(fileID_earth,'%s%s\n%s\n%s\n%s\n%s',string_style8,string_style9,string_style10,string_style11,string_style12,string_style13);
    string_style14 = mymap3(i);
    fprintf(fileID_earth,'%s%s\n%s\n%s\n%s\n%s\n',string_style14,string_style15,string_style16,string_style17,string_style18);
end
%% track styles folder open
string_track_stles1 = '<Folder>';
string_track_stles2 = '<open>1</open>';
string_track_stles3 = '<styleUrl>#folder_style</styleUrl>';
string_track_stles4 = '<name>style kolorowania trasy</name>';
string_track_stles5 = '</Folder>';
fprintf(fileID_earth,'%s\n%s\n%s\n%s\n',string_track_stles1,string_track_stles2,string_track_stles3,string_track_stles4);
%% colored by altitude
string_00B = '<Folder>';
string_015B = '<styleUrl>#hidechildren</styleUrl>';
string_01B = '<name>Colored by altitude</name>';
string_1B = '<Placemark>';
string_5B = '      <styleUrl>#';

string_17B = '</styleUrl>';
string_18B = '    <LineString>';       
string_19B = '        <altitudeMode>absolute</altitudeMode>';
string_20B ='        <extrude>1</extrude>';
string_21B = '        <tessellate>1</tessellate>';
string_22B = '          <coordinates>';
string_23B = '          </coordinates>';
string_24B = '    </LineString>';
string_25B = '</Placemark>';
string_26B = '</Folder>';
fprintf(fileID_earth,'%s\n%s\n%s\n',string_00B,string_015B,string_01B);
kolor_odcinka = strings(1, size(mymap3,2));
max_wys = max(earth_map_data(:,3));
min_wys = min(earth_map_data(:,3));

delta_h = max_wys-min_wys;
przedzial_wysokosci_na_kolor = delta_h/ilosc_kolorow+0.3;
for i=1:n
    j = 1;
    check = 1;
    while check <= earth_map_data(i,3)
        check = przedzial_wysokosci_na_kolor * j;
        j = j+1;
    end
    kolor_odcinka(i) = mymap3(j);
end
i=1;
dp = 0;
while i <= n-2
     i = dp+1;
fprintf(fileID_earth,'%s\n%s',string_1B,string_5B);
string_8B = kolor_odcinka(i);
fprintf(fileID_earth,'%s%s\n%s\n%s\n%s\n%s\n%s\n',string_8B,string_17B,string_18B,string_19B,string_20B,string_21B,string_22B);
r = i;
if   i <= n-2 && r < n-1 && kolor_odcinka(r) == kolor_odcinka(r+1)  
    while i <= n-1 && r < n-1 && kolor_odcinka(r) == kolor_odcinka(r+1)
    dlmwrite('GE_Path.kml',earth_map_data(r,:),'-append','precision',7);
    r = r+1;
    end
    dlmwrite('GE_Path.kml',earth_map_data(r,:),'-append','precision',7);
    dlmwrite('GE_Path.kml',earth_map_data(r+1,:),'-append','precision',7);
elseif i <= n-1
    dlmwrite('GE_Path.kml',earth_map_data(i,:),'-append','precision',7); %wypisanie koordynatów z dok³adnoœci¹ do 7 cyfr znacz¹cych
    dlmwrite('GE_Path.kml',earth_map_data(i+1,:),'-append','precision',7);
end
    dp = r;
fprintf(fileID_earth,'%s\n%s\n%s\n',string_23B,string_24B,string_25B);
end
fprintf(fileID_earth,'%s\n',string_26B);
%% colored by time
% jeœli Ÿród³em jest zewnêtrzny plik
aktualny_czas = strings(1,size(data,1));
aktualny_czas_skrocony = strings(1,size(data,1));
for i=1:n
   aktualny_czas_char(i,:) = convertStringsToChars(data(i));
   aktualny_czas(i) = convertCharsToStrings(aktualny_czas_char(i,12:19));
   aktualny_czas_skrocony(i) = convertCharsToStrings(aktualny_czas_char(i,12:16));
end
time_char = char(end_result_GPS(:,2));
time_hh_GPS = time_char(:,1:2);
time_mm_GPS = time_char(:,3:4);
time_ss_GPS = time_char(:,5:10);
%jeœli Ÿród³em jest zewnêtrzny plik
time_hh_str = strings(size(data,2),2);
time_mm_str = strings(size(data,2),2);
time_ss_str = strings(size(data,2),2);
%jeœli Ÿród³em jest plik GPS.txt
% time_hh_str = strings(size(time_hh_GPS,1),2);
% time_mm_str = strings(size(time_mm_GPS,1),2);
% time_ss_str = strings(size(time_ss_GPS,1),size(time_ss_GPS,2));
time_hh = zeros(1,size(time_hh_str,2));
time_mm = zeros(1,size(time_mm_str,2));
time_ss = zeros(1,size(time_ss_str,2));
%jeœli Ÿród³em jest zewnêtrzny plik
for i=1:n
    time_hh_str(i) = convertCharsToStrings(aktualny_czas_char(i,12:13));
    time_mm_str(i) = convertCharsToStrings(aktualny_czas_char(i,15:16));
    time_ss_str(i) = convertCharsToStrings(aktualny_czas_char(i,18:19));
    time_hh(i) = str2double(time_hh_str(i));
    time_mm(i) = str2double(time_mm_str(i));
    time_ss(i) = str2double(time_ss_str(i));
end
%jeœli Ÿród³em jest plik GPS.txt
% for i=1:size(end_result_GPS,1)
%     time_hh_str(i) = convertCharsToStrings(time_hh_GPS(i,:));
%     time_mm_str(i) = convertCharsToStrings(time_mm_GPS(i,:));
%     time_ss_str(i) = convertCharsToStrings(time_ss_GPS(i,:));
%     time_hh(i) = str2double(time_hh_str(i));
%     time_mm(i) = str2double(time_mm_str(i));
%     time_ss(i) = str2double(time_ss_str(i));
% end
elementarny_czas_ss = zeros(1,size(time_ss,2)-1);
for i=1:n-1 %jesli GPS.txt to: size(end_result_GPS,1)-1
    if time_hh(i+1) > time_hh(i)
        elementarny_czas_ss(i) = ((((time_hh(i+1) - time_hh(i))*60 + time_mm(i+1)) - time_mm(i))*60 + time_ss(i+1)) - time_ss(i);
    elseif time_mm(i+1) > time_mm(i)
        elementarny_czas_ss(i) = (((time_mm(i+1)) - time_mm(i))*60 + time_ss(i+1)) - time_ss(i);
    else
        elementarny_czas_ss(i) = time_ss(i+1) - time_ss(i);
    end
end
% jeœli Ÿród³em jest plik GPS.txt
% for i=1:size(end_result_GPS,1) %n-1
%     aktualny_czas_char(i,:) = [time_hh_GPS(i,:), ':',time_mm_GPS(i,:)];
%     aktualny_czas(i) = convertCharsToStrings(aktualny_czas_char(i,:));
% end
string_cbt1 = '<Folder>';
string_cbt105 = '<styleUrl>#hidechildren</styleUrl>';
string_cbt2 = '<name>Colored by time</name>';
string_cbt3 = '<Placemark>';
string_cbt4 = '      <styleUrl>#';

string_cbt6 = '</styleUrl>';
string_cbt7 = '    <LineString>';       
string_cbt8 = '        <altitudeMode>absolute</altitudeMode>';
string_cbt9 = '        <tessellate>1</tessellate>';
string_cbt10 = '          <coordinates>';

string_cbt11 = '          </coordinates>';
string_cbt12= '    </LineString>';
string_cbt13 = '</Placemark>';
string_cbt14 = '</Folder>';
fprintf(fileID_earth,'%s\n%s\n%s\n',string_cbt1,string_cbt105,string_cbt2);
przedzial_czasu_na_kolor = size(earth_map_data,1)/ilosc_kolorow + 0.01;
kolor_odcinka_cbt = strings(1, size(mymap3,2));
for i=1:n-1
    j = 0;
    check = 0;
    while check <= i
        check = przedzial_czasu_na_kolor * j;
        j = j+1;
    end
    kolor_odcinka_cbt(i) = mymap3(j);
end    
   i=1;
dp = 0;  
 while i <= n-2
    i = dp+1; 
fprintf(fileID_earth,'%s\n%s',string_cbt3,string_cbt4);
string_cbt5 = kolor_odcinka_cbt(i);
fprintf(fileID_earth,'%s%s\n%s\n%s\n%s\n%s\n',string_cbt5,string_cbt6,string_cbt7,string_cbt8,string_cbt9,string_cbt10);
    r = i;
if   i <= n-3 && r < n-2 && kolor_odcinka_cbt(r) == kolor_odcinka_cbt(r+1)  
    while i <= n-2 && r < n-2 && kolor_odcinka_cbt(r) == kolor_odcinka_cbt(r+1) 
    dlmwrite('GE_Path.kml',earth_map_data(r,:),'-append','precision',7);
    r = r+1;
    end
    dlmwrite('GE_Path.kml',earth_map_data(r,:),'-append','precision',7);
    dlmwrite('GE_Path.kml',earth_map_data(r+1,:),'-append','precision',7);
else
    dlmwrite('GE_Path.kml',earth_map_data(i,:),'-append','precision',7); %wypisanie koordynatów z dok³adnoœci¹ do 7 cyfr znacz¹cych
    dlmwrite('GE_Path.kml',earth_map_data(i+1,:),'-append','precision',7);
end
    dp = r;
fprintf(fileID_earth,'%s\n%s\n%s\n',string_cbt11,string_cbt12,string_cbt13);
end
fprintf(fileID_earth,'%s\n',string_cbt14);
%% colored by climb
string_cbc1 = '<Folder>';
string_cbc105 = '<styleUrl>#hidechildren</styleUrl>';
string_cbc2 = '<name>Colored by climb</name>';
string_cbc3 = '<Placemark>';
string_cbc4 = '      <styleUrl>#';

string_cbc6 = '</styleUrl>';
string_cbc7 = '    <LineString>';       
string_cbc8 = '        <altitudeMode>absolute</altitudeMode>';
string_cbc9 = '        <tessellate>1</tessellate>';
string_cbc10 = '          <coordinates>';

string_cbc11 = '          </coordinates>';
string_cbc12= '    </LineString>';
string_cbc13 = '</Placemark>';
string_cbc14 = '</Folder>';
fprintf(fileID_earth,'%s\n%s\n%s\n',string_cbc1,string_cbc105,string_cbc2);
elementarne_delta_h = zeros(1,n-1);
for i=1:n-1
    elementarne_delta_h(i) = earth_map_data(i+1,3) - earth_map_data(i,3);
end
predkosc_pionowa = elementarne_delta_h./elementarny_czas_ss;
delta_v_cbc = max(predkosc_pionowa) - min(predkosc_pionowa);
%delta_v_cbc = max(elementarne_delta_h) - min(elementarne_delta_h);
przedzial_wysokosci_na_kolor_cbc = delta_v_cbc/ilosc_kolorow+0.03;
kolor_odcinka_cbc = strings(1, size(mymap3,2));
for i=1:n-1
        j = 0;
    check = min(predkosc_pionowa);
    while check <= predkosc_pionowa(i) %elementarne_delta_h(i)
        check = min(predkosc_pionowa) + przedzial_wysokosci_na_kolor_cbc * j;
        j = j+1;
    end
    kolor_odcinka_cbc(i) = mymap3(j);
end
i=1;
dp = 0;
while i <= n-2
     i = dp+1;
fprintf(fileID_earth,'%s\n%s',string_cbc3,string_cbc4);
string_cbc5 = kolor_odcinka_cbc(i);
fprintf(fileID_earth,'%s%s\n%s\n%s\n%s\n%s\n',string_cbc5,string_cbc6,string_cbc7,string_cbc8,string_cbc9,string_cbc10);
    r = i;
if  i <= n-3 && r < n-2 && kolor_odcinka_cbc(r) == kolor_odcinka_cbc(r+1)  
    while i <= n-2 && r < n-2 && kolor_odcinka_cbc(r) == kolor_odcinka_cbc(r+1) 
    dlmwrite('GE_Path.kml',earth_map_data(r,:),'-append','precision',7);
    r = r+1;
    end
    dlmwrite('GE_Path.kml',earth_map_data(r,:),'-append','precision',7);
    dlmwrite('GE_Path.kml',earth_map_data(r+1,:),'-append','precision',7);
else
    dlmwrite('GE_Path.kml',earth_map_data(i,:),'-append','precision',7); %wypisanie koordynatów z dok³adnoœci¹ do 7 cyfr znacz¹cych
    dlmwrite('GE_Path.kml',earth_map_data(i+1,:),'-append','precision',7);
end
    dp = r;
fprintf(fileID_earth,'%s\n%s\n%s\n',string_cbc11,string_cbc12,string_cbc13);
end
fprintf(fileID_earth,'%s\n',string_cbc14);

%% colored by speed
string_cbs1 = '<Folder>';
string_cbs105 = '<styleUrl>#hidechildren</styleUrl>';
string_cbs2 = '<name>Colored by speed</name>';
string_cbs3 = '<Placemark>';
string_cbs4 = '      <styleUrl>#';

string_cbs6 = '</styleUrl>';
string_cbs7 = '    <LineString>';       
string_cbs8 = '        <altitudeMode>absolute</altitudeMode>';
string_cbs9 = '        <tessellate>1</tessellate>';
string_cbs10 = '          <coordinates>';

string_cbs11 = '          </coordinates>';
string_cbs12= '    </LineString>';
string_cbs13 = '</Placemark>';
string_cbs14 = '</Folder>';

fprintf(fileID_earth,'%s\n%s\n%s\n',string_cbs1,string_cbs105,string_cbs2);
elementarna_dlugosc_odcinka = zeros(1,n-1);
for i=1:n-1
    %total speed
    elementarna_dlugosc_odcinka(i) = sqrt((earth_map_data(i+1,3) - earth_map_data(i,3))^2) + 111000 * sqrt((earth_map_data(i+1,2) - earth_map_data(i,2))^2+(earth_map_data(i+1,1) - earth_map_data(i,1))^2);
    %ground speed
    %elementarna_dlugosc_odcinka(i) = 111000 * sqrt((earth_map_data(i+1,2) - earth_map_data(i,2))^2+(earth_map_data(i+1,1) - earth_map_data(i,1))^2);
end
elementarna_predkosc = (elementarna_dlugosc_odcinka./elementarny_czas_ss); %[m/s]

delta_v = max(elementarna_predkosc) - min(elementarna_predkosc);
przedzial_predkosci_na_kolor = delta_v/ilosc_kolorow+0.0011;
kolor_odcinka_cbs = strings(1, size(mymap3,2));
for i=1:n-1
        j = 0;
    check = min(elementarna_predkosc);
    while check <= elementarna_predkosc(i)
        check = min(elementarna_predkosc) + przedzial_predkosci_na_kolor * j;
        j = j+1;
    end
    kolor_odcinka_cbs(i) = mymap3(j);
end   
  i=1;
dp = 0;  
 while i <= n-2
    i = dp+1;
fprintf(fileID_earth,'%s\n%s',string_cbs3,string_cbs4);
string_cbs5 = kolor_odcinka_cbs(i);
fprintf(fileID_earth,'%s%s\n%s\n%s\n%s\n%s\n',string_cbs5,string_cbs6,string_cbs7,string_cbs8,string_cbs9,string_cbs10);
    r = i;
if  i <= n-3 && r < n-2 && kolor_odcinka_cbs(r) == kolor_odcinka_cbs(r+1)  
    while i <= n-2 && r < n-2 && kolor_odcinka_cbs(r) == kolor_odcinka_cbs(r+1) 
    dlmwrite('GE_Path.kml',earth_map_data(r,:),'-append','precision',7);
    r = r+1;
    end
    dlmwrite('GE_Path.kml',earth_map_data(r,:),'-append','precision',7);
    dlmwrite('GE_Path.kml',earth_map_data(r+1,:),'-append','precision',7);
else
    dlmwrite('GE_Path.kml',earth_map_data(i,:),'-append','precision',7); %wypisanie koordynatów z dok³adnoœci¹ do 7 cyfr znacz¹cych
    dlmwrite('GE_Path.kml',earth_map_data(i+1,:),'-append','precision',7);
end
    dp = r;
fprintf(fileID_earth,'%s\n%s\n%s\n',string_cbs11,string_cbs12,string_cbs13);
end
fprintf(fileID_earth,'%s\n',string_cbs14);
%% track styles folder close
fprintf(fileID_earth,'%s\n',string_track_stles5);
%% shadow folder open
string_track_stles4s = '<name>shadows</name>';
fprintf(fileID_earth,'%s\n%s\n%s\n%s\n',string_track_stles1,string_track_stles2,string_track_stles3,string_track_stles4s);
%% normal shadow
string_shadow1 = '<Folder>';
string_shadow2 = '<name>Normal</name>';
string_shadow25 = '<styleUrl>#hidechildren</styleUrl>';
string_shadow3 = '<Placemark>';
string_shadow4 = '      <styleUrl>#shadow</styleUrl>';
string_shadow5 = '    <LineString>';       
string_shadow6 = '        <altitudeMode>clampToGround</altitudeMode>';
string_shadow7 = '        <tessellate>1</tessellate>';
string_shadow8 = '          <coordinates>';
fprintf(fileID_earth,'%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n',string_shadow1,string_shadow2,string_shadow25,string_shadow3,string_shadow4,string_shadow5,string_shadow6,string_shadow7,string_shadow8);
dlmwrite('GE_Path.kml',earth_map_data,'-append','precision',7); 
string_shadow9 = '          </coordinates>';
string_shadow10= '    </LineString>';
string_shadow11 = '</Placemark>';
string_shadow12 = '</Folder>';
fprintf(fileID_earth,'%s\n%s\n%s\n%s\n',string_shadow9,string_shadow10,string_shadow11,string_shadow12);
%% Extruded shadow
string_shadow2 = '<name>Extruded shadow</name>';
string_shadow4e = '      <styleUrl>#shadow</styleUrl>';
string_shadow55 = '           <outline>1</outline>';
fprintf(fileID_earth,'%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n',string_shadow1,string_shadow2,string_shadow25,string_shadow3,string_shadow4e,string_shadow5,string_shadow55,string_20B,string_cbs8,string_shadow7,string_shadow8);
dlmwrite('GE_Path.kml',earth_map_data,'-append','precision',7); 
fprintf(fileID_earth,'%s\n%s\n%s\n%s\n',string_shadow9,string_shadow10,string_shadow11,string_shadow12);
%% shadows folder close
fprintf(fileID_earth,'%s\n',string_track_stles5);
%% marks folder open
string_track_stles4s = '<name>znaczniki</name>';
fprintf(fileID_earth,'%s\n%s\n%s\n%s\n',string_track_stles1,string_track_stles2,string_track_stles3,string_track_stles4s);
%% altitude marks
string_cbs2 = '<name>Altitude marks</name>';
string_vis = '<visibility>0</visibility>';
fprintf(fileID_earth,'%s\n%s\n%s\n%s\n',string_cbs1,string_cbs105,string_cbs2,string_vis);
sting_mark1 = '<Placemark>';
sting_mark2 = '<Point>';
sting_mark3 = '<altitudeMode>absolute</altitudeMode>';
sting_mark4 = '<coordinates>';
sting_mark5 = '</coordinates>';
sting_mark6 = '</Point>';
sting_mark7 = '<styleUrl>';
sting_mark9 = 'p</styleUrl>';
sting_mark10 = '<name>';
sting_mark11 = 'm</name>';
sting_mark12 = '</Placemark>';
m=10;
t = m+1;
for i=1:t
    p = i-1;
    if p == 0
        j = 1;
    else
    j=floor(p*((n-1)/m));
    end
    fprintf(fileID_earth,'%s\n%s\n%s\n%s\n',sting_mark1,sting_mark2,sting_mark3,sting_mark4);
    dlmwrite('GE_Path.kml',earth_map_data(j,:),'-append','precision',7);
    fprintf(fileID_earth,'%s\n%s\n%s',sting_mark5,sting_mark6,sting_mark7);
    string_mark8 = kolor_odcinka(j);
    fprintf(fileID_earth,'%s%s\n%s',string_mark8,sting_mark9,sting_mark10);
    loc_mark = string(earth_map_data(j,3));
    fprintf(fileID_earth,'%s%s\n%s\n',loc_mark,sting_mark11,sting_mark12);
end
fprintf(fileID_earth,'%s\n',string_cbs14);
%% time marks
string_cbs2 = '<name>Time marks</name>';
sting_mark11s = '</name>';
fprintf(fileID_earth,'%s\n%s\n%s\n%s\n',string_cbs1,string_cbs105,string_cbs2,string_vis);
for i=1:t
    p = i-1;
    if p == 0
        j = 1;
    else
    j=floor(p*((n-1)/m));
    end
    fprintf(fileID_earth,'%s\n%s\n%s\n%s\n',sting_mark1,sting_mark2,sting_mark3,sting_mark4);
    dlmwrite('GE_Path.kml',earth_map_data(j,:),'-append','precision',7);
    fprintf(fileID_earth,'%s\n%s\n%s',sting_mark5,sting_mark6,sting_mark7);
    string_mark8 = kolor_odcinka_cbt(j);
    fprintf(fileID_earth,'%s%s\n%s',string_mark8,sting_mark9,sting_mark10);
    loc_mark = aktualny_czas_skrocony(j);
    fprintf(fileID_earth,'%s%s\n%s\n',loc_mark,sting_mark11s,sting_mark12);
end
fprintf(fileID_earth,'%s\n',string_cbs14);
%% speed marks
string_cbs2 = '<name>Speed marks</name>';
sting_mark11s = 'm/s</name>';
fprintf(fileID_earth,'%s\n%s\n%s\n%s\n',string_cbs1,string_cbs105,string_cbs2,string_vis);
for i=1:t
    p = i-1;
    if p == 0
        j = 1;
    else
    j=floor(p*((n-1)/m));
    end
    fprintf(fileID_earth,'%s\n%s\n%s\n%s\n',sting_mark1,sting_mark2,sting_mark3,sting_mark4);
    dlmwrite('GE_Path.kml',earth_map_data(j,:),'-append','precision',7);
    fprintf(fileID_earth,'%s\n%s\n%s',sting_mark5,sting_mark6,sting_mark7);
    string_mark8 = kolor_odcinka_cbs(j);
    fprintf(fileID_earth,'%s%s\n%s',string_mark8,sting_mark9,sting_mark10);
    loc_mark = string(ceil(elementarna_predkosc(j)));
    fprintf(fileID_earth,'%s%s\n%s\n',loc_mark,sting_mark11s,sting_mark12);
end
fprintf(fileID_earth,'%s\n',string_cbs14);
%% climb marks
string_cbs2 = '<name>Climb marks</name>';
sting_mark11s = 'm/s</name>';
fprintf(fileID_earth,'%s\n%s\n%s\n%s\n',string_cbs1,string_cbs105,string_cbs2,string_vis);
for i=1:t
    p = i-1;
    if p == 0
        j = 1;
    else
    j=floor(p*((n-1)/m));
    end
    fprintf(fileID_earth,'%s\n%s\n%s\n%s\n',sting_mark1,sting_mark2,sting_mark3,sting_mark4);
    dlmwrite('GE_Path.kml',earth_map_data(j,:),'-append','precision',7);
    fprintf(fileID_earth,'%s\n%s\n%s',sting_mark5,sting_mark6,sting_mark7);
    string_mark8 = kolor_odcinka_cbc(j);
    fprintf(fileID_earth,'%s%s\n%s',string_mark8,sting_mark9,sting_mark10);
    loc_mark = string(ceil(predkosc_pionowa(j)));
    fprintf(fileID_earth,'%s%s\n%s\n',loc_mark,sting_mark11s,sting_mark12);
end
fprintf(fileID_earth,'%s\n',string_cbs14);
%% maxs & mins
string_cbs2 = '<name>Maxs and mins</name>';
fprintf(fileID_earth,'%s\n%s\n%s\n%s\n',string_cbs1,string_cbs105,string_cbs2,string_vis);
sting_mark7m = '<styleUrl>max_mins</styleUrl>';

%max alt
sting_mark10 = '<name>Max altitude: ';
sting_mark11m = 'm</name>';
fprintf(fileID_earth,'%s\n%s\n%s\n%s\n',sting_mark1,sting_mark2,sting_mark3,sting_mark4);
f = find(earth_map_data(:,3)==max_wys);
dlmwrite('GE_Path.kml',earth_map_data(f(1),:),'-append','precision',7); 
fprintf(fileID_earth,'%s\n%s\n%s\n%s',sting_mark5,sting_mark6,sting_mark7m,sting_mark10);
loc_mark = string(max_wys);
fprintf(fileID_earth,'%s%s\n%s\n',loc_mark,sting_mark11m,sting_mark12);
%min alt
sting_mark10 = '<name>Min altitude: ';
sting_mark11m = 'm</name>';
fprintf(fileID_earth,'%s\n%s\n%s\n%s\n',sting_mark1,sting_mark2,sting_mark3,sting_mark4);
f = find(earth_map_data(:,3)==min_wys);
dlmwrite('GE_Path.kml',earth_map_data(f(1),:),'-append','precision',7); 
fprintf(fileID_earth,'%s\n%s\n%s\n%s',sting_mark5,sting_mark6,sting_mark7m,sting_mark10);
loc_mark = string(min_wys);
fprintf(fileID_earth,'%s%s\n%s\n',loc_mark,sting_mark11m,sting_mark12);
%max climb
sting_mark10 = '<name>Max climb: ';
sting_mark11m = 'm/s</name>';
fprintf(fileID_earth,'%s\n%s\n%s\n%s\n',sting_mark1,sting_mark2,sting_mark3,sting_mark4);
f = find(predkosc_pionowa==max(predkosc_pionowa));
dlmwrite('GE_Path.kml',earth_map_data(f(1),:),'-append','precision',7); 
fprintf(fileID_earth,'%s\n%s\n%s\n%s',sting_mark5,sting_mark6,sting_mark7m,sting_mark10);
loc_mark = string(max(predkosc_pionowa));
fprintf(fileID_earth,'%s%s\n%s\n',loc_mark,sting_mark11m,sting_mark12);
%min climb
sting_mark10 = '<name>Min climb: ';
sting_mark11m = 'm/s</name>';
fprintf(fileID_earth,'%s\n%s\n%s\n%s\n',sting_mark1,sting_mark2,sting_mark3,sting_mark4);
f = find(predkosc_pionowa==min(predkosc_pionowa));
dlmwrite('GE_Path.kml',earth_map_data(f(1),:),'-append','precision',7); 
fprintf(fileID_earth,'%s\n%s\n%s\n%s',sting_mark5,sting_mark6,sting_mark7m,sting_mark10);
loc_mark = string(min(predkosc_pionowa));
fprintf(fileID_earth,'%s%s\n%s\n',loc_mark,sting_mark11m,sting_mark12);
%max speed
sting_mark10 = '<name>Max speed: ';
sting_mark11m = 'm/s</name>';
fprintf(fileID_earth,'%s\n%s\n%s\n%s\n',sting_mark1,sting_mark2,sting_mark3,sting_mark4);
f = find(elementarna_predkosc==max(elementarna_predkosc));
dlmwrite('GE_Path.kml',earth_map_data(f(1),:),'-append','precision',7); 
fprintf(fileID_earth,'%s\n%s\n%s\n%s',sting_mark5,sting_mark6,sting_mark7m,sting_mark10);
loc_mark = string(max(elementarna_predkosc));
fprintf(fileID_earth,'%s%s\n%s\n',loc_mark,sting_mark11m,sting_mark12);
fprintf(fileID_earth,'%s\n',string_cbs14);
%% marks folder close
fprintf(fileID_earth,'%s\n',string_track_stles5);
%% zamkniêcie dokumentu
string_2A = '</Document>';
string_3A = '</kml>';
fprintf(fileID_earth,'%s\n%s\n',string_2A,string_3A);
fclose(fileID_earth);
toc