package com.williamcomartin.plexpyremote.MediaActivities.Show;

import android.content.Context;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.content.ContextCompat;
import android.text.SpannableString;
import android.text.style.ForegroundColorSpan;
import android.util.TypedValue;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.RatingBar;
import android.widget.TextView;

import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.NetworkImageView;
import com.williamcomartin.plexpyremote.ApplicationController;
import com.williamcomartin.plexpyremote.Helpers.Exceptions.NoServerException;
import com.williamcomartin.plexpyremote.Helpers.GsonRequest;
import com.williamcomartin.plexpyremote.Helpers.UrlHelpers;
import com.williamcomartin.plexpyremote.R;

/**
 * Created by wcomartin on 2016-12-14.
 */

public class ShowProfileFragment extends Fragment {

    private View view;
    private String ratingKey;

    private NetworkImageView vImage;
    private TextView vStudio;
    private TextView vAired;
    private TextView vRuntime;
    private TextView vRated;
    private RatingBar vRating;

    private TextView vDescription;

    private LinearLayout vStarring;
    private LinearLayout vGenres;

    private Context context;

    public ShowProfileFragment() {}

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        view = inflater.inflate(R.layout.fragment_show_profile, container, false);

        context = this.getContext();

        vImage = (NetworkImageView) view.findViewById(R.id.show_profile_image);
        vStudio = (TextView) view.findViewById(R.id.show_profile_studio);
        vAired = (TextView) view.findViewById(R.id.show_profile_aired);
        vRuntime = (TextView) view.findViewById(R.id.show_profile_runtime);
        vRated = (TextView) view.findViewById(R.id.show_profile_rated);
        vRating = (RatingBar) view.findViewById(R.id.show_profile_rating);

        vDescription = (TextView) view.findViewById(R.id.show_profile_description);

        vStarring = (LinearLayout) view.findViewById(R.id.show_profile_starring);
        vGenres = (LinearLayout) view.findViewById(R.id.show_profile_genres);

        fetchProfile();
        return view;
    }

    public void setRatingKey(String ratingKey) {
        this.ratingKey = ratingKey;
    }

    private void fetchProfile(){
        String url = "";
        try {
            url = UrlHelpers.getHostPlusAPIKey() + "&cmd=get_metadata&rating_key=" + ratingKey;
        } catch (NoServerException e) {
            e.printStackTrace();
        }
        GsonRequest<ShowProfileModels> request = new GsonRequest<>(
                url,
                ShowProfileModels.class,
                null,
                requestListener(),
                errorListener()
        );

        ApplicationController.getInstance().addToRequestQueue(request);
    }

    private Response.ErrorListener errorListener() {
        return new Response.ErrorListener() {
            @Override
            public void onErrorResponse(VolleyError error) {
            }
        };
    }

    private Response.Listener<ShowProfileModels> requestListener() {
        return new Response.Listener<ShowProfileModels>() {
            @Override
            public void onResponse(ShowProfileModels response) {
                vImage.setImageUrl(UrlHelpers.getImageUrl(response.response.data.thumb, "400", "600"),
                        ApplicationController.getInstance().getImageLoader());

                vStudio.setText(response.response.data.studio);
                vAired.setText(response.response.data.year);
                int duration = Integer.parseInt(response.response.data.duration) / 60 / 1000;
                vRuntime.setText(String.valueOf(duration) + " mins");
                vRated.setText(response.response.data.contentRating);

                vRating.setRating(Float.parseFloat(response.response.data.rating) / 2);

                vDescription.setText(response.response.data.summary);

                int listLength;
                if(response.response.data.actors.size() > 5){
                    listLength = 5;
                } else {
                    listLength = response.response.data.actors.size();
                }

                LinearLayout.LayoutParams params = new LinearLayout.LayoutParams(
                        LinearLayout.LayoutParams.WRAP_CONTENT,
                        LinearLayout.LayoutParams.WRAP_CONTENT
                );
                int marginInDp = (int) TypedValue.applyDimension(
                        TypedValue.COMPLEX_UNIT_DIP, 10, getResources().getDisplayMetrics());
                params.setMargins(marginInDp, 0, 0, 0);

                int color = ContextCompat.getColor(context, R.color.colorTextHeading);



                for (int i = 0; i < listLength; i++){
                    TextView text = new TextView(context);
                    text.setLayoutParams(params);

                    SpannableString s = new SpannableString(response.response.data.actors.get(i));
                    s.setSpan(new ForegroundColorSpan(color), 0, s.length(), 0);

                    text.setText(s);
                    vStarring.addView(text);
                }

                for (String genre : response.response.data.genres){
                    TextView text = new TextView(context);
                    text.setLayoutParams(params);

                    SpannableString s = new SpannableString(genre);
                    s.setSpan(new ForegroundColorSpan(color), 0, s.length(), 0);

                    text.setText(s);
                    vGenres.addView(text);
                }
            }
        };
    }
}
