cd "%~dp0"
pushd..
set PATH=%cd%\msys64\usr\bin;%PATH%
popd
for /f %%i in ('dir /b /a:d ..\deluge-2* ^| findstr dev') do set var2=%%i
curl https://dl.miyuru.lk/geoip/maxmind/country/maxmind4.dat.gz | gzip -d -c > ..\%var2%\GeoIP.dat
del ..\deluge-*.exe 2>nul
..\nsis\makensis /DPROGRAM_VERSION=%var2:~7% /Dsrcdir=..\%var2% deluge-installer.nsi
pause
