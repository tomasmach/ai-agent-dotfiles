---
name: verify
description: Verify the affected behavior of a completed change in the running application, API, job or CLI. Use before claiming a fix or feature works; keep checks proportional to the change.
---

# Ověření změny

Před úpravou zjisti z pravidel projektu, existujících skriptů a CI, jak se ověřuje dotčená část. Použij aktuální checkout a prostředí. Dokumentace ani mrtvá větev kódu nejsou důkaz skutečně používaného flow.

## Ověř to, co uživatel požadoval

- Bug: zachyť původní projev a po opravě zopakuj stejné kroky. Nelze-li reprodukovat, řekni to a odděl hypotézu od potvrzené příčiny.
- Web: najdi správný běžící server a jeho worktree. Proveď dotčenou interakci, ověř změnu stavu a relevantní logy. Kompilované assets musí odpovídat změně.
- UI: podívej se na screenshot výsledku. Má-li změna schválený mock, porovnej ho při stejném viewportu a stavu. Počty testů nenahrazují tuto kontrolu.
- Mobilní appka: proveď flow v simulátoru či emulátoru s odpovídajícím buildem a aktuálním JS. Ověření webové verze nevydávej za ověření nativního chování. EAS build za Macha nespouštěj.
- API nebo job: zavolej relevantní endpoint či vykonej job v lokálním/testovacím prostředí a zkontroluj odpověď, změnu dat a související log. U Uprate používej fake/mock App Store Connect.
- CLI nebo skript: spusť reálný vstup, přečti výstup, ověř exit code a vedlejší účinky.
- HTML report: jednou vykresli desktopovou a mobilní šířku, prohlédni screenshot a ověř obsah proti skutečnému inventáři. Nevyžaduje plnou aplikační sadu testů.

U stavu rozloženého v čase ověř relevantní přerušení, retry, přechod do pozadí nebo návrat. Vyber scénáře podle konkrétního rizika a závady; nedělej univerzální crash test každé kosmetické změny.

## Zachovej prostředí

Login proveď dokumentovanou metodou projektu a existující schválenou session. Nevymýšlej auth bypass, když repo požaduje ruční login. Nezabíjej cizí server ani simulátor; před reuse ověř projekt, port a vlastníka.

U širšího QA sestav před testováním konečný seznam scénářů podle zadání. QA končí po jeho průchodu a doložení výsledků, pokud nezůstala známá závažná chyba. Další kontroly přidávej na základě konkrétních nálezů. Méně závažné zbývající nálezy výslovně uveď; netvrď bezchybnost celé aplikace.

## Uzavři důkaz

Zapiš ověřenou revizi, prostředí, scénář, výsledek a odkaz na artefakt. Po opravě opakuj selhaný krok a kontroly ovlivněné změnou. Stejnou zelenou sadu neopakuj jen kvůli předání jinému agentovi. Širší kontroly přidej při změně rizika, kódu, prostředí nebo podle CI požadavků.

Oprava není hotová, pokud chybí důkaz dotčeného chování. Ve výstupu přesně uveď, co proběhlo a co zůstalo neověřené. Nezaměňuj vizuální kontrolu za souhlas uživatele s novým designem.
