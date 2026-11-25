![DeltaTranslator](../Cover.png)

[![Telegram](https://img.shields.io/badge/Telegram-X3aBapkaTriangle-229ED9?logo=telegram&logoColor=white)](https://t.me/X3aBapkaTriangle)

[English](../README.md) · [Русский](README.ru.md) · [Español](README.es.md) · [Português (Brasil)](README.pt-BR.md) · [Deutsch](README.de.md) · **Polski** · [Українська](README.uk.md) · [Türkçe](README.tr.md) · [Italiano](README.it.md) · [Français](README.fr.md)

# DeltaTranslator

DeltaTranslator to nieoficjalny mod do DELTARUNE, który wyświetla tłumaczenie maszynowe nad oryginalnym tekstem. Języki docelowe: **rosyjski, hiszpański, portugalski brazylijski (`pt`), niemiecki, polski, ukraiński, turecki, włoski i francuski**. Instalator Windows ma interfejs po angielsku, rosyjsku, hiszpańsku, portugalsku brazylijsku i niemiecku; angielski nie jest językiem docelowym.

## Co jest tłumaczone

Obsługiwane dialogi poza walką i w walce, wybory odpowiedzi, tekst menu wyświetlany przez `obj_writer` lub `obj_menuwriter` oraz dymki `obj_talkbubble`, także w rozdziale 5. Tłumaczenie dymka podąża za nim. Mod nie tłumaczy innego tekstu na obrazach, napisów rysowanych przez nieobsługiwane skrypty ani tekstów piosenek w minigrach rytmicznych. Oryginalny tekst i czcionki pozostają bez zmian.

Krótkie dopowiedzenia i dymki Tenny są tłumaczone obok oryginału. Znane animowane wstawki, np. **Lovely**, są tłumaczone w ramach dialogu, bez osobnego podpisu.

## Działanie i prywatność

Mod wysyła obsługiwany tekst oraz język docelowy do Tłumacza Google przez HTTPS; język źródłowy jest rozpoznawany automatycznie. Internet jest wymagany. Domyślnie tłumaczenie automatyczne jest wyłączone, a żądania są wysyłane dopiero po naciśnięciu F5. Wynik pojawia się jako osobna nakładka. To nie jest oficjalna lokalizacja ani projekt Google.

- **F1:** otwórz lub zamknij wybór języka; użyj strzałek i klawisza **Enter** albo wybierz bezpośrednio klawiszem **1–9**.
- **F2:** włącz lub wyłącz automatyczne pozycjonowanie, gdy jest obsługiwane.
- **F3:** włącz lub wyłącz automatyczne tłumaczenie.
- **F5:** przetłumacz bieżący obsługiwany tekst. **F6:** ukryj tłumaczenie.

Menu urządzenia pokazuje skróty i stan trybów automatycznych. Rosyjska nakładka używa adaptacji Determination Mono autorstwa **DubstepDude**. Zobacz [źródła czcionek i autorów](../Fonts/Overlay/README.md).

## Pobieranie i instalacja

Pobierz instalator dla swojego systemu z sekcji **Assets** na stronie [Releases](https://github.com/portalT4/DeltaTranslator/releases). Zamknij DELTARUNE.

- **Windows x64:** uruchom `DeltaTranslator-Setup-win-x64.exe`.
- **Linux x64 / Steam Deck (Proton):** otwórz `DeltaTranslator-Setup-linux-x64.AppImage` z menedżera plików (na Decku w trybie pulpitu). W razie potrzeby zezwól na wykonanie we właściwościach pliku. System musi obsługiwać AppImage.
- **macOS:** rozpakuj `DeltaTranslator-Setup-osx-arm64.zip` (Apple Silicon) lub `DeltaTranslator-Setup-osx-x64.zip` (Intel) i otwórz `DeltaTranslator.app` w Finderze. Instalator nie przeszedł notaryzacji Apple. Zmiana zasobów podpisanej gry może uniemożliwić jej uruchomienie. Instalator wymaga zgody i nie podpisuje gry na nowo.

Nie mam Maca ani komputera z Linuksem; w tych wydaniach mogą występować problemy. Wskaż folder gry (Steam → Właściwości → Zainstalowane pliki → Przeglądaj), zaznacz wybrane rozdziały i kliknij **Install**. Terminal ani osobny .NET nie są wymagane.

## Zgodność, aktualizacja i usuwanie

Instalator nie pobiera plików gry ani nie zmienia zapisów. Tworzy kopie `.deltatranslator.bak` lub `.deltatranslator.<SHA-256>.bak`. Aby usunąć mod albo go zaktualizować, przywróć oryginalne archiwa tej samej wersji lub sprawdź integralność plików w Steam. Na Macu usuń dodane pliki kopii z pakietu `.app` podczas przywracania. Starsze samodzielne dema ze wspólnym archiwum, urządzenia mobilne i konsole nie są obsługiwane.

[Screenshots](../Screenshots/) · [Development](DEVELOPMENT.md)
