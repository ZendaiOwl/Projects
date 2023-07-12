package com.example.kanban;

import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.os.Bundle;
import android.text.TextUtils;
import android.util.Log;
import android.widget.Button;
import android.widget.EditText;
import android.widget.RadioButton;
import android.widget.RadioGroup;
import android.widget.TextView;
import android.widget.Toast;
import java.util.Calendar;

public class EditTaskActivity extends AppCompatActivity {

  /* Variables to hold the text data in the Task fields */
  private String TITLE, INFO, STATUS, TIME;
  /* Variables to hold the Task Key and Position */
  private static int POSITION, KEY;
  /* The TAG for the EditTaskActivity logs */
  private static final String TAG = "EditTaskActivity";
  /* Variables to hold the Views/UI elements of the EditTaskActivity */
  private EditText txtTitle, txtInfo;
  private RadioGroup radioGrp;
  private RadioButton btnSelected;

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.activity_edit_task);
    Log.d(TAG, "Launched");
    Intent data = getIntent(); // Gets the Intent that launched the EditTaskActivity
    POSITION = data.getIntExtra("POSITION", -1); // Gets the Task position from the intent data
    KEY = data.getIntExtra("KEY", -1); // Gets the Task key from the intent data
    TITLE = data.getStringExtra("TITLE"); // Gets the Task title from the intent data
    INFO = data.getStringExtra("INFO"); // Gets the Task info from the intent data
    STATUS = data.getStringExtra("STATUS"); // Gets the Task status from the intent data
    TIME = data.getStringExtra("TIME"); // Gets the Task time from the intent data

    /* Initiate the Views with the data received from the intent */
    txtTitle = findViewById(R.id.edit_title);
    txtTitle.setText(TITLE);
    txtInfo = findViewById(R.id.edit_info);
    txtInfo.setText(INFO);
    TextView txtViewTime = findViewById(R.id.edit_time);
    txtViewTime.setText(TIME);

    radioGrp = findViewById(R.id.edit_task_status_group);
    RadioButton btnCompleted = findViewById(R.id.edit_status_completed);
    RadioButton btnOnGoing = findViewById(R.id.edit_status_ongoing);
    RadioButton btnNotStarted = findViewById(R.id.edit_status_not_started);
    /*
     * Sets the selected RadioButton to the same as
     * previously selected in the Task that's being edited
     */
    if (STATUS.equals("Completed")) {
      radioGrp.check(btnCompleted.getId());
    } else if (STATUS.equals("Ongoing")) {
      radioGrp.check(btnOnGoing.getId());
    } else {
      radioGrp.check(btnNotStarted.getId());
    }

    /* Assign the delete button to a final variable, since the button view won't change */
    final Button delete = findViewById(R.id.button_delete_task);
    /* Assign a OnClickListener to the button */
    delete.setOnClickListener(click -> {
      Log.d(TAG, "Delete"); // Logs the action taken by the user
      /* Manipulate the database using the static variable from MainActivity to delete a Task */
      MainActivity.taskViewModel.deleteATask(KEY); // Delete the Task with the corresponding KEY
      setResult(RESULT_FIRST_USER); // Set EditTaskActivity resultCode
      finish(); // Finish EditTaskActivity and return to the previous one
    });

    /* Assign the cancel button to a final variable, since the button view won't change */
    final Button cancel = findViewById(R.id.button_cancel_edit_task);
    /* Assign a OnClickListener to the button */
    cancel.setOnClickListener(click -> {
      Log.d(TAG, "Cancel"); // Logs the action taken by the user
      setResult(RESULT_CANCELED); // Set EditTaskActivity resultCode
      finish();
    });

    /* Assign the save button to a final variable, since the button view won't change */
    final Button save = findViewById(R.id.button_save_edit_task);
    /* Assign a OnClickListener to the button */
    save.setOnClickListener(click -> {
      Log.d(TAG, "Save"); // Logs the action taken by the user
      int selection = radioGrp.getCheckedRadioButtonId(); // Assign the RadioButton RadioGroup to a variable
      btnSelected = findViewById(selection); // Assign the selected RadioButton to a variable
      /* Check if a Task field that can be edited by the user is empty */
      if (TextUtils.isEmpty(txtTitle.getText()) ||
          TextUtils.isEmpty(txtInfo.getText()) ||
          selection == -1) {
        Log.d(TAG, "A field is empty"); // Logs the result of the check
        Toast.makeText(this, getString(R.string.TXT_empty_task), Toast.LENGTH_SHORT).show();
      } else {
        Log.d(TAG, "Get time"); // Logs the action taken by the system
        TIME = Calendar.getInstance().getTime().toString(); // Gets the current time
        TITLE = txtTitle.getText().toString(); // Gets the title text as a String
        INFO = txtInfo.getText().toString();  // Gets the info text as a String
        STATUS = btnSelected.getText().toString(); // Gets the status text as a String
        Log.d(TAG, "Get task"); // Logs the action taken by the system
        /* Fetch the Task that's being edited from the database */
        Task taskToUpdate = MainActivity.taskViewModel.getATask(POSITION);
        Log.d(TAG, "Update task fields"); // Logs the action taken by the system
        /* Updating the Task fields with the data from the EditTaskActivity fields */
        taskToUpdate.setTitle(TITLE);
        taskToUpdate.setInfo(INFO);
        taskToUpdate.setStatus(STATUS);
        taskToUpdate.setTime(TIME);
        Log.d(TAG, "Update task"); // Logs the action taken by the system
        MainActivity.taskViewModel.update(taskToUpdate); // Updates a Task in the database
        Log.d(TAG, "Activity completed"); // Logs the activity completion
        setResult(RESULT_OK); // Set EditTaskActivity resultCode
        finish(); // Finish EditTaskActivity and return to the previous one
      }
    });
  }
}