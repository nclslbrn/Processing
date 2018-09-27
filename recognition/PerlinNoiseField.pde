class PerlinNoiseField {

    float fieldIntensity;
    float noiseScale;

    PerlinNoiseField(float fieldIntensity, float noiseScale)  {
        this.fieldIntensity = fieldIntensity;
        this.noiseScale = noiseScale;
    }


    float getNoiseValue(PVector position) {
        return noise(position.x / noiseScale, position.y / noiseScale) * fieldIntensity;
    }
}
