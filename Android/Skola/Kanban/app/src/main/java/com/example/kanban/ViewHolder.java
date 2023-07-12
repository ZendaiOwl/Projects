package com.example.kanban;

import android.content.Context;
import android.graphics.Color;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;
import androidx.cardview.widget.CardView;
import androidx.recyclerview.widget.RecyclerView;

class ViewHolder extends RecyclerView.ViewHolder {
  private final TextView taskItemTitleView, taskItemInfoView, taskItemStatusView, taskItemTimeView;
  public final CardView cardView;
  /*
   * Holds the Status text in final String variables, since these don't change,
   * this makes it a little easier to read in the bind method
   */
  public static final String NOT_STARTED = "Not started", ONGOING = "Ongoing", COMPLETED = "Completed";

  /**
   * Initiates the ViewHolder after the static create(ViewGroup parent) method has been called
   * and returned an inflated View
   * @param itemView The View to assign the ViewHolder variables to by the View ID
   */
  public ViewHolder(View itemView) {
    super(itemView);
    this.cardView = itemView.findViewById(R.id.item_cardview);
    this.taskItemTitleView = itemView.findViewById(R.id.item_title);
    this.taskItemInfoView = itemView.findViewById(R.id.item_info);
    this.taskItemStatusView = itemView.findViewById(R.id.item_status);
    this.taskItemTimeView = itemView.findViewById(R.id.item_time);
  }

  /**
   * This method binds the data from the Task to the Views displaying the data in the recyclerview
   * @param task The Task to have it's data bound to the ViewGroup View's fields
   */
  public void bind(Task task) {
    this.taskItemTitleView.setText(task.getTitle());
    this.taskItemInfoView.setText(task.getInfo());
    this.taskItemStatusView.setText(task.getStatus());
    if (task.getStatus().equals(COMPLETED)) {
      taskItemStatusView.setTextColor(Color.GREEN);
    } else if (task.getStatus().equals(ONGOING)) {
      taskItemStatusView.setTextColor(Color.YELLOW);
    } else {
      taskItemStatusView.setTextColor(Color.WHITE);
    }
    taskItemTimeView.setText(task.getTime());
  }

  /**
   * A static method used to create new Task ViewHolders
   * @param parent The item ViewGroup views being sent from TaskAdapter
   * @return The inflated Task item layout ViewHolder
   */
  static ViewHolder create(ViewGroup parent) {
    Context context = parent.getContext();
    LayoutInflater inflater = LayoutInflater.from(context);
    View view = inflater.inflate(R.layout.item, parent, false);
    return new ViewHolder(view);
  }

}
