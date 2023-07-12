package com.example.kanban;

import androidx.lifecycle.LiveData;
import androidx.room.Dao;
import androidx.room.Delete;
import androidx.room.Insert;
import androidx.room.OnConflictStrategy;
import androidx.room.Query;
import androidx.room.Update;
import java.util.List;

/**
 * The database Access Object interface
 * This is used to access the database and is used within the TaskRepository class
 * Is not used directly
 */
@Dao
public interface TaskDao {
    @Insert(onConflict = OnConflictStrategy.REPLACE) void insert(Task task);
    @Update(onConflict = OnConflictStrategy.REPLACE) void update(Task task);
    @Delete void deleteTask(Task task);
    @Query("DELETE FROM project_tasks WHERE `key` = :key;") void deleteTaskQuery(int key);
    @Query("SELECT * FROM project_tasks ORDER BY `key` DESC;") LiveData<List<Task>> getAllTasks();
    @Query("SELECT * FROM project_tasks WHERE `key` = :key;") Task getTask(int key);
    @Query("DELETE FROM project_tasks;") void clearTable();
}
