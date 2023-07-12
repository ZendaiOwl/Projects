package advent.of.code.days.day01;

import java.io.File;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Scanner;

public class Day01 {
  private final static String TXTFile = "./app/src/main/java/advent/of/code/days/day01/input.txt";
  private static File inputTXT;
  public static void getLargestAmountOfCalories() {
    try {
      inputTXT = new File(TXTFile);
    } catch(Exception e) {
      System.err.println(e);
    }
    int largestAmountOfCalories = 0;
    try {
      Scanner sc = new Scanner(inputTXT);
      int count = 0, elf = 0;
      while (sc.hasNextLine()) {
        String line = sc.nextLine();
        int calories = 0;
        count++;
        while(!line.equals("") && sc.hasNextLine()) {
          calories += Integer.parseInt(line);
          line = sc.nextLine();
        }
        if(calories > largestAmountOfCalories) {
          largestAmountOfCalories = calories;
          elf = count;
        }
      }
      System.out.println("Largest amount of calories: " + largestAmountOfCalories + "\n" +
          "Carried by Elf: " + elf + "\n");
      sc.close();
    } catch (Exception e) {
      System.err.println(e);
    }
  }

  public static void getTopThreeElvesCaloriesCount() {
    ArrayList<Integer> allCalories = new ArrayList<>();
    try {
      inputTXT = new File(TXTFile);
    } catch(Exception e) {
      System.err.println(e);
    }
    try {
      Scanner sc = new Scanner(inputTXT);
        while(sc.hasNextLine()) {
          int calories = 0;
          String line = sc.nextLine();
            while(!line.equals("") && sc.hasNextLine()) {
              calories += Integer.parseInt(line);
              line = sc.nextLine();
            }
            allCalories.add(calories);
        }
      sc.close();
      Collections.sort(allCalories);
      int size = (allCalories.size() - 1);
      int calculatedCaloriesTop3 = (allCalories.get(size) + allCalories.get(size-1) + allCalories.get(size-2));
      System.out.println("Calories count for the top 3 Elves: " + calculatedCaloriesTop3 + "\n");
    } catch (Exception e) {
      System.err.println(e);
    }
  }

  public static void main(String[] args) {
    getLargestAmountOfCalories();
    getTopThreeElvesCaloriesCount();
  }
}
