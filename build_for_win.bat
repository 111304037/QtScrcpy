@echo off
set VsDevCmd="C:\Program Files (x86)\Microsoft Visual Studio\2017\Professional\Common7\Tools\VsDevCmd.bat"
set qt_msvc_path="D:\Qt\Qt5.12.4\5.12.4\msvc2017\bin"

:: ��ȡ�ű�����·��
set script_path=%~dp0
:: ����ű�����Ŀ¼,��Ϊ���Ӱ��ű���ִ�еĳ���Ĺ���Ŀ¼
set old_cd=%cd%
cd /d %~dp0

:: ������������
set debug_mode="false"

echo=
echo=
echo ---------------------------------------------------------------
echo ���������[debug/release]
echo ---------------------------------------------------------------

:: ���������� /i���Դ�Сд
if /i "%1"=="debug" (
    set debug_mode="true"
    goto param_ok
)
if /i "%1"=="release" (
    set debug_mode="false"
    goto param_ok
)

echo "waring: unkonow build mode -- %1, default release"
set debug_mode="false"
goto param_ok

:param_ok

:: ��ʾ
if /i %debug_mode% == "true" (
    echo ��ǰ����汾Ϊdebug�汾
) else (
    echo ��ǰ����汾Ϊrelease�汾
)

:: ������������
set build_path=%script_path%build
set PATH=%qt_msvc_path%;%PATH%

call %VsDevCmd%

if not %errorlevel%==0 (
    echo "VsDevCmd not find"
    goto return
)

echo=
echo=
echo ---------------------------------------------------------------
echo ��ʼqmake����
echo ---------------------------------------------------------------

if exist %build_path% (          
    rmdir /q /s %build_path%
)
md %build_path%
cd %build_path%

set qmake_params=-spec win32-msvc

if /i %debug_mode% == "true" (
    set qmake_params=%qmake_params% "CONFIG+=debug" "CONFIG+=qml_debug"
) else (
    set qmake_params=%qmake_params% "CONFIG+=qtquickcompiler"
)

:: qmake ../all.pro -spec win32-msvc "CONFIG+=debug" "CONFIG+=qml_debug"
qmake ../all.pro %qmake_params%

nmake

if not %errorlevel%==0 (
    echo "qmake build failed"
    goto return
)

echo=
echo=
echo ---------------------------------------------------------------
echo ��ɣ�
echo ---------------------------------------------------------------

:return
cd %old_cd%