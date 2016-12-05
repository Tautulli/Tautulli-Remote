package com.williamcomartin.plexpyremote.Helpers.CustomPreferences;

import android.annotation.TargetApi;
import android.content.Context;
import android.os.Build;
import android.preference.EditTextPreference;
import android.util.AttributeSet;
import android.util.Log;

/**
 * Created by wcomartin on 2016-12-05.
 */

public class EditTextPreferenceWithDisplay extends EditTextPreference {
    private String defaultSummary;

    public EditTextPreferenceWithDisplay(final Context ctx, final AttributeSet attrs) {
        super(ctx, attrs);

        for (int i=0;i<attrs.getAttributeCount();i++) {
            String attr = attrs.getAttributeName(i);
            String val  = attrs.getAttributeValue(i);
            if (attr.equalsIgnoreCase("defaultsummary")) {
                this.defaultSummary = val;
            }
        }
    }

    public EditTextPreferenceWithDisplay(final Context ctx) {
        super(ctx);
    }

    @Override
    public void setText(String text) {
        super.setText(text);
        if (!getText().equals("")) {
            setSummary(getText());
        } else {
            setSummary(defaultSummary);
        }
    }
}
