package com.example.exam1;
import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.widget.Button;
import com.example.exam1.databinding.ActivityCvBinding;

public class ActivityCV extends AppCompatActivity {

    private static String TAG;
    private ActivityCvBinding binding;
    private Button btnProfile, btnExperience, btnEducation, btnVolunteer, btnPrevious;
    /*
     * Källan/Inspirationen till hur jag skulle använda Android SDK PDFRenderer i kod.
     * PDF Renderer från Android SDK kan endast öppna en sida åt gången, därför
     * öppnar den en activity per sida.
     * https://developer.android.com/reference/android/graphics/pdf/PdfRenderer
     */
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        this.binding = ActivityCvBinding.inflate(getLayoutInflater());
        setContentView(this.binding.getRoot());
        initVAR();
        Log.d(TAG,"Created activity");
        this.btnProfile.setOnClickListener(openPage1 -> openPDFPage1());
        this.btnExperience.setOnClickListener(openPage2 -> openPDFPage2());
        this.btnEducation.setOnClickListener(openPage3 -> openPDFPage3());
        this.btnVolunteer.setOnClickListener(openPage4 -> openPDFPage4());
        this.btnPrevious.setOnClickListener(toActivityMain -> openMainActivity());
    }
    // Used to return to the MainActivity
    private void openMainActivity() {
        Log.d(TAG,"Opening MainActivity");
        Intent intent = new Intent(this,MainActivity.class);
        startActivity(intent);
    }
    // Used to open page 1 of the PDF
    private void openPDFPage1() {
        Log.d(TAG,"Opening CV p.1");
        Intent intent = new Intent(this,Page1.class);
        startActivity(intent);
    }
    // Used to open page 2 of the PDF
    private void openPDFPage2() {
        Log.d(TAG,"Opening CV p.2");
        Intent intent = new Intent(this,Page2.class);
        startActivity(intent);
    }
    // Used to open page 3 of the PDF
    private void openPDFPage3() {
        Log.d(TAG,"Opening CV p.3");
        Intent intent = new Intent(this,Page3.class);
        startActivity(intent);
    }
    // Used to open page 4 of the PDF
    private void openPDFPage4() {
        Log.d(TAG,"Opening CV p.4");
        Intent intent = new Intent(this,Page4.class);
        startActivity(intent);
    }

    /**
     * Init the variables
     */
    private void initVAR() {
        TAG = getString(R.string.TAG_ActivityCV);
        initButtons();
        Log.d(TAG,"Init variables complete");
    }

    /**
     * Init the buttons for each page
     */
    private void initButtons() {
        this.btnProfile = this.binding.btnCvProfile;
        this.btnEducation = this.binding.btnCvEducation;
        this.btnExperience = this.binding.btnCvExperience;
        this.btnVolunteer = this.binding.btnCvVolunteer;
        this.btnPrevious = this.binding.btnCvPrevious;
        Log.d(TAG,"Init button variables complete");
    }


    @Override
    protected void onDestroy() {
        super.onDestroy();
        Log.d(TAG,"Closing and destroying activity");
        this.binding = null;
    }
}