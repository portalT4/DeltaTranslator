![DeltaTranslator](../Cover.png)

[![Telegram](https://img.shields.io/badge/Telegram-X3aBapkaTriangle-229ED9?logo=telegram&logoColor=white)](https://t.me/X3aBapkaTriangle)

[English](../README.md) · [Русский](README.ru.md) · [Español](README.es.md) · [Português (Brasil)](README.pt-BR.md) · [Deutsch](README.de.md) · [Polski](README.pl.md) · [Українська](README.uk.md) · [Türkçe](README.tr.md) · **Italiano** · [Français](README.fr.md)

# DeltaTranslator

DeltaTranslator è una mod non ufficiale per DELTARUNE che mostra traduzioni automatiche sopra il testo originale. Lingue di destinazione: **russo, spagnolo, portoghese brasiliano (`pt`), tedesco, polacco, ucraino, turco, italiano e francese**. L'interfaccia dell'installer per Windows è disponibile in inglese, russo, spagnolo, portoghese brasiliano e tedesco. L'inglese non è una lingua di destinazione nel gioco.

## Cosa traduce

I dialoghi supportati, sia durante l'esplorazione che in battaglia, le opzioni di risposta, il testo dei menu scritto da `obj_writer` o `obj_menuwriter` e i fumetti `obj_talkbubble`, inclusi quelli del capitolo 5. La traduzione segue il relativo fumetto. Non traduce altri testi incorporati nelle immagini, testi disegnati da script non supportati o parole delle canzoni dei minigiochi ritmici. Il testo e i caratteri originali non vengono sostituiti.

I brevi commenti e i fumetti di Tenna sono tradotti accanto all’originale. Gli inserti animati noti come **Lovely** sono tradotti nel dialogo, senza didascalie separate.

## Funzionamento e privacy

La mod invia il testo supportato e la lingua di destinazione a Google Traduttore via HTTPS. La lingua di partenza viene rilevata automaticamente. Serve una connessione a Internet. La traduzione automatica è disattivata all'avvio: in questa modalità le richieste partono solo premendo F5. Il risultato appare in sovrimpressione. Non è una localizzazione ufficiale né un progetto di Google.

- **F1:** apri o chiudi il selettore; usa le frecce e **Invio** oppure premi **1–9** per scegliere direttamente.
- **F2:** attiva o disattiva il posizionamento automatico dove supportato.
- **F3:** attiva o disattiva la traduzione automatica.
- **F5:** traduci il testo supportato corrente. **F6:** nascondi la traduzione.

Il menu del dispositivo indica le scorciatoie e lo stato delle modalità automatiche. In russo viene usato l'adattamento di Determination Mono di **DubstepDude**. Vedi le [fonti dei caratteri e i crediti](../Fonts/Overlay/README.md).

## Scaricare e installare

Scarica l'installer per il tuo sistema dalla sezione **Assets** di [Releases](https://github.com/portalT4/DeltaTranslator/releases). Chiudi prima DELTARUNE.

- **Windows x64:** avvia `DeltaTranslator-Setup-win-x64.exe`.
- **Linux x64 / Steam Deck (Proton):** apri `DeltaTranslator-Setup-linux-x64.AppImage` dal gestore di file (in modalità desktop su Steam Deck). Se necessario, abilita l'esecuzione nelle proprietà del file. Il sistema deve supportare AppImage.
- **macOS:** estrai `DeltaTranslator-Setup-osx-arm64.zip` (Apple Silicon) o `DeltaTranslator-Setup-osx-x64.zip` (Intel) e apri `DeltaTranslator.app` nel Finder. L'installer non è autenticato da Apple. Modificare le risorse del gioco firmato può impedirne l'avvio. L'installer chiede conferma e non firma di nuovo il gioco.

Non ho un Mac né un computer Linux; queste versioni possono avere problemi. Seleziona la cartella del gioco (Steam → Proprietà → File installati → Sfoglia), scegli i capitoli e premi **Install**. Non occorrono il terminale o una copia separata di .NET.

## Compatibilità, aggiornamento e rimozione

L'installer non scarica i file del gioco e non modifica i salvataggi. Crea backup `.deltatranslator.bak` o `.deltatranslator.<SHA-256>.bak`. Per rimuovere o aggiornare la mod, ripristina gli archivi originali della stessa versione o verifica l'integrità dei file su Steam. Su Mac, sposta i backup aggiunti fuori da `.app` durante il ripristino. Non sono supportati le vecchie demo autonome con un solo archivio, i porting per dispositivi mobili e le console.

[Screenshots](../Screenshots/) · [Development](DEVELOPMENT.md)
