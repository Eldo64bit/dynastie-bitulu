# Initialisation réelle BITULU — état du 15 août 2026

- [x] Vérifier que le compte privé `bgloretienne1@gmail.com` existe dans le projet Supabase.
- [x] Ne créer aucune donnée de démonstration.
- [x] Créer les tables `family_units`, `profiles`, `events`, `stories` et `albums`.
- [x] Créer la famille réelle `Dynastie BITULU`.
- [x] Rattacher `bgloretienne1@gmail.com` comme premier SuperAdmin par son identifiant Auth réel.
- [x] Ajouter le trigger de création de profil à l’inscription.
- [x] Activer les règles RLS essentielles pour famille, profils et événements.
- [x] Autoriser les visiteurs non connectés à lire uniquement les événements `PUBLIC`.
- [x] Ajouter le prénom obligatoire au formulaire d’inscription et transmettre les métadonnées de profil à Supabase Auth.
- [x] Ajouter la consultation publique des événements, récits et albums explicitement `PUBLIC`, avec état vide réel si aucun contenu n’existe.
- [x] Valider `pnpm check` et `pnpm build`.
- [x] Vérifier les compositions desktop et mobile ; aucune scrollbar visible n’apparaît dans la vue contrôlée.

## Limites restantes avant la production complète

- [ ] Ajouter les tables et RLS des documents et invitations lorsque l’interface de gestion sera implémentée.
- [ ] Ajouter l’écran de complétion du profil pour le compte créé avant l’obligation du prénom.
- [ ] Remplacer l’inscription publique ouverte par un parcours d’invitation contrôlé après validation du premier SuperAdmin.
- [ ] Tester la création réelle d’un membre depuis le compte SuperAdmin, puis enregistrer un nouveau checkpoint.
