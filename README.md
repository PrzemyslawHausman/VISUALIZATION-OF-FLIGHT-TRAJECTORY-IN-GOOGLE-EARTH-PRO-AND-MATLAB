# VISUALIZATION OF FLIGHT TRAJECTORY IN GOOGLE EARTH PRO AND MATLAB

|                                       |                                       |
| :-----------------------------------: | :-----------------------------------: |
|![](images/colored_by_altitude.PNG)    |![](images/colored_by_time.PNG)        |
|Colored by altitude                    | Colored by time with normal shadow    |
|![](images/colored_by_climb.PNG)       |![](images/colored_by_speed.PNG)       |
|Colored by climb with extruded shadow  |Colored by speed with extruded shadow  |
|![](images/speed_marks.PNG)            |![](images/trajec.PNG)                 |
|Colored by speed with speed marks (there are also altitude, time and climb marks to choose)|The same trajectory generated in MATLAB colored by altitude|

## Instalation
To make this app work:
1. Install flile: "Google Earth trajectory.mlappinstall"
2. Extraxt file "aircraft.7z"
3. Set current directory in Matlab where you placed "aircraft" folder (for example - if you extracted it on desktop then set current dirrectory as desktop)


## INPUT DATA

You can choose to input data at few different ways:
1. spreadsheet file (.xlsx)
2. text file (.txt)
3. X-Plane log (.txt)
4. GPS log in NMEA format (.txt)

Data is then recognised and put into table where you can select corresponding parameters.
In X-Plane data format the parameters are recognized automatically.


## DOWNLOADING MORE AIRCRAFTS
1. Search and download file from: [3dWarehouse](https://3dwarehouse.sketchup.com/)
2. Place File in "aircraft" folder
3. Click "refresh" button in app or restart app

(authors sometimes set origin of the model in random point so dont expect every model to work correctly)
