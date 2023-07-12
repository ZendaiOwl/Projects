package com.example.kanban;

import androidx.appcompat.app.AppCompatActivity;
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

public class NewTaskActivity extends AppCompatActivity {

  /* Variables to hold the text data in the Task fields */
  private String TITLE, INFO, STATUS, TIME;
  /* The TAG for the NewTaskActivity logs */
  private static final String TAG = "NewTaskActivity";
  /* Variables to hold the Views/UI elements of the EditTaskActivity */
  private EditText txtTitle, txtInfo;
  private RadioGroup radioGrp;
  private RadioButton radioBtn;

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.activity_new_task);
    Log.d(TAG, "Launched");
    /* Assign the Views to a variable */
    radioGrp = findViewById(R.id.new_task_status_group);
    txtTitle = findViewById(R.id.new_title);
    txtInfo = findViewById(R.id.new_info);
    TextView txtTime = findViewById(R.id.new_time);
    /*
    Fetch the current time using Calendar class, which uses the system locale by default,
    this is great so we don't have to check the current timezone via network or another way
    */
    Log.d(TAG, "Get current time");
    TIME = Calendar.getInstance().getTime().toString();
    Log.d(TAG, "Set current time");
    txtTime.setText(TIME);

    /* Assign the cancel button to a final variable, since the button view won't change */
    final Button cancel = findViewById(R.id.button_cancel_new_task);
    /* Sets the OnClickListener action */
    cancel.setOnClickListener(click -> {
      Log.d(TAG,"Cancel");
      setResult(RESULT_CANCELED); // Set NewTaskActivity resultCode
      finish(); // Finish NewTaskActivity and return to the previous one
    });

    /* Assign the save button to a final variable, since the button view won't change */
    final Button save = findViewById(R.id.button_save_new_task);
    /* Sets the OnClickListener action */
    save.setOnClickListener(click -> {
      Log.d(TAG, "Save");
      int selection = radioGrp.getCheckedRadioButtonId(); // Assign the selected RadioButton to a variable
      if (TextUtils.isEmpty(txtTitle.getText()) ||
          TextUtils.isEmpty(txtInfo.getText()) ||
          selection == -1) {
        Log.d(TAG, "A field is empty");
        Toast.makeText(this, getString(R.string.TXT_empty_field), Toast.LENGTH_SHORT).show();
      } else {
        /* Gets the text field data to create a new Task */
        TITLE = txtTitle.getText().toString();
        INFO = txtInfo.getText().toString();
        radioBtn = findViewById(selection);
        STATUS = radioBtn.getText().toString();
        Log.d(TAG, "Creating new task");
        /* Creates the new Task */
        Task newTask = new Task(TITLE,INFO,STATUS,TIME);
        Log.d(TAG, "Inserting new task");
        /*
         * Since the TaskAdapter in the MainActivity uses the simplified "simpleList"
         * to view any changes to the database list, whenever a new task was created it
         * would end up below any task that was edited.
         * To solve this issue, after inserting a task, the activity immediately calls the
         * MainActivity.update(task) static function to properly place the Task at
         * the top of the list in the recyclerview.
         */
        MainActivity.taskViewModel.insert(newTask); // Insert Task
        MainActivity.taskViewModel.update(newTask); // Update Task <- Places the Task at the top
        setResult(RESULT_OK); // Set NewTaskActivity resultCode
        Log.d(TAG, "Activity completed successfully");
        finish(); // Finish NewTaskActivity and return to the previous one
      }
    });
  }
}