package com.example.appexam1.data.model;
import android.util.Log;
import androidx.annotation.NonNull;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
public class Model {

    public static final ArrayList<foodItem> ITEMS = new ArrayList<>();
    public static final Map<String, foodItem> ITEM_MAP = new HashMap<>();
    public static int quant;
    public static String orderMsg;

    public static void addItem(foodItem item) {
        ITEMS.add(item);
        ITEM_MAP.put(item.id, item);
    }

    public static void setOrderMsg(String msg) { orderMsg = msg; }

    public static void setQuant(int q) { quant = q; }

    public static foodItem createItem(int position, String title, String content, int data, String price) {
        return new foodItem(String.valueOf(position),title, content, data,0, price);
    }

    public static class foodItem {
        public static final int IMAGE_TYPE = 1;
        private static final String TAG = "foodItem";
        public int type, data, quantity;
        public String id, title, content, price;

        public String getFoodItemTitle() { return this.title; }
        public String getQuantity() { return String.valueOf(this.quantity); }

        public foodItem(String id, String title, String content, int data, int quantity, String price) {
            Log.d(TAG,"Creating foodItem object");
            this.type = IMAGE_TYPE;
            this.id = id;
            this.title = title;
            this.content = content;
            this.data = data;
            this.quantity = quantity;
            this.price = price;
        }
        @NonNull
        @Override
        public String toString() {
            return this.content;
        }
    }

}
