package cards;

import java.util.ArrayList;
import java.util.Collections;

/**
 * @author ZendaiOwl
 *
 */
public class DeckOfCards {
  public static final int maxcards = 52;
  private ArrayList<Card> deck;
  private int currentcard;

  /**
   * Constructor : Creates the deck with all the cards in order of suits
   */
  public DeckOfCards() {
    this.currentcard = 0;
    this.deck = new ArrayList<Card>();
    for (Suits s : Suits.values()) {
      for (Rank r : Rank.values()) {
        this.deck.add(new Card(s.suit(), r.rank()));
      }
    }
  }

  /**
   * This method resets the counter for the current card
   */
  public void reset() {
    this.currentcard = 0;
  }

  /**
   * @return the integer counter for the current card
   */
  public int current() {
    return currentcard;
  }

  /**
   * @return the remaining cards as an integer value
   */
  public int remaining() {
    return maxcards - currentcard;
  }

  /**
   * @return the deck of cards as an ArrayList<Card>
   */
  public ArrayList<Card> cards() {
    return new ArrayList<Card>(deck);
  }

  /**
   * @return the deck of cards in a String array
   */
  public String[] cardS() {
    String[] out = new String[maxcards];
    for (int i = 0; i < maxcards; i++)
      out[i] = deck.get(i).card();
    return out;
  }

  /**
   * @param the card to get as a String
   * @return the specified card as a String
   */
  public String card(int i) {
    String o = deck.get(i).card() + "\n";
    return o;
  }

  /**
   * @return 1 card in a String <i>without</i> a new line included
   */
  public String deal1() {
    return deck.get(this.currentcard++).card();
  }

  /**
   * @return 2 cards in a String with a new line included per card
   */
  public String deal2() {
    String draw2 = "";
    for (int i = currentcard; i < (currentcard + 2); i++)
      draw2 += deck.get(i).card() + " \n";
    this.currentcard += 2;
    return draw2;
  }

  /**
   * @return 3 cards in a String with a new line included per card
   */
  public String deal3() {
    String draw3 = "";
    for (int c = currentcard; c < (currentcard + 3); c++)
      draw3 += deck.get(c).card() + " \n";
    this.currentcard += 3;
    return draw3;
  }

  /**
   * @return 4 cards in a String with a new line included per card
   */
  public String deal4() {
    String draw4 = "";
    for (int c = currentcard; c < (currentcard + 4); c++)
      draw4 += deck.get(c).card() + " \n";
    this.currentcard += 4;
    return draw4;
  }

  /**
   * @return 5 cards in a String with a new line included per card
   */
  public String deal5() {
    String draw5 = "";
    for (int c = currentcard; c < (currentcard + 5); c++)
      draw5 += deck.get(c).card() + " \n";
    this.currentcard += 5;
    return draw5;
  }

  /**
   * Shuffles the deck 6 times using the Collections class shuffle method
   */
  public void shuffle() {
    Collections.shuffle(this.deck);
    Collections.shuffle(this.deck);
    Collections.shuffle(this.deck);
    Collections.shuffle(this.deck);
    Collections.shuffle(this.deck);
    Collections.shuffle(this.deck);
  }

  /**
   * <tbody>
   * <p>
   * Overrides toString method to generate a String for text representation
   * </p>
   * </tbody>
   */
  @Override
  public String toString() {
    String u = "";
    for (int x = 0; x < maxcards; x++)
      if (x != 12 || x != 24 || x != 36 || x != 48)
        u += deck.get(x).card() + "\n";
      else {
        u += "\n";
        x--;
      }
    return u;
  }

  /**
   * @param args A program to test and demo the DeckOfCards class
   */
  public static void main(String[] args) {
    DeckOfCards test = new DeckOfCards();
    for (String s : test.cardS())
      System.out.println(s);
    System.out.println("\nShuffling");
    test.shuffle();
    System.out.println("\nTo String\n");
    System.out.println(test.toString());
    System.out.println("Dealing 1 card");
    System.out.println(test.deal1() + "\n");
    System.out.println("Dealing 2 cards");
    System.out.println(test.deal2());
    System.out.println("Dealing 3 cards");
    System.out.println(test.deal3());
    System.out.println("Dealing 4 cards");
    System.out.println(test.deal4());
    System.out.println("Dealing 5 cards");
    System.out.println(test.deal5());
    System.out.println("Cards remaining : " + test.remaining());
    System.out.println("Card counter : " + test.current());
  }

}
