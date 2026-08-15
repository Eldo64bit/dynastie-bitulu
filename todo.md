# Correctif prioritaire — Dynastie BITULU

- [ ] Auditer et supprimer toutes les données fictives, noms, statistiques, médias et dates codés en dur.
- [ ] Vérifier que la base Supabase du projet est réellement vide et documenter l’état réel sans insérer de données de démonstration.
- [ ] Brancher les écrans sur les tables Supabase réelles et afficher des états vides explicites tant qu’aucune donnée n’existe.
- [ ] Éliminer les scrollbars visibles dans toutes les vues mobiles, y compris les conteneurs horizontaux et les panneaux internes.
- [ ] Remplacer les contrôles natifs utilisés par l’interface par des composants custom cohérents avec le design BITULU.
- [ ] Diagnostiquer la 404 GitHub Pages et vérifier le contenu servi par le domaine public.
- [ ] Recompiler, tester les parcours public/authentifié avec base vide, vérifier desktop/mobile, puis publier le correctif.

## Verification finding
- [x] Cache-busted URL `https://eldo64bit.github.io/dynastie-bitulu/?v=10fe47d` serves the real application.
- [ ] Make the bare URL compatible with the CDN-cached old JavaScript asset by publishing a compatibility alias during Pages builds, then verify the bare URL again.
