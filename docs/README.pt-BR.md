![Capa do DeltaTranslator](../Cover.png)

[![Telegram](https://img.shields.io/badge/Telegram-X3aBapkaTriangle-229ED9?logo=telegram&logoColor=white)](https://t.me/X3aBapkaTriangle)

[English](../README.md) · [Русский](README.ru.md) · [Español](README.es.md) · **Português (Brasil)** · [Deutsch](README.de.md) · [Polski](README.pl.md) · [Українська](README.uk.md) · [Türkçe](README.tr.md) · [Italiano](README.it.md) · [Français](README.fr.md)

# DeltaTranslator

DeltaTranslator é um mod não oficial para DELTARUNE que mostra traduções automáticas sobre o texto original. Idiomas de destino: **russo, espanhol, português do Brasil (`pt`), alemão, polonês, ucraniano, turco, italiano e francês**. A interface do instalador do Windows está disponível em **inglês, russo, espanhol, português do Brasil e alemão**. O inglês não é um idioma de destino no jogo.

## O que o mod traduz

- Diálogos compatíveis no mundo do jogo e em batalhas, além de textos de menus exibidos por `obj_writer` ou `obj_menuwriter`. Nem todos os menus e rótulos de batalha usam esses objetos.
- Opções de resposta em painéis de escolha compatíveis.
- Balões de fala `obj_talkbubble`, inclusive os do Capítulo 5. A tradução é exibida acima do próprio balão e acompanha sua posição, independentemente dos diálogos comuns. Em capítulos sem esse objeto, o recurso fica desativado.
- Falas curtas e balões do Tenna são traduzidos junto do original. Inserções animadas conhecidas, como **Lovely**, são traduzidas no próprio diálogo, sem legenda separada.

O mod não traduz outros textos dentro de imagens, texto desenhado diretamente por outros scripts nem elementos não compatíveis, como letras em cenas de ritmo. O texto e as fontes originais do jogo não são substituídos.

## Como funciona

Ao solicitar uma tradução, o mod lê o texto compatível ativo e remove códigos de formatação quando necessário. O texto e o idioma de destino são enviados ao **Google Tradutor** por HTTPS; o idioma original é detectado automaticamente. A tradução automática chega de forma assíncrona e aparece em uma camada separada. O modo automático acompanha as mudanças e evita reenviar o mesmo texto na mesma posição ativa. **É necessário ter acesso à internet.** Com o modo automático desligado, só há solicitações ao pressionar F5. O mod não tem vínculo com o Google, DELTARUNE ou equipes de tradução de fãs.

| Tecla | Ação |
| --- | --- |
| **F1** | Abrir ou fechar o seletor; use as setas e **Enter** ou pressione **1–9** para escolher diretamente |
| **F2** | Ativar ou desativar o posicionamento automático quando compatível |
| **F3** | Ativar ou desativar a tradução automática (desativada ao iniciar) |
| **F5** | Traduzir o texto compatível atual |
| **F6** | Ocultar a tradução |

O menu do dispositivo exibe os atalhos e o estado dos modos automáticos. Em russo, a camada usa a adaptação de Determination Mono de **DubstepDude**. Nos outros idiomas, usa Determination com glifos adicionais. Veja as [fontes e os créditos](../Fonts/Overlay/README.md).

## Download e instalação

Abra [Releases](https://github.com/portalT4/DeltaTranslator/releases) e baixe o instalador do seu sistema em **Assets**. Feche o DELTARUNE antes da instalação.

**Linux / Steam Deck e macOS:** não tenho um Mac nem um computador com Linux. Essas versões podem apresentar problemas.

| Plataforma | Instalador |
| --- | --- |
| Windows x64 | `DeltaTranslator-Setup-win-x64.exe` |
| Linux x64 / Steam Deck (jogo via Proton) | `DeltaTranslator-Setup-linux-x64.AppImage` |
| macOS, Apple Silicon | `DeltaTranslator-Setup-osx-arm64.zip` → `DeltaTranslator.app` |
| macOS, Intel | `DeltaTranslator-Setup-osx-x64.zip` → `DeltaTranslator.app` |

- **Windows:** abra o `.exe`. O instalador não solicita permissões de administrador por padrão; use `/ALLUSERS` só para uma pasta protegida. Na instalação silenciosa, `/CHAPTERS=1,2` limita a seleção; sem essa opção, todos os capítulos encontrados são selecionados.
- **Linux / Steam Deck:** abra o `.AppImage` no gerenciador de arquivos (Modo Área de Trabalho no Steam Deck). Se necessário, permita a execução nas **Propriedades** do arquivo. O sistema precisa oferecer suporte a AppImage.
- **macOS:** extraia o ZIP e abra `DeltaTranslator.app` no Finder. O instalador não passou pela notarização da Apple, então o Gatekeeper pode bloqueá-lo. Alterar os recursos do **jogo assinado** invalida a assinatura e pode impedir a abertura. O instalador pede autorização explícita, não assina o jogo de novo nem altera o Gatekeeper. A abertura do jogo nativo modificado no Mac não foi verificada.

Selecione a pasta do jogo (**Steam → Propriedades → Arquivos instalados → Explorar**), não a pasta de saves nem o `data.win` da raiz. Marque os capítulos desejados e clique em **Install**. Nenhum capítulo vem marcado. Não é preciso usar o terminal nem instalar o .NET à parte.

## Compatibilidade, atualização e remoção

O utilitário adiciona o mod aos arquivos dos capítulos escolhidos sem baixar arquivos do jogo nem alterar saves. Verifica o resultado antes de substituir cada arquivo e guarda uma cópia `.deltatranslator.bak` ou `.deltatranslator.<SHA-256>.bak`. O GitHub Actions compila os instaladores sem arquivos do jogo. Os testes dos Capítulos 1 e 2 exigem uma cópia local; nem todas as versões e plataformas foram verificadas. Demos antigas com um único arquivo compartilhado e versões de console ou mobile não são compatíveis.

Para remover ou atualizar, feche o jogo e restaure os arquivos originais da mesma versão ou verifique os arquivos no Steam. No Mac, tire do `.app` assinado os `.bak` que foram adicionados ao restaurá-lo. Para atualizar o DeltaTranslator, instale a nova versão sobre os arquivos originais.

[Capturas de tela](../Screenshots/) · [Compilação e desenvolvimento](DEVELOPMENT.md) · [Origem e licença da fonte](../Fonts/Overlay/README.md)
