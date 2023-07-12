package org.eu.net.zendai.kanbankt

import androidx.room.ColumnInfo
import androidx.room.Entity
import androidx.room.PrimaryKey

@Entity(tableName = "tasks")
data class Task (
    @PrimaryKey(autoGenerate = true) val key: Int,
    @ColumnInfo(name = "title") val title: String?,
    @ColumnInfo(name = "info") val info: String?,
    @ColumnInfo(name = "status") val status: String?,
    @ColumnInfo(name = "time") val time: String?
)