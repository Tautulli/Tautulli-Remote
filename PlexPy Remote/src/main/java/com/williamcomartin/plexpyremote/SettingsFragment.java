package com.williamcomartin.plexpyremote;

import android.content.SharedPreferences;
import android.os.Bundle;
import android.preference.EditTextPreference;
import android.preference.PreferenceFragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import java.util.Map;

public class SettingsFragment extends PreferenceFragment implements SharedPreferences.OnSharedPreferenceChangeListener {
    SharedPreferences sharedPreferences;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        addPreferencesFromResource(R.xml.settings);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        // Inflate the layout for this fragment
        return inflater.inflate(R.layout.fragment_settings, container, false);
    }

    @Override
    public void onResume() {
        super.onResume();

        sharedPreferences = getPreferenceManager().getSharedPreferences();

        // we want to watch the preference values' changes
        sharedPreferences.registerOnSharedPreferenceChangeListener(this);

        Map<String, ?> preferencesMap = sharedPreferences.getAll();
        // iterate through the preference entries and update their summary if they are an instance of EditTextPreference
        for (Map.Entry<String, ?> preferenceEntry : preferencesMap.entrySet()) {
            if (preferenceEntry instanceof EditTextPreference) {
                updateSummary((EditTextPreference) preferenceEntry);
            }
        }
    }

    @Override
    public void onPause() {
        sharedPreferences.unregisterOnSharedPreferenceChangeListener(this);
        super.onPause();
    }

    @Override
    public void onSharedPreferenceChanged(SharedPreferences sharedPreferences,
                                          String key) {
        Map<String, ?> preferencesMap = sharedPreferences.getAll();

        // get the preference that has been changed
        Object changedPreference = preferencesMap.get(key);
        // and if it's an instance of EditTextPreference class, update its summary
        if (preferencesMap.get(key) instanceof EditTextPreference) {
            updateSummary((EditTextPreference) changedPreference);
        }
    }

    private void updateSummary(EditTextPreference preference) {
        // set the EditTextPreference's summary value to its current text
        preference.setSummary(preference.getText());
    }

}
