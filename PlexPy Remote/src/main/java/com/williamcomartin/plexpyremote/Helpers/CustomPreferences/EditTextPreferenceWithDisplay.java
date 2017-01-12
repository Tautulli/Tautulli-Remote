package com.williamcomartin.plexpyremote.Helpers.CustomPreferences;

import android.annotation.TargetApi;
import android.content.Context;
import android.content.res.TypedArray;
import android.os.Build;
import android.preference.EditTextPreference;
import android.util.AttributeSet;
import android.util.Log;

import com.williamcomartin.plexpyremote.R;

/**
 * Created by wcomartin on 2016-12-05.
 */

public class EditTextPreferenceWithDisplay extends EditTextPreference {
    private boolean trimValue;
    private String defaultSummary;

    public EditTextPreferenceWithDisplay(final Context ctx, final AttributeSet attrs) {
        super(ctx, attrs);

        TypedArray a = ctx.obtainStyledAttributes(attrs, R.styleable.EditTextPreferenceWithDisplay);
        defaultSummary = a.getString(R.styleable.EditTextPreferenceWithDisplay_defaultSummary);
        trimValue = a.getBoolean(R.styleable.EditTextPreferenceWithDisplay_trimValue, false);
        a.recycle();
    }

    public EditTextPreferenceWithDisplay(final Context ctx) {
        super(ctx);
    }

    @Override
    public void setText(String text) {
        if(trimValue) super.setText(text.trim());
        else super.setText(text);
        if (!getText().equals("")) {
            setSummary(getText());
        } else {
            setSummary(defaultSummary);
        }
    }
}
