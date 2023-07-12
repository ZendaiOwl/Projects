package org.eu.net.zendai.kanbankt

import android.app.Application
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.SupervisorJob

class TaskApplication : Application() {
    private val applicationScope = CoroutineScope(SupervisorJob())
    private val database by lazy { TaskDB.getDatabase(this, applicationScope) }
    val repository by lazy { TaskRepository(database.taskDao()) }
}