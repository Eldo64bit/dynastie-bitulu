# Correctif prioritaire — Dynastie BITULU

Le frontend n’affiche plus aucune donnée fictive : membres, compteurs, dates, histoires, albums et documents proviennent uniquement de Supabase. Lorsque la base est vide ou que le schéma est absent, l’interface affiche un état vide explicite et n’invente aucun contenu.

La base Supabase contrôlée est réellement vide au niveau des tables métier attendues : la requête de vérification a renvoyé l’erreur d’absence de `public.family_units`, confirmant que la migration n’a pas été appliquée et qu’aucun enregistrement de démonstration n’a été créé.

La politique mobile est appliquée globalement : overflow horizontal masqué, scrollbars natives invisibles dans les vues mobiles et drawer de navigation sans scrollbar visible. Aucun calendrier, checkbox ou select natif n’a été ajouté ; les contrôles utilisés sont des champs textuels personnalisés par le design de l’application.

Le build TypeScript et la compilation de production passent. Le workflow GitHub Pages est vert. L’URL explicite `https://eldo64bit.github.io/dynastie-bitulu/index.html` et l’URL avec cache-buster servent correctement l’application. La route courte avec slash reste momentanément servie par une ancienne réponse CDN mise en cache ; le workflow publie désormais des alias de compatibilité pour les anciens hashes afin de laisser le CDN converger.
