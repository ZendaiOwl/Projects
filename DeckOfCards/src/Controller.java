import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.scene.control.Button;
import javafx.scene.image.ImageView;

public class Controller extends Images{
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
    middle.setImage(super.cards()[0][0]); 
  }

  @FXML
  protected void handleShuffleButtonAction(ActionEvent event) {
  }
}
