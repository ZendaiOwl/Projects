package org.eu.net.zendai.kanbankt

import android.content.Context
import androidx.room.Database
import androidx.room.Room
import androidx.room.RoomDatabase
import androidx.sqlite.db.SupportSQLiteDatabase
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.launch
import java.util.*

@Database(entities = [Task::class], version = 1, exportSchema = false)
abstract class TaskDB : RoomDatabase() {
    abstract fun taskDao(): TaskDao

    private class TaskDatabaseCallback(
        private val scope: CoroutineScope
    ) : Callback() {
        override fun onCreate(db: SupportSQLiteDatabase) {
            super.onCreate(db)
            INSTANCE?.let { database ->
                scope.launch {
                    populateDatabase(database.taskDao())
                }
            }
        }
        suspend fun populateDatabase(taskDao: TaskDao) {
            taskDao.deleteAll()
            val currentTime = Calendar.getInstance().time.toString()
            val task = Task(0,
                "Welcome to KanbanKt!",
                "Create a new Task by clicking on the '+' in the bottom right corner of your screen ",
                "Not started",
                currentTime
            )
            taskDao.insert(task)
        }
    }

    companion object {
        @Volatile
        private var INSTANCE: TaskDB? = null
        fun getDatabase(
            context: Context,
            scope: CoroutineScope
        ): TaskDB {
            return INSTANCE ?: synchronized(this) {
                val instance = Room.databaseBuilder(
                    context.applicationContext,
                    TaskDB::class.java,
                    "tasks_database"
                ).addCallback(TaskDatabaseCallback(scope)).build()
                INSTANCE = instance
                // Return instance
                instance
            }
        }
    }
}