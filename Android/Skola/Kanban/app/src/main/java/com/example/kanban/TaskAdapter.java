package com.example.kanban;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.DiffUtil;
import androidx.recyclerview.widget.ListAdapter;
import android.content.Context;
import android.content.Intent;
import android.util.Log;
import android.view.ViewGroup;

/**
 * {@link TaskAdapter} that can display a {@link Task}.
 */
class TaskAdapter extends ListAdapter<Task, ViewHolder> {

    private final Context context; // Holds the context from the MainActivity

    public TaskAdapter(Context context) {
        super(DIFF_CALLBACK);
        this.context = context;
    }

    /**
     * @param parent ViewGroup of the item Views
     * @param viewType ViewType of the item Views
     * @return new ViewHolder using the static method in ViewHolder class inflated with the item layout
     */
    @NonNull
    @Override
    public ViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        return ViewHolder.create(parent);
    }

    /**
     * @param holder The newly created ViewHolder with the item Views ViewGroup
     * @param position The position of the Task in the LiveData Task list
     */
    @Override
    public void onBindViewHolder(final ViewHolder holder, int position) {
        Task current = getItem(position); // Gets the Task at the indicated position
        holder.bind(current); // Binds the Task data to the ViewHolder ViewGroup views
        /* Creates the OnClickListener for when the item is clicked in the recyclerview */
        holder.cardView.setOnClickListener(click -> {
            Log.d("CardView","Recycle view item was clicked");
            // Creates the intent for EditTaskActivity
            Intent editIntent = new Intent(this.context, EditTaskActivity.class);
            editIntent.putExtra("POSITION",holder.getAbsoluteAdapterPosition());
            editIntent.putExtra("KEY",current.getKey());
            editIntent.putExtra("TITLE",current.getTitle());
            editIntent.putExtra("INFO",current.getInfo());
            editIntent.putExtra("STATUS",current.getStatus());
            editIntent.putExtra("TIME",current.getTime());
            // Launches the EditTaskActivty using the static method in MainActivity
            MainActivity.intentLauncher.launch(editIntent);
        });
    }

    /**
     * A DiffUtil.ItemCallback
     * This method is used by the adapter to differentiate between
     * the Task items in the LiveData Task list
     */
    public static final DiffUtil.ItemCallback<Task> DIFF_CALLBACK =
        new DiffUtil.ItemCallback<Task>() {
            @Override
            public boolean areItemsTheSame(@NonNull Task oldItem, @NonNull Task newItem) {
                return oldItem == newItem;
            }

            @Override
            public boolean areContentsTheSame(@NonNull Task oldItem, @NonNull Task newItem) {
                StringBuilder oldKey = new StringBuilder(oldItem.toString());
                StringBuilder oldTitle = new StringBuilder(oldItem.getTitle());
                StringBuilder oldInfo = new StringBuilder(oldItem.getInfo());
                StringBuilder oldStatus = new StringBuilder(oldItem.getStatus());
                StringBuilder newKey = new StringBuilder(newItem.getKey());
                StringBuilder newTitle = new StringBuilder(newItem.getTitle());
                StringBuilder newInfo = new StringBuilder(newItem.getInfo());
                StringBuilder newStatus = new StringBuilder(newItem.getStatus());
                if (!oldKey.toString().equals(newKey.toString())) {
                    return false;
                } else if (!oldTitle.toString().equals(newTitle.toString())) {
                    return false;
                } else if (!oldInfo.toString().equals(newInfo.toString())) {
                    return false;
                } else return !oldStatus.toString().equals(newStatus.toString());
            }
        };
}