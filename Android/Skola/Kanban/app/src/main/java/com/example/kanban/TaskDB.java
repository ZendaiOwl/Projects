package com.example.kanban;

import android.content.Context;

import androidx.annotation.NonNull;
import androidx.room.Database;
import androidx.room.Room;
import androidx.room.RoomDatabase;
import androidx.sqlite.db.SupportSQLiteDatabase;
import java.util.Date;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

@Database(entities = {Task.class}, version = 1, exportSchema = false)
public abstract class TaskDB extends RoomDatabase {

    public abstract TaskDao getDao();
    private static volatile TaskDB INSTANCE;
    private static final int NUMBER_OF_THREADS = 4;
    static final ExecutorService databaseWriteExecutor = Executors.newFixedThreadPool(NUMBER_OF_THREADS);

    /**
     * @param context The context of the application for the database
     * @return A new instance of the TaskDB database
     */
    static TaskDB getDatabase(final Context context) {
        if (INSTANCE == null) {
            synchronized (TaskDB.class) {
                if (INSTANCE == null) {
                    INSTANCE = Room.databaseBuilder(context.getApplicationContext(),
                                    TaskDB.class, "taskDatabase")
                            .addCallback(TaskDatabaseCallback)
                            .build();
                }
            }
        }
        return INSTANCE;
    }

    /**
     * Override the onCreate method to populate the database.
     * We clear the database every time it is created.
     */
    private static final RoomDatabase.Callback TaskDatabaseCallback = new RoomDatabase.Callback() {
        @Override
        public void onCreate(@NonNull SupportSQLiteDatabase db) {
            super.onCreate(db);
            /* This method is used to interact with the TaskDao class and by extension, the database */
            databaseWriteExecutor.execute(() -> {
                // Populate the database in the background.
                // If you want to start with more Tasks, just add them.
                TaskDao dao = INSTANCE.getDao();
                // Clears the database table at creation (or app install)
                dao.clearTable();
                Date timeNow = new Date();
                Task welcome = new Task(
                    "Welcome to Kanban!",
                    "Create a new Task by clicking the '+' button down below in the corner of your screen",
                    ViewHolder.NOT_STARTED,timeNow.toString()
                );
                dao.insert(welcome);
            });
        }
    };
}
