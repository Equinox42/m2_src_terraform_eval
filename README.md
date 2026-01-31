## Ce que fait la solution actuelle 

La solution actuelle tente péniblement de déployer des machines virtuelles sur différents cloud providers (aws, azure, gcp et libvirt) en faisant usage de "module", on observe deux grandes familles d'OS (Debian et Rocky Linux) et en général de multiples disques sont alloués aux VMs. 

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

J'ai relevé également des aspects du code problématique, notamment celui-ci `source = "https://cloud.debian.org/images/cloud/bookworm/latest/debian-12-generic-amd64.qcow2"` d'un point de vue sécurité c'est rarement une bonne idée, on va plutôt privilégier un checksum  et en terme d'immuabilité ça va contre les principes de Terraform qui est censé décrire l'état de l'infrastructure tel quelle est réellement, il suffit que les personnes en charge du dépôt mettent à jour l'image pour qu'on se retrouve avec différentes versions sur nos VMs. 

On fait usage de la même clef publique sur tous les providers et ce quelque soit la distribution, je pense qu'on pourrait a minima avoir une paire de clef ssh différentes par provider, ça permet de contenir le blast radius si jamais la clef privée n'était plus si privée...

### Industrialisation

Les propositions suivantes sont certainement hors-scope du TP, néanmoins, on pourra se dire que l'usage du code existant aura ses limites dès lors que l'infrastructure sera grandissante et que d'autres personnes viendront à contribuer au code au sein de l'entreprise. 

- **Gestion du State Distribué (Remote Backend) :** Le stockage local du fichier `terraform.tfstate` est incompatible avec le travail en équipe (risques d'écrasement et de désynchronisation). On fera le choix de migrer vers un **Remote Backend** (ex: AWS S3 + DynamoDB, Azure Storage Account) pour bénéficier d'un mécanisme de **State Locking** afin d'empêcher les écritures concurrentes.

- **Stratégie de CI/CD et Automatisation :** Le déploiement manuel depuis un poste local pose des problèmes de sécurité et de traçabilité. L'infrastructure devrait être déployée via un pipeline d'Intégration et Déploiement Continus (CI/CD) garantissant un environnement d'exécution reproductible. 

- **Workflow Git :** L'adoption d'une stratégie de branches claire est nécessaire pour mapper les environnements (branche `develop` -> env `dev`, branche `main` -> env `prod`) et sécuriser les déploiements via des Pull/Merge Requests. Idéalement il ne doit pas être possible de bypass la validation par un autre membre de l'équipe. 

- **Standardisation Automatisée :** Pour garantir une base de code homogène, des outils comme `terraform fmt` et `terraform validate` doivent être intégrés, soit via des Pre-commit hooks (côté DevOps/AdSys), soit dans des jobs dans la CI (Continuous Integration) lors de Pull/Merge Request.  

- **Sécurité de l'Authentification :** Les blocs `provider` ne doivent contenir aucun secret. L'authentification doit être déportée via des variables d'environnement (`TF_VAR`) ou, idéalement, via des mécanismes d'identité managée (OIDC, IAM Roles) au sein de la CI/CD.

