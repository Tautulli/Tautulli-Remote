package com.williamcomartin.plexpyremote.Helpers;

/**
 * Created by wcomartin on 2017-11-27.
 */

public class StringHelpers {


    public static boolean isNullOrWhiteSpace(String value) {
        if (value == null) {
            return true;
        }

        for (int i = 0; i < value.length(); i++) {
            if (!Character.isWhitespace(value.charAt(i))) {
                return false;
            }
        }

        return true;
    }

}
