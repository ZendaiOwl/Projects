import java.awt.image.BufferedImage;
import java.net.URL;
import javax.imageio.ImageIO;

public class Diamonds {
  private BufferedImage ace,two,three,four,five,six,seven,eight,nine,ten,jack,queen,king;
  private String ACE = ("/images/diamonds1.png");
  private String TWO = ("images/diamonds2.png");
  private String THREE = ("images/diamonds3.png");
  private String FOUR = ("images/diamonds4.png");
  private String FIVE = ("images/diamonds5.png");
  private String SIX = ("images/diamonds6.png");
  private String SEVEN = ("images/diamonds7.png");
  private String EIGHT = ("images/diamonds8.png");
  private String NINE = ("images/diamonds9.png");
  private String TEN = ("images/diamonds10.png");
  private String JACK = ("images/diamonds11.png");
  private String QUEEN = ("images/diamonds12.png");
  private String KING = ("images/diamonds13.png");
  private String[] images = {ACE,TWO,THREE,FOUR,FIVE,SIX,SEVEN,EIGHT,NINE,TEN,JACK,QUEEN,KING};
  private String[] url = {TWO,THREE,FOUR,FIVE,SIX,SEVEN,EIGHT,NINE,TEN,JACK,QUEEN,KING};
  private BufferedImage[] diamondsImages = {ace,two,three,four,five,six,seven,eight,nine,ten,jack,queen,king};

  public Diamonds() {
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
      System.out.println("Diamonds Ace loaded");
    } catch (Exception e) {
      System.out.println("Error loading image 1" + e.getStackTrace());
    }

    try {
      this.two = ImageIO.read(new URL(TWO));
      System.out.println("Diamonds Two loaded");
    } catch (Exception e) {
      System.out.println("Error loading image 2" + e.getStackTrace());
    }

    try {
      this.three = ImageIO.read(new URL(THREE));
      System.out.println("Diamonds Three loaded");
    } catch (Exception e) {
      System.out.println("Error loading image 3" + e.getStackTrace());
    }

    try {
      this.four = ImageIO.read(new URL(FOUR));
      System.out.println("Diamonds Four loaded");
    } catch (Exception e) {
      System.out.println("Error loading image 4" + e.getStackTrace());
    }

    try {
      this.five = ImageIO.read(new URL(FIVE));
      System.out.println("Diamonds Five loaded");
    } catch (Exception e) {
      System.out.println("Error loading image 5" + e.getStackTrace());
    }

    try {
      this.six = ImageIO.read(new URL(SIX));
      System.out.println("Diamonds Six loaded");
    } catch (Exception e) {
      System.out.println("Error loading image 6" + e.getStackTrace());
    }

    try {
      this.seven = ImageIO.read(new URL(SEVEN));
      System.out.println("Diamonds Seven loaded");
    } catch (Exception e) {
      System.out.println("Error loading image 7" + e.getStackTrace());
    }

    try {
      this.eight = ImageIO.read(new URL(EIGHT));
      System.out.println("Diamonds Eight loaded");
    } catch (Exception e) {
      System.out.println("Error loading image 8" + e.getStackTrace());
    }

    try {
      this.nine = ImageIO.read(new URL(NINE));
      System.out.println("Diamonds Nine loaded");
    } catch (Exception e) {
      System.out.println("Error loading image 9" + e.getStackTrace());
    }
    
    try {
      this.ten = ImageIO.read(new URL(TEN));
      System.out.println("Diamonds Ten loaded");
    } catch (Exception e) {
      System.out.println("Error loading image 10" + e.getStackTrace());
    }

    try {
      this.jack = ImageIO.read(new URL(JACK));
      System.out.println("Diamonds Jack loaded");
    } catch (Exception e) {
      System.out.println("Error loading image 11" + e.getStackTrace());
    }

    try {
      this.queen = ImageIO.read(new URL(QUEEN));
      System.out.println("Diamonds Queen loaded");
    } catch (Exception e) {
      System.out.println("Error loading image 12" + e.getStackTrace());
    }

    try {
      this.king = ImageIO.read(new URL(KING));
      System.out.println("Diamonds King loaded");
    } catch (Exception e) {
      System.out.println("Error loading image 13" + e.getStackTrace());
    }
  }

  public String[] getImages() {
    return images;
  }

  public String getImage(int i) {
    return images[i];
  }

  public String getURL(int i) {
    return url[i];
  } 

  public String getAce() {
    return ACE;
  }

  public BufferedImage[] getDiamondsImages() {
    return diamondsImages;
  }

  public BufferedImage getDiamondsBufferedImage(int i) {
    return diamondsImages[i];
  }

  public static void main(String[] args) {
    new Diamonds();
  }
}
