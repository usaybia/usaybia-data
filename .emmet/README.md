# Custom Emmet Snippets in Visual Studio Code
These custom snippets for our project make it really easy to add pieces of code we use frequently, like various types of factoids. 

## Installing
1. You must have this repository cloned (downloaded) to your computer. If you don't, [download GitHub Desktop](https://desktop.github.com/) and then add this repo by cloning it from `https://github.com/usaybia/usaybia-data.git`.
2. [Download and install Visual Studio Code](https://code.visualstudio.com/Download) if you haven't already.

## Using
1. In VS Code, click `File > Open workspace...` and then select the file `usaybia-data.code-workspace` in the root folder of the repo. You must have this workspace open whenever you use the snippets. The workspace file links to the custom snippets, which are stored in the `.emmet/snippets.json` file in the repo.
2. Open an XML file from the repo and type an abbreviation for a snippet, then press the TAB key on your keyboard. It will insert the snippet.
3. Use the TAB key to step through the parts of the snippet that need editing.

## Reference
Below are some of our most common custom snippets. For all our custom snippets, look at the `.emmet/snippets.json` file. Also see the [VS Code Emmet documentation](https://code.visualstudio.com/docs/editor/emmet) and the [Emmet Cheat Sheet](https://docs.emmet.io/cheat-sheet/).

| Item | Abbreviation |
| :------------- | :----------: |
| *this list of common snippets* | *help* |
| date | dt |
| factoid with birth place | factbp |
| factoid with citizenship | citizenship |
| factoid with death place | factdp |
| factoid with education | facted |
| factoid with event | facte |
| factoid with event and active-passive relation | factera |
| factoid with event and mutual relation | facterm |
| factoid with occupation | factoc |
| factoid with relation (active-passive) | factra |
| factoid with relation (mutual) | factrm |
| factoid with residence | factre |
| factoid with state | factst |
| factoid with socio-economic status | factss |
| factoid with trait | facttt |
| person name (persName) | prnm |
| place name (placeName) | plnm |