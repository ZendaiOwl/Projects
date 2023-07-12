package com.example.appexam1;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AlertDialog;
import androidx.recyclerview.widget.RecyclerView;

import android.content.Context;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;

import com.example.appexam1.data.model.Model;
import com.example.appexam1.databinding.FragmentFoodItemBinding;
import com.example.appexam1.data.model.Model.foodItem;

import java.util.ArrayList;
import java.util.Locale;

/**
 * {@link RecyclerView.Adapter} that can display a {@link foodItem}.
 */
public class MyFoodRecyclerViewAdapter extends RecyclerView.Adapter<RecyclerView.ViewHolder> {

    private final ArrayList<foodItem> allFoodItems;
    private static final String TAG = "FoodRecyclerViewAdapter";
    Context dContext;
    int totTypes;
    int qTotal;

    public static class ImageTypeViewHolder extends RecyclerView.ViewHolder {

        TextView txtType, txtContent, txtQuantity, txtPrice;
        ImageView image;
        Button btnIncrement, btnDecrement, btnAddToOrder;

        public ImageTypeViewHolder(View itemView)  {
            super(itemView);
            this.txtType = itemView.findViewById(R.id.type);
            this.image = itemView.findViewById(R.id.food_image);
            this.txtContent = itemView.findViewById(R.id.txt_content);
            this.txtQuantity = itemView.findViewById(R.id.textView_quantity);
            this.txtPrice = itemView.findViewById(R.id.textView_price);
            this.btnIncrement = itemView.findViewById(R.id.button_increment);
            this.btnDecrement = itemView.findViewById(R.id.button_decrement);
            this.btnAddToOrder = itemView.findViewById(R.id.button_add_to_order);
            Log.d(TAG,"Init itemView");
        }
        public String getTxtPrice() {
            return this.txtPrice.getText().toString();
        }
    }

    public MyFoodRecyclerViewAdapter(ArrayList<foodItem> items, Context context) {
        this.allFoodItems = items;
        this.dContext = context;
        this.totTypes = items.size();
        this.qTotal = 0;
    }

    @NonNull
    @Override
    public RecyclerView.ViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View view;
        view = LayoutInflater.from(parent.getContext()).inflate(R.layout.image_type, parent, false);
        return new ImageTypeViewHolder(view.getRootView());

    }

    /**
     * Called by RecyclerView to display the data at the specified position. This method should
     * update the contents of the {@link ViewHolder#itemView} to reflect the item at the given
     * position.
     * <p>
     * Note that unlike {@link ListView}, RecyclerView will not call this method
     * again if the position of the item changes in the data set unless the item itself is
     * invalidated or the new position cannot be determined. For this reason, you should only
     * use the <code>position</code> parameter while acquiring the related data item inside
     * this method and should not keep a copy of it. If you need the position of an item later
     * on (e.g. in a click listener), use {@link ViewHolder#getBindingAdapterPosition()} which
     * will have the updated adapter position.
     * <p>
     *
     * @param holder   The ViewHolder which should be updated to represent the contents of the
     *                 item at the given position in the data set.
     * @param position The position of the item within the adapter's data set.
     */
    @Override
    public void onBindViewHolder(@NonNull final RecyclerView.ViewHolder holder, final int position) {
        Log.d(TAG,"ViewHolder binds.");
        Model.foodItem obj = allFoodItems.get(position);
        ((ImageTypeViewHolder) holder).txtType.setText(obj.title);
        ((ImageTypeViewHolder) holder).image.setImageResource(obj.data);
        ((ImageTypeViewHolder) holder).txtContent.setText(obj.content);
        ((ImageTypeViewHolder) holder).txtQuantity.setText(obj.getQuantity());
        ((ImageTypeViewHolder) holder).txtPrice.setText(obj.price);
        ((ImageTypeViewHolder) holder).btnIncrement.setOnClickListener(increase -> {
            int val = 0;
            try {
                val = Integer.parseInt(((ImageTypeViewHolder) holder).txtQuantity.getText().toString());
            } catch (Exception e) { e.printStackTrace(); }
            ++val;
            ((ImageTypeViewHolder) holder).txtQuantity.setText(String.valueOf(val));
            this.qTotal = val;
        });
        ((ImageTypeViewHolder) holder).btnDecrement.setOnClickListener(decrease -> {
            int val = 0;
            try {
                val = Integer.parseInt(((ImageTypeViewHolder) holder).txtQuantity.getText().toString());
            } catch (Exception e) { e.printStackTrace(); }
            if (val > 0) {
                --val;
                ((ImageTypeViewHolder) holder).txtQuantity.setText(String.valueOf(val));
                this.qTotal = val;
            }
        });
        ((ImageTypeViewHolder) holder).btnAddToOrder.setOnClickListener(order -> {
            this.qTotal = Integer.parseInt(((ImageTypeViewHolder) holder).txtQuantity.getText().toString());
            // 1. Instantiate an <code><a href="/reference/android/app/AlertDialog.Builder.html">AlertDialog.Builder</a></code> with its constructor
            AlertDialog.Builder builder = new AlertDialog.Builder(order.getContext());
            // 2. Chain together various setter methods to set the dialog characteristics
            builder.setMessage(genOrder(obj.getFoodItemTitle(),((ImageTypeViewHolder) holder).getTxtPrice()))
                    .setTitle(R.string.dialog_title);
            // 3. Get the <code><a href="/reference/android/app/AlertDialog.html">AlertDialog</a></code> from <code><a href="/reference/android/app/AlertDialog.Builder.html#create()">create()</a></code>
            AlertDialog dialog = builder.create();
            dialog.show();
        });
    }

    private String genOrder(String item, String thePrice) {
        String priceMessage = item + "\n";
        priceMessage += "Antal: " + this.qTotal + "\n";
        priceMessage += "\nPris: €" + thePrice;
        if (this.qTotal > 0) {
            double newTotal;
            newTotal = (Double.parseDouble(thePrice) * this.qTotal);
            priceMessage += "\nAtt betala: €" + String.format(Locale.getDefault(),"%.2f",newTotal);
        } else {
            priceMessage += "\nAtt betala: €0";
        }
        priceMessage += "\n\nTack för din beställning!";
        Model.setOrderMsg(priceMessage);
        return Model.orderMsg;
    }

    @Override
    public int getItemCount() {
        return this.allFoodItems.size();
    }

    public static class ViewHolder extends RecyclerView.ViewHolder {
        public final TextView modelTxtViewId, modelTxtViewContent, modelTxtViewQuantity, modelTxtViewPrice;
        public final ImageView modelImageView;
        public final Button modelIncrementBtn, modelDecrementBtn, modelAddToOrderBtn;

        public ViewHolder(FragmentFoodItemBinding binding) {
            super(binding.getRoot());
            Log.d(TAG,"Binding ViewHolder");
            modelTxtViewId = binding.foodItemNumber;
            modelImageView = binding.imageViewFoodItem;
            modelTxtViewContent = binding.txtViewContent;
            modelTxtViewQuantity = binding.txtViewQuantityFoodItem;
            modelTxtViewPrice = binding.textViewFoodItemPrice;
            modelIncrementBtn = binding.increment;
            modelDecrementBtn = binding.decrement;
            modelAddToOrderBtn = binding.btnAddToOrder;
            modelAddToOrderBtn.setOnClickListener(order -> Model.setQuant(Integer.parseInt(modelTxtViewQuantity.getText().toString())));
        }

        @NonNull
        @Override
        public String toString() {
            return super.toString() + " '" + modelTxtViewContent.getText() + "'";
        }
    }
}