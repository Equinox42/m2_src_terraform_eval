**Note sur la méthodologie de documentation**

Dans une optique d'industrialisation et de maintenabilité, la documentation technique de ce projet a été générée de manière semi-automatisée :

- **Aspects techniques (Inputs/Outputs/Resources) :** Générés automatiquement via **`terraform-docs`** pour garantir une fidélité entre le code et la documentation.
- **Aspects rédactionnels (Descriptions & Architecture) :** Rédigés avec l'assistance d'outils d'IA générative pour assurer clarté et synthèse.

Cette approche a permis de prioriser le développement de la logique d'infrastructure du code Terraform, tout en fournissant une documentation standardisée.

## Ce que fait la solution actuelle 

La solution actuelle tente péniblement de déployer des machines virtuelles sur différents cloud providers (aws, azure, gcp et libvirt) en faisant usage de "module", on observe deux grandes familles d'OS (Debian et Rocky Linux) et en général de multiples disques sont attachés aux VMs. 

## Critiques de la solution 

### Architecture et Maintenabilité (DRY & Modularité)

**Manque d'abstraction (DRY) et de standardisation :** Le code actuel va à l'encontre du principe DRY _(Don't Repeat Yourself)_. La présence de deux dossiers quasi-identiques pour gérer des distributions différentes (Debian/Rocky) augmente grandement la maintenance du code terraform. Qui plus est, le code n'est pas totalement identique pour les deux distributions, ça demande une gymnastique supplémentaire, parfois on fait l'usage de data source pour passer une AMI parfois passe sa valeur en dur, etc.

**Valeurs en dur (Hardcoding) et variables :** De nombreux arguments (sizing d'instance, IDs d'AMI) sont déclarés en dur. Il est impératif de les "variabiliser" pour offrir de la flexibilité, tout en définissant des valeurs par défaut (`default`) pour simplifier l'usage courant. Pour les variables déjà présente

**Architecture** : La structure des dossiers et des fichiers est disons pour le moins...exotique. Il est généralement recommandé d'adopter une certaines hygiène dans la structure des répertoires pour en facilité la compréhension et l'usage. 

### Stabilité et Gestion des Dépendances

**Absence de versions :** L'absence de contraintes de versions (`required_providers`, `required_version`) expose le projet à des risques de régressions lors de mises à jour automatiques de providers (breaking changes).

**Déclaration des versions dans les modules :** Bien que les providers soient déclarés à la racine, les bonnes pratiques recommandent d'inclure un fichier `versions.tf` dans chaque module pour expliciter les dépendances et garantir la compatibilité du binaire Terraform.
### Gestion du State et Cycle de Vie

 **Instabilité de l'argument `count` :** L'utilisation de `count` pour des ressources stateful (VMs, Disques) est risquée car elle repose sur un index numérique. La suppression d'une ressource intermédiaire entraîne un décalage des index et une reconstruction en cascade des ressources suivantes. L'usage de `for_each` avec des clés stables est préconisé.

**Absence de blocs `lifecycle` :** Le code ne définit aucune stratégie de cycle de vie. Sur un environnement de production, l'ajout de `create_before_destroy` est souvent crucial pour assurer la continuité de service lors du remplacement d'une ressource critique.

### Qualité de Code et Collaboration 

**Documentation inexistante :** L'absence de fichier `README.md` à la racine des modules freine l'adoption et la compréhension du code par les collaborateurs (inputs requis, outputs, dépendances).

**Convention de nommage :** L'utilisation du nom générique `"this"` pour les ressources uniques au sein d'un module est une convention recommandée pour uniformiser le code et réduire la charge cognitive.

**Lisibilité des Diffs (Git) :** L'usage excessif de "one-liners" (tout sur une ligne) est à éviter. Bien que compact, cela nuit à la lisibilité des "git diffs", car la modification d'un seul attribut marque toute la ligne comme modifiée. 

### Sécurité 

-  Certains aspects du code sont problématique, notamment celui-ci `source = "https://cloud.debian.org/images/cloud/bookworm/latest/debian-12-generic-amd64.qcow2"` d'un point de vue sécurité c'est rarement une bonne idée, on va plutôt privilégier un checksum  et en terme d'immuabilité ça va contre les principes de Terraform qui est censé décrire l'état de l'infrastructure tel quelle est réellement, il suffit que les personnes en charge du dépôt mettent à jour l'image pour qu'on se retrouve avec différentes versions sur nos VMs. D'ailleurs Debian 12 et Rocky 9 ne sont pas les dernières versions sur ces deux OS, on préfera partir sur des releases plus récentes. 

- On fait usage de la même clef publique sur tous les providers et ce quelque soit la distribution, je pense qu'on pourrait a minima avoir une paire de clef ssh différentes par provider, ça permet de contenir le blast radius si jamais la clef privée n'était plus si privée...

- En ne précisant rien dans configuration des ressources aws_instance on viendra déployer sur le default VPC, ce qui est généralement pas une bonne pratique, étant donné que ceux-ci viennent de facto avec des sous-réseaux publiques. 

### Industrialisation

Les propositions suivantes sont certainement hors-scope du TP, néanmoins, on pourra se dire que l'usage du code existant aura ses limites dès lors que l'infrastructure sera grandissante et que d'autres personnes viendront à contribuer au code au sein de l'entreprise. 

- **Gestion du State Distribué (Remote Backend) :** Le stockage local du fichier `terraform.tfstate` est incompatible avec le travail en équipe (risques d'écrasement et de désynchronisation). On fera le choix de migrer vers un **Remote Backend** (ex: AWS S3 + DynamoDB, Azure Storage Account) pour bénéficier d'un mécanisme de **State Locking** afin d'empêcher les écritures concurrentes.

- **Stratégie de CI/CD et Automatisation :** Le déploiement manuel depuis un poste local pose des problèmes de sécurité et de traçabilité. L'infrastructure devrait être déployée via un pipeline d'Intégration et Déploiement Continus (CI/CD) garantissant un environnement d'exécution reproductible. 

- **Workflow Git :** L'adoption d'une stratégie de branches claire est nécessaire pour mapper les environnements (branche `develop` -> env `dev`, branche `main` -> env `prod`) et sécuriser les déploiements via des Pull/Merge Requests. Idéalement il ne doit pas être possible de bypass la validation par un autre membre de l'équipe. 

- **Standardisation Automatisée :** Pour garantir une base de code homogène, des outils comme `terraform fmt` et `terraform validate` doivent être intégrés, soit via des Pre-commit hooks (côté DevOps/AdSys), soit dans des jobs dans la CI (Continuous Integration) lors de Pull/Merge Request.  

- **Sécurité de l'Authentification :** Les blocs `provider` ne doivent contenir aucun secret. L'authentification doit être déportée via des variables d'environnement (`TF_VAR`) ou, idéalement, via des mécanismes d'identité managée (OIDC, IAM Roles) au sein de la CI/CD.

## Proposition d'améliorations 

### Architecture de la Solution

L'architecture du projet repose sur une approche modulaire et hiérarchisée, conçue pour garantir la maintenabilité, la scalabilité et la sécurité des déploiements Multi-Cloud (AWS & Azure).

### Structure du projet

**Note sur la méthodologie de documentation**

Dans une optique d'industrialisation et de maintenabilité, la documentation technique de ce projet a été générée de manière semi-automatisée :

- **Aspects techniques (Inputs/Outputs/Resources) :** Générés automatiquement via **`terraform-docs`** pour garantir une fidélité entre le code et la documentation.
- **Aspects rédactionnels (Descriptions & Architecture) :** Rédigés avec l'assistance d'outils d'IA générative pour assurer clarté et synthèse.

Cette approche a permis de prioriser le développement de la logique d'infrastructure du code Terraform, tout en fournissant une documentation standardisée.

La structure suit le pattern suivant :

* `modules/` : Contient le code réutilisable et agnostique.
    * **Séparation Fonctionnelle** : Découpage strict entre `network` (VPC/VNet, Subnets) et `compute` (EC2/VM, Disques). L'idée des modules étant le "self-service". Chaque module possède une architecture similaire avec une séparation distinctes des fichiers (main.tf, variables.tf, locals.tf, data.tf, etc) pour en faciliter la maintenance et la compréhension. 
    * **Abstraction** : Les modules masquent la complexité des ressources (ex: la gestion des disques EBS via `dynamic blocks` ou les validations `lifecycle`).

*`environments/` : Contient l'instanciation des modules pour chaque environnement (`dev`, `prod`).
    * **Isolation** : Chaque environnement possède son propre `main.tf` et ses variables (`tfvars`), garantissant une isolation totale des états et réduisant le Blast Radius en cas d'erreur.

### Choix Techniques Clés

**Validations Robustes** : Utilisation intensive des blocs `validation` (variables) et `lifecycle { precondition }` (ressources) pour empêcher le déploiement d'une configuration invalide (ex: AMI non taguée "stable" ou n'ayant pas un OS Rocky Linux ou Debian) avant même l'appel API.

**Gestion Dynamique des Ressources** : Remplacement de l'argument `count` par `for_each` pour la gestion des instances et des disques. Cela garantit la stabilité des ressources lors de la suppression d'un élément au milieu d'une liste (problème de décalage d'index) ainsi qu'une plus grande granularité dans la configurations des ressources. 

L'usage de count dans l'appel des modules (`enable_aws`, `enable_azure`, etc.), permet d'instancier ou non des ressources sur les cloud providers, si toutefois dans le futur on ne souhaitait plus déployer sur certains cloud providers. 

L'usage de structure conditionnelle comme pour le sizing des instances sur les environnements de dévelopemment permet de pas provisionner des instances démesurées. 

La configuration du cloud_init est maintenant déportée dans un template `cloud_init.yaml.tftpl` et elle varie en fonction du contenu de la variable `var.distro` grâce à une structure conditionnelle if. C'est ce que préconise en général hashicorp plutôt que l'usage de heredoc. 

**Tags & Gouvernance** : Centralisation des tags via `locals` et fusion automatique (`merge`) pour assurer la traçabilité des coûts notamment avec l'usage de tags `team` et managed by terraform pour éviter (tout du moins essayer) qu'une personne vienne modifier la ressource à la main.

**Documentation** : Les fichiers .tf sont commentés pour la plupart pour facilement s'y retrouver et un README.md est présent pour chaque module. 