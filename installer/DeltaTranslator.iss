[Setup]
AppId=DeltaTranslator
AppName=DeltaTranslator
AppVersion=1.1.4
DisableWelcomePage=no
DefaultDirName={autopf}\Steam\steamapps\common\DELTARUNE
DisableDirPage=no
AppendDefaultDirName=no
DirExistsWarning=no
UsePreviousAppDir=no
DisableProgramGroupPage=yes
Uninstallable=no
PrivilegesRequired=lowest
PrivilegesRequiredOverridesAllowed=commandline
ArchitecturesAllowed=x64compatible
OutputDir=..\artifacts\installer
OutputBaseFilename=DeltaTranslator-Setup-win-x64
Compression=lzma2
SolidCompression=yes
WizardStyle=modern
SetupLogging=yes
LicenseFile=..\Patcher\LICENSE

[Files]
Source: "..\artifacts\patcher\*"; DestDir: "{tmp}\patcher"; Flags: dontcopy noencryption recursesubdirs

[Languages]
Name: "en"; MessagesFile: "compiler:Default.isl"
Name: "ru"; MessagesFile: "compiler:Languages\Russian.isl"
Name: "es"; MessagesFile: "compiler:Languages\Spanish.isl"
Name: "pt"; MessagesFile: "compiler:Languages\BrazilianPortuguese.isl"
Name: "de"; MessagesFile: "compiler:Languages\German.isl"

[Messages]
en.WelcomeLabel1=DeltaTranslator
en.WelcomeLabel2=DeltaTranslator adds a translated text overlay to DELTARUNE. It sends dialogue and choices to Google Translate over the internet.%n%nAfter installation, press F5 in a dialogue to translate, F3 for automatic translation, or F1 to change the translation language.
en.SelectDirLabel3=Choose the folder where DELTARUNE is installed. Close the game before continuing.
en.FinishedLabel=The mod is installed. In a dialogue, press F5 to translate. Your original chapter files are backed up next to the patched files.
ru.WelcomeLabel1=DeltaTranslator
ru.WelcomeLabel2=DeltaTranslator показывает перевод текста поверх игры DELTARUNE. Для перевода мод отправляет реплики и варианты ответа в Google Переводчик через интернет.%n%nВ игре нажми F5 для перевода, F3 для автоперевода или F1 для смены языка.
ru.SelectDirLabel3=Выбери папку, в которую установлена DELTARUNE. Закрой игру перед продолжением.
ru.FinishedLabel=Мод установлен. Нажми F5 во время диалога, чтобы перевести его. Резервные копии исходных файлов лежат рядом с пропатченными архивами.
es.WelcomeLabel1=DeltaTranslator
es.WelcomeLabel2=DeltaTranslator muestra traducciones sobre el juego DELTARUNE. Envía los diálogos y las opciones al Traductor de Google por Internet.%n%nPulsa F5 para traducir, F3 para activar la traducción automática o F1 para cambiar el idioma.
es.SelectDirLabel3=Elige la carpeta donde está instalado DELTARUNE. Cierra el juego antes de continuar.
es.FinishedLabel=El mod está instalado. Pulsa F5 durante un diálogo para traducirlo. Las copias de seguridad están junto a los archivos modificados.
pt.WelcomeLabel1=DeltaTranslator
pt.WelcomeLabel2=O DeltaTranslator exibe traduções sobre o jogo DELTARUNE. O mod envia diálogos e opções ao Google Tradutor pela internet.%n%nPressione F5 para traduzir, F3 para ativar a tradução automática ou F1 para mudar o idioma.
pt.SelectDirLabel3=Escolha a pasta onde DELTARUNE está instalado. Feche o jogo antes de continuar.
pt.FinishedLabel=O mod foi instalado. Pressione F5 durante um diálogo para traduzi-lo. As cópias de segurança estão ao lado dos arquivos modificados.
de.WelcomeLabel1=DeltaTranslator
de.WelcomeLabel2=DeltaTranslator zeigt Übersetzungen direkt in DELTARUNE an. Dialoge und Antwortoptionen werden über das Internet an Google Übersetzer gesendet.%n%nDrücke F5 zum Übersetzen, F3 für die automatische Übersetzung oder F1 zum Sprachwechsel.
de.SelectDirLabel3=Wähle den Installationsordner von DELTARUNE. Schließe das Spiel, bevor du fortfährst.
de.FinishedLabel=Der Mod ist installiert. Drücke F5 in einem Dialog, um ihn zu übersetzen. Die Sicherungskopien liegen neben den geänderten Dateien.

[CustomMessages]
en.ChooseCaption=Select chapters
en.ChooseDescription=Check the chapters you want to translate. The installer will leave unchecked chapters untouched.
en.Chapter=Chapter %1
en.ProgressCaption=Installing the translation mod
en.ProgressDescription=Keep DELTARUNE closed while the selected chapters are patched.
en.Extracting=Unpacking the patcher…
en.Starting=Starting the patcher…
en.NotFound=No chapter files were found. Select the folder where DELTARUNE is installed.
en.NoSelection=Select at least one chapter.
en.InvalidSelection=Pass the chapter numbers separated by commas: /CHAPTERS=1,3
en.StartFailed=Could not start the patcher: %1
en.PatchFailed=Installation failed (exit code %1).
en.OlderVersion=An older version of DeltaTranslator is installed. Restore the matching original backup or verify the game files in Steam, then install again.
en.Reading=Reading: %1
en.Compiling=Compiling the mod: %1
en.Writing=Writing the modified archive: %1
en.Verifying=Verifying the modified archive: %1
en.Backup=Saving a backup: %1
en.Installing=Installing: %1

ru.ChooseCaption=Выбор глав
ru.ChooseDescription=Отметь главы, которые нужно перевести. Мастер не изменит файлы остальных глав.
ru.Chapter=Глава %1
ru.ProgressCaption=Установка мода перевода
ru.ProgressDescription=Не запускай DELTARUNE, пока мастер изменяет файлы выбранных глав.
ru.Extracting=Распаковка патчера…
ru.Starting=Запуск патчера…
ru.NotFound=Файлы глав не найдены. Выбери папку, в которую установлена DELTARUNE.
ru.NoSelection=Отметь хотя бы одну главу.
ru.InvalidSelection=Укажи номера глав через запятую: /CHAPTERS=1,3
ru.StartFailed=Не удалось запустить патчер: %1
ru.PatchFailed=Не удалось установить мод (код %1).
ru.OlderVersion=Установлена старая версия DeltaTranslator. Восстанови исходный архив нужной версии или проверь файлы игры в Steam, затем запусти установку снова.
ru.Reading=Чтение: %1
ru.Compiling=Компиляция мода: %1
ru.Writing=Запись изменённого архива: %1
ru.Verifying=Проверка изменённого архива: %1
ru.Backup=Создание резервной копии: %1
ru.Installing=Установка: %1

es.ChooseCaption=Selección de capítulos
es.ChooseDescription=Marca los capítulos que quieras traducir. Los capítulos sin marcar no se modificarán.
es.Chapter=Capítulo %1
es.ProgressCaption=Instalación del mod de traducción
es.ProgressDescription=Mantén DELTARUNE cerrado mientras se modifican los capítulos seleccionados.
es.Extracting=Extrayendo el parcheador…
es.Starting=Iniciando el parcheador…
es.NotFound=No se encontraron archivos de capítulos. Elige la carpeta de instalación de DELTARUNE.
es.NoSelection=Selecciona al menos un capítulo.
es.InvalidSelection=Indica los capítulos separados por comas: /CHAPTERS=1,3
es.StartFailed=No se pudo iniciar el parcheador: %1
es.PatchFailed=No se pudo instalar el mod (código %1).
es.OlderVersion=Hay una versión anterior de DeltaTranslator. Restaura la copia original correspondiente o verifica los archivos en Steam y vuelve a instalar el mod.
es.Reading=Leyendo: %1
es.Compiling=Compilando el mod: %1
es.Writing=Guardando el archivo modificado: %1
es.Verifying=Verificando el archivo modificado: %1
es.Backup=Creando copia de seguridad: %1
es.Installing=Instalando: %1

pt.ChooseCaption=Seleção de capítulos
pt.ChooseDescription=Marque os capítulos que deseja traduzir. Os capítulos desmarcados não serão alterados.
pt.Chapter=Capítulo %1
pt.ProgressCaption=Instalação do mod de tradução
pt.ProgressDescription=Mantenha DELTARUNE fechado enquanto os capítulos selecionados são modificados.
pt.Extracting=Extraindo o aplicador do mod…
pt.Starting=Iniciando o aplicador do mod…
pt.NotFound=Nenhum arquivo de capítulo encontrado. Escolha a pasta de instalação de DELTARUNE.
pt.NoSelection=Selecione pelo menos um capítulo.
pt.InvalidSelection=Informe os capítulos separados por vírgulas: /CHAPTERS=1,3
pt.StartFailed=Não foi possível iniciar o aplicador do mod: %1
pt.PatchFailed=Não foi possível instalar o mod (código %1).
pt.OlderVersion=Uma versão anterior do DeltaTranslator está instalada. Restaure a cópia original correspondente ou verifique os arquivos na Steam e instale o mod novamente.
pt.Reading=Lendo: %1
pt.Compiling=Compilando o mod: %1
pt.Writing=Gravando o arquivo modificado: %1
pt.Verifying=Verificando o arquivo modificado: %1
pt.Backup=Criando cópia de segurança: %1
pt.Installing=Instalando: %1

de.ChooseCaption=Kapitelauswahl
de.ChooseDescription=Wähle die Kapitel aus, die du übersetzen möchtest. Nicht ausgewählte Kapitel bleiben unverändert.
de.Chapter=Kapitel %1
de.ProgressCaption=Übersetzungsmod wird eingerichtet
de.ProgressDescription=Lass DELTARUNE geschlossen, während die ausgewählten Kapitel geändert werden.
de.Extracting=Patch-Programm wird entpackt…
de.Starting=Patch-Programm wird gestartet…
de.NotFound=Keine Kapiteldateien gefunden. Wähle den Installationsordner von DELTARUNE.
de.NoSelection=Wähle mindestens ein Kapitel aus.
de.InvalidSelection=Gib die Kapitelnummern durch Kommas getrennt an: /CHAPTERS=1,3
de.StartFailed=Das Patch-Programm konnte nicht gestartet werden: %1
de.PatchFailed=Die Installation ist fehlgeschlagen (Code %1).
de.OlderVersion=Eine ältere DeltaTranslator-Version ist installiert. Stelle die passende Originaldatei wieder her oder überprüfe die Spieldateien in Steam. Installiere den Mod dann erneut.
de.Reading=Lesen: %1
de.Compiling=Mod kompilieren: %1
de.Writing=Geändertes Archiv schreiben: %1
de.Verifying=Geändertes Archiv prüfen: %1
de.Backup=Sicherungskopie erstellen: %1
de.Installing=Installieren: %1

[Code]
var
  PayloadExtracted: Boolean;
  ChapterPage: TWizardPage;
  PatchProgress: TOutputMarqueeProgressWizardPage;
  PatchError: String;
  ChapterList: TNewCheckListBox;
  ChapterNumbers: TArrayOfString;
  ListedDirectory, ListedChapters: String;

procedure InitializeWizard;
begin
  ChapterPage := CreateCustomPage(wpSelectDir, CustomMessage('ChooseCaption'),
    CustomMessage('ChooseDescription'));
  ChapterList := TNewCheckListBox.Create(ChapterPage);
  ChapterList.Parent := ChapterPage.Surface;
  ChapterList.Width := ChapterPage.SurfaceWidth;
  ChapterList.Height := ChapterPage.SurfaceHeight;
  ChapterList.TabOrder := 0;
  PatchProgress := CreateOutputMarqueeProgressPage(CustomMessage('ProgressCaption'),
    CustomMessage('ProgressDescription'));
end;

// Match Patcher/ChapterFiles.cs. Only inspect names here; the CLI validates
// the archives and resolves duplicate paths before performing any writes.
function FindChapters(const Directory: String): TArrayOfString;
var
  Entry: TFindRec;
  Root, Name, NumberText: String;
  Chapters: TStringList;
  Number, I: Integer;
begin
  SetArrayLength(Result, 0);
  Root := AddBackslash(Directory);
  Chapters := TStringList.Create;
  try
    Chapters.Sorted := True;
    Chapters.Duplicates := dupIgnore;
    if FindFirst(Root + '*', Entry) then
    try
      repeat
        Name := Lowercase(Entry.Name);
        NumberText := '';
        if (Entry.Attributes and FILE_ATTRIBUTE_DIRECTORY) <> 0 then
        begin
          if (Copy(Name, 1, 7) = 'chapter') and FileExists(Root + Entry.Name + '\data.win') then
          begin
            NumberText := Copy(Name, 8, Length(Name));
            if Copy(NumberText, Length(NumberText) - 7, 8) = '_windows' then
              NumberText := Copy(NumberText, 1, Length(NumberText) - 8);
          end;
        end
        else if (Copy(Name, 1, 7) = 'data_ch') and (Copy(Name, Length(Name) - 3, 4) = '.win') then
          NumberText := Copy(Name, 8, Length(Name) - 11);
        Number := StrToIntDef(NumberText, 0);
        if (Number > 0) and (IntToStr(Number) = NumberText) then
          Chapters.Add(Format('%.10d', [Number]));
      until not FindNext(Entry);
    finally
      FindClose(Entry);
    end;
    SetArrayLength(Result, Chapters.Count);
    for I := 0 to Chapters.Count - 1 do
      Result[I] := IntToStr(StrToIntDef(Chapters[I], 0));
  finally
    Chapters.Free;
  end;
end;

procedure OnPatcherOutput(const Line: String; const OutputError, FirstLine: Boolean);
var
  Separator: Integer;
  Phase, Key: String;
begin
  Log(Line);
  if OutputError or (Copy(Line, 1, 7) = 'Error: ') then
    PatchError := Line
  else
  begin
    Separator := Pos(': ', Line);
    if Separator = 0 then Exit;
    Phase := Copy(Line, 1, Separator - 1);
    Key := '';
    if Phase = 'Reading' then Key := 'Reading'
    else if Phase = 'Preparing patch' then Key := 'Compiling'
    else if Phase = 'Writing patched archive' then Key := 'Writing'
    else if Phase = 'Verifying patched archive' then Key := 'Verifying'
    else if Phase = 'Backing up' then Key := 'Backup'
    else if Phase = 'Installing' then Key := 'Installing';
    if Key <> '' then
      PatchProgress.SetText(FmtMessage(CustomMessage(Key), [Copy(Line, Separator + 2, Length(Line))]), '');
  end;
end;

function RunPatcher(const Options: String): String;
var
  PatcherDir, Executable, Arguments, LogPath: String;
  RawLog: AnsiString;
  ResultCode: Integer;
  Started: Boolean;
begin
  Result := '';
  PatchError := '';
  try
    PatcherDir := ExpandConstant('{tmp}\patcher');
    if not PayloadExtracted then
    begin
      ExtractTemporaryFiles('{tmp}\patcher\*');
      PayloadExtracted := True;
    end;
    Executable := PatcherDir + '\DeltaTranslator.Patcher.exe';
    // A trailing dot prevents a final backslash from escaping the closing quote.
    Arguments := 'install ' + AddQuotes(AddBackslash(WizardDirValue) + '.') + Options;
    if WizardSilent then
    begin
      LogPath := ExpandConstant('{tmp}\delta-patch.log');
      DeleteFile(LogPath);
      Started := Exec(Executable, Arguments + ' --log ' + AddQuotes(LogPath),
        PatcherDir, SW_HIDE, ewWaitUntilTerminated, ResultCode);
      if LoadStringFromFile(LogPath, RawLog) then
      begin
        PatchError := Utf8Decode(RawLog);
        Log(PatchError);
      end;
    end
    else
    begin
      PatchProgress.SetText(CustomMessage('Starting'), '');
      Started := ExecAndLogOutput(Executable, Arguments,
        PatcherDir, SW_SHOWNORMAL, ewWaitUntilTerminated, ResultCode, @OnPatcherOutput);
    end;
    if not Started then
      Result := FmtMessage(CustomMessage('StartFailed'), [SysErrorMessage(ResultCode)])
    else if ResultCode <> 0 then
    begin
      if Pos('An earlier DeltaTranslator is installed.', PatchError) > 0 then
        Result := CustomMessage('OlderVersion')
      else
        Result := FmtMessage(CustomMessage('PatchFailed'), [IntToStr(ResultCode)]) + #13#10 + PatchError;
    end;
  except
    Result := GetExceptionMessage;
  end;
end;

function SelectedChapters: String;
var
  I: Integer;
begin
  Result := '';
  for I := 0 to GetArrayLength(ChapterNumbers) - 1 do
    if ChapterList.Checked[I] then
    begin
      if Result <> '' then Result := Result + ',';
      Result := Result + ChapterNumbers[I];
    end;
end;

function NextButtonClick(CurPageID: Integer): Boolean;
var
  ErrorText, FoundChapters: String;
  Found: TArrayOfString;
  I: Integer;
begin
  Result := True;
  if WizardSilent then Exit;
  ErrorText := '';
  if CurPageID = wpSelectDir then
  begin
    Found := FindChapters(WizardDirValue);
    if GetArrayLength(Found) = 0 then
      ErrorText := CustomMessage('NotFound')
    else
    begin
      FoundChapters := '';
      for I := 0 to GetArrayLength(Found) - 1 do
        FoundChapters := FoundChapters + Found[I] + ',';
      if (WizardDirValue <> ListedDirectory) or (FoundChapters <> ListedChapters) then
      begin
        ListedDirectory := WizardDirValue;
        ListedChapters := FoundChapters;
        ChapterNumbers := Found;
        ChapterList.Items.Clear;
        for I := 0 to GetArrayLength(ChapterNumbers) - 1 do
          ChapterList.AddCheckBox(FmtMessage(CustomMessage('Chapter'), [ChapterNumbers[I]]), '', 0, False, True, False, False, nil);
      end;
    end;
  end
  else if (CurPageID = ChapterPage.ID) and (SelectedChapters = '') then
    ErrorText := CustomMessage('NoSelection');
  if ErrorText <> '' then
  begin
    MsgBox(ErrorText, mbError, MB_OK);
    Result := False;
  end;
end;

function PrepareToInstall(var NeedsRestart: Boolean): String;
var
  Selection, Options: String;
  I: Integer;
begin
  Options := '';
  if WizardSilent then
    Selection := ExpandConstant('{param:CHAPTERS|}')
  else
  begin
    Selection := SelectedChapters;
    if Selection = '' then
    begin
      Result := CustomMessage('NoSelection');
      Exit;
    end;
  end;
  if Selection <> '' then
  begin
    for I := 1 to Length(Selection) do
      if Pos(Selection[I], '0123456789,') = 0 then
      begin
        Result := CustomMessage('InvalidSelection');
        Exit;
      end;
    Options := ' --chapters ' + AddQuotes(Selection);
  end;
  if WizardSilent then
    Result := RunPatcher(Options)
  else
  begin
    PatchProgress.SetText(CustomMessage('Extracting'), '');
    PatchProgress.Show;
    try
      PatchProgress.Animate;
      Result := RunPatcher(Options);
    finally
      PatchProgress.Hide;
    end;
  end;
end;
