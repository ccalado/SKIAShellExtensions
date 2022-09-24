; Script generated by the Inno Setup Script Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!
#define MyAppName 'SKIA Shell Extensions and Lottie Text Editor'
#define MyAppVersion '1.0.1'

[Setup]
AppName={#MyAppName}
AppPublisher=Ethea S.r.l.
AppVerName={#MyAppName} {#MyAppVersion}
VersionInfoVersion={#MyAppVersion}
AppPublisherURL=https://www.ethea.it/
AppSupportURL=https://github.com/EtheaDev/SKIAShellExtensions/issues
DefaultDirName={commonpf}\Ethea\SKIAShellExtensions
OutputBaseFileName=SKIAShellExtensionsSetup
DisableDirPage=false
DefaultGroupName=SKIA Shell Extensions
Compression=lzma
SolidCompression=true
UsePreviousAppDir=false
AppendDefaultDirName=false
PrivilegesRequired=admin
WindowVisible=false
WizardImageFile=WizEtheaImage.bmp
WizardSmallImageFile=WizEtheaSmallImage.bmp
AppContact=info@ethea.it
SetupIconFile=..\Icons\setup.ico
AppID=SKIAShellExtensions
UsePreviousSetupType=false
UsePreviousTasks=false
AlwaysShowDirOnReadyPage=true
AlwaysShowGroupOnReadyPage=true
ShowTasksTreeLines=true
DisableWelcomePage=False
AppCopyright=Copyright � 2021-2022 Ethea S.r.l.
ArchitecturesInstallIn64BitMode=x64
MinVersion=0,6.0
CloseApplications=force
UninstallDisplayIcon={app}\LottieTextEditor.exe

[Languages]
Name: eng; MessagesFile: compiler:Default.isl; LicenseFile: .\License_ENG.rtf
Name: ita; MessagesFile: compiler:Languages\Italian.isl; LicenseFile: .\Licenza_ITA.rtf


[Tasks]
Name: desktopicon; Description: {cm:CreateDesktopIcon}; GroupDescription: {cm:AdditionalIcons}; Flags: unchecked; Components: Editor

[Files]
; 32 Bit files
Source: "..\Bin32\sk4d.dll"; DestDir: "{sys}"; Flags : sharedfile 32bit; Components: ShellExtensions
Source: "..\Bin32\LottieTextEditor.exe"; DestDir: "{app}"; Flags: ignoreversion 32bit; Components: Editor
Source: "..\Bin32\SKIAShellExtensions32.dll"; DestDir: {app}; Flags : regserver sharedfile noregerror 32bit; Components: ShellExtensions

; 64 Bit files
Source: "..\Bin64\sk4d.dll"; DestDir: "{sys}"; Flags : 64bit sharedfile; Components: ShellExtensions
Source: "..\Bin64\LottieTextEditor.exe"; DestDir: "{app}"; Flags: ignoreversion 64bit; Components: Editor
Source: "..\Bin64\SKIAShellExtensions.dll"; DestDir: {app}; Flags : 64bit regserver sharedfile noregerror; Components: ShellExtensions

[Icons]
Name: "{group}\LottieTextEditor"; Filename: "{app}\LottieTextEditor.exe"; WorkingDir: "{app}"; IconFilename: "{app}\LottieTextEditor.exe"; Components: Editor
Name: "{userdesktop}\LottieTextEditor"; Filename: "{app}\LottieTextEditor.exe"; Tasks: desktopicon; Components: Editor

[Run]
Filename: {app}\LottieTextEditor.exe; Description: {cm:LaunchProgram,'Lottie Text Editor'}; Flags: nowait postinstall skipifsilent; Components: Editor

[Components]
Name: Editor; Description: Lottie Text Editor; Flags: fixed; Types: custom full
Name: ShellExtensions; Description: Shell Extensions (Preview and Thumbnails); Types: custom compact full

[Registry]
Root: "HKCR"; Subkey: ".lottie"; ValueType: string; ValueData: "Open"; Flags: uninsdeletekey
Root: "HKCR"; Subkey: ".json"; ValueType: string; ValueData: "Open"; Flags: uninsdeletekey
Root: "HKCR"; Subkey: "OpenLottieEditor"; ValueType: string; ValueData: "Lottie file"; Flags: uninsdeletekey
Root: "HKCR"; Subkey: "OpenLottieEditor\Shell\Open\Command"; ValueType: string; ValueData: """{app}\LottieTextEditor.exe"" ""%1"""; Flags: uninsdeletevalue
Root: "HKCR"; Subkey: "OpenLottieEditor\DefaultIcon"; ValueType: string; ValueData: "{app}\LottieTextEditor.exe,0"; Flags: uninsdeletevalue

[Code]
function InitializeSetup(): Boolean;
begin
   Result:=True;
end;

function GetUninstallString(): String;
var
  sUnInstPath: String;
  sUnInstallString: String;
begin
  sUnInstPath := ExpandConstant('Software\Microsoft\Windows\CurrentVersion\Uninstall\{#emit SetupSetting("AppId")}_is1');
  sUnInstallString := '';
  if not RegQueryStringValue(HKLM, sUnInstPath, 'UninstallString', sUnInstallString) then
    RegQueryStringValue(HKCU, sUnInstPath, 'UninstallString', sUnInstallString);
  Result := sUnInstallString;
end;

function IsUpgrade(): Boolean;
var
  s : string;
begin
  s := GetUninstallString();
  //MsgBox('GetUninstallString '+s, mbInformation, MB_OK);
  Result := (s <> '');
end;

function UnInstallOldVersion(): Integer;
var
  sUnInstallString: String;
  iResultCode: Integer;
begin
// Return Values:
// 1 - uninstall string is empty
// 2 - error executing the UnInstallString
// 3 - successfully executed the UnInstallString

  // default return value
  Result := 0;

  // get the uninstall string of the old app
  sUnInstallString := GetUninstallString();
  if sUnInstallString <> '' then begin
    sUnInstallString := RemoveQuotes(sUnInstallString);
    if Exec(sUnInstallString, '/SILENT /NORESTART /SUPPRESSMSGBOXES', '', SW_HIDE, ewWaitUntilTerminated, iResultCode) then
      Result := 3
    else
      Result := 2;
  end else
    Result := 1;
end;

procedure CurStepChanged(CurStep: TSetupStep);
begin
  if (CurStep=ssInstall) then
  begin
    if (IsUpgrade()) then
    begin
      MsgBox(ExpandConstant('An old version of "SKIA Shell Extensions" was detected. The uninstaller will be executed...'), mbInformation, MB_OK);
      UnInstallOldVersion();
    end;
  end;
end;
