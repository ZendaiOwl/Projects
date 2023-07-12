package org.eu.net.zendai.kanbankt

import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.RadioGroup
import android.widget.TextView
import androidx.recyclerview.widget.DiffUtil
import androidx.recyclerview.widget.ListAdapter
import androidx.recyclerview.widget.RecyclerView

class TaskListAdapter: ListAdapter<Task, TaskListAdapter.TaskViewHolder>(TasksComparator()) {
    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): TaskViewHolder {
        return TaskViewHolder.create(parent)
    }
    override fun onBindViewHolder(holder: TaskViewHolder, position: Int) {
        val current = getItem(position)
        holder.bind(current.title, current.info, current.status, current.time)
    }
    class TaskViewHolder(itemView: View) : RecyclerView.ViewHolder(itemView) {
        private val taskTitle: TextView = itemView.findViewById(R.id.textView_title)
        private val taskInfo: TextView = itemView.findViewById(R.id.textView_info)
        private val taskStatusBtnNotStarted: RadioGroup = itemView.findViewById(R.id.radioButton_status_not_started)
        private val taskStatusBtnOngoing: RadioGroup = itemView.findViewById(R.id.radioButton_status_ongoing)
        private val taskStatusBtnCompleted: RadioGroup = itemView.findViewById(R.id.radioButton_status_completed)
        private val taskTime: TextView = itemView.findViewById(R.id.textView_title)

        fun bind(title: String?,info: String?,status: String?,time: String?) {
            taskTitle.text = title
            taskInfo.text = info
            when (status) {
                "Completed" -> {
                    taskStatusBtnCompleted.isSelected = true
                }
                "Ongoing" -> {
                    taskStatusBtnOngoing.isSelected = true
                }
                else -> {
                    taskStatusBtnNotStarted.isSelected = true
                }
            }
            taskTime.text = time
        }

        companion object {
            fun create(parent: ViewGroup): TaskViewHolder {
                val view: View = LayoutInflater.from(parent.context).inflate(R.layout.recyclerview_item, parent, false)
                return TaskViewHolder(view)
            }
        }
    }
    class TasksComparator : DiffUtil.ItemCallback<Task>() {
        override fun areItemsTheSame(oldItem: Task, newItem: Task): Boolean {
            return oldItem == newItem
        }

        override fun areContentsTheSame(oldItem: Task, newItem: Task): Boolean {
            return oldItem.key == newItem.key
        }
    }
}