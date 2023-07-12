package advent.of.code.days.day02;

import java.io.File;
import java.util.Scanner;

public class Day02 {

  private static final int ROCK = 1, PAPER = 2, SCISSOR = 3, LOST = 0, DRAW = 3, WIN = 6;
  private static final String[] firstChoices = {"A", "B", "C"}, 
  secondChoices = {"X", "Y", "Z"}, choices = { "Rock", "Paper", "Scissors" }, outcomes = {"LOSE", "DRAW", "WIN"};
  private static final String TXTFile = "./app/src/main/java/advent/of/code/days/day02/input.txt", SPACE = " ";
  private static File inputTXT;
  private static int SCORE, WINS, LOSSES, DRAWS;

  public static void solvePart1() {
    try {
      inputTXT = new File(TXTFile);
    } catch (Exception e) {
      System.err.println(e);
    }
    try {
      Scanner sc = new Scanner(inputTXT);
        while(sc.hasNextLine()) {
          String[] letters = sc.nextLine().split(SPACE);
          checkScorePart1(letters[0], letters[1]);
        }
      sc.close();
      System.out.println("Total score: " + SCORE + "\nWins: " + WINS + "\nLosses: " + LOSSES + "\nDraws: " + DRAWS);
    } catch(Exception e) {
      System.err.println(e);
    }
  }

  public static void checkScorePart1(String firstLetter, String secondLetter) {
    int playerChoice;
    String elf, player;
    if (firstLetter.compareTo(firstChoices[0]) == 0) {
      elf = choices[0];
    } else if(firstLetter.compareTo(firstChoices[1]) == 0) {
      elf = choices[1];
    } else {
      elf = choices[2];
    }
    if (secondLetter.compareTo(secondChoices[0]) == 0) {
      playerChoice = ROCK;
      player = choices[0];
    } else if (secondLetter.compareTo(secondChoices[1]) == 0) {
      playerChoice = PAPER;
      player = choices[1];
    } else {
      playerChoice = SCISSOR;
      player = choices[2];
    }
    if (elf.equals(player)) {
      SCORE += playerChoice + DRAW;
      DRAWS += 1;
    } else if (elfWins(elf, player)) {
      SCORE += playerChoice + LOST;
      LOSSES += 1;
    } else {
      SCORE += playerChoice + WIN;
      WINS += 1;
    }
  }

  static boolean elfWins(String elf, String player) {
    if (elf.equals("Rock")) {
      return player.equals("Scissors");
    } else if (elf.equals("Paper")) {
      return player.equals("Rock");
    } else {
      return player.equals("Paper");
    }
  }

  public static void solvePart2() {
    try {
      inputTXT = new File(TXTFile);
    } catch (Exception e) {
      System.err.println(e);
    }
    try {
      Scanner sc = new Scanner(inputTXT);
      while (sc.hasNextLine()) {
        String[] letters = sc.nextLine().split(SPACE);

      }
      sc.close();
    } catch (Exception e) {
      System.err.println(e);
    }
  }

  public static void checkScorePart2(String first, String second) {
    String elf, player;
    if (first.compareTo(firstChoices[0]) == 0) {
      elf = choices[0];
    } else if (first.compareTo(firstChoices[1]) == 0) {
      elf = choices[1];
    } else {
      elf = choices[2];
    }
    if (second.compareTo(secondChoices[0]) == 0) {
      player = outcomes[0];
    } else if (second.compareTo(secondChoices[1]) == 0) {
      player = outcomes[1];
    } else {
      player = outcomes[2];
    }
  }

  public static void main(String[] args) {
    solvePart1();
    solvePart2();
  }
}
