package com.example.javaapplication;

import android.content.Context;
import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.TextView;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.fragment.app.Fragment;
import androidx.navigation.NavController;
import androidx.navigation.fragment.NavHostFragment;

import com.example.javaapplication.databinding.FragmentFirstBinding;

public class FirstFragment extends Fragment {

    private FragmentFirstBinding binding;
    private Button btnRandom, btnCount, btnToast, btnClear;
    private Context theContext;
    private TextView txtView_fragment1;
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
        btnToast.setOnClickListener(showToast -> Toast.makeText(theContext, "Hello there", Toast.LENGTH_SHORT).show());
        btnCount.setOnClickListener(count -> incrementCount());
        btnRandom.setOnClickListener(toFragment2 -> getNav().navigate(R.id.action_FirstFragment_to_SecondFragment));
        btnClear.setOnClickListener(clearCount -> resetCount());
    }

    private FragmentFirstBinding getBinds(LayoutInflater inflater, ViewGroup container) {
        return FragmentFirstBinding.inflate(inflater, container, false);
    }

    private void initVAR() {
        btnRandom = binding.btnFragment1Next;
        btnCount = binding.btnFragment1Count;
        btnToast = binding.btnFragment1Toast;
        btnClear = binding.btnFragment1Clear;
        txtView_fragment1 = binding.txtviewFragment1;
        theContext = this.getContext();
        TAG = getString(R.string.TAG_FirstFragment);
        Log.d(TAG,"Init variables is complete");
    }

    private void resetCount() { txtView_fragment1.setText(getString(R.string.TXT_Nr0)); }

    private NavController getNav() { return NavHostFragment.findNavController(FirstFragment.this); }

    private void incrementCount() {
        String txtCount = txtView_fragment1.getText().toString();
        int theCount = Integer.parseInt(txtCount);
        theCount++;
        txtView_fragment1.setText(String.valueOf(theCount));
    }

    @Override
    public void onDestroyView() {
        super.onDestroyView();
        binding = null;
    }

}