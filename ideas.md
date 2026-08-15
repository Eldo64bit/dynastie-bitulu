# Dynastie BITULU — Direction artistique et décisions de conception

## Trois approches explorées

### Approche 1 — Archives de lumière
Une esthétique patrimoniale contemporaine inspirée des albums de famille, des bibliothèques et des carnets de transmission. Le ton est chaleureux, calme et durable, avec des textures papier, des accents cuivre et une composition éditoriale.

**Probabilité : 0,03**

### Approche 2 — Maison des générations
Une interface domestique et lumineuse, proche d'une maison de famille modernisée : matières naturelles, tons ivoire et sauge, photographies encadrées et navigation douce. Elle privilégie l'accueil, la lisibilité intergénérationnelle et la confiance.

**Probabilité : 0,07**

### Approche 3 — Registre vivant
Une direction plus sombre et cinématographique, articulée autour d'un registre numérique, de lignes de temps fines et d'accents dorés. Elle donne à l'application le caractère d'un conservatoire privé, sans basculer dans une esthétique technologique froide.

**Probabilité : 0,02**

## Direction retenue : Archives de lumière

### Design Movement
Éditorial patrimonial contemporain, à la rencontre du modernisme suisse, des archives imprimées et des interfaces de musée. L'application doit évoquer un registre précieux que l'on ouvre avec attention, tout en restant pratique sur mobile.

### Core Principles
1. **La mémoire comme matière** : les espaces respirent, les contenus sont datés et contextualisés, les récits ont une place centrale.
2. **La confidentialité comme confiance** : les niveaux de visibilité sont lisibles, explicites et présents au moment de l'action.
3. **La transmission comme fil conducteur** : la timeline et l'arbre familial structurent la navigation plus que des flux sociaux.
4. **La continuité comme calme** : les actions sensibles sont discrètes, réversibles quand elles doivent l'être, et toujours accompagnées d'un historique.

### Color Philosophy
La base est un ivoire chaud, jamais blanc clinique, pour rappeler le papier conservé. Un brun-encre profond assure la lisibilité et le sérieux. Le cuivre rosé sert de signature pour les moments de transmission et les actions importantes, tandis qu'un vert sauge désaturé indique la confiance et les états confirmés. La palette évite les couleurs criardes et reste confortable pour les grands-parents comme pour les adolescents.

### Layout Paradigm
La structure repose sur une navigation latérale persistante et un contenu éditorial décalé : un rail de contexte à gauche, une colonne principale de récit, puis des panneaux secondaires qui apparaissent au besoin. Les timelines utilisent une ligne verticale et des repères datés ; l'arbre familial utilise des liens organiques plutôt qu'une grille de cartes uniforme.

### Signature Elements
- Une **ligne de reliure cuivre** qui accompagne les timelines et les cartes de mémoire.
- Des **étiquettes d'archive** avec année, visibilité et type de contenu, inspirées des fiches de classement.
- Un motif discret de **papier fibreux** et de micro-grain, utilisé pour donner de la profondeur sans alourdir l'interface.

### Interaction Philosophy
Chaque interaction doit ressembler à une manipulation attentive d'une archive : ouvrir, consulter, annoter, classer, transmettre. Les actions critiques ne sont jamais impulsives ; les confirmations expliquent la conséquence, et les niveaux de confidentialité sont visibles avant l'enregistrement. Les transitions sont courtes, douces et orientées par le contexte.

### Animation
Les apparitions utilisent un fondu accompagné d'un déplacement vertical de 6 à 10 px, entre 180 et 260 ms. Les éléments d'une timeline se révèlent en cascade légère, espacés de 40 ms. Les drawers et modales partent de leur point d'ancrage avec une échelle initiale de 0,97, jamais de 0. Les pressions de bouton répondent par une réduction à 0,97 pendant environ 140 ms. Les animations non essentielles sont désactivées pour `prefers-reduced-motion`.

### Typography System
Les titres utilisent **Cormorant Garamond** en poids 500 à 600, avec une taille généreuse et une interlettrage légèrement resserré. Le texte courant utilise **DM Sans** en 400 à 600 pour sa clarté à toutes les tailles. Les métadonnées sont en DM Sans 11 à 12 px, en capitales espacées, et les années de timeline en Cormorant Garamond italique.

### Brand Essence
**La mémoire numérique privée de la famille BITULU, conçue pour préserver les histoires, les liens et les générations dans le temps.**

Personnalité : **patrimoniale, chaleureuse, digne**.

### Brand Voice
Les titres sont évocateurs mais précis. Les CTA sont calmes et concrets. Les microcopies expliquent la confidentialité et la continuité sans dramatisation. Aucun remplissage générique.

Exemples :
- « Ouvrir une nouvelle page de votre histoire »
- « Cette mémoire restera visible uniquement par vous. »

### Wordmark & Logo
Le symbole est une **parenthèse d'archive** : deux arcs verticaux cuivre qui entourent un point central, comme deux générations protégeant une mémoire commune. Le mot-symbole « BITULU » est composé en petites capitales serif, avec « Dynastie » en Cormorant Garamond au-dessus. Le symbole doit fonctionner seul en favicon et dans le rail de navigation.

### Signature Brand Color
**Cuivre BITULU — `#B7795B`**, un cuivre rosé discret qui évoque la reliure, la terre et la chaleur sans devenir décoratif.

## Règle de décision
Avant chaque choix d'interface, vérifier : **« Est-ce que cette décision renforce ou dilue l'idée d'une archive familiale vivante, chaleureuse et confidentielle ? »**

## Périmètre de la première version fonctionnelle
La première livraison doit privilégier une expérience réellement utilisable : accueil public, authentification Supabase, tableau de bord, profils, membres et relations, timeline, événements, visibilité par contenu, albums et histoires, documents privés, invitations, notifications, arbre familial et premiers écrans de succession/certification. Les actions sensibles doivent être reliées à des états explicites et à des journaux, même si certaines étapes d'administration avancée sont livrées progressivement.

## Contraintes d'intégration
Le frontend sera connecté à Supabase avec des variables d'environnement publiques côté navigateur et des politiques RLS côté base. Les documents privés utiliseront un bucket privé et des URLs signées. GitHub Pages servira la version statique compilée ; le routage client devra donc prévoir un fallback compatible avec Pages.

## Style Decisions

- La ligne de reliure cuivre doit traverser les sections publiques et les espaces produits, avec des repères circulaires comme un registre cousu.
- Chaque bloc majeur porte au moins un indice d'archive : registre, année, type, rôle, niveau de visibilité ou provenance.
- Le lockup Dynastie BITULU est cérémoniel : symbole parenthèse visible, « Dynastie » en Cormorant Garamond et « BITULU · ARCHIVE FAMILIALE » en petites capitales serif.
- La confidentialité est exprimée comme une promesse produit par des mentions « privé par défaut », des badges d'accès et des surfaces protégées.
