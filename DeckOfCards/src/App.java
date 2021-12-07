import javafx.application.Application;
import javafx.fxml.FXMLLoader;
import javafx.scene.*;
import javafx.stage.*;

public class App extends Application {

  @Override
  public void start(Stage stage) throws Exception {

    FXMLLoader loader = new FXMLLoader(getClass().getResource("/ui/AppView.fxml"));

    Group root = new Group();
    root.getChildren().add(loader.load());
    Scene scene = new Scene(root, 640, 480);
    stage.setTitle("Deck of Cards");
    
    stage.setScene(scene);
    stage.show();
  }
  public static void main(String[] args) throws Exception {
    launch(args);
  }
}