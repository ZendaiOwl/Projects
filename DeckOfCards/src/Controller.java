import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.scene.control.Button;
import javafx.scene.image.Image;
import javafx.scene.image.ImageView;
import javafx.scene.text.Text;
import java.awt.*;
import java.io.*;

import javax.imageio.ImageReader;

public class Controller {
  @FXML 
  private ImageView left;
  @FXML
  private ImageView middle;
  @FXML
  private ImageView right;
  @FXML 
  private Button dealButton;  
  @FXML 
  private Button shuffleButton;
  @FXML 
  private Button resetButton;
  @FXML 
  private ImageView display;
  @FXML 
  private ImageView deckImageView;
  @FXML 
  private ImageView cardImageView;
  @FXML
  protected void handleDealButtonAction(ActionEvent event) {
    File img = new File("/images/diamonds1.png");
    Image image = new Image(img.toURI().toString());
    middle.setImage(image);

  }

  @FXML
  protected void handleShuffleButtonAction(ActionEvent event) {
  }
}
