# Product

## Register

product

## Users

Flutter developers (solo devs and small teams) building novel/web-fiction
reading apps who want Webnovel-quality UI without designing every screen from
scratch. Their end users are readers on phones, often reading at night, in
bed or commuting, for 30–90 minute sessions. Many end users read in Arabic
(RTL) as well as English.

## Product Purpose

novel_ui is a Flutter design-system package that ships everything a
novel-app needs: book cards/rails, rankings, chapter catalogs with paid
unlock flows, engagement widgets (votes, gifts, comments), and a full
reading engine (paginated & scroll modes, six paper themes, paragraph
comments, typography controls). Success = a developer assembles an app that
is visually indistinguishable from a top-store commercial novel app in days,
not months.

## Brand Personality

Warm, literate, trustworthy. Three words: **bookish, precise, calm**.
Reading surfaces must feel like paper; chrome must recede so the story is
the loudest thing on screen. Controls are confident and compact, never
gimmicky.

## Anti-references

- Toy widget collections: unthemed Material defaults, hardcoded colors,
  no dark mode, no RTL.
- Reader apps with gray-on-dark body text (low-contrast night mode is the
  most common real-world failure).
- AI-slop UI: glassmorphism everywhere, gradient text, oversized radii
  (24px+) on cards, decorative side-stripe borders, identical card grids.
- Cluttered monetization: unlock sheets that shout; coins must inform,
  not pressure.

## Design Principles

1. **Paper first**: the reading surface leads; every other surface defers
   to it (colors, motion, density).
2. **Theme-resolved, never hardcoded**: any visual value resolves through
   `widget ?? componentTheme ?? default`; presets exist but nothing bypasses
   the chain.
3. **Contrast is non-negotiable**: body text ≥4.5:1 on every paper theme,
   including night and kraft.
4. **Bilingual by birthright**: every user-facing string lives in
   `NovelStrings` (EN/AR); layouts must survive RTL mirroring.
5. **Recovered, not invented**: when the official apps already solved a
   pattern (unlock sheets, podium rankings, power votes), follow their
   verified specs instead of inventing new shapes.
6. **No third-party assets**: patterns and specs may be studied from other
   apps, but their icons/artwork are never bundled into this library —
   shipped assets must be originally licensed.

## Accessibility & Inclusion

- WCAG AA: ≥4.5:1 body text, ≥3:1 large text/UI, verified across light,
  dark, and all six reader papers.
- Screen-reader support: interactive widgets expose Semantics (buttons,
  toggles, adjustable rating values); composite cards merge into one node.
- Minimum 44–48dp touch targets for tappable controls.
- Respect `MediaQuery.disableAnimations` for reader page transitions.
- RTL correctness: mirrored layouts via Directionality, no hardcoded
  left/right in insets.
