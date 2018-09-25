class ImageField
{
    float fieldIntensity; // Intensité du champ de force
    PImage image; // Fichier image (géométrie du champ de force)

    // Le constructeur permet de charger une image à partir du chemin d'accès
    // au fichier.
    ImageField(float fieldIntensity, String imagePath) 
    {
        this.fieldIntensity = fieldIntensity;
        this.image = loadImage(imagePath);
    }

    // Méthode permettant d'obtenir la luminosité de l'image à une position donnée
    float getBrightness(PVector position)
    {
        color c = getColor(position);
        return brightness(c) * fieldIntensity;
    }

    // Il peut être utile de définir également une méthode permettant d'obtenir
    // la couleur de l'image à une position donnée.
    color getColor(PVector position)
    {
        return image.get(int(position.x/width * image.width), int(position.y/height * image.height));
    }

    // Méthode permettant d'appliquer un flou à l'image
    void blur(float blurLevel)
    {
        image.filter(BLUR, blurLevel);
    }
}