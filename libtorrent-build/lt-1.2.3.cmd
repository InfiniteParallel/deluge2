cd "%~dp0"
cd..
set BOOST_ROOT=%cd%\boost
set OPENSSL=%cd%\OpenSSL-Win64
set BOOST_BUILD_PATH=%BOOST_ROOT%\tools\build
set PATH=%PATH%;%BOOST_BUILD_PATH%\src\engine\bin.ntx86;%BOOST_ROOT%;%cd%\python;%cd%\msys64\usr\bin
curl -LO https://dl.bintray.com/boostorg/release/1.70.0/source/boost_1_70_0.7z
msys64\usr\lib\p7zip\7z x boost_*.7z
del boost_*.7z
move boost_* boost
git clone https://github.com/arvidn/libtorrent -b libtorrent-1_2_3 lt
for /f %%i in ('curl -s https://www.python.org/ ^| grep "Latest: " ^| cut -d/ -f5 ^| cut -d" " -f2 ^| tr -d "<"') do set var2=%%i
for /f %%i in ('echo %var2% ^| cut -d. -f1-2 ^| tr -d .') do set PYTHONVER=%%i
mkdir python & curl -L https://www.nuget.org/api/v2/package/python/%var2% | bsdtar -xf - -C python --include tools --strip-components 1
msys64\usr\bin\echo -e "Lib\nDLLs\nimport site" >> python\python%PYTHONVER%._pth
call "%programfiles(x86)%\Microsoft Visual Studio\2019\BuildTools\VC\Auxiliary\Build\vcvars64.bat"
pushd boost
call bootstrap.bat
popd
pushd lt\bindings\python
b2 crypto=openssl libtorrent-link=static boost-link=static release optimization=space stage_module --abbreviate-paths -j4 address-model=64 openssl-include=%OPENSSL%\include openssl-lib=%OPENSSL%\lib
popd
move /y libtorrent.pyd C:\deluge2\libtorrent\lt1.2.3\Lib\site-packages
rd /s /q boost
rd /s /q boost 2>nul
rd /s /q lt
rd /s /q lt 2>nul
rd /s /q python
rd /s /q python 2>nul
pause