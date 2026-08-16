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

## Publication du correctif
Le checkpoint `a185541c` a été poussé sur GitHub par le commit `a185541c869ad06b6b7d5d4eab839f3f25e09c45`. Le workflow GitHub Pages `31900319864` est terminé avec succès. La version live vérifiée est `https://eldo64bit.github.io/dynastie-bitulu/index.html?v=a185541`.

## Publication immédiate et affichage du profil
- [ ] Republier immédiatement l’état actuel sur GitHub Pages.
- [ ] Diagnostiquer pourquoi la requête du profil réel ne produit pas le prénom dans la session frontend.
- [ ] Afficher `Eldo Bitulu` ou `Etienne Stéphane Bitulu` selon la règle métier, sans fallback email lorsque le profil existe.
- [ ] Republier et vérifier le correctif avec cache-buster.

## Correctif du nom affiché
La policy `profile_read` contenait une récursion sur `profiles` qui empêchait la lecture fiable du profil par la session authentifiée. Elle a été remplacée par une policy directe `id = auth.uid()`, exécutée avec succès après confirmation. Le dashboard utilise désormais aussi les métadonnées Auth comme secours avant l’email. `pnpm check` et `pnpm build` passent.

## Fonctionnalité profil membre
- [ ] Inspecter Home.tsx, les helpers Supabase et le schéma existant pour identifier les points d’extension du tableau de bord.
- [x] Définir les champs profil modifiables, la structure des téléphones et les règles d’accès aux médias.
- [x] Implémenter l’écran de profil : identité, avatar, téléphones multiples et arrière-plan facultatif.
- [x] Ajouter les migrations et policies Supabase nécessaires pour les champs et le stockage privé.
- [ ] Tester les parcours de sauvegarde, upload, suppression, mobile et déploiement GitHub Pages.
- [ ] Publier immédiatement le checkpoint actuel sur GitHub Pages.
- [x] Publier la version 578dbac5 demandée sur GitHub Pages avant les nouvelles modifications.
- [x] Recentrer l’accueil sur le hero et les quatre principes, avec un bouton Invité vers l’archive publique dédiée.
- [x] Ajouter la prévisualisation du message WhatsApp avant la redirection finale.
- [x] Afficher les portraits réels dans les avatars près des noms.
- [x] Rendre Histoires utilisable : liste des contributions personnelles, dépôt DnD de texte, suggestion du titre et visibilité.

- [x] Corriger les colonnes avatar_url, biography, background_url et les autres champs de profil absents du cache de schéma, puis ajouter la suppression d’arrière-plan.
- [x] Repenser l’invitation : identité, place dans l’arbre, téléphone et redirection wa.me avec message prérempli.
- [x] Transformer l’accès Invité en véritable vitrine publique dédiée, en lecture seule, avec menus proches de l’espace membre et livre d’or.
- [x] Réparer la sélection visuelle des tuiles de rôle dans le wizard d’invitation et diagnostiquer l’erreur de préparation Supabase.
- [x] Ajouter une prévisualisation claire et un enregistrement fiable de l’invitation avant WhatsApp.
- [x] Retirer de la vitrine les mentions internes « lecture seule », « vue publique » et autres libellés destinés au concepteur.
- [x] Retirer « Invité » du CTA haut droit de l’accueil principal.
- [x] Ajouter le formulaire de dépôt du livre d’or et l’interface de modération SuperAdmin/réseau familial.
- [x] Ajouter recherche et filtres aux rubriques de la vitrine publique.
- [x] Remplacer le point du tag de visibilité par une icône explicite avec infobulle.
- [x] Corriger les erreurs d’import album/document et le layout de prévisualisation WhatsApp.
- [x] Créer la table `media` manquante dans Supabase avec RLS, puis vérifier l’import d’album réel.
- [x] Créer la table `documents` manquante dans Supabase avec RLS, puis vérifier l’import de document réel.


- [x] Corriger le débordement horizontal de la prévisualisation WhatsApp sur petit écran.
- [x] Retirer uniquement « Accès membre · visibilité contrôlée » de l’accueil principal, sans autre changement de composition.
- [x] Recomposer la troisième étape WhatsApp, ajouter une barre de progression et un bouton de copie du message.
- [x] Ajouter progression et messages de succès aux imports albums/documents.
- [x] Ajouter une alerte d’administration lors d’un nouveau message du livre d’or.
- [x] Afficher les invitations envoyées comme membres en attente dans l’arbre.
- [x] Réparer la persistance réelle de la visibilité choisie par l’auteur.

- [ ] Republier sur GitHub Pages et vérifier le flux d’invitation WhatsApp en ligne.

- [x] Rendre les tags de visibilité cliquables pour l’auteur et ajouter le ciblage de membres précis.
- [x] Implémenter les CTA Créer un album, Ajouter un document et les imports associés.
- [x] Afficher l’arrière-plan de profil dans la fiche membre et les surfaces prévues.
- [x] Ajouter un livre d’or public en lecture seule côté membres, avec modération avant publication.

- [ ] Ajouter les CTA des sections Chronologie, Albums et Documents et les contrôles de visibilité sobres.
- [x] Réparer les sauvegardes Supabase des champs biography, avatar_url et background_url après rafraîchissement du cache PostgREST.
- [x] Ajouter un bouton de suppression d’arrière-plan et nettoyer les messages techniques d’erreur affichés aux membres.
- [ ] Tester l’ouverture du wizard, le format international du téléphone et la redirection WhatsApp.

- [ ] Retirer de l’interface les mentions techniques destinées uniquement au concepteur.


## Profil membre — implémentation en cours
La base réelle contient maintenant `profile_phone_numbers`, les policies RLS de lecture/écriture propres au membre, le bucket privé `profile-media` et les policies de fichiers limitées au dossier UUID de l’utilisateur. Le dashboard contient l’écran « Mon profil » avec identité, biographie, plusieurs téléphones, numéro principal, avatar et arrière-plan facultatif. `pnpm check` et `pnpm build` passent.

## Nouvelle refonte — wizard et arbre généalogique
- [x] Nettoyer complètement l’étape 3 du wizard : masquer tous les champs et contrôles de l’étape 2.
- [x] Ne retenir dans l’arbre que les invitations dont l’envoi WhatsApp a réellement été déclenché.
- [x] Afficher les invitations en attente avec une légère couleur d’accent et le texte « Invitation en attente » uniquement.
- [x] Remplacer les cards linéaires par un véritable arbre généalogique avec générations, embranchements et positions relationnelles.
- [x] Ajouter un filtre pour afficher ou masquer les invitations en attente dans l’arbre.
- [ ] Tester et publier la nouvelle structure de l’arbre et du wizard.

## Nouvelle série — arbre interactif, invitations et confidentialité des coordonnées
- [x] Permettre à l’auteur de révoquer une invitation en attente depuis l’arbre.
- [x] Rendre les tuiles de l’arbre cliquables : profil détaillé pour un membre confirmé et détail/édition pour une invitation en attente.
- [x] Corriger la sauvegarde de visibilité signalée dans la capture, avec retour d’erreur exploitable.
- [x] Corriger les imports albums/documents signalés dans la capture, avec gestion fiable du stockage et des enregistrements.
- [x] Ajouter la visibilité dédiée aux coordonnées dans « Ma confidentialité ».
- [x] Étendre les coordonnées privées aux emails, réseaux sociaux et autres moyens de contact.
- [ ] Tester les parcours complets, créer un checkpoint et publier la correction.

## Nouvelle série — migration Supabase, photos d’albums et renvoi
- [ ] Publier immédiatement la version actuelle avant les nouvelles extensions.
- [x] Appliquer réellement les colonnes et policies Supabase pour `revoked_at` et les contacts.
- [x] Ajouter un bouton « Renvoyer » dans le détail d’une invitation sans créer de doublon.
- [x] Ajouter les photos individuelles dans les albums partagés.
- [x] Permettre plusieurs emails, sites et réseaux sociaux avec une visibilité indépendante par entrée.
- [ ] Tester la migration, les imports, le renvoi et créer un checkpoint final.

## Publication immédiate puis corrections
- [x] Pousser immédiatement le checkpoint actuel sur GitHub pour déclencher GitHub Pages.
- [x] Diagnostiquer et corriger le problème persistant des imports albums/documents.
- [x] Remplacer les libellés de réseaux dans les coordonnées privées par des logos ou icônes explicites.
- [x] Supprimer la redondance entre la section « Coordonnées » et « Coordonnées privées » en conservant une seule occurrence.
- [ ] Tester puis pousser la correction finale sur GitHub Pages.
