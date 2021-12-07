import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.scene.control.Button;
import javafx.scene.image.*;
import java.util.Random;

public class Controller extends Images{
  private Images cards = new Images();
  private Random r = new Random();
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
    this.middle.setImage(cards.cards()[r.nextInt(3)+1][r.nextInt(12)]); 
  }

  @FXML
  protected void handleShuffleButtonAction(ActionEvent event) {
  }
}
