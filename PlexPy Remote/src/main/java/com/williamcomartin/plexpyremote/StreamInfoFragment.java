package com.williamcomartin.plexpyremote;

import android.app.AlertDialog;
import android.content.DialogInterface;
import android.databinding.DataBindingUtil;
import android.databinding.ViewDataBinding;
import android.graphics.Bitmap;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v4.app.Fragment;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.ProgressBar;
import android.widget.ScrollView;
import android.widget.TextView;

import com.android.volley.toolbox.NetworkImageView;
import com.joanzapata.iconify.widget.IconTextView;
import com.williamcomartin.plexpyremote.Helpers.ImageHelper;
import com.williamcomartin.plexpyremote.Helpers.UrlHelpers;
import com.williamcomartin.plexpyremote.Helpers.VolleyHelpers.ImageCacheManager;
import com.williamcomartin.plexpyremote.Models.ActivityModels;
import com.williamcomartin.plexpyremote.Models.ActivityModels.Activity;
import com.williamcomartin.plexpyremote.Services.PlatformService;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;
import java.util.concurrent.TimeUnit;

public class StreamInfoFragment extends Fragment {

    private TextView vEta;
    private TextView vRemaining;
    private IconTextView vState;
    private ProgressBar vProgress;

    private Activity activity;
    private ViewDataBinding binding;

    private NetworkImageView vBackgroundImage;
    private NetworkImageView vImage;
    private NetworkImageView vImageBlurred;

    private ImageView vPlayerAvatar;

    private TextView vTitle;
    private TextView vSubtitle;
    private TextView vEpisode;

    private TextView vIPAddressButton;
    private TextView vBandwidthButton;

    public StreamInfoFragment() {
        // Required empty public constructor
    }

    @Override
    public View onCreateView(LayoutInflater inflater,
                             @Nullable ViewGroup container,
                             @Nullable Bundle savedInstanceState) {
        binding = DataBindingUtil.inflate(inflater, R.layout.fragment_stream_info, container, false);
        View view = binding.getRoot();

        vBackgroundImage = view.findViewById(R.id.activity_stream_background_art);
        vImage = view.findViewById(R.id.activity_stream_image);
        vImageBlurred = view.findViewById(R.id.activity_stream_image_blurred);

        vEta = view.findViewById(R.id.activity_stream_eta);
        vRemaining = view.findViewById(R.id.activity_stream_time_remaining);
        vState = view.findViewById(R.id.activity_stream_state_icon);
        vProgress = view.findViewById(R.id.activity_stream_progress_bar);

        vTitle = view.findViewById(R.id.activity_stream_title);
        vSubtitle = view.findViewById(R.id.activity_stream_subtitle);
        vEpisode = view.findViewById(R.id.activity_stream_muted_title);

        vPlayerAvatar = view.findViewById(R.id.activity_stream_player_avatar);

        vIPAddressButton = view.findViewById(R.id.activity_stream_open_ip_address);
        vBandwidthButton = view.findViewById(R.id.activity_stream_open_bandwidth);

        return view;
    }

    public int getSessionKey() {
        if(activity.session_key == null) return 0;
        return Integer.parseInt(activity.session_key);
    }

    public void setStreamInfo(ActivityModels.Activity activity) {
        this.activity = activity;
        binding.setVariable(BR.activity, activity);

        vBackgroundImage.setImageUrl(UrlHelpers.getImageUrl(activity.art, "600", "400"), ImageCacheManager.getInstance().getImageLoader());

        vEta.setText(String.format(getString(R.string.eta), formatDuration(activity.duration, activity.view_offset)));

        vRemaining.setText(formatSeconds(activity.view_offset) + "/" + formatSeconds(activity.duration));

        if (activity.state.equals("playing")) {
            vState.setText("{fa-play}");
        } else if (activity.state.equals("paused")) {
            vState.setText("{fa-pause}");
        } else if (activity.state.equals("buffering")) {
            vState.setText("{fa-spinner}");
        }

        vProgress.setProgress(Integer.parseInt(activity.progress_percent));
        vProgress.setSecondaryProgress(Integer.parseInt(activity.transcode_progress));

        String imageUrl;

        if (activity.media_type.equals("episode")) {
            vTitle.setText(activity.grandparent_title);
            vSubtitle.setText(activity.title);
            vEpisode.setText("S" + activity.parent_media_index + " • E" + activity.media_index);
            imageUrl = UrlHelpers.getImageUrl(activity.grandparent_thumb, "600", "400");
            vImage.setScaleType(ImageView.ScaleType.CENTER_CROP);
        } else if (activity.media_type.equals("track")) {
            vTitle.setText(activity.grandparent_title);
            vSubtitle.setText(activity.title);
            vEpisode.setText(activity.parent_title);
            imageUrl = UrlHelpers.getImageUrl(activity.thumb, "600", "400");
            vImage.setScaleType(ImageView.ScaleType.CENTER_INSIDE);
        } else {
            vTitle.setText(activity.title);
            vSubtitle.setText("");
            vEpisode.setText(activity.year);
            imageUrl = UrlHelpers.getImageUrl(activity.thumb, "600", "400");
            vImage.setScaleType(ImageView.ScaleType.CENTER_CROP);
        }

        vImage.setImageUrl(imageUrl, ImageCacheManager.getInstance().getImageLoader());
        vImageBlurred.setImageUrl(imageUrl, ImageCacheManager.getInstance().getImageLoader());
        vImageBlurred.setAlpha(0.75f);

        if (vSubtitle.getText().equals("")) {
            vSubtitle.setVisibility(View.GONE);
        } else {
            vSubtitle.setVisibility(View.VISIBLE);
        }

        int platformResource;
        int platformColorResource;
        if(activity.platform_name == null){
            platformResource = PlatformService.getV1Platform(activity.platform);
            platformColorResource = PlatformService.getV1PlatformColor(activity.platform);
        } else {
            platformResource = PlatformService.getPlatformImagePath(activity.platform_name);
            platformColorResource = PlatformService.getPlatformColor(activity.platform_name);
        }

        Bitmap platform = PlatformService.getBitmapFromVectorDrawable(getContext(), platformResource, platformColorResource);
        vPlayerAvatar.setImageBitmap(ImageHelper.getRoundedCornerBitmap(platform, 15));

        vBandwidthButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Log.d("StreamInfo", "Bandwidth Button");

                AlertDialog.Builder builder = new AlertDialog.Builder(getActivity());
                builder.setMessage(R.string.bandwidth_dialog);

                builder.setPositiveButton("Dismiss", new DialogInterface.OnClickListener() {
                    public void onClick(DialogInterface dialog, int id) {
                        dialog.dismiss();
                    }
                });

                AlertDialog dialog = builder.create();

                dialog.show();
            }
        });

        vIPAddressButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Log.d("StreamInfo", "IP Address Button");
            }
        });
    }

    private String formatSeconds(String millis) {
        try {
            return String.format(Locale.US, "%d:%02d",
                    TimeUnit.MILLISECONDS.toMinutes(Integer.parseInt(millis)),
                    TimeUnit.MILLISECONDS.toSeconds(Integer.parseInt(millis)) -
                            TimeUnit.MINUTES.toSeconds(TimeUnit.MILLISECONDS.toMinutes(Integer.parseInt(millis)))
            );
        } catch (NumberFormatException e) {
            return "0:00";
        }
    }

    private String formatDuration(String duration, String difference){
        int timeleft = Integer.parseInt(duration) - Integer.parseInt(difference);
        long eta = new Date().getTime() + timeleft;
        SimpleDateFormat dt = new SimpleDateFormat("hh:mm", Locale.US);
        return dt.format(new Date(eta));
    }
}
