class Agent 
{
    // Attributs de la classe
    PVector position; // Position de l'agent
    PVector previousPosition; // Stockage de la position précédente (pour le dessin)
    float stepSize; // Incrément de déplacement (= vitesse de base de l'agent)
    float angle; // Angle de déplacement de l'agent
    boolean isPositionResetWhenOutside; // Permet d'activer ou non la réinitialisation de la position de l'agent lorsqu'il quitte l'espace du sketch

    // Le constucteur par défaut de la classe
    Agent() 
    {
        position = new PVector(random(width), random(height)); // Position aléatoire
        previousPosition = position.get(); // Attention à bien copier le PVector avec la méthode 'get()';
        angle = random(2 * PI); // Angle aléatoire
        stepSize = 1;
        isPositionResetWhenOutside = true;
    }

    // Un autre constructeur dont l'argument 'position' permet de spécifier une position
    Agent(PVector position)
    {
        this(); // Appel du constructeur par défaut pour initialiser tous les attributs
        this.position = position; // Mise à jour de l'attribut position avec l'argument 'position' passé au constructeur. Comme l'argument du constructeur et l'attribut ont le même nom, on identifie l'attribut en le faisant précéder de 'this.'
        previousPosition = position.get();
    }

    // Une méthode de la classe permettant de mettre à jour la position de l'agent (en fonction de son angle de déplacement actuel)
    void updatePosition() 
    {
        previousPosition = position.get(); // Sauvegarde de la position précédente
        position.x += cos(angle) * stepSize; // L'agent avance sur une distance égale à 'stepSize' à partir de sa position actuelle, selon un angle 'angle'
        position.y += sin(angle) * stepSize;
        if (isPositionResetWhenOutside && isOutsideSketch() > 0) 
        {
            position = new PVector(random(width), random(height)); // Si l'agent sort du sketch, on lui attribue une nouvelle position aléatoire
            previousPosition = position.get();
        }
    }
    
    // Une méthode permettant de vérifier si l'agent est sorti des limites de l'espace du sketch (+ marges)
    // La méthode renvoie les valeurs suivantes :
    // 0: l'agent n'est pas sorti des limites de l'espace du sketch
    // 1: l'agent est sorti par le haut
    // 2: l'agent est sorti par la droite
    // 3: l'agent est sorti par le bas
    // 4: l'agent est sorti par la gauche
    int isOutsideSketch()
    {
        if (position.y < 0) 
        {
            return 1;
        } 
        else if (position.x > width) 
        {
            return 2;
        } 
        else if (position.y > height)
        {
            return 3;
        }
        else if (position.x < 0)
        {
            return 4;
        } 
        else
        {
            return 0;
        }
    }
}