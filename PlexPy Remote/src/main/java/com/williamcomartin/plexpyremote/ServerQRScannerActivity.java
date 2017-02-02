package com.williamcomartin.plexpyremote;

import android.Manifest;
import android.annotation.TargetApi;
import android.app.Activity;
import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.pm.PackageManager;
import android.hardware.camera2.CameraAccessException;
import android.hardware.camera2.CameraCharacteristics;
import android.hardware.camera2.CameraManager;
import android.os.AsyncTask;
import android.os.Build;
import android.os.Bundle;
import android.preference.PreferenceManager;
import android.support.v4.app.ActivityCompat;
import android.support.v4.content.ContextCompat;
import android.util.Log;
import android.widget.Toast;

import com.google.zxing.integration.android.IntentIntegrator;
import com.google.zxing.integration.android.IntentResult;

import java.net.InetAddress;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.UnknownHostException;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Created by wcomartin on 2016-12-05.
 */

public class ServerQRScannerActivity extends Activity {

    private static final int MY_PERMISSIONS_REQUEST_CAMERA = 1;
    protected final Context context = this;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        requestCameraPermission();
    }

    public void requestCameraPermission() {
        if (ContextCompat.checkSelfPermission(this,
                Manifest.permission.CAMERA) != PackageManager.PERMISSION_GRANTED) {
            ActivityCompat.requestPermissions(this, new String[]{Manifest.permission.CAMERA}, MY_PERMISSIONS_REQUEST_CAMERA);
        } else {
            scanCode();
        }
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        switch (requestCode){
            case MY_PERMISSIONS_REQUEST_CAMERA: {
                if (grantResults.length > 0
                        && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                    scanCode();
                }
            }
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
        }

    }

    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        IntentResult result = IntentIntegrator.parseActivityResult(requestCode, resultCode, data);
        if (result != null) {
            if (result.getContents() == null) {
                Toast.makeText(this, "Cancelled", Toast.LENGTH_LONG).show();
                Intent intent = new Intent(context, SettingsActivity.class);
                startActivity(intent);
            } else {
                Toast.makeText(this, "Scanned: " + result.getContents(), Toast.LENGTH_LONG).show();
                String[] parts = result.getContents().split("\\|");

                SharedPreferences SP = PreferenceManager.getDefaultSharedPreferences(getApplicationContext());
                SharedPreferences.Editor editor = SP.edit();
                try {
                    URL oldUrl = new URL(parts[0]);

                    boolean serverSSL = oldUrl.getProtocol().equals("https");
                    String serverHost = oldUrl.getHost();
                    int serverPort = oldUrl.getPort();
                    String serverPath = oldUrl.getPath();

                    editor.putBoolean("server_settings_ssl", serverSSL);
                    editor.putString("server_settings_address", serverHost);
                    if(serverPort != -1) {
                        editor.putString("server_settings_port", String.valueOf(serverPort));
                    } else {
                        editor.putString("server_settings_port", serverSSL ? "443" : "80");
                    }
                    editor.putString("server_settings_path", serverPath);

                } catch (MalformedURLException e) {
                    e.printStackTrace();
                }
                editor.putString("server_settings_apikey", parts[1]);
                editor.apply();

                Map<String,?> keys = SP.getAll();

                for(Map.Entry<String,?> entry : keys.entrySet()){
                    Log.d("map values",entry.getKey() + ": " +
                            entry.getValue().toString());
                }

                new CheckLocalAsync().execute(parts[0]);
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
                    return true;
                }
            } catch (UnknownHostException e){
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

            Intent intent = new Intent(context, SettingsActivity.class);
            startActivity(intent);
        }
    }
}
