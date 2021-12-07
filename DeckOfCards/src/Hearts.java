import javax.imageio.*;
import java.awt.image.BufferedImage;
import java.net.URL;

public class Hearts {
  private BufferedImage ace, two, three, four, five, six, seven, eight, nine, ten, jack, queen, king;
  private String ACE = ("images/hearts1.png");
  private String TWO = ("images/hearts2.png");
  private String THREE = ("images/hearts3.png");
  private String FOUR = ("images/hearts4.png");
  private String FIVE = ("images/hearts5.png");
  private String SIX = ("images/hearts6.png");
  private String SEVEN = ("images/hearts7.png");
  private String EIGHT = ("images/hearts8.png");
  private String NINE = ("images/hearts9.png");
  private String TEN = ("images/hearts10.png");
  private String JACK = ("images/hearts11.png");
  private String QUEEN = ("images/hearts12.png");
  private String KING = ("images/hearts13.png");
  private String[] images = {ACE, TWO, THREE, FOUR, FIVE, SIX, SEVEN, EIGHT, NINE, TEN, JACK, QUEEN, KING};
  private BufferedImage[] heartsImages = { ace, two, three, four, five, six, seven, eight, nine, ten, jack, queen,
      king };

  public Hearts() {
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
      System.out.println("Hearts Ace loaded");
    } catch (Exception e) {
      System.out.println("Error loading image 1" + e.getStackTrace());
    }
    try {
      this.two = ImageIO.read(new URL(TWO));
      System.out.println("Hearts Two loaded");
    } catch (Exception e) {
      System.out.println("Error loading image 2" + e.getStackTrace());
    }
    try {
      this.three = ImageIO.read(new URL(THREE));
      System.out.println("Hearts Three loaded");
    } catch (Exception e) {
      System.out.println("Error loading image 3" + e.getStackTrace());
    }
    try {
      this.four = ImageIO.read(new URL(FOUR));
      System.out.println("Hearts Four loaded");
    } catch (Exception e) {
      System.out.println("Error loading image 4" + e.getStackTrace());
    }
    try {
      this.five = ImageIO.read(new URL(FIVE));
      System.out.println("Hearts Five loaded");
    } catch (Exception e) {
      System.out.println("Error loading image 5" + e.getStackTrace());
    }
    try {
      this.six = ImageIO.read(new URL(SIX));
      System.out.println("Hearts Six loaded");
    } catch (Exception e) {
      System.out.println("Error loading image 6" + e.getStackTrace());
    }
    try {
      this.seven = ImageIO.read(new URL(SEVEN));
      System.out.println("Hearts Seven loaded");
    } catch (Exception e) {
      System.out.println("Error loading image 7" + e.getStackTrace());
    }
    try {
      this.eight = ImageIO.read(new URL(EIGHT));
      System.out.println("Hearts Eight loaded");
    } catch (Exception e) {
      System.out.println("Error loading image 8" + e.getStackTrace());
    }
    try {
      this.nine = ImageIO.read(new URL(NINE));
      System.out.println("Hearts Nine loaded");
    } catch (Exception e) {
      System.out.println("Error loading image 9" + e.getStackTrace());
    }
    try {
      this.ten = ImageIO.read(new URL(TEN));
      System.out.println("Hearts Ten loaded");
    } catch (Exception e) {
      System.out.println("Error loading image 10" + e.getStackTrace());
    }
    try {
      this.jack = ImageIO.read(new URL(JACK));
      System.out.println("Hearts Jack loaded");
    } catch (Exception e) {
      System.out.println("Error loading image 11" + e.getStackTrace());
    }
    try {
      this.queen = ImageIO.read(new URL(QUEEN));
      System.out.println("Hearts Queen loaded");
    } catch (Exception e) {
      System.out.println("Error loading image 12" + e.getStackTrace());
    }
    try {
      this.king = ImageIO.read(new URL(KING));
      System.out.println("Hearts King loaded");
    } catch (Exception e) {
      System.out.println("Error loading image 13" + e.getStackTrace());
    }
  }

  public BufferedImage[] getHeartsImages() {
    return heartsImages;
  }

  public BufferedImage getHeartsImage(int i) {
    return heartsImages[i];
  }

  public String getImage(int i) {
    return images[i];
  }

  public String[] getImages() {
    return images;
  }
  
  public static void main(String[] args) {
    new Hearts();
  }
}
