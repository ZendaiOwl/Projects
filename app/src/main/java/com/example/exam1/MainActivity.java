package com.example.exam1;

import android.content.ClipData;
import android.content.ClipboardManager;
import android.content.Context;
import android.os.Bundle;
import android.util.Log;
import android.view.Menu;
import android.view.MenuInflater;
import android.widget.Toast;

import com.example.exam1.databinding.ActivityMainBinding;
import com.google.android.material.snackbar.Snackbar;

import androidx.appcompat.app.AppCompatActivity;

import androidx.navigation.NavController;
import androidx.navigation.Navigation;
import androidx.navigation.ui.AppBarConfiguration;
import androidx.navigation.ui.NavigationUI;

public class MainActivity extends AppCompatActivity {

    private AppBarConfiguration appBarConfiguration;
    private ActivityMainBinding binding;
    private static String TAG;
    private ClipboardManager clipboardManager;
    private ClipData clipData;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        this.binding = ActivityMainBinding.inflate(getLayoutInflater());
        setContentView(this.binding.getRoot());
        setSupportActionBar(this.binding.toolbar);
        initVAR();
        Log.d(TAG,"Launched application");
        NavController navController = Navigation.findNavController(this, R.id.nav_host_fragment_content_main);
        this.appBarConfiguration = new AppBarConfiguration.Builder(navController.getGraph()).build();
        NavigationUI.setupActionBarWithNavController(this, navController, appBarConfiguration);
        Log.d(TAG,"Setup navigation bar");
        this.binding.fab.setOnClickListener(emailAction -> Snackbar.make(emailAction, getString(R.string.TXT_email_skola), Snackbar.LENGTH_LONG)
                .setAction("Copy", copy -> {
                    this.clipboardManager.setPrimaryClip(this.clipData);
                    Toast.makeText(copy.getContext(), getString(R.string.TXT_copied), Toast.LENGTH_LONG).show();
                }).show());
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        Log.d(TAG,"Creating menu");
        MenuInflater inflater = getMenuInflater();
        inflater.inflate(R.menu.interest_menu,menu);
        return super.onCreateOptionsMenu(menu);
    }

    private void initVAR() {
        TAG = getString(R.string.TAG_MainActivity);
        this.clipboardManager = (ClipboardManager) getSystemService(Context.CLIPBOARD_SERVICE);
        this.clipData = ClipData.newPlainText(getString(R.string.TXT_email),getString(R.string.TXT_email_skola));
        Log.d(TAG,"Init variables done");
    }

    @Override
    public boolean onSupportNavigateUp() {
        NavController navController = Navigation.findNavController(this, R.id.nav_host_fragment_content_main);
        return NavigationUI.navigateUp(navController, appBarConfiguration)
                || super.onSupportNavigateUp();
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        this.binding = null;
    }
}