import java.awt.image.BufferedImage;
import javafx.scene.image.Image;

public class Images {
  private final int RANKS = 13;
  private Clubs clubImage;
  private Diamonds diamondImage;
  private Hearts heartImage;
  private Spades spadeImage;
  private Image[] diamonds, clubs, hearts, spades;
  private Image[][] cards;
  public Images(){
    this.clubImage = new Clubs();
    this.diamondImage = new Diamonds();
    this.heartImage = new Hearts();
    this.spadeImage = new Spades();
    this.diamonds = new Image[RANKS];
    this.clubs = new Image[RANKS];
    this.hearts = new Image[RANKS];
    this.spades = new Image[RANKS];
    for(int i = 0; i < RANKS; i++){
      this.diamonds[i] = new Image(diamondImage.getURL(i));
      this.clubs[i] = new Image(clubImage.getImage(i));
      this.hearts[i] = new Image(heartImage.getImage(i));
      this.spades[i] = new Image(spadeImage.getImage(i));
    }
    this.cards = new Image[][]{this.diamonds, this.clubs, this.hearts, this.spades};
    
  }
  public Clubs getClubImage(){
    return clubImage;
  }
  public BufferedImage[] getClubImages(){
    return clubImage.getClubsImages();
  }
  public Diamonds getDiamondImage(){
    return diamondImage;
  }
  public BufferedImage[] getDiamondImages(){
    return diamondImage.getDiamondsImages();
  }
  public Hearts getHeartImage(){
    return heartImage;
  }
  public BufferedImage[] getHeartImages(){
    return heartImage.getHeartsImages();
  }
  public Spades getSpadeImage(){
    return spadeImage;
  }
  public BufferedImage[] getSpadeImages(){
    return spadeImage.getSpadesImages();
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
  public static void main(String[] args){
    new Images();
  }
}
