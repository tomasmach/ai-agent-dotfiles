---
name: html-plan
description: Create a readable self-contained HTML plan or report when the user explicitly asks for HTML or invokes html-plan. Ordinary planning and product HTML edits do not activate this skill.
---

# HTML Communication

Nepoužívej pro HTML, které je součástí produktu. Tohle je komunikační artefakt pro člověka.

## Jak vysvětlovat Machovi

Začni tím, co funguje, co nefunguje a co doporučuješ udělat. Piš česky pro člověka, který rozhoduje o produktu a nebude dělat code review. Technický název použij jen když pomáhá rozhodnutí a vysvětli jeho důsledek. Například „při obnovení stránky se ztratí rozepsaná odpověď“ místo názvu chybějícího mechanismu ukládání.

- První pohled má stačit k pochopení výsledku a nejbližšího rozhodnutí. Důkazy, seznamy a technické podrobnosti dej do rozbalovacích bloků; zachovej úplný inventář, pokud byl zadán.
- Proces nebo závislosti nakresli diagramem. Srovnání ukaž vedle sebe. Graf použij pro skutečná čísla se zdrojem, obdobím a významem os. Nevymýšlej procenta jistoty ani úspory a nekresli graf jen jako dekoraci.
- U opravy ukaž konkrétní „předtím → potom“. U QA popiš činnost uživatele, skutečný výsledek a dopad chyby. Odděl neověřené od fungujícího.
- U rozhodnutí napiš vlastní doporučení a jeho nevýhodu. Nedávej Machovi technický dotazník, který umíš vyřešit sám.
- Při společném průchodu řeš jednu otázku najednou. Celý podklad může být v HTML, chat má nést právě probírané rozhodnutí.
- Před odevzdáním aplikuj unslop na viditelný text, včetně popisků diagramů. Žádné popisy nástrojů nebo implementační inventáře místo vysvětlení dopadu.

## Dokument

Jeden self-contained HTML soubor, max 512 KB.

- Piš čitelný podklad pro rozhodnutí. Krátký úvod, přehledné bloky a podrobnosti na rozkliknutí. Žádný marketingový hero ani dekorace.
- Default: dark mode, true black (`#000`), bílý primární text, tmavě šedá jen pro sekundární plochy.
- Responzivní viewport, žádný fixed-width layout, čitelné na mobilu.
- Sémantické HTML, inline CSS, inline SVG, obrázky přes HTTPS nebo data-URL.
- Inline skript jen když interaktivita reálně pomáhá. Stránka musí být užitečná i bez JavaScriptu.
- Nikdy: externí skripty, inline event handlery, `javascript:` URL, formuláře, iframy, meta refresh, linkované styly, secrets, privátní URL, lokální cesty k souborům.

## UI mocky

Když uživatel chce varianty:

- Renderuj skutečné nastylované varianty, ne popisy.
- Označ je `A`, `B`, `C`… ať jde snadno vybrat.
- Polož je vedle sebe pro přímé srovnání.
- Drž jeden soubor napříč iteracemi, ať URL zůstává stabilní.

## Publikace

Soubor ulož do `~/.claude/html-comm/<téma>.html` a drž stejnou cestu napříč iteracemi.

1. Zapiš HTML lokálně.
2. Spusť `npx postplan upload <cesta>`. Stejná absolutní cesta aktualizuje existující URL; `--new` jen když je chtěný nový draft.
3. Ohlas lokální cestu a vrácenou Postplan URL.

Když postplan hlásí chybějící autentizaci, řekni uživateli, ať spustí `npx postplan auth set <api-key>` (klíč na postplan.dev), a mezitím mu předej lokální cestu a otevři soubor dostupným browser nástrojem nebo systémovým příkazem podle OS, na macOS `open`, na Linuxu `xdg-open`, pokud je k dispozici grafické prostředí. Na headless stroji předej lokální cestu a netvrď, že se prohlížeč otevřel. Nikdy netvrď, že je dokument hostovaný, dokud upload neproběhl. Před uploadem dokument jednou vykresli, prohlédni screenshot při desktopové i mobilní šířce a ověř jeho úplnost proti skutečným podkladům. Neprováděj kvůli reportu plnou sadu aplikačních testů. Soukromé důkazy a syrové historie ponech lokálně; publikuj jen redigovaný výklad.
