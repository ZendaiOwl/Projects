package com.example.kanban;

import android.app.Application;
import androidx.lifecycle.LiveData;
import java.util.List;
import java.util.Objects;

/**
 * This class is used as an intermediary when interacting with the Database (TaskDB)
 */
class TaskRepository {
    private final TaskDao rTaskDao; // Task Database Access Object
    private final LiveData<List<Task>> rAllTasks; // LiveData Task List
    TaskRepository(Application application) {
        TaskDB db = TaskDB.getDatabase(application);
        rTaskDao = db.getDao();
        rAllTasks = rTaskDao.getAllTasks();
    }
    public LiveData<List<Task>> getAllTasks() {
        return rAllTasks;
    }
    void insert(Task task) { TaskDB.databaseWriteExecutor.execute(() -> rTaskDao.insert(task)); } // @Insert
    void update(Task task) { TaskDB.databaseWriteExecutor.execute(() -> rTaskDao.update(task)); } // @Update
    void delete(Task task) { TaskDB.databaseWriteExecutor.execute(() -> rTaskDao.deleteTask(task)); } // @Delete
    void deleteTask(int key) { TaskDB.databaseWriteExecutor.execute(() -> rTaskDao.deleteTaskQuery(key)); } // @Query
    // I was unable to implement this in time, this will be used to clear the database table
    void deleteAll() { TaskDB.databaseWriteExecutor.execute(rTaskDao::clearTable); } // @Query
    Task getTask(int key) { return rTaskDao.getTask(key); } // @Query
    Task getATask(int position) { return Objects.requireNonNull(rAllTasks.getValue()).get(position); } // @Query
}
