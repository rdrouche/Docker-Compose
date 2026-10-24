# RDR Conductor

**Des environnements Docker prêts à l'emploi, à la demande, en un clic — pour former, tester et démontrer.**

Vos apprenants cliquent, un terminal (ou une application) s'ouvre dans leur navigateur en quelques secondes, et tout disparaît proprement à la fin de la session. Vous gardez la main sur les ressources, les quotas et la sécurité.

---

## Le problème

Préparer un TP, c'est souvent :

- des machines virtuelles à cloner, à réinitialiser, à réparer avant chaque session ;
- des apprenants qui perdent leur temps à installer au lieu d'apprendre ;
- des « ça marche chez moi » impossibles à diagnostiquer à distance ;
- des serveurs de démo oubliés, allumés pendant des semaines ;
- aucune visibilité sur ce que font réellement les participants.

## La réponse

RDR Conductor transforme n'importe quel environnement décrit en **Docker Compose** en un **service à la demande** :

1. **Vous décrivez** votre lab dans un dossier (un `docker-compose.yml` et un petit `meta.yml`).
2. **L'apprenant lance** depuis un portail, une page web ou votre propre application via l'API.
3. **Conductor réserve** une machine, démarre l'environnement et ouvre le terminal dans le navigateur.
4. **À l'échéance**, tout est arrêté et nettoyé. Aucune ressource ne traîne.

---

## Ce que vous obtenez

### Pour les formateurs

- **Des labs reproductibles** : chaque apprenant démarre d'un état identique, propre, isolé.
- **Un catalogue simple à écrire** : un stack = un dossier. Terminal Linux, Ansible, Docker-in-Docker, Apache, Nginx, bases de données… des modèles sont fournis.
- **Synchronisation Git** : vos stacks vivent dans un dépôt, sont versionnés, sauvegardés et restaurables depuis l'interface.
- **Durée et prolongation** : chaque lab a un temps limité, prolongeable dans la limite que vous fixez.
- **Un guide intégré** : instructions en Markdown à cocher, affichées à côté du terminal.

### Pour les apprenants

- **Zéro installation** : un navigateur suffit.
- **Un terminal prêt en quelques secondes**, grâce au pré-téléchargement automatique des images.
- **Des applications à la demande** (outils de diagramme, de modélisation de bases de données…) avec une **adresse stable** : on arrête, on relance, on retrouve son travail.
- **Interface en français et en anglais.**

### Pour les administrateurs

- **Plusieurs serveurs, un seul tableau de bord** : ajoutez des agents sur d'autres machines, répartissez la charge, dédiez des serveurs à certains publics.
- **Capacité maîtrisée** : nombre de stacks, CPU et RAM par serveur, réglables depuis l'interface.
- **Supervision en temps réel** : sessions actives, état des agents, consommation, erreurs, historique.
- **Journal d'audit, alertes et page de diagnostic** : versions des agents, dérive d'horloge, durcissement, sauvegardes.
- **Déploiement sans douleur** : données dans des dossiers de l'hôte (pas de volumes cachés), droits gérés automatiquement, mise à jour d'un agent depuis l'interface.

---

## Les applications à la demande : production comme tests

Conductor ne sert pas qu'aux terminaux de formation. Il peut aussi lancer **n'importe quelle application web conteneurisée**, pour chaque utilisateur, quand il en a besoin :

- **Un espace personnel pour chacun** : chaque utilisateur obtient sa propre instance, avec sa propre adresse stable et ses propres données. On arrête, on relance, on retrouve tout.
- **Deux modes de vie** :
  - **À la demande** : durée limitée, prolongeable, arrêt et nettoyage automatiques — idéal pour essayer, démontrer ou tester ;
  - **Toujours active** : aucune expiration, relance automatique en cas de panne, arrêt volontaire respecté — pour les services qu'on utilise au quotidien.
- **Données persistantes** dans un dossier de l'hôte, avec quotas par utilisateur et par palier (nombre d'instances, stockage, durée) réglables dans l'interface.
- **En production** : un service personnel fiable, supervisé et relancé tout seul. **En test** : une application jetable, sans engagement, qu'on détruit d'un clic.

### L'exemple Trilium : rendre « mono-utilisateur » compatible avec « plusieurs utilisateurs »

Beaucoup d'excellentes applications — **Trilium Notes**, Joplin Server, Excalidraw… — n'ont **pas été conçues pour servir plusieurs personnes isolées** : une seule base, un seul compte, aucune séparation entre utilisateurs. Les héberger pour une équipe, une classe ou des clients pose alors un vrai problème : soit tout le monde partage le même espace, soit vous montez et maintenez un serveur par personne à la main.

Conductor règle ce problème sans toucher à l'application :

1. L'application reste **telle quelle**, dans son image d'origine.
2. Conductor lance **une instance dédiée par utilisateur**, avec ses propres données et son adresse non devinable.
3. Chaque personne a donc l'impression d'avoir **son propre serveur Trilium**, alors qu'un seul catalogue et un seul tableau de bord pilotent le tout.
4. Les quotas évitent les excès (nombre d'instances, stockage), et l'administrateur voit tout.

Résultat : un outil pensé pour un seul utilisateur devient un **service multi-utilisateurs isolé**, sans fork ni développement spécifique. Ajouter une application au catalogue se résume à copier un modèle de stack et à renseigner l'image, le port et le dossier de données.

---

## Un portail clé en main

Le portail (facultatif) est un front complet, à votre marque :

- catalogue avec recherche et filtres, fiche de chaque lab, page d'exécution avec minuteur ;
- **comptes, plans et quotas** (par jour, sessions simultanées) ;
- **inscription libre ou restreinte** à certains domaines de messagerie ;
- **validation des comptes** : automatique, par un administrateur, ou par e-mail ;
- **connexion par lien magique** et mot de passe oublié (SMTP configurable depuis l'interface, journal des envois) ;
- **SSO** pour les organisations qui en disposent ;
- **marque blanche** : titre et couleur d'accent.

Vous préférez votre propre interface ? Tout ce que fait le portail passe par l'**API REST**, que vous pouvez appeler depuis votre site, votre LMS ou un script.

---

## Sécurité par conception

- **Isolation** : chaque session tourne dans ses propres conteneurs, avec limites de CPU, mémoire et processus.
- **Analyse des commandes** : les commandes tapées dans les terminaux sont contrôlées selon des règles que vous définissez ; les comportements à risque sont journalisés, avec **bannissement d'IP** possible.
- **Quotas et anti-abus** : crédits par utilisateur ou par IP, anti-double-lancement, nettoyage automatique des sessions expirées.
- **Communications protégées** : jetons d'agent, protection anti-rejeu, TLS entre le Conductor et ses agents (certificat interne possible).
- **Secrets maîtrisés** : mots de passe hachés, sessions serveur, protection CSRF, politique de sécurité stricte.
- **Données de journal** : chiffrement des adresses IP si vous le souhaitez.

---

## Une architecture "simple"

```
Navigateur ──► Portail (facultatif) ──► API Conductor ──► Agents ──► conteneurs
                                              │
                                  Redis (file de jobs)  ·  SQLite
```

- **Conductor** : le cerveau (ordonnancement, quotas, catalogue, tableau de bord).
- **Agents** : un par serveur Docker ; ils lancent et arrêtent les stacks, récupèrent leur configuration et leurs stacks depuis le Conductor.
- **Portail** : l'interface publique, indépendante du Conductor.
- **Tout est conteneurisé** : un `docker compose up -d` démarre l'ensemble. Compatible avec nginx, Traefik, Caddy ou Apache en frontal.

---

## Pour qui ?

| Vous êtes… | Conductor vous permet de… |
|---|---|
| **Centre de formation / école** | Offrir des TP identiques à chaque promotion, sans préparer de machines |
| **Formateur indépendant** | Proposer des labs en ligne à vos clients, avec quotas et durées |
| **Éditeur, communauté open source** | Donner un bac à sable de démonstration, sans exposer d'infrastructure |
| **Équipe ou association** | Offrir à chacun sa propre instance d'une application mono-utilisateur (notes, mots de passe, dessin…) |
| **Équipe interne (DevOps, support)** | Fournir des environnements de test jetables à la demande |
| **Organisateur d'événements** | Ouvrir un atelier à des dizaines de participants en quelques minutes |

---

## Pourquoi Conductor ?

- **Léger** : Docker uniquement, pas d'hyperviseur ni d'orchestrateur lourd à administrer.
- **Rapide** : un environnement prêt en quelques secondes, pas en minutes.
- **Économe** : les ressources n'existent que pendant la session.
- **Maîtrisé** : vos données, vos serveurs, vos règles. Rien ne part chez un tiers.
- **Ouvert** : stacks en Docker Compose standard, API documentée, aucune dépendance à un fournisseur.

---

> **RDR Conductor** — donnez à chaque apprenant son propre environnement, sans qu'il ait rien à installer.