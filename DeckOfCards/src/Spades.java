import javax.imageio.*;
import java.awt.image.BufferedImage;
import java.net.URL;

public class Spades {
  private BufferedImage ace, two, three, four, five, six, seven, eight, nine, ten, jack, queen, king;
  private String ACE = "images/spades1.png";
  private String TWO = "images/spades2.png";
  private String THREE = "images/spades3.png";
  private String FOUR = "images/spades4.png";
  private String FIVE = "images/spades5.png";
  private String SIX = "images/spades6.png";
  private String SEVEN = "images/spades7.png";
  private String EIGHT = "images/spades8.png";
  private String NINE = "images/spades9.png";
  private String TEN = "images/spades10.png";
  private String JACK = "images/spades11.png";
  private String QUEEN = "images/spades12.png";
  private String KING = "images/spades13.png";
  private String[] images = {ACE, TWO, THREE, FOUR, FIVE, SIX, SEVEN, EIGHT, NINE, TEN, JACK, QUEEN, KING};
  private BufferedImage[] spadesImages = { ace, two, three, four, five, six, seven, eight, nine, ten, jack, queen,
      king };

  public Spades() {
    this.ace = null;
    this.two = null;
    this.three = null;
    this.four = null;
    this.five = null;
    this.six = null;
    this.seven = null;
    this.eight = null;
    this.nine = null;
    this.ten = null;
    this.jack = null;
    this.queen = null;
    this.king = null;
    try {
      this.ace = ImageIO.read(new URL(ACE));
      System.out.println("Spades Ace loaded");
    } catch (Exception e) {
      System.out.println("Error loading image 1" + e.getStackTrace());
    }
    try {
      this.two = ImageIO.read(new URL(TWO));
      System.out.println("Spades Two loaded");
    } catch (Exception e) {
      System.out.println("Error loading image 2" + e.getStackTrace());
    }
    try {
      this.three = ImageIO.read(new URL(THREE));
      System.out.println("Spades Three loaded");
    } catch (Exception e) {
      System.out.println("Error loading image 3" + e.getStackTrace());
    }
    try {
      this.four = ImageIO.read(new URL(FOUR));
      System.out.println("Spades Four loaded");
    } catch (Exception e) {
      System.out.println("Error loading image 4" + e.getStackTrace());
    }
    try {
      this.five = ImageIO.read(new URL(FIVE));
      System.out.println("Spades Five loaded");
    } catch (Exception e) {
      System.out.println("Error loading image 5" + e.getStackTrace());
    }
    try {
      this.six = ImageIO.read(new URL(SIX));
      System.out.println("Spades Six loaded");
    } catch (Exception e) {
      System.out.println("Error loading image 6" + e.getStackTrace());
    }
    try {
      this.seven = ImageIO.read(new URL(SEVEN));
      System.out.println("Spades Seven loaded");
    } catch (Exception e) {
      System.out.println("Error loading image 7" + e.getStackTrace());
    }
    try {
      this.eight = ImageIO.read(new URL(EIGHT));
      System.out.println("Spades Eight loaded");
    } catch (Exception e) {
      System.out.println("Error loading image 8" + e.getStackTrace());
    }
    try {
      this.nine = ImageIO.read(new URL(NINE));
      System.out.println("Spades Nine loaded");
    } catch (Exception e) {
      System.out.println("Error loading image 9" + e.getStackTrace());
    }
    try {
      this.ten = ImageIO.read(new URL(TEN));
      System.out.println("Spades Ten loaded");
    } catch (Exception e) {
      System.out.println("Error loading image 10" + e.getStackTrace());
    }
    try {
      this.jack = ImageIO.read(new URL(JACK));
      System.out.println("Spades Jack loaded");
    } catch (Exception e) {
      System.out.println("Error loading image 11" + e.getStackTrace());
    }
    try {
      this.queen = ImageIO.read(new URL(QUEEN));
      System.out.println("Spades Queen loaded");
    } catch (Exception e) {
      System.out.println("Error loading image 12" + e.getStackTrace());
    }
    try {
      this.king = ImageIO.read(new URL(KING));
      System.out.println("Spades King loaded");
    } catch (Exception e) {
      System.out.println("Error loading image 13" + e.getStackTrace());
    }
  }

  public BufferedImage[] getSpadesImages() {
    return spadesImages;
  }

  public BufferedImage getSpadesImage(int i) {
    return spadesImages[i];
  }

  public String getImage(int i) {
    return images[i];
  }

  public String[] getImages() {
    return images;
  }

  public static void main(String[] args) {
    new Spades();
  }
}
