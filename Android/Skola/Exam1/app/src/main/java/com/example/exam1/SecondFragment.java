package com.example.exam1;

import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.fragment.app.Fragment;
import androidx.navigation.fragment.NavHostFragment;

import com.example.exam1.databinding.FragmentSecondBinding;

public class SecondFragment extends Fragment {

    private FragmentSecondBinding binding;
    private static String TAG;
    private Button btnPrevious;
    private TextView txtViewHobby;

    @Override
    public View onCreateView(
            @NonNull LayoutInflater inflater, ViewGroup container,
            Bundle savedInstanceState
    ) {

        this.binding = FragmentSecondBinding.inflate(inflater, container, false);
        initVAR();
        return this.binding.getRoot();

    }

    public void onViewCreated(@NonNull View view, Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);
        Log.d(TAG,"Fragment created");
        String txtHobby = getString(R.string.TXT_hobby);
        this.txtViewHobby.setText(txtHobby);
        this.btnPrevious.setOnClickListener(toFragment1 -> NavHostFragment.findNavController(SecondFragment.this)
                .navigate(R.id.action_SecondFragment_to_FirstFragment));
    }

    private void initVAR() {
        TAG = getString(R.string.TAG_MainActivity);
        this.btnPrevious = this.binding.btnFragment2Previous;
        this.txtViewHobby = this.binding.txtViewFragment2Hobby;
        Log.d(TAG,"Init variables done");
    }

    @Override
    public void onDestroyView() {
        super.onDestroyView();
        this.binding = null;
    }

}