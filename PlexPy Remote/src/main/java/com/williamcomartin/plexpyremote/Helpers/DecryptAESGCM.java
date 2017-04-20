package com.williamcomartin.plexpyremote.Helpers;

import android.os.Build;
import android.util.Base64;

import javax.crypto.Cipher;
import javax.crypto.SecretKey;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.GCMParameterSpec;
import javax.crypto.spec.PBEKeySpec;
import javax.crypto.spec.SecretKeySpec;

/**
 * Created by wcomartin on 2017-04-18.
 */

public class DecryptAESGCM {
    public static String Decrypt(String apiKey, String _salt, String _cipherText, String _nonce) {

        byte[] cipherText = Base64.decode(_cipherText.getBytes(), Base64.DEFAULT);
        byte[] nonce = Base64.decode(_nonce.getBytes(), Base64.DEFAULT);
        byte[] salt = Base64.decode(_salt.getBytes(), Base64.DEFAULT);

        try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
                SecretKey encryptionKey = deriveKey(apiKey, salt, 1000, 32 * 8);

                Cipher cipher = Cipher.getInstance("AES/GCM/NoPadding");
                cipher.init(Cipher.DECRYPT_MODE, encryptionKey, new GCMParameterSpec(16 * 8, nonce));
                byte[] plainText = cipher.doFinal(cipherText);

                String plainTextOut = new String(plainText, "UTF8");

                return plainTextOut;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return "";
    }

    public static SecretKey deriveKey(String p, byte[] s, int i, int l) throws Exception {
        PBEKeySpec ks = new PBEKeySpec(p.toCharArray(), s, i, l);
        SecretKeyFactory skf = SecretKeyFactory.getInstance("PBKDF2WithHmacSHA1");
        SecretKey tmp = skf.generateSecret(ks);
        SecretKey key = new SecretKeySpec(tmp.getEncoded(), "AES");
        return key;
    }
}
