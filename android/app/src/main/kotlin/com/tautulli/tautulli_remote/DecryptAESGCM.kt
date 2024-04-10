package com.tautulli.tautulli_remote

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
 * Updated by wcomartin on 2020-07-19 (converted to kotlin)
 */
object DecryptAESGCM {
    fun decrypt(version: Int, deviceToken: String, _salt: String, _cipherText: String, _nonce: String): String {
        val charset = Charsets.UTF_8

        val cipherText: ByteArray = Base64.decode(_cipherText.toByteArray(charset), Base64.DEFAULT)
        val nonce: ByteArray = Base64.decode(_nonce.toByteArray(charset), Base64.DEFAULT)
        val salt: ByteArray = Base64.decode(_salt.toByteArray(charset), Base64.DEFAULT)
        try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
                val encryptionKey: SecretKey = if (version == 2) deriveKeyV2(deviceToken, salt, 600000, 32 * 8) else deriveKey(deviceToken, salt, 1000, 32 * 8)
                val cipher: Cipher = Cipher.getInstance("AES/GCM/NoPadding")
                cipher.init(Cipher.DECRYPT_MODE, encryptionKey, GCMParameterSpec(16 * 8, nonce))
                val plainText: ByteArray = cipher.doFinal(cipherText)
                return plainText.toString(charset)
            }
        } catch (e: Exception) {
            e.printStackTrace()
        }
        return ""
    }

    @kotlin.jvm.Throws(Exception::class)
    fun deriveKey(p: String, s: ByteArray?, i: Int, l: Int): SecretKey {
        val ks = PBEKeySpec(p.toCharArray(), s, i, l)
        val skf: SecretKeyFactory = SecretKeyFactory.getInstance("PBKDF2WithHmacSHA1")
        val tmp: SecretKey = skf.generateSecret(ks)
        return SecretKeySpec(tmp.getEncoded(), "AES")
    }

    @kotlin.jvm.Throws(Exception::class)
    fun deriveKeyV2(p: String, s: ByteArray?, i: Int, l: Int): SecretKey {
        val ks = PBEKeySpec(p.toCharArray(), s, i, l)
        val skf: SecretKeyFactory = SecretKeyFactory.getInstance("PBKDF2WithHmacSHA256")
        val tmp: SecretKey = skf.generateSecret(ks)
        return SecretKeySpec(tmp.getEncoded(), "AES")
    }
}