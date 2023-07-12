package com.example.javatts;

import androidx.activity.result.ActivityResultLauncher;
import androidx.activity.result.contract.ActivityResultContracts;
import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.os.Bundle;
import android.speech.tts.TextToSpeech;
import android.text.TextUtils;
import android.util.Log;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;

import java.util.Locale;

/**
 * Denna behövs inte längre sedan ActivityResultContracts & ActivityResultLauncher implementerades.
 * private final int MY_DATA_CHECK_CODE = 2323;
 */
public class MainActivity extends AppCompatActivity implements TextToSpeech.OnInitListener {
    private static TextToSpeech mTts = null;
    private static String TAG = null;
    private Button mBtnTts;
    private EditText mETxt1;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        mBtnTts = (Button) findViewById(R.id.button1);
        mETxt1 = (EditText) findViewById(R.id.editText1);
        TAG = getString(R.string.tag_mainActivity);
        Log.d(TAG, "MainActivity created");
        if (mTts == null) {
            Log.d(TAG, "Check TTS");
            checkTTS();
        }
        mBtnTts.setOnClickListener(click -> {
            if (TextUtils.isEmpty(mETxt1.getText().toString())) {
                Log.d(TAG, "Text input field is empty");
                Toast.makeText(this, getString(R.string.err_noText), Toast.LENGTH_SHORT).show();
            } else {
                Log.d(TAG, "Fetching & speaking text");
                mTts.speak(mETxt1.getText().toString(), TextToSpeech.QUEUE_FLUSH, null, null);
            }
        });
    }

    /**
     * Kontrollerar om Text-Till-Tal motorn finns tillgänglig, om språket finns & stödjs.
     */
    public void checkTTS() {
        Log.d(TAG, "Init new intent with action");
        Intent initTTS = new Intent().setAction(TextToSpeech.Engine.ACTION_CHECK_TTS_DATA);
        Log.d(TAG, "Creating activity result launcher");
        ActivityResultLauncher<Intent> activityResultLauncher = registerForActivityResult(
                new ActivityResultContracts.StartActivityForResult(),
                result -> {
                    Log.d(TAG, "Voice data check - Start");
                    if (result.getResultCode() == TextToSpeech.Engine.CHECK_VOICE_DATA_PASS) {
                        // No request codes
                        Log.i(TAG, "Passed voice data check");
                        mTts = new TextToSpeech(this, this);
                    } else {
                        Log.i(TAG, "Failed voice data check or user interrupted");
                        if (result.getResultCode() == TextToSpeech.LANG_AVAILABLE) {
                            Log.d(TAG, "Language is available, user interrupted, initiating TTS");
                            mTts = new TextToSpeech(this, this);
                        } else if (result.getResultCode() == TextToSpeech.LANG_MISSING_DATA) {
                            Log.i(TAG, "Missing language data - Installing");
                            Intent installIntent = new Intent().setAction(TextToSpeech.Engine.ACTION_INSTALL_TTS_DATA);
                            startActivity(installIntent);
                        } else if (result.getResultCode() == TextToSpeech.LANG_NOT_SUPPORTED) {
                            Log.e(TAG, "Language is unsupported");
                            Toast.makeText(this, getString(R.string.err_lang_unsupported) + ": " + Locale.getDefault().getLanguage(), Toast.LENGTH_LONG).show();
                        } else {
                            Log.e(TAG, "Something went wrong!");
                            Toast.makeText(this, getString(R.string.msg_tts_init_error), Toast.LENGTH_SHORT).show();
                        }
                    }
                });
        Log.d(TAG, "Launch intent");
        activityResultLauncher.launch(initTTS);
    }

    /**
     * Called to signal the completion of the TextToSpeech engine initialization.
     *
     * @param status {@link TextToSpeech#SUCCESS} or {@link TextToSpeech#ERROR}.
     */
    @Override
    public void onInit(int status) {
        if (status == TextToSpeech.SUCCESS) {
            mTts.setLanguage(Locale.getDefault());
            mTts.speak(getString(R.string.hello_android), TextToSpeech.QUEUE_ADD, null, TAG);
            mTts.speak(getString(R.string.course_welcome), TextToSpeech.QUEUE_FLUSH, null, TAG);
        } else {
            Toast.makeText(this, getString(R.string.msg_tts_init_error), Toast.LENGTH_LONG).show();
        }
    }

    /**
     * Destroy the activity
     */
    @Override
    public void onDestroy() {
        if (mTts != null) {
            mTts.shutdown();
        }
        super.onDestroy();
    }
}