package com.example.exam1;

import androidx.annotation.NonNull;
import androidx.annotation.RawRes;
import androidx.appcompat.app.AppCompatActivity;

import android.graphics.Bitmap;
import android.graphics.pdf.PdfRenderer;
import android.os.Bundle;
import android.os.ParcelFileDescriptor;
import android.util.Log;
import android.widget.ImageView;

import com.example.exam1.databinding.ActivityPage3Binding;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;

public class Page3 extends AppCompatActivity {

    private ActivityPage3Binding binding;
    private static String TAG;
    private static final String FILENAME = "ray_cv.pdf";
    private PdfRenderer pdfRenderer;
    private PdfRenderer.Page pdfPage;
    private ImageView imgView;
    private int pageNr3;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        this.binding = ActivityPage3Binding.inflate(getLayoutInflater());
        setContentView(this.binding.getRoot());
        initVAR();
        try {
            openPDF(imgView,this.pageNr3);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    /**
     * Init variables
     */
    private void initVAR() {
        TAG = getString(R.string.TAG_Page3);
        this.imgView = this.binding.imgViewPage3Pdf;
        this.pageNr3 = 2;
    }

    /**
     * Render a given page in the PDF document into an ImageView.
     *
     * @param imageView  used to display the PDF
     * @param pageNumber page of the PDF to view (index starting at 0)
     */
    private void openPDF(@NonNull ImageView imageView, int pageNumber) throws IOException {
        Log.d(TAG,"Opening PDF document");
        // Copy sample.pdf from 'res/raw' folder into local cache so PdfRenderer can handle it
        File fileCopy = new File(getCacheDir(), FILENAME);
        copyToLocalCache(fileCopy, R.raw.ray_cv);

        Log.d(TAG,"Fetching a page");
        // We will get a page from the PDF file by calling openPage
        ParcelFileDescriptor fileDescriptor =
                ParcelFileDescriptor.open(fileCopy,
                        ParcelFileDescriptor.MODE_READ_ONLY);
        this.pdfRenderer = new PdfRenderer(fileDescriptor);
        this.pdfPage = this.pdfRenderer.openPage(pageNumber);

        // Create a new bitmap and render the page contents on to it
        Log.d(TAG,"Render content to a bitmap");
        Bitmap bitmap = Bitmap.createBitmap(this.pdfPage.getWidth(),
                this.pdfPage.getHeight(),
                Bitmap.Config.ARGB_8888);
        this.pdfPage.render(bitmap, null, null, PdfRenderer.Page.RENDER_MODE_FOR_DISPLAY);

        // Set the bitmap in the ImageView so we can view it
        Log.d(TAG,"Set bitmap in ImageView");
        imageView.setImageBitmap(bitmap);
    }


    /**
     * Copies the resource PDF file locally so that {@link PdfRenderer} can handle the file
     *
     * @param outputFile  location of copied file
     * @param pdfResource pdf resource file
     */
    private void copyToLocalCache(@NonNull File outputFile, @RawRes int pdfResource) throws IOException {
        Log.d(TAG,"Copying PDF resource file to local cache");
        if (!outputFile.exists()) {
            InputStream input = getResources().openRawResource(pdfResource);
            FileOutputStream output;
            output = new FileOutputStream(outputFile);
            byte[] buffer = new byte[1024];
            int size;
            // Just copy the entire contents of the file
            while ((size = input.read(buffer)) != -1) {
                output.write(buffer, 0, size);
            }
            input.close();
            output.close();
        }
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        Log.d(TAG,"Closing and destroying activity");
        if (this.pdfPage != null) {
            this.pdfPage.close();
        }
        if (this.pdfRenderer != null) {
            this.pdfRenderer.close();
        }
        this.binding = null;
    }
}