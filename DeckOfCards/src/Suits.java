/**
 * @author ZendaiOwl
 *         <p>
 *         <li>Clubs = 1</li>
 *         <li>Diamonds = 2</li>
 *         <li>Hearts = 3</li>
 *         <li>Spades = 4</li>
 *         </p>
 */
enum Suits {
  CLUBS(1) {
    @Override
    public String toString() {
      return "Clubs";
    }
  },
  DIAMONDS(2) {
    @Override
    public String toString() {
      return "Diamonds";
    }
  },
  HEARTS(3) {
    @Override
    public String toString() {
      return "Hearts";
    }
  },
  SPADES(4) {
    @Override
    public String toString() {
      return "Spades";
    }
  };

  public abstract String toString();

  private final int suit;

  Suits(int i) {
    this.suit = i;
  }

  /**
   * @return the suit
   */
  public int suit() {
    return suit;
  }
  /**
   * @param i Suits value as an integer
   * @return The Suits enum value as specified by the parameter
   */
  public static Suits thesuit(int i) {
    Suits suit = Suits.values()[i-1];
    return suit;
  }
}
