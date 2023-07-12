package com.example.helloandroid

import android.os.Build
import android.os.Bundle
import android.speech.tts.TextToSpeech
import android.speech.tts.TextToSpeech.*
import android.util.Log
import android.widget.Button
import android.widget.EditText
import android.widget.Toast
import androidx.annotation.RequiresApi
import androidx.appcompat.app.AppCompatActivity
import java.util.*

private const val TAG = "AndroidSpeech"

/**
 * När jag försökte implementera koden från uppgiften för duggan,
 * fick jag fram att dessa metoder är "depreceated" och inte skall användas längre.
 * Så jag läste igenom uppgiften så gott jag kunde och försökte förstå konceptet
 * och skriva en app direkt i Kotlin istället, hoppas det går bra ändå.
 *
 * Depreceated i dokumentationen
 *
 * https://developer.android.com/reference/kotlin/android/preference/PreferenceManager.OnActivityResultListener
 *
 * Här är guiden som jag använde mig utav som referens tillsammans med android developer dokumentationen
 * och ett par GitHub repositories för att konvertera din Java kod i studiehandledningen till Kotlin kod.
 *
 * https://github.com/rtdtwo/STT-TTS-Android/blob/master/app/src/main/java/blog/rishabh/verbose/MainActivity.kt
 *
 * https://github.com/Marc-JB/TextToSpeechKt/blob/main/app/src/main/java/nl/marc_apps/tts_demo/MainActivity.kt
 *
 * https://www.tothenew.com/blog/android-katha-onactivityresult-is-deprecated-now-what/
 *
 * https://developer.android.com/reference/kotlin/android/speech/tts/TextToSpeech
 *
 * MY_DATA_CHECK_CODE variabeln behövs inte längre sedan onActivityResult() metoden är depreceated i Java.
 * Men om vi skulle konvertera den till Kotlin kod, så ser den ut så här:
 *
 *     companion object {
 *       private const val MY_DATA_CHECK_CODE = 2323
 *     }
 */
class MainActivity : AppCompatActivity(), OnInitListener {
    private var mTts: TextToSpeech? = null
    private var mBtnTts: Button? = null
    private var mETxt1: EditText? = null

    @RequiresApi(Build.VERSION_CODES.LOLLIPOP)
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        Log.d(TAG, "Create app")
        setContentView(R.layout.activity_main)
        mBtnTts = this.findViewById(R.id.button1) // Knappen som läser upp inskriven text.
        mETxt1 = this.findViewById(R.id.editText1) // Text rutan där användaren skriver in text.
        Log.d(TAG, "Create listener for hint text")
        // Lyssnar efter ifall fokus ändras till text rutan & ändrar hjälp texten till "", eller inget.
        mETxt1!!.setOnFocusChangeListener { _, hasFocus ->
            if (hasFocus) {
                mETxt1!!.setHint(R.string.hint_text) // Hjälp text. (hint)
            } else {
                mETxt1!!.hint = "" // Ta bort hjälp texten (hint).
            }
        }
        mBtnTts!!.isEnabled = false // Deaktivera knappen innan vi vet att TTS existerar & är igång
        if (mTts == null) {
            checkTTS()
        }
        mBtnTts!!.setOnClickListener { speakOut() }

    }

    /**
     * Då onActivityResult och startActivityForResult är depreceated och en Intent inte behövs för TTS,
     * så initieras TTS här, för att kontrollera status i onInit() funktionen istället.
     */
    private fun checkTTS() {
        Log.d(TAG, "Start checkTTS")
        mTts = TextToSpeech(this, this)
    }

    /**
     * Taget ur onInit dokumentationen som det görs en override på.
     * Called to signal the completion of the TextToSpeech engine initialization.
     * Params:
     * @param status – SUCCESS or ERROR.
     */
    @RequiresApi(Build.VERSION_CODES.LOLLIPOP)
    override fun onInit(status: Int) {
        // Kontrollerar att TextTillTal fungerar när TTS Engine instansieras.
        if (status == SUCCESS) {
            mBtnTts!!.isEnabled = true
            Log.d(TAG, "Ställer in språket till Engelska.")
            mTts!!.language = Locale.US
            val myText1 = getText(R.string.hello_android)
            val myText2 = getText(R.string.course_welcome)
            mTts!!.speak(myText1, QUEUE_FLUSH, null, TAG)
            mTts!!.speak(myText2, QUEUE_ADD, null, TAG)
            Log.d(TAG, "Ställer in språket till mobilens default språk.")
            val ttsLang = mTts!!.setLanguage(Locale.getDefault())
            // Kontrollerar om språket saknas eller om språket stöds av TextToSpeech Engine.
            if (ttsLang == LANG_MISSING_DATA || ttsLang == TextToSpeech.LANG_NOT_SUPPORTED) {
                Toast.makeText(this, "An error occurred with TTS init!", Toast.LENGTH_LONG).show()
                Log.e(TAG, "Språket stöds inte.")
            } else {
                mBtnTts!!.isEnabled = true
                Log.i(TAG, "TTS successfully initialized.")
                Toast.makeText(this, "Language: " + Locale.getDefault(), Toast.LENGTH_LONG).show()
            }
        } else {
            Toast.makeText(
                this,
                "TextToSpeech initialization failed! Something went wrong..",
                Toast.LENGTH_SHORT
            ).show()
            Log.e(TAG, "TTS initialization failed.")
        }
    }

    /**
     * Tal funktion, används för att läsa upp inskriven text.
     */
    @RequiresApi(Build.VERSION_CODES.LOLLIPOP)
    private fun speakOut() {
        val text = mETxt1!!.text.toString()
        mTts!!.speak(text, QUEUE_FLUSH, null, TAG)
    }

    /**
     * Förstör TextTillTal instansen när den avslutas/stoppas.
     */
    public override fun onDestroy() {
        if (mTts != null) {
            mTts!!.stop()
            mTts!!.shutdown()
        }
        super.onDestroy()
    }
}
