cd "%~dp0"
cd ..
set DOWNLOAD_DIR="%cd%\gtk-cache"
set BUILD_DIR="%cd%\gtk-build"
set MSVC_DIR="%cd%\msvc"
set PYTHON_PATH="%cd%\python"
set MSYSPATH="%cd%\msys64\usr\bin"
set PATH=%PYTHON_PATH%;%PYTHON_PATH%\Scripts;%cd%\gtk-build\gtk\x64\release\bin;%MSYSPATH%;%PATH%
set platform=x64
set VS_VER=16
set arch=amd64
set VSCMD_DEBUG=1
for /f %%i in ('curl -s https://www.python.org/ ^| grep "Latest: " ^| cut -d/ -f5 ^| cut -d" " -f2 ^| tr -d "<"') do set var2=%%i
for /f %%i in ('echo %var2% ^| cut -d. -f1-2 ^| tr -d .') do set PYTHONVER=%%i
mkdir python & curl -L https://www.nuget.org/api/v2/package/python/%var2% | bsdtar xf - -C python --include tools --strip-components 1
curl https://bootstrap.pypa.io/get-pip.py | python\python.exe
git clone https://github.com/wingtk/gvsbuild gtk-build\gvsbuild
pushd gtk-build\gvsbuild
sed -i 's/gtk3_24(Tarball/gtk3_24(GitRepo/' gvsbuild\projects.py
sed -i "/prj_dir='gtk3-24',/{n;N;d}" gvsbuild\projects.py
sed -i "/prj_dir='gtk3-24',/a\            repo_url = 'https:\/\/gitlab.gnome.org\/GNOME\/gtk.git',\n            fetch_submodules = False,\n            tag = 'gtk-3-24'," gvsbuild\projects.py
sed -i "\|self.builder.opts.tools_root_dir, dir_part = self.dir_part, check_file = self.full_exe, check_mark=True)|a \        cmd = '%%s/usr/bin/sed -i \"s/paths=True/paths=False/\" %%s/%%s/mesonbuild/modules/gnome.py' %% (self.opts.msys_dir, self.opts.tools_root_dir, self.dir_part, )\n \       subprocess.check_call(cmd, shell=True)" gvsbuild\tools.py
mkdir %DOWNLOAD_DIR% 2>nul
curl https://win.rustup.rs/x86_64 > %DOWNLOAD_DIR%\rustup-init.exe
rd /s /q %DOWNLOAD_DIR%\git-exp\gtk3
rd /s /q %DOWNLOAD_DIR%\git-exp\gtk3
del %DOWNLOAD_DIR%\git-exp\gtk3.hash
del %DOWNLOAD_DIR%\git\gtk3-*
python -E build.py -d build --gtk3-ver=3.24 --archives-download-dir=%DOWNLOAD_DIR% --build-dir="%BUILD_DIR%" --msys-dir="%MSYSPATH:~1,-9%" --vs-ver=%VS_VER% --platform=x64 --vs-install-path="%MSVC_DIR%" --python-dir="%PYTHON_PATH%" -k --enable-gi --py-wheel --python-ver=%var2% enchant gtk3-full pycairo pygobject lz4 --skip gtksourceview3,emeus,clutter --capture-out --print-out
popd
rd /s /q python
rd /s /q python
del gtk-build\gtk\x64\release\bin\*.exe
del gtk-build\gtk\x64\release\bin\*.pdb
del gtk-build\gtk\x64\release\\bin\gdbus-codegen
del gtk-build\gtk\x64\release\\bin\g-ir-annotation-tool
del gtk-build\gtk\x64\release\bin\g-ir-scanner
del gtk-build\gtk\x64\release\bin\glib-genmarshal
del gtk-build\gtk\x64\release\bin\glib-mkenums
del gtk-build\gtk\x64\release\bin\gtester-report
del gtk-build\gtk\x64\release\etc\gtk-3.0\im-multipress.conf
del gtk-build\gtk\x64\release\lib\harfbuzz.lib
del gtk-build\gtk\x64\release\lib\*.pdb
del gtk-build\gtk\x64\release\lib\enchant\*.pdb
del deluge-build\pycairo-*-win_amd64.whl
del deluge-build\PyGObject-*-win_amd64.whl
move /y gtk-build\gtk\x64\release\python\*.whl deluge-build
rd /s /q gtk-build\gtk\x64\release\include 
rd /s /q gtk-build\gtk\x64\release\libexec
rd /s /q gtk-build\gtk\x64\release\python
rd /s /q gtk-build\gtk\x64\release\share\aclocal 
rd /s /q gtk-build\gtk\x64\release\share\cogl-1.0
rd /s /q gtk-build\gtk\x64\release\share\doc 
rd /s /q gtk-build\gtk\x64\release\share\gettext 
rd /s /q gtk-build\gtk\x64\release\share\gir-1.0 
rd /s /q gtk-build\gtk\x64\release\share\gobject-introspection-1.0
rd /s /q gtk-build\gtk\x64\release\share\gtk-2.0 
rd /s /q gtk-build\gtk\x64\release\share\gtk-3.0
rd /s /q gtk-build\gtk\x64\release\share\installed-tests 
rd /s /q gtk-build\gtk\x64\release\share\man 
rd /s /q gtk-build\gtk\x64\release\share\pkgconfig
rd /s /q gtk-build\gtk\x64\release\share\thumbnailers
rd /s /q gtk-build\gtk\x64\release\share\icons\Adwaita\cursors
del gtk-build\gtk\x64\release\lib\gdk-pixbuf-2.0\2.10.0\loaders\*.pdb
del gtk-build\gtk\x64\release\lib\gobject-introspection\giscanner\_giscanner.pdb
move overlay\data\bin\msvcp140.dll gtk-build\gtk\x64\release\bin
move overlay\data\etc\gtk-3.0\settings.ini gtk-build\gtk\x64\release\etc\gtk-3.0
move overlay\data\share\themes\win32x gtk-build\gtk\x64\release\share\themes
rd /s /q  overlay\data
rd /s /q  overlay\data 2>nul
move gtk-build\gtk\x64\release overlay\data
rd /s /q gtk-build
rd /s /q gtk-build 2>nul
for /f %%i in ('dir /b deluge-2* ^| findstr /v dev') do rd /s /q %%i\data
for /f %%i in ('dir /b deluge-2* ^| findstr /v dev') do rd /s /q %%i\data 2>nul
for /f %%i in ('dir /b deluge-2* ^| findstr dev') do rd /s /q %%i\data
for /f %%i in ('dir /b deluge-2* ^| findstr dev') do rd /s /q %%i\data 2>nul
for /f %%i in ('dir /b deluge-2* ^| findstr /v dev') do xcopy /ehq overlay\data %%i\data\
for /f %%i in ('dir /b deluge-2* ^| findstr dev') do xcopy /ehq overlay\data %%i\data\
