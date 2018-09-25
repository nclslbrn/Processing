// Paramètres
int agentCount = 1000;
float agentSize = 1.5;
float agentAlpha = 90;
float fieldIntensity = 0.005;

// Variables
ImageField field;
ArrayList<Agent> agents;

void setup() 
{
    size(800, 800);
    smooth();
    background(255);
    field = new ImageField(fieldIntensity, "xblur.jpg"); // Conseil : placer les images dans le répertoire 'data' et donner les chemins d'accès aux images de manière relative à ce répertoire, ce qui revient à simplement donner le nom du fichier image.
    agents = new ArrayList<Agent>();
    for (int i = 0; i < agentCount; i++)
    {
        Agent a = new Agent();
        agents.add(a);
    }
}

void draw() 
{
    for (Agent a : agents)
    {
        a.angle = field.getBrightness(a.position); // Utilisation de la luminosité de l'image à la position de l'agent comme nouvelle valeur de l'angle
        a.updatePosition();
    }
    stroke(0, agentAlpha);
    strokeWeight(agentSize);
    for (Agent a : agents)
    {
        line(a.previousPosition.x, a.previousPosition.y, a.position.x, a.position.y);
    }
}