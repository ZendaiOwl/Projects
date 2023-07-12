package com.example.appexam1;
import androidx.appcompat.app.AlertDialog;
import androidx.appcompat.app.AppCompatActivity;
import androidx.recyclerview.widget.DefaultItemAnimator;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import android.os.Bundle;
import android.util.Log;
import com.example.appexam1.data.model.Model;
import com.example.appexam1.data.model.Model.foodItem;
import com.example.appexam1.databinding.ActivityMainBinding;
import com.google.android.material.floatingactionbutton.FloatingActionButton;
public class MainActivity extends AppCompatActivity {

    private ActivityMainBinding binding;
    private RecyclerView recyclerView;
    private String TAG;
    private FloatingActionButton order;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        this.binding = ActivityMainBinding.inflate(getLayoutInflater());
        this.recyclerView = this.binding.recyclerView;
        setContentView(this.binding.getRoot());
        initItems();
        Log.d(TAG,"Init main activity");
        MyFoodRecyclerViewAdapter adapter = new MyFoodRecyclerViewAdapter(Model.ITEMS, this);
        LinearLayoutManager linearLayoutManager = new LinearLayoutManager(this, RecyclerView.VERTICAL, false);
        this.recyclerView = findViewById(R.id.recyclerView);
        this.recyclerView.setLayoutManager(linearLayoutManager);
        this.recyclerView.setItemAnimator(new DefaultItemAnimator());
        this.recyclerView.setAdapter(adapter);
        this.order.setOnClickListener(createOrder -> {
            AlertDialog.Builder builder = new AlertDialog.Builder(this.recyclerView.getContext());
            if (Model.orderMsg != null) {
                builder.setMessage(Model.orderMsg)
                        .setTitle(R.string.dialog_title);
            } else {
                builder.setMessage("Ingen beställning")
                        .setTitle(R.string.dialog_title);
            }
            AlertDialog dialog = builder.create();
            dialog.show();
        });
    }

    private void initItems() {
        this.TAG = getString(R.string.TAG_main_activity);
        this.order = this.binding.btnOrder;
        Log.d(TAG,"Creating food items");
        foodItem firstOne = Model.createItem(1,
                getString(R.string.TITLE_chicken_salad),
                getString(R.string.CONTENT_chicken_salad),
                R.drawable.sandwich_with_chicken_salad,
                getString(R.string.PRICE_chicken_salad));

        foodItem secondOne = Model.createItem(2,
                getString(R.string.TITLE_club_sandwich),
                getString(R.string.CONTENT_club_sandwich),
                R.drawable.club_sandwich_slice_on_white,
                getString(R.string.PRICE_club_sandwich));

        foodItem thirdOne = Model.createItem(3,
                getString(R.string.TITLE_smoked_ham),
                getString(R.string.CONTENT_smoked_ham),
                R.drawable.sandwich_with_smoked_ham_and_lettuce,
                getString(R.string.PRICE_smoked_ham));

        foodItem fourthOne = Model.createItem(4,
                getString(R.string.TITLE_panini),
                getString(R.string.CONTENT_panini),
                R.drawable.turkey__tomato__basil__spinach_and_cheese_panini,
                getString(R.string.PRICE_panini));

        Model.addItem(firstOne);
        Model.addItem(secondOne);
        Model.addItem(thirdOne);
        Model.addItem(fourthOne);
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        Log.d(TAG,"Destroy activity");
        this.order = null;
        this.recyclerView = null;
        this.binding = null;
        this.TAG = null;
    }
}

