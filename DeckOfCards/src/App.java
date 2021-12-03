import java.util.*;

import javafx.application.Application;
import javafx.fxml.FXMLLoader;
import java.net.URL;
import javafx.scene.*;
import javafx.scene.layout.StackPane;
import javafx.scene.paint.Color;
import javafx.stage.*;

public class App extends Application {

  private DeckOfCards deck = new DeckOfCards();

  @Override
  public void start(Stage stage) throws Exception {

    FXMLLoader loader = new FXMLLoader(getClass().getResource("/ui/AppView.fxml"));

    Group root = new Group();
    root.getChildren().add(loader.load());
    Scene scene = new Scene(root, 640, 480);
    stage.setScene(scene);
    stage.show();
  }
  public static void main(String[] args) throws Exception {
    launch(args);
  }
}