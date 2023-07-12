package com.example.exam1;

import android.content.Intent;
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

import com.example.exam1.databinding.FragmentFirstBinding;

public class FirstFragment extends Fragment {

    private FragmentFirstBinding binding;
    private Button btnNext, btnCv;
    private TextView intro;
    private static String TAG;

    @Override
    public View onCreateView(
            @NonNull LayoutInflater inflater, ViewGroup container,
            Bundle savedInstanceState
    ) {

        this.binding = FragmentFirstBinding.inflate(inflater, container, false);
        initVAR();
        return this.binding.getRoot();

    }

    public void onViewCreated(@NonNull View view, Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);
        Log.d(TAG,"Fragment created");
        String introduction = getString(R.string.TXT_presentation);
        this.intro.setText(introduction);
        this.btnNext.setOnClickListener(toFragment2 -> NavHostFragment.findNavController(FirstFragment.this)
                .navigate(R.id.action_FirstFragment_to_SecondFragment));
        this.btnCv.setOnClickListener(toActivityCV -> openActivityCV());
    }

    private void openActivityCV() {
        Intent intent = new Intent(this.getContext(), ActivityCV.class);
        startActivity(intent);
    }

    private void initVAR() {
        TAG = getString(R.string.TAG_MainActivity);
        this.btnNext = this.binding.btnFragment1Next;
        this.btnCv = this.binding.btnFragment1Cv;
        this.intro = this.binding.txtViewFragment1Presentation;
        Log.d(TAG,"Init variables done");
    }

    @Override
    public void onDestroyView() {
        super.onDestroyView();
        this.binding = null;
    }

}