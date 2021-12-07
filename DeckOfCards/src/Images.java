import javafx.scene.image.Image;
public class Images {
  private final int RANKS = 12;
  private Image[] diamonds, clubs, hearts, spades;
  private Image[][] cards;
  public Images(){
    this.diamonds = new Image[RANKS];
    this.clubs = new Image[RANKS];
    this.hearts = new Image[RANKS];
    this.spades = new Image[RANKS];
    for(int i = 0; i < RANKS; i++){
      this.diamonds[i] = new Image(Diamonds.images[i], true);
      this.clubs[i] = new Image(Clubs.images[i], true);
      this.hearts[i] = new Image(Hearts.images[i], true);
      this.spades[i] = new Image(Spades.images[i], true);
    }
    this.cards = new Image[][]{this.diamonds, this.clubs, this.hearts, this.spades};
  }
  public Image[] getDiamonds() {
    return diamonds;
  }

  public Image[] getClubs() {
    return clubs;
  }

  public Image[] getHearts() {
    return hearts;
  }

  public Image[] getSpades() {
    return spades;
  }

  public Image[][] cards(){
    return cards; 
  }
}
