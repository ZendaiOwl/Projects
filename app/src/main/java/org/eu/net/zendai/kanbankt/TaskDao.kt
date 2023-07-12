package org.eu.net.zendai.kanbankt

import androidx.room.*
import kotlinx.coroutines.flow.Flow

@Dao
interface TaskDao {
    @Query("SELECT * FROM tasks ORDER BY time DESC") fun getAll(): Flow<List<Task>>
    @Query("DELETE FROM tasks") suspend fun deleteAll()
    @Delete suspend fun delete(task: Task)
    @Insert(onConflict = OnConflictStrategy.REPLACE) suspend fun insertAll(vararg task: Task)
    @Insert(onConflict = OnConflictStrategy.REPLACE) suspend fun insert(task: Task)
    @Update(onConflict = OnConflictStrategy.REPLACE) suspend fun update(task: Task)
}