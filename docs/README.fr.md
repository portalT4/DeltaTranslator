![DeltaTranslator](../Cover.png)

[![Telegram](https://img.shields.io/badge/Telegram-X3aBapkaTriangle-229ED9?logo=telegram&logoColor=white)](https://t.me/X3aBapkaTriangle)

[English](../README.md) · [Русский](README.ru.md) · [Español](README.es.md) · [Português (Brasil)](README.pt-BR.md) · [Deutsch](README.de.md) · [Polski](README.pl.md) · [Українська](README.uk.md) · [Türkçe](README.tr.md) · [Italiano](README.it.md) · **Français**

# DeltaTranslator

DeltaTranslator est un mod non officiel pour DELTARUNE qui affiche une traduction automatique par-dessus le texte d’origine. Langues cibles : **russe, espagnol, portugais du Brésil (`pt`), allemand, polonais, ukrainien, turc, italien et français**. Le programme d’installation Windows est disponible en anglais, russe, espagnol, portugais du Brésil et allemand. L’anglais n’est pas une langue cible dans le jeu.

## Ce qui est traduit

Les dialogues pris en charge dans le monde et en combat, les choix de réponse, le texte des menus affiché par `obj_writer` ou `obj_menuwriter` et les bulles `obj_talkbubble`, notamment au chapitre 5. La traduction suit sa bulle. Le mod ne traduit pas les autres textes intégrés aux images, celui dessiné par des scripts non pris en charge, ni les paroles des mini-jeux de rythme. Le texte et les polices d’origine restent inchangés.

Les petites répliques et les bulles de Tenna sont traduites à côté de l’original. Les incrustations animées connues, comme **Lovely**, sont traduites dans le dialogue, sans sous-titre séparé.

## Fonctionnement et confidentialité

Le mod envoie le texte pris en charge et la langue cible à Google Traduction via HTTPS. La langue source est détectée automatiquement. Une connexion Internet est nécessaire. Par défaut, le mode automatique est désactivé et seule la touche F5 déclenche une requête. La traduction s’affiche en surimpression. Ce n’est ni une localisation officielle ni un projet de Google.

- **F1 :** ouvrir ou fermer le sélecteur ; utiliser les flèches et **Entrée**, ou appuyer sur **1–9** pour choisir directement.
- **F2 :** activer ou désactiver le placement automatique lorsqu’il est pris en charge.
- **F3 :** activer ou désactiver la traduction automatique.
- **F5 :** traduire le texte pris en charge à l’écran. **F6 :** masquer la traduction.

Le menu de l’appareil affiche les raccourcis et l’état des modes automatiques. La surimpression en russe utilise l’adaptation de Determination Mono par **DubstepDude**. Voir les [sources et crédits des polices](../Fonts/Overlay/README.md).

## Téléchargement et installation

Téléchargez le programme adapté à votre système dans la section **Assets** de [Releases](https://github.com/portalT4/DeltaTranslator/releases). Fermez d’abord DELTARUNE.

- **Windows x64 :** lancez `DeltaTranslator-Setup-win-x64.exe`.
- **Linux x64 / Steam Deck (Proton) :** ouvrez `DeltaTranslator-Setup-linux-x64.AppImage` depuis le gestionnaire de fichiers (en mode Bureau sur Steam Deck). Autorisez son exécution dans les propriétés si nécessaire. Le système doit prendre en charge AppImage.
- **macOS :** décompressez `DeltaTranslator-Setup-osx-arm64.zip` (Apple Silicon) ou `DeltaTranslator-Setup-osx-x64.zip` (Intel) et ouvrez `DeltaTranslator.app` dans le Finder. Le programme n’est pas notarié par Apple. Modifier les ressources du jeu signé peut empêcher son lancement. Le programme demande confirmation et ne signe pas à nouveau le jeu.

Je n’ai ni Mac ni ordinateur sous Linux ; ces versions peuvent poser problème. Sélectionnez le dossier du jeu (Steam → Propriétés → Fichiers installés → Parcourir), cochez les chapitres voulus et cliquez sur **Install**. Aucun terminal ni installation séparée de .NET ne sont nécessaires.

## Compatibilité, mise à jour et suppression

Le programme ne télécharge aucun fichier du jeu et ne modifie pas les sauvegardes. Il crée des copies `.deltatranslator.bak` ou `.deltatranslator.<SHA-256>.bak`. Pour mettre à jour ou supprimer le mod, restaurez les archives d’origine de la même version ou vérifiez les fichiers dans Steam. Sur Mac, déplacez les copies ajoutées hors du paquet `.app` lors de la restauration. Les anciennes démos autonomes à archive unique, les portages mobiles et les consoles ne sont pas pris en charge.

[Screenshots](../Screenshots/) · [Development](DEVELOPMENT.md)
