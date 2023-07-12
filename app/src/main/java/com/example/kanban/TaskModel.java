package com.example.kanban;

import android.app.Application;
import androidx.lifecycle.AndroidViewModel;
import androidx.lifecycle.LiveData;
import java.util.List;

/**
 * This class is used to manipulate the Tasks
 * data and the database from the other classes of the application
 */
public class TaskModel extends AndroidViewModel {

    // Using LiveData and caching what getAlphabetizedWords returns has several benefits:
    // - We can put an observer on the data (instead of polling for changes) and only update the
    //   the UI when the data actually changes.
    // - Repository is completely separated from the UI through the ViewModel.
    private final TaskRepository taskRepository;
    private final LiveData<List<Task>> taskAllTasks;

    public TaskModel(Application application) {
        super(application);
        this.taskRepository = new TaskRepository(application);
        this.taskAllTasks = this.taskRepository.getAllTasks();
    }
    Task getATask(int position) { return this.taskRepository.getATask(position); }
    LiveData<List<Task>> getAllTasks() {
        return this.taskAllTasks;
    }
    void insert(Task task) { this.taskRepository.insert(task); } // @Insert annotated method in the database
    void update(Task task) { this.taskRepository.update(task); } // @@Update annotated method in the database
    void delete(Task task) { this.taskRepository.delete(task); } // @Delete annotated method in the database
    void deleteATask(int key) { this.taskRepository.deleteTask(key); } // @Query annotated method in the database
}
