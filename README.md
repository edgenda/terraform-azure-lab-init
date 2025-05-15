# Initialisation du lab Terraform avec Azure

Ce repository est destiné aux instructeurs qui doivent superviser l'exécution du lab contenu dans le repository `terraform-azure-lab` dans le contexte d'une formation avec plusieurs apprenants.  
L'objectif est de fournir à chaque apprenant:
- Un compte dans un tenant Entra ID
- Un groupe de ressources dans une souscription Azure pour contenir les ressources provisionnées par le lab
- Un autre groupe de ressources avec un compte de stockage pour la gestion du state (à partir de l'étape 3 du lab)

Tous ces éléments sont créés dans Azure/Entra avec Terraform, pour utiliser ce repo vous aurez besoin:
1. D'une souscription Azure avec la permission d'y créer des ressources et d'y assigner des rôles
2. D'un tenant Entra ID avec la possibilité d'y créer des comptes utilisateurs
3. D'un environnement en ligne de commande avec 

## Première application de la configuration
Aucune information liée à votre environnement Azure/Entra doit se trouver dans ce repo, tout est géré via des variables qu'il faut renseigner avant de lancer une commande Terraform.  
Une bonne façon de renseigner ces variables est de créer un fichier `.env` à la racine du repo avec le contenu suivant et d'y renseigner les valeurs:
```
export ARM_SUBSCRIPTION_ID="<identifiant de votre souscription Azure>"
export TF_VAR_users="<liste des prénoms des apprenants séparés par des virgules>"
export TF_VAR_location="<la région Azure à utiliser, par exemple canadaeast>"
export TF_VAR_tenant_domain="<le domaine de votre tenant Entra ID, par exemple mon-tenant.onmicrosoft.com>"
export TF_VAR_use_state="<false dans un premier, puis true avant l'étape 3 du lab>"
```
Une fois ceci fait, vous pouvez lancer la commande `source .env` et un `terraform apply`, qui va créer pour chaque utilisateur un groupe de ressources, un compte utilisateur, et une assignation de role contributeur sur le groupe de ressources.  
Pendant que les ressources sont créées, vous pouvez en profiter pour montrer aux apprenants la structure du repo, les ressources dans le fichier `main.tf`. Il est également recommandé au formateur de s'ajouter dans la liste des utilisateurs, pour qu'il puisse suivre le lab avec le même niveau d'accès que les apprenants.

## Seconde application à l'étape 3 du lab
L'étape 3 du lab consiste à déplacer le state dans un compte de stockage, pour cela un compte de stockage est nécessaire par utilisateur.  
Les ressources liées aux states sont gérées dans le fichier `states.tf`, et ne sont appliquées que si la variable `use_state` vaut `true`.  
Avant de lancer cette étape du lab, modifiez la valeur de cette variable dans votre fichier `.env`, et relancez les commandes `source .env` et `terraform apply` pour déclencer la création de ces ressources.  
C'est également l'occasion de montrer aux apprenants la configuration dans le fichier `states.tf`, notamment avec l'utilisation des _meta-arguments_ `count` et `for_each`.  