package org.eu.net.zendai.kanbankt

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.appcompat.app.AppCompatActivity
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.material.AppBarDefaults
import androidx.compose.material.MaterialTheme
import androidx.compose.material.Surface
import androidx.compose.material.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.tooling.preview.Preview
import androidx.recyclerview.widget.DiffUtil
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import androidx.room.Room
import com.google.android.material.floatingactionbutton.FloatingActionButton
import org.eu.net.zendai.kanbankt.ui.theme.KanbanKtTheme

// ComponentActivity()
class MainActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        val application = TaskApplication()
        val db = Room.databaseBuilder(
            applicationContext,
            TaskDB::class.java,
            "tasks_database"
        ).build()
        val taskDao = db.taskDao()
        val tasks = taskDao.getAll()
        val fab: FloatingActionButton? = findViewById(R.id.fab)
        fab?.show()
        val recyclerView: RecyclerView? = findViewById(R.id.recyclerview)
        val adapter = TaskListAdapter()
        recyclerView?.adapter = adapter
        recyclerView?.layoutManager = LinearLayoutManager(this)
        setContent {
            KanbanKtTheme {
                // A surface container using the 'background' color from the theme
                Surface(
                    modifier = Modifier.fillMaxSize(),
                    color = MaterialTheme.colors.background
                ) {

                }
            }
        }
    }
}
