# ARTM - Countries - 4H

### **Architecture**

Séparation des couches (services, logique, UI).
-   **Dip** pour gérer les dépendances
-   **Alamofire** et **AlamofireImage** pour gérer les appels réseaux
-  **CountryModel** pour modéliser les données
-  **ViewControllers** dédiés

Élaboration des UI par programmation (par opposition au storyboard) afin de faciliter le travail collaboratif sous Git.

Le projet étant simple, j'ai opté pour pour le pattern MVC, mais dans l'absolu le modèle MVVM serait plus adapté ici pour éviter que les ViewControllers contiennent trop de logique. Actuellement, les ViewControllers font trop de choses (appel API, gestion des erreurs).

### **Gestion des erreurs**

Une gestion basique des erreurs en affichant un message quand l’API échoue est mise en place. Mais, une gestion des erreurs plus centralisées et orientée produit serait pertinente (à voir avec le PO).

Il serait pertinent d'optimiser la gestion des erreurs réseau différemment en vérifiant le code HTTP

### **3. Tests unitaires**
Les tests unitaire UrlService sont implémentés, mais il serait interessant d'implémenter des tests unitaires pour le service CountryService au travers de mocks. Pour cela, un modèle MVVM est requis.
De plus, des tests UI pourraient s'avérer pertinents.
