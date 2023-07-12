package com.example.kanban;

import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.widget.Toast;
import androidx.activity.result.ActivityResultLauncher;
import androidx.activity.result.contract.ActivityResultContracts;
import androidx.appcompat.app.AppCompatActivity;
import androidx.lifecycle.ViewModelProvider;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import com.google.android.material.floatingactionbutton.FloatingActionButton;

public class MainActivity extends AppCompatActivity {

  /* TaskModel instance, this is used to manipulate the database from the other classes */
  public static TaskModel taskViewModel;
  /* The TAG for the MainActivity logs */
  private static final String TAG = "MainActivity";
  /* This is a static reference to an ActivityResultLauncher that can be used
   * in the sub-classes to initiate an activity, primarily EditTaskActivity */
  static ActivityResultLauncher<Intent> intentLauncher;

  /**
   * Runs on application creation/initiation
   * @param savedInstanceState The saved application state
   */
  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState); // Runs on creation
    setContentView(R.layout.activity_main); // Sets the content view for the MainActivity
    Log.d(TAG, "Init"); // Debug log
    /* ActivityResultLauncher for launching the activity to edit a Task */
    intentLauncher = registerForActivityResult(
        new ActivityResultContracts.StartActivityForResult(),
        result -> {
          Log.d(TAG, "Init: intentLauncher");
          /* Check the result of launching EditTaskActivity */
          if (result.getResultCode() == RESULT_OK) {
            Log.d(TAG, "Result: OK");
            Toast.makeText(MainActivity.this, getString(R.string.TXT_updated), Toast.LENGTH_SHORT).show();
          } else if (result.getResultCode() == RESULT_CANCELED) {
            Log.d(TAG, "Result: Cancelled");
            Toast.makeText(MainActivity.this, getString(R.string.DBG_cancelled), Toast.LENGTH_SHORT).show();
          } else if (result.getResultCode() == RESULT_FIRST_USER) {
            Log.d(TAG, "Result: Delete");
            Toast.makeText(MainActivity.this, getString(R.string.TXT_deleted), Toast.LENGTH_SHORT).show();
          } else {
            Log.d(TAG, "Result: Error");
          }
        }
    );
    /* ActivityResultLauncher for adding a new Task to the Kanban recyclerview */
    ActivityResultLauncher<Intent> activityResultLauncherAdd = registerForActivityResult(
        new ActivityResultContracts.StartActivityForResult(),
        result -> {
          Log.d(TAG, "Init: ActivityResultLauncher");
          /* Check the result of launching NewTaskActivity */
          if (result.getResultCode() == RESULT_OK) {
            Log.d(TAG, "Result: OK");
            Toast.makeText(MainActivity.this, getString(R.string.TXT_task_created), Toast.LENGTH_LONG).show();
          } else if (result.getResultCode() == RESULT_CANCELED) {
            Log.d(TAG, "Result: Cancelled by user");
            Toast.makeText(MainActivity.this, getString(R.string.DBG_cancelled), Toast.LENGTH_LONG).show();
          } else {
            Log.d(TAG, "Result: Empty field");
            Toast.makeText(MainActivity.this, getString(R.string.TXT_empty_field), Toast.LENGTH_LONG).show();
          }
        });
    RecyclerView recyclerView = findViewById(R.id.recyclerview); // Fetch the recyclerview
    final TaskAdapter adapter = new TaskAdapter(MainActivity.this); // Initiate the TaskAdapter instance
    recyclerView.setAdapter(adapter); // Set TaskAdapter instance as the recyclerview adapter
    recyclerView.setLayoutManager(new LinearLayoutManager(MainActivity.this)); // Set MainActivity as context for LinearLayout manager
    FloatingActionButton fab = findViewById(R.id.floatingActionButton); // Fetch the FAB
    taskViewModel = new ViewModelProvider(this).get(TaskModel.class); // Initiate the DB and the data
    taskViewModel.getAllTasks().observe(this, adapter::submitList); // Get all the tasks and observer the data for any changes
    Intent intent = new Intent(MainActivity.this, NewTaskActivity.class); // Initiate an intent for creating a new Task
    fab.setOnClickListener(view -> activityResultLauncherAdd.launch(intent)); // Launch NewTaskActivity for result
  }

  @Override
  protected void onDestroy() {
    super.onDestroy();
    Log.d(TAG, "Activity destroyed");
  }
}