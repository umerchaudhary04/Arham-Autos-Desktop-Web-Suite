[Setup]
AppName=Arham Autos POS
AppVersion=1.0.0
Publisher=AlphaSync Systems (Private) Limited
DefaultDirName={autopf}\ArhamAutos
DefaultGroupName=Arham Autos
OutputDir=build\installer
OutputBaseFilename=ArhamAutos_Setup
Compression=lzma2
SolidCompression=yes
ArchitecturesInstallIn64BitMode=x64
SetupIconFile=windows\runner\resources\app_icon.ico

[Files]
Source: "build\windows\x64\runner\Release\arham_autos.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "build\windows\x64\runner\Release\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{group}\Arham Autos POS"; Filename: "{app}\arham_autos.exe"
Name: "{commondesktop}\Arham Autos POS"; Filename: "{app}\arham_autos.exe"; Tasks: desktopicon

[Tasks]
Name: "desktopicon"; Description: "Create a &desktop icon"; GroupDescription: "Additional icons:"

[Run]
Filename: "{app}\arham_autos.exe"; Description: "Launch Arham Autos POS"; Flags: nowait postinstall skipifsilent
