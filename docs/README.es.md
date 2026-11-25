![Portada de DeltaTranslator](../Cover.png)

[![Telegram](https://img.shields.io/badge/Telegram-X3aBapkaTriangle-229ED9?logo=telegram&logoColor=white)](https://t.me/X3aBapkaTriangle)

[English](../README.md) · [Русский](README.ru.md) · **Español** · [Português (Brasil)](README.pt-BR.md) · [Deutsch](README.de.md) · [Polski](README.pl.md) · [Українська](README.uk.md) · [Türkçe](README.tr.md) · [Italiano](README.it.md) · [Français](README.fr.md)

# DeltaTranslator

DeltaTranslator es un mod no oficial de DELTARUNE que muestra traducciones automáticas sobre el texto original. Idiomas de destino: **ruso, español, portugués de Brasil (`pt`), alemán, polaco, ucraniano, turco, italiano y francés**. La interfaz del instalador de Windows está disponible en **inglés, ruso, español, portugués de Brasil y alemán**. El inglés no es un idioma de destino dentro del juego.

## Qué traduce

- Diálogos compatibles en el mundo y en combate, y texto de menús que usan `obj_writer` u `obj_menuwriter`. No traduce todos los menús ni todas las etiquetas de combate.
- Opciones de respuesta en paneles de selección compatibles.
- Bocadillos de diálogo `obj_talkbubble`, incluidos los del capítulo 5. La traducción se muestra encima de su propio bocadillo y sigue su posición, de forma independiente del diálogo habitual. Los capítulos sin ese objeto omiten esta función.
- Los apartes y los bocadillos de Tenna se traducen junto al original. Las inserciones animadas conocidas, como **Lovely**, se traducen dentro del diálogo, sin un rótulo aparte.

El mod no traduce otro texto incrustado en imágenes, texto dibujado directamente por otros scripts ni elementos no compatibles como las letras de las secciones rítmicas. No sustituye los textos ni las fuentes originales del juego.

## Cómo funciona

Al solicitar una traducción, el mod lee el texto compatible activo y elimina los códigos de formato cuando corresponde. Envía el texto y el idioma de destino al **Traductor de Google** por HTTPS; el idioma original se detecta automáticamente. El resultado se recibe de forma asíncrona y se muestra en una capa independiente. El modo automático detecta cambios y no vuelve a enviar el mismo texto de una misma posición activa. **Se requiere conexión a Internet.** Con el modo automático desactivado, solo se hacen solicitudes al pulsar F5. El mod no está afiliado a Google, DELTARUNE ni a ningún equipo de traducción de fans.

| Tecla | Acción |
| --- | --- |
| **F1** | Abrir o cerrar el selector; usa las flechas y **Enter** o pulsa **1–9** para elegir directamente |
| **F2** | Activar o desactivar la posición automática donde sea compatible |
| **F3** | Activar o desactivar la traducción automática (desactivada al iniciar) |
| **F5** | Traducir el texto compatible actual |
| **F6** | Ocultar la traducción |

El menú del dispositivo muestra los atajos y el estado de los modos automáticos. La capa en ruso usa la adaptación de Determination Mono de **DubstepDude**; las demás usan Determination con glifos adicionales. Consulta las [fuentes y sus créditos](../Fonts/Overlay/README.md).

## Descarga e instalación

Abre [Releases](https://github.com/portalT4/DeltaTranslator/releases) y descarga el instalador de tu sistema en **Assets**. Cierra DELTARUNE antes de instalar.

**Linux / Steam Deck y macOS:** no tengo un Mac ni un equipo con Linux. Estas compilaciones pueden dar problemas.

| Plataforma | Instalador |
| --- | --- |
| Windows x64 | `DeltaTranslator-Setup-win-x64.exe` |
| Linux x64 / Steam Deck (juego mediante Proton) | `DeltaTranslator-Setup-linux-x64.AppImage` |
| macOS, Apple Silicon | `DeltaTranslator-Setup-osx-arm64.zip` → `DeltaTranslator.app` |
| macOS, Intel | `DeltaTranslator-Setup-osx-x64.zip` → `DeltaTranslator.app` |

- **Windows:** abre el `.exe`. No pide permisos de administrador por defecto; usa `/ALLUSERS` solo para una carpeta protegida. En modo silencioso, `/CHAPTERS=1,2` limita la selección; si se omite, se seleccionan todos los capítulos detectados.
- **Linux / Steam Deck:** abre el `.AppImage` desde el gestor de archivos (modo escritorio en Steam Deck). Si hace falta, permite su ejecución en **Propiedades**. El sistema debe poder ejecutar AppImage.
- **macOS:** extrae el ZIP y abre `DeltaTranslator.app` en Finder. El instalador no está notarizado, así que Gatekeeper puede bloquearlo. Cambiar los recursos del **juego firmado** invalida su firma y puede impedir su inicio. El instalador pide autorización explícita; no vuelve a firmar el juego ni modifica Gatekeeper. No se ha verificado el inicio del juego nativo de Mac modificado.

En el instalador, selecciona la carpeta del juego (**Steam → Propiedades → Archivos instalados → Explorar**), no la carpeta de partidas guardadas ni el `data.win` raíz. Marca los capítulos deseados y pulsa **Install**. No hay capítulos marcados de antemano. No necesitas usar la terminal ni instalar .NET por separado.

## Compatibilidad, actualización y desinstalación

El parcheador añade el mod a los archivos de los capítulos elegidos, sin descargar archivos de juego ni tocar las partidas guardadas. Verifica el resultado antes de sustituir cada archivo y conserva una copia `.deltatranslator.bak` o `.deltatranslator.<SHA-256>.bak`. GitHub Actions compila los instaladores sin archivos del juego. Las pruebas con los capítulos 1 y 2 requieren una copia local; no se han verificado todas las versiones y plataformas. Se excluyen las demos antiguas con un único archivo común y las versiones móviles o de consola.

Para actualizar o desinstalar, cierra el juego y restaura los archivos originales de la misma versión o verifica los archivos en Steam. En Mac, saca del `.app` firmado los `.bak` añadidos al restaurarlo. Para actualizar DeltaTranslator, instálalo de nuevo sobre los archivos originales.

[Capturas](../Screenshots/) · [Compilación y desarrollo](DEVELOPMENT.md) · [Fuente y licencia tipográfica](../Fonts/Overlay/README.md)
