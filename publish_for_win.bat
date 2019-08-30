@echo off
set qt_msvc_path="D:\Qt\Qt5.12.4\5.12.4\msvc2017\bin"

:: ��ȡ�ű�����·��
set script_path=%~dp0
:: ����ű�����Ŀ¼,��Ϊ���Ӱ��ű���ִ�еĳ���Ĺ���Ŀ¼
set old_cd=%cd%
cd /d %~dp0

:: ������������
set cpu_mode=x86
if /i "%2"=="x86" (
    set cpu_mode=x86
)
if /i "%2"=="x64" (
    set cpu_mode=x64
)

:: ������������
set PATH=%qt_msvc_path%;%PATH%

set publish_path=%script_path%publish\
set adb_path=%script_path%\third_party\adb\win\*.*
set jar_path=%script_path%\third_party\scrcpy-server.jar
set keymap_path=%script_path%\keymap

if /i %cpu_mode% == x86 (
    set release_path=%script_path%output\win\release
) else (
    set release_path=%script_path%output\win-x64\release
)

:: ����Ҫ�����İ�
xcopy %release_path% %publish_path% /E /Y
xcopy %adb_path% %publish_path% /Y
xcopy %jar_path% %publish_path% /Y
xcopy %keymap_path% %publish_path%keymap\ /E /Y

:: ���qt������
windeployqt %publish_path%\QtScrcpy.exe

:: ɾ������qt������
rmdir /s/q %publish_path%\iconengines
rmdir /s/q %publish_path%\imageformats
rmdir /s/q %publish_path%\translations
del %publish_path%\vc_redist.x86.exe

echo=
echo=
echo ---------------------------------------------------------------
echo ��ɣ�
echo ---------------------------------------------------------------

:return
cd %old_cd%