![Titelbild von DeltaTranslator](../Cover.png)

[![Telegram](https://img.shields.io/badge/Telegram-X3aBapkaTriangle-229ED9?logo=telegram&logoColor=white)](https://t.me/X3aBapkaTriangle)

[English](../README.md) · [Русский](README.ru.md) · [Español](README.es.md) · [Português (Brasil)](README.pt-BR.md) · **Deutsch** · [Polski](README.pl.md) · [Українська](README.uk.md) · [Türkçe](README.tr.md) · [Italiano](README.it.md) · [Français](README.fr.md)

# DeltaTranslator

DeltaTranslator ist eine inoffizielle Mod für DELTARUNE, die maschinelle Übersetzungen über dem Originaltext anzeigt. Zielsprachen: **Russisch, Spanisch, brasilianisches Portugiesisch (`pt`), Deutsch, Polnisch, Ukrainisch, Türkisch, Italienisch und Französisch**. Die Oberfläche des Windows-Installers ist auf **Englisch, Russisch, Spanisch, brasilianischem Portugiesisch und Deutsch** verfügbar. Englisch ist keine Zielsprache im Spiel.

## Was wird übersetzt?

- Unterstützte Dialoge in der Spielwelt und im Kampf sowie Menütexte, die `obj_writer` oder `obj_menuwriter` nutzen. Nicht alle Menüs und Kampfbeschriftungen werden übersetzt.
- Antwortmöglichkeiten in unterstützten Auswahlfenstern.
- Sprechblasen vom Typ `obj_talkbubble`, beispielsweise in Kapitel 5. Die Übersetzung erscheint über der zugehörigen Sprechblase und folgt ihr unabhängig vom übrigen Dialog. Kapiteln ohne diesen Objekttyp steht die Funktion nicht zur Verfügung.
- Kurze Zwischenbemerkungen und Tennas Sprechblasen werden neben dem Original übersetzt. Bekannte animierte Texteinblendungen wie **Lovely** werden nur im Dialog übersetzt, ohne separate Einblendung.

Andere Texte in Bildern, direkt von anderen Spielskripten gezeichnete Texte und nicht unterstützte Elemente wie Liedtexte in Rhythmusabschnitten werden nicht übersetzt. Die Originaltexte und Spielschriften bleiben unverändert.

## So funktioniert es

Auf Anfrage liest die Mod den unterstützten aktiven Text und entfernt gegebenenfalls Formatierungscodes. Sie übermittelt den Text und die Zielsprache per HTTPS an **Google Übersetzer**; die Ausgangssprache wird automatisch erkannt. Das maschinell übersetzte Ergebnis wird asynchron abgerufen und separat eingeblendet. Die Automatik erkennt Änderungen und sendet unveränderten Text im selben aktiven Platz nicht erneut. **Eine Internetverbindung ist erforderlich.** Ohne Automatik werden nur beim Drücken von F5 Anfragen gesendet. Die Mod steht in keiner Verbindung zu Google, DELTARUNE oder einem Fan-Übersetzungsteam.

| Taste | Funktion |
| --- | --- |
| **F1** | Sprachauswahl öffnen oder schließen; mit Pfeiltasten und **Enter** oder direkt mit **1–9** auswählen |
| **F2** | Automatische Positionierung ein- oder ausschalten, sofern unterstützt |
| **F3** | Automatische Übersetzung ein- oder ausschalten (beim Start aus) |
| **F5** | Den aktuell unterstützten Text übersetzen |
| **F6** | Übersetzung ausblenden |

Im Gerätemenü stehen die Tastenkürzel und der Status der Automatik. Die russische Einblendung verwendet **DubstepDudes** Determination-Mono-Adaption; die übrigen Sprachen nutzen Determination mit ergänzten Zeichen. Siehe [Schriftquellen und Mitwirkende](../Fonts/Overlay/README.md).

## Herunterladen und installieren

Unter [Releases](https://github.com/portalT4/DeltaTranslator/releases) den passenden Installer aus **Assets** herunterladen. Vor der Installation DELTARUNE schließen.

**Linux / Steam Deck und macOS:** Ich habe weder einen Mac noch einen Linux-Rechner. Bei diesen Builds kann es zu Problemen kommen.

| Plattform | Installer |
| --- | --- |
| Windows x64 | `DeltaTranslator-Setup-win-x64.exe` |
| Linux x64 / Steam Deck (Spiel über Proton) | `DeltaTranslator-Setup-linux-x64.AppImage` |
| macOS, Apple Silicon | `DeltaTranslator-Setup-osx-arm64.zip` → `DeltaTranslator.app` |
| macOS, Intel | `DeltaTranslator-Setup-osx-x64.zip` → `DeltaTranslator.app` |

- **Windows:** die `.exe` öffnen. Standardmäßig werden keine Administratorrechte angefordert; `/ALLUSERS` ist nur bei einem geschützten Ordner nötig. Bei stiller Installation schränkt `/CHAPTERS=1,2` die Auswahl ein; ohne diesen Parameter werden alle erkannten Kapitel ausgewählt.
- **Linux / Steam Deck:** das `.AppImage` im Dateimanager öffnen (auf dem Steam Deck im Desktop-Modus). Falls nötig, das Ausführen in den Datei-**Eigenschaften** erlauben. Das System muss AppImages ausführen können.
- **macOS:** die ZIP-Datei entpacken und `DeltaTranslator.app` im Finder öffnen. Der Installer ist nicht notarisiert und kann von Gatekeeper blockiert werden. Änderungen an Ressourcen des **signierten Spiels** machen seine Signatur ungültig und können den Start verhindern. Der Installer verlangt eine ausdrückliche Bestätigung, signiert das Spiel nicht neu und ändert Gatekeeper nicht. Der Start des modifizierten nativen Mac-Spiels wurde nicht überprüft.

Im Installer den Spielordner auswählen (**Steam → Eigenschaften → Installierte Dateien → Durchsuchen**), nicht den Spielstandordner oder die oberste `data.win`. Die gewünschten Kapitel markieren und auf **Install** klicken. Standardmäßig ist kein Kapitel ausgewählt. Weder ein Terminal noch eine separate .NET-Installation ist nötig.

## Kompatibilität, Updates und Deinstallation

Der Patcher ergänzt die ausgewählten Kapitelarchive, ohne Spieldateien herunterzuladen oder Spielstände zu bearbeiten. Vor dem Ersetzen prüft er das Ergebnis und bewahrt eine Sicherung als `.deltatranslator.bak` oder `.deltatranslator.<SHA-256>.bak` auf. GitHub Actions baut die Installer ohne Spielarchive. Tests der Archive von Kapitel 1 und 2 benötigen eine lokale Kopie des Spiels; nicht alle Spielversionen und Plattformen sind überprüft. Ältere Demos mit einem gemeinsamen Archiv sowie Mobil- und Konsolenversionen werden nicht unterstützt.

Zum Entfernen oder Aktualisieren das Spiel schließen und die Originalarchive derselben Spielversion zurückkopieren oder die Dateien in Steam überprüfen lassen. Beim Wiederherstellen einer signierten Mac-App die hinzugefügten `.bak` aus dem Paket verschieben. Für ein Update die neue Version von DeltaTranslator danach auf die Originalarchive anwenden.

[Screenshots](../Screenshots/) · [Build und Entwicklung](DEVELOPMENT.md) · [Schriftquelle und Lizenz](../Fonts/Overlay/README.md)
