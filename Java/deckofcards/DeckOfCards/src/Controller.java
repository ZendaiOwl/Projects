import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.scene.control.*;
import javafx.scene.image.*;
import java.util.Random;

public class Controller {
  private Images cards = new Images();
  private Random r = new Random();
  private int suits = 0;
  private int ranks = 0;
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
  protected void handleShuffleButtonAction(ActionEvent event) {
    this.left.setImage(cards.cards()[this.r.nextInt(3)][this.r.nextInt(12)]);
    this.middle.setImage(cards.cards()[this.r.nextInt(3)][this.r.nextInt(12)]);
    this.right.setImage(cards.cards()[this.r.nextInt(3)][this.r.nextInt(12)]);
  }
  @FXML
  protected void handleDealButtonAction(ActionEvent event) {
    if (ranks < 13 && suits < 3) {
      this.left.setImage(cards.cards()[this.suits][this.ranks++]);
      if(ranks < 13){
        this.middle.setImage(cards.cards()[this.suits][this.ranks++]);
        if(ranks < 13){
          this.right.setImage(cards.cards()[this.suits][this.ranks++]);
        }else if(!(ranks < 13)){
          this.suits++;
          this.ranks = 0;
          this.right.setImage(cards.cards()[this.suits][this.ranks++]);
        }
      }else if(!(ranks < 13)) {
        this.suits++;
        this.ranks = 0;
        this.middle.setImage(cards.cards()[this.suits][this.ranks++]);
        this.right.setImage(cards.cards()[this.suits][this.ranks++]);
        }
      }
      else{
        this.ranks = 0;
        this.suits = 0;
        this.left.setImage(cards.cards()[this.suits][this.ranks++]);
        this.middle.setImage(cards.cards()[this.suits][this.ranks++]);
        this.right.setImage(cards.cards()[this.suits][this.ranks++]);
      }
  }
}
