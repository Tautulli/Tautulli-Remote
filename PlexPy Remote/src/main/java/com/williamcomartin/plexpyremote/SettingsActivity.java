package com.williamcomartin.plexpyremote;

import android.Manifest;
import android.annotation.TargetApi;
import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.SharedPreferences;
import android.hardware.camera2.CameraAccessException;
import android.hardware.camera2.CameraCharacteristics;
import android.hardware.camera2.CameraManager;
import android.os.AsyncTask;
import android.os.Build;
import android.os.Bundle;
import android.preference.PreferenceManager;
import android.support.v7.app.ActionBar;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;
import android.widget.Toast;

import com.google.zxing.integration.android.IntentIntegrator;
import com.google.zxing.integration.android.IntentResult;

import java.net.InetAddress;
import java.net.UnknownHostException;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class SettingsActivity extends NavBaseActivity {

    private static final int MY_PERMISSIONS_REQUEST_CAMERA = 1;
    protected final Context context = this;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_settings);

        setupActionBar();
    }

    protected void setupActionBar() {
        ActionBar actionBar = getSupportActionBar();
        actionBar.setTitle(R.string.settings);
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_main, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // handle item selection
        switch (item.getItemId()) {
            case R.id.readQRButton:
                scanCode();
                return true;
            default:
                return super.onOptionsItemSelected(item);
        }
    }


    @TargetApi(Build.VERSION_CODES.LOLLIPOP)
    public void scanCode() {

        try {
            CameraManager manager = (CameraManager) getApplicationContext().getSystemService(Context.CAMERA_SERVICE);
            String[] cameraIds = manager.getCameraIdList();
            for (int i = 0; i < cameraIds.length; i++) {
                CameraCharacteristics characteristics = manager.getCameraCharacteristics(cameraIds[i]);
                if (characteristics.get(CameraCharacteristics.LENS_FACING) == CameraCharacteristics.LENS_FACING_BACK) {
                    IntentIntegrator integrator = new IntentIntegrator(this);
                    integrator.setCameraId(i);
                    integrator.initiateScan();
                }
            }
        } catch (CameraAccessException e) {
            Log.d("No Camera Access", e.getMessage());
        }

    }

    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        IntentResult result = IntentIntegrator.parseActivityResult(requestCode, resultCode, data);
        if (result != null) {
            if (result.getContents() == null) {
                Toast.makeText(this, "Cancelled", Toast.LENGTH_LONG).show();
            } else {
                Toast.makeText(this, "Scanned: " + result.getContents(), Toast.LENGTH_LONG).show();
                String[] parts = result.getContents().split("\\|");

                SharedPreferences SP = PreferenceManager.getDefaultSharedPreferences(getApplicationContext());
                SharedPreferences.Editor editor = SP.edit();
                editor.putString("server_settings_address", parts[0]);
                editor.putString("server_settings_apikey", parts[1]);
                editor.apply();

                new CheckLocalAsync().execute(parts[0]);

                SettingsFragment frag = (SettingsFragment) getFragmentManager().findFragmentById(R.id.settings_fragment);
                frag.onResume();
            }
        } else {
            // This is important, otherwise the result will not be passed to the fragment
            super.onActivityResult(requestCode, resultCode, data);
        }
    }

    private class CheckLocalAsync extends AsyncTask<String, Void, Boolean> {
        @Override
        protected Boolean doInBackground(String... params) {
            String address = getAddress(params[0]);
            Boolean isLocal = testAddress(address);
            return isLocal;
        }

        private String getAddress(String part){
            String address = "";

            String pattern = "https?:\\/\\/([\\w\\.]*)(:\\d+)?(\\/.*)?";
            Pattern r = Pattern.compile(pattern);
            Matcher m = r.matcher(part);

            if(m.find()){
                address = m.group(1);
            }
            return address;
        }

        private Boolean testAddress(String address){
            try{
                InetAddress ad = InetAddress.getByName(address);
                if(ad.isSiteLocalAddress()){
                    Log.d("CheckIfLocal", "LOCAL TRUE");
                    return true;
                }
            } catch (UnknownHostException e){
                Log.d("CheckIfLocal", e.getMessage());
            }
            return false;
        }

        @Override
        protected void onPostExecute(Boolean isLocal) {
            if(isLocal) {
                new AlertDialog.Builder(context)
                        .setTitle("Local Address")
                        .setMessage("Note: This is a private IP address. PlexPy will not be reachable outside of your home network. Access PlexPy externally to generate the QR code for remote access.")
                        .setCancelable(false)
                        .setPositiveButton("OK", new DialogInterface.OnClickListener() {
                            public void onClick(DialogInterface dialog, int id) {
                                //do things
                            }
                        })
                        .setIcon(android.R.drawable.ic_dialog_alert)
                        .show();
            }
        }
    }

    @Override
    public void onBackPressed() {
        Intent intent = new Intent(this, ActivityActivity.class);
        intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TASK);
        startActivity(intent);
    }
}
