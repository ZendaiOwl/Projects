package cards;

/**
 * @author ZendaiOwl
 *
 */
public class Card {
  private final Suits cs;
  private final Rank cr;

  /**
   * @param suit of the card
   * @param rank of the card
   * Constructor for the Card class
   */
  public Card(int suit, int rank) {
    this.cs = Suits.thesuit(suit);
    this.cr = Rank.therank(rank);
  }
  /**
   * @return the suit as a String
   */
  public String suit() {
    return cs.toString();
  }
  /**
   * @return the suits value as an integer
   */
  public int suitValue() {
    return cs.suit();
  }
  /**
   * @return the rank as an integer
   */
  public int rankValue() {
    return cr.rank();
  }
  /**
   * @return the rank as a String
   */
  public String rank() {
    return cr.toString();
  }
  /**
   * @return the card as a String
   */
  public String card() {
    String out = cr.toString() + " of " + cs.toString();
    return out;
  }
}
