package com.example.kanban;

import androidx.annotation.NonNull;
import androidx.room.ColumnInfo;
import androidx.room.Entity;
import androidx.room.PrimaryKey;

/**
 *
 * @ Entity - Database table name
 * @ PrimaryKey - Key that is auto-generated
 * @ ColumnInfo - Column name
 *
 * See the documentation for the full rich set of annotations.
 * https://developer.android.com/topic/libraries/architecture/room.html
 */
@Entity(tableName = "project_tasks")
public class Task {
    @PrimaryKey(autoGenerate = true)
    @ColumnInfo(name = "key") int key;
    @ColumnInfo(name = "title") private String title;
    @ColumnInfo(name = "info") private String info;
    @ColumnInfo(name = "status") private String status;
    @ColumnInfo(name = "time") private String time;

    public Task(@NonNull String title,
                @NonNull String info,
                @NonNull String status,
                @NonNull String time) {
        this.title = title;
        this.info = info;
        this.status = status;
        this.time = time;
    }
    /* Setters and Getters methods */
    int getKey() { return this.key; }
    String getTitle() { return this.title; }
    String getInfo() { return this.info; }
    String getStatus() { return this.status; }
    String getTime() { return this.time; }
    void setKey(int key) { this.key = key; }
    void setTitle(@NonNull String title) { this.title = title; }
    void setInfo(@NonNull String info) { this.info = info; }
    void setStatus(@NonNull String status) { this.status = status; }
    void setTime(@NonNull String time) { this.time = time; }
    @NonNull public String toString() { return getKey()+"\n\n"+getTitle()+"\n\n"+getInfo()+"\n\n"+getStatus()+"\n\n"+getTime(); }
}
