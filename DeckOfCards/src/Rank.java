import javafx.scene.image.Image;

/**
 * @author ZendaiOwl
 * 
 */
public enum Rank {
  ACE(1) {
    @Override
    public String toString() {
      return "Ace";
    }
  },
  DEUCE(2) {
    @Override
    public String toString() {
      return "Two";
    }
  },
  THREE(3) {
    @Override
    public String toString() {
      return "Three";
    }
  },
  FOUR(4) {
    @Override
    public String toString() {
      return "Four";
    }
  },
  FIVE(5) {
    @Override
    public String toString() {
      return "Five";
    }
  },
  SIX(6) {
    @Override
    public String toString() {
      return "Six";
    }
  },
  SEVEN(7) {
    @Override
    public String toString() {
      return "Seven";
    }
  },
  EIGHT(8) {
    @Override
    public String toString() {
      return "Eight";
    }
  },
  NINE(9) {
    @Override
    public String toString() {
      return "Nine";
    }
  },
  TEN(10) {
    @Override
    public String toString() {
      return "Ten";
    }
  },
  JACK(11) {
    @Override
    public String toString() {
      return "Jack";
    }
  },
  QUEEN(12) {
    @Override
    public String toString() {
      return "Queen";
    }
  },
  KING(13) {
    @Override
    public String toString() {
      return "King";
    }
  };

  public abstract String toString();
  private final int rank;
  
  Rank(int i) {
    this.rank = i;
  }

  /**
   * @return the rank
   */
  public int rank() {
    return rank;
  }
  /**
   * @param rank to return as Rank enum
   * @return Rank enum
   */
  public static Rank therank(int rank) {
    Rank theone = Rank.values()[rank-1];
    return theone;
  }
}
