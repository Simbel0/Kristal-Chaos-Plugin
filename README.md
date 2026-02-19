# Chaos Plugin for Kristal
A plugin for Deltarune fangames made on the Kristal engine that produces random effects at random intervals while playing, making everything chaotic. Based on [Super Mario 64 Chaos Edition](https://romhacking.com/hack/super-mario-64---chaos-edition).

# How to install
> [!CAUTION]
> Due to the nature of the Chaos Plugin, ***crashes are to be expected***. Some are normal mistakes that can be fixed, some are the result of the engine getting too unstable and so are way more difficult to track down and fix if that's even possible.

## Kristal-dependant projects
**Kristal-dependant projects are fangames that require you to install Kristal to play them. Smile, Bikini Spamton and Dark Place Legacy are example of such fangames.**

* Download the [Plugin Loader](https://github.com/Hyperboid/kristal-pluginloader) and add it in your `mods` folder like you would for any other project.
* Then download the latest release of this plugin and also add it in your `mods` folder.
* Reload the fangames list and you should see the "Variant Loader" project in your list, click on it and activate "Chaos Plugin".
* Now enter a fangame and *have fun*.

## Standalone releases
**Standalone releases are fangames that are made with Kristal but don't require you to install the base engine to work. Frozen Heart, Starrune, Dark Place Rebirth, Deoxynn Act 1 and Plugged Dream are examples of such fangames.**

There's no way to make the Plugin Loader work for a standalone release for now :(

<!-- * Download the [Plugin Loader](https://github.com/Hyperboid/kristal-pluginloader) and the latest release of this plugin.
* Figure out the **id of the fangame you want to install**. They are generally pretty obvious. Frozen Heart's id is `frozen_heart`, Dark Place Rebirth's id is `dpr`. They all follow the same pattern. However, some might still use `kristal` as their id.
* Go to the following path depending on which version of the game you're running:
  * If you're running the EXE version, go to `%AppData%\<fangame_id>\mods`
  * If you're running the LOVE version, go to `%AppData%\LOVE\<fangame_id>\mods`
* Put the plugin loader and the chaos plugin in that folder.
* This probably won't work. -->

# Contributing
If you want to add a Chaos effect to the plugin, there's two ways to do it:

## Form submission
If you can't/don't want to code an effect yourself, you can simply submit your idea [here](https://forms.gle/RoCSJKUX3CfdfxCV8).
You could also create an issue for it but please prioritize the form.

## Pull Request
If you can and want to code the effect yourself, look into [CONTRIBUTING.md](CONTRIBUTING.md)

# Credits
* [The Kristal Team](https://github.com/KristalTeam) for the [Kristal Engine](https://github.com/KristalTeam/Kristal)
* [Hyperboid](https://github.com/Hyperboid) for the [Plugin Loader](https://github.com/Hyperboid/kristal-pluginloader)
* [Kaze Emanuar](https://www.youtube.com/@KazeN64) for [Super Mario 64 Chaos Edition](https://romhacking.com/hack/super-mario-64---chaos-edition)
