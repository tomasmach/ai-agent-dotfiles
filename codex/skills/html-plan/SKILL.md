---
name: html-plan
description: Create self-contained interactive HTML plans when the user explicitly requests one, or selectively for genuinely large features spanning multiple subsystems and requiring architectural decisions, migrations, or staged implementation. Do not use for routine planning, localized changes, fixes, or ordinary refactors.
metadata:
  short-description: Deliver plans as interactive HTML mini-apps
---

# HTML Plan

Tento skill použij, když si ho uživatel **explicitně vyžádá** — například příkazem `/html-plan` nebo přímou žádostí o HTML plán. Můžeš ho výjimečně aktivovat také sám u **skutečně rozsáhlé feature**, která zasahuje více subsystémů a vyžaduje architektonická rozhodnutí, migraci nebo implementaci v několika samostatných fázích. Neaktivuj ho pro běžné plánování, lokalizované změny, opravy, standardní refaktory ani úkol jen proto, že má více kroků. Když je skill aktivován, výstupem je **samostatný HTML soubor**, ne dlouhý markdown v terminálu.

**Klíčové pravidlo: plán je malá jednorázová webová aplikace, ne vyrenderovaný markdown.** Test: kdyby šel dokument převést 1:1 na `.md` beze ztráty, nevyužil jsi médium a je to špatně. Před psaním si dokument *navrhni*: co čtenáři nejvíc pomůže plán pochopit, posoudit a rozhodnout — a jakou interakci k tomu HTML umožňuje.

## Kam soubor uložit

1. **V projektu (git repo):** `docs/plans/YYYY-MM-DD-<slug>.html` (adresář vytvoř, pokud neexistuje).
2. **Mimo projekt / jednorázová diskuse:** `~/.codex/tmp/plans/YYYY-MM-DD-<slug>.html`.

Jeden plán = jeden soubor. Když se plán během diskuse vyvíjí, **edituj tentýž soubor** a řekni uživateli, ať stránku obnoví — nezakládej verze v2, v3. (Stav v localStorage díky tomu přežije aktualizaci plánu.)

## Po zapsání

Otevři soubor v prohlížeči: `open <cesta>`. Při další aktualizaci už znovu neotvírej (stačí refresh), pokud uživatel okno nezavřel.

Do odpovědi v terminálu pak napiš jen krátké shrnutí (3–5 vět: co plán navrhuje a klíčová rozhodnutí) + cestu k souboru. Nekopíruj obsah plánu do chatu.

## Obsahové jádro

Co plán musí říct (formu viz další sekce — tohle nejsou „sekce za sebou"):

- **Titulek + TL;DR** — 2–4 věty nahoře: co se dělá a proč, zvolený přístup. Vedle titulku status badge (`návrh` / `schváleno` / `probíhá`) a datum.
- **Cíle / Ne-cíle** — co je v rozsahu a co explicitně ne.
- **Kroky** — číslovaný postup; u každého kroku dotčené soubory a stručné „co a proč".
- **Rizika a otevřené otázky** — čemu nevěříš, co musí rozhodnout uživatel.
- Podle povahy úkolu: varianty řešení, diagram, mockup, diff náhledy.

## HTML naplno — povinný repertoár

Z těchto vzorů nasaď každý, který pro daný plán dává smysl. Netraktuj je jako volitelné ozdoby — jsou to důvody, proč plán vůbec píšeme v HTML:

- **Kroky = checklist s progresem.** Každý krok má checkbox; stav se ukládá do localStorage a nahoře je progress bar počítaný z odškrtnutých kroků. Plán tím slouží jako živý tracker během implementace a stav přežije refresh i pozdější editaci souboru.
- **Varianty řešení = taby.** Zvažované přístupy jako přepínatelné taby, v každém tab-panelu popis + dopady; nad nimi srovnávací tabulka trade-offů. Doporučená varianta je předvybraná a viditelně označená. Ne tři nadpisy pod sebou.
- **Otevřené otázky = formulář s odesláním do chatu.** Každá otázka jako skupina radio/checkbox voleb (včetně „jinak — napíšu v chatu"). Dole tlačítko **„Zkopírovat odpovědi"**, které zvolené odpovědi serializuje do čitelného textu a dá do schránky — uživatel je vloží zpět do terminálu. Rozhodování tak proběhne v plánu, ne přepisováním otázek ručně.
- **Přepínač úrovně detailu.** Toggle „přehled / plný detail" (třída na `<body>` + CSS, žádná duplikace obsahu): přehled ukáže TL;DR, kroky jednou větou a rozhodnutí; plný detail rozbalí technické podrobnosti, diffy, alternativy.
- **Sticky navigace.** U plánu delšího než ~2 obrazovky boční nebo horní lišta s anchor odkazy na sekce a zvýrazněním aktuální sekce (scroll-spy přes `IntersectionObserver`).
- **Diagram = interaktivní inline SVG.** Architektura, datový tok, závislosti kroků. Uzly jsou klikatelné (scroll na příslušný krok) a hover zvýrazní související hrany/uzly. Diagram kresli jen tam, kde ukazuje vztahy, které text vyjadřuje špatně — ne jako ilustraci.
- **Změny kódu = diff náhled.** Plánované úpravy jako before/after se zvýrazněním přidaných/odebraných řádků (stačí `<del>`/`<ins>` nebo obarvené řádky v `<pre>`), ne jen věta „uprav funkci X".
- **Frontend plán = živý mockup.** Když se plánuje UI, ukaž ho jako skutečné HTML/CSS přímo v dokumentu (klidně s hover stavy a responzivním chováním v resizovatelném kontejneru), případně `<iframe srcdoc="…">` pro izolaci stylů. Žádný ASCII art ani slovní popis layoutu.
- **Příkazy = copy tlačítko.** U každého příkazu, který má uživatel spustit, tlačítko „kopírovat" (`navigator.clipboard`).
- **Odkazy do kódu.** Dotčené soubory jako `vscode://file/<absolutní-cesta>:<řádek>` (otevře editor) s viditelnou relativní cestou jako textem odkazu; hover přes `title` může ukázat, co se v souboru mění.
- **Rozbalitelné detaily.** `<details>/<summary>` pro delší zdůvodnění, logy, ukázky — funguje i bez JS.

## Technická pravidla

- **Zcela self-contained**: veškeré CSS a JS inline, vanilla JS bez knihoven, žádné CDN, žádné externí fonty ani obrázky (assets jako data: URI). Soubor musí fungovat offline z disku přes `file://`.
- **Progressive enhancement**: obsah musí být čitelný i s vypnutým JS — JS přidává interakci (taby, progres, kopírování), neschovává obsah nenávratně. `<noscript>` netřeba, stačí rozumné výchozí stavy.
- **localStorage klíč** odvoď z názvu souboru (např. `plan:<slug>`), ať si plány nepřepisují stav navzájem.
- **Pouze tmavý režim** — jedna pevná tmavá paleta (včetně SVG diagramů a diff barev), žádné `prefers-color-scheme` ani světlá varianta.
- Střídmý, čitelný design: systémová písma, max šířka ~72ch pro text, dostatek bílého místa. Interaktivita slouží pochopení a rozhodování, ne efektu — žádné animace a dekorace; jediné povolené přechody jsou funkční (např. zvýraznění cíle po kliknutí v diagramu).
- Široký obsah (tabulky, diagramy, kód) v kontejneru s `overflow-x: auto`.
- `<title>` = název plánu.

## Anti-vzory

- Nadpisy + odrážky + `<details>` a nic víc — to je markdown s příponou .html.
- Tři varianty řešení jako tři sekce pod sebou místo tabů se srovnáním.
- Statický „diagram", který jen opakuje seznam kroků v rámečcích.
- Otázky pro uživatele jako prostý seznam, na který musí odpovídat přepisováním do chatu.
- Interaktivita pro efekt: animace, parallax, ozdobné hovery. Každý JS řádek musí čtenáři šetřit práci.

## Vztah k plan modu

Tento skill nenahrazuje plan mode. Když je aktivní plan mode, plán pro schválení předlož normálně obvyklým způsobem — HTML soubor vytvoř jako doprovodný, čitelnější artefakt téhož plánu.
