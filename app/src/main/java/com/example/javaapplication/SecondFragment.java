package com.example.javaapplication;

import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.fragment.app.Fragment;
import androidx.navigation.NavController;
import androidx.navigation.fragment.NavHostFragment;

import com.example.javaapplication.databinding.FragmentSecondBinding;

import kotlin.random.Random;

public class SecondFragment extends Fragment {

    private FragmentSecondBinding binding;
    private Button btnPrevious;
    private TextView txtView_fragment2;
    private static String TAG;

    @Override
    public View onCreateView(
            @NonNull LayoutInflater inflater, ViewGroup container,
            Bundle savedInstanceState
    ) {
        binding = getBinds(inflater,container);
        return binding.getRoot();
    }

    public void onViewCreated(@NonNull View view, Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);
        initVAR();
        setRandom();
        btnPrevious.setOnClickListener(toFragment1 -> getNav().navigate(R.id.action_SecondFragment_to_FirstFragment));
    }

    private void setRandom() {
        int rndInt = Random.Default.nextInt();
        txtView_fragment2.setText(String.valueOf(rndInt));
    }

    private void initVAR() {
        btnPrevious = binding.btnFragment2Previous;
        txtView_fragment2 = binding.txtviewFragment2;
        TAG = getString(R.string.TAG_SecondFragment);
        Log.d(TAG, "Init variables is complete");
    }

    private NavController getNav() {
        return NavHostFragment.findNavController(SecondFragment.this);
    }

    private FragmentSecondBinding getBinds(LayoutInflater inflater, ViewGroup container) {
        return FragmentSecondBinding.inflate(inflater, container, false);
    }

    @Override
    public void onDestroyView() {
        super.onDestroyView();
        binding = null;
    }

}