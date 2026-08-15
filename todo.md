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

## Identité Etienne Eldo Bitulu et publication
- [ ] Préparer un checkpoint publiable et demander à l’utilisateur d’utiliser le bouton Publish de l’interface.
- [ ] Ajouter les champs profil obligatoires prénom et nom, ainsi que postnom et surnom optionnels.
- [ ] Enregistrer Etienne Stéphane Bitulu, postnom Kunyima Kabeya, surnom Eldo, sans inventer ni fusionner les champs.
- [ ] Afficher `surnom + nom` lorsqu’un surnom existe, sinon `prénom + nom`.
- [ ] Conserver les champs non affichés pour la recherche et le SEO des profils publics.
- [ ] Ajouter les métadonnées SEO de base pour les profils rendus publics, sans exposer les profils privés.
- [ ] Tester puis créer un nouveau checkpoint après ces changements.

## État courant
La version de publication a été validée par `pnpm check` et `pnpm build`. Les champs réels d’Etienne sont enregistrés dans Supabase : prénom « Etienne Stéphane », nom « Bitulu », postnom « Kunyima Kabeya », surnom « Eldo ». L’interface affiche « Eldo Bitulu » lorsqu’un surnom existe, sinon « Prénom Nom ». Un slug public et une policy RLS dédiée sont en place pour les profils explicitement rendus publics ; le profil d’Etienne n’a pas été rendu public automatiquement.

## Publication convention
- [ ] Push the current validated commit to GitHub and trigger the GitHub Pages workflow when the user says « publier ».
- [ ] Verify the deployed GitHub Pages artifact and effective public URL after the workflow completes.

## Publication vérifiée
La publication GitHub Pages a été déclenchée par le commit `0308d35` et le workflow `31899250069` s’est terminé avec succès. Le site répond publiquement sur `https://eldo64bit.github.io/dynastie-bitulu/index.html` ; la vérification a confirmé le titre et le contenu Dynastie BITULU servis par GitHub Pages.

## Espace familial BITULU et mémoires
- [ ] Vérifier l’existence réelle de l’espace `Dynastie BITULU` et le rattachement du profil d’Etienne.
- [ ] Vérifier que le profil SuperAdmin est lisible par l’application avec la session actuelle.
- [ ] Vérifier les colonnes, contraintes et RLS de `stories` utilisées par l’enregistrement d’une mémoire.
- [ ] Corriger l’initialisation de famille et le message d’invitation disponible après création.
- [ ] Corriger la création d’une mémoire sans données fictives.
- [ ] Republier le correctif sur GitHub Pages et vérifier le parcours réel.

## Audit réel
La famille `Dynastie BITULU` existe bien et c’est l’unique ligne de `family_units`. En revanche, `auth.users` contient actuellement zéro compte et `public.profiles` contient zéro ligne ; l’identifiant utilisé précédemment ne correspondait donc à aucun utilisateur réel. Le refus de mémoire venait de l’absence de profil familial. Le trigger `handle_new_user` a maintenant été installé pour créer un profil réel et l’attacher automatiquement à l’unique famille BITULU lors d’un prochain signup.

## Correctif vérifié
L’espace `Dynastie BITULU` est confirmé comme l’unique espace familial. Le compte `bgloretienne1@gmail.com` existe maintenant dans ce projet Supabase et son profil réel est rattaché avec le rôle `SUPERADMIN` et les quatre champs d’identité. Le refus de mémoire venait de l’absence totale de policy RLS sur `stories`; les policies d’insertion et de lecture ont été ajoutées. Le loader frontend n’interprète plus l’absence optionnelle de `documents` comme une base non installée, et le bouton d’invitation copie maintenant le lien réel de l’application. `pnpm check` et `pnpm build` passent.
