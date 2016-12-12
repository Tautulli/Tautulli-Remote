package com.williamcomartin.plexpyremote.Helpers;

import java.sql.Time;
import java.util.concurrent.TimeUnit;

/**
 * Created by wcomartin on 2016-12-01.
 */

public class TimeHelpers {

    public static class SplitDuration {
        public int days;
        public int hours;
        public int minutes;

        public SplitDuration(int days, int hours, int minutes) {
            this.days = days;
            this.hours = hours;
            this.minutes = minutes;
        }
    }

    public static SplitDuration splitTimestamp(int Timestamp) {

        int days = (int) TimeUnit.SECONDS.toDays(Timestamp);
        int hours = (int) (TimeUnit.SECONDS.toHours(Timestamp) - (days * 24));
        int minutes = (int) (TimeUnit.SECONDS.toMinutes(Timestamp) - (TimeUnit.SECONDS.toHours(Timestamp) * 60));

//        int days = (int) TimeUnit.MILLISECONDS.toDays(Timestamp);
//        int hours = (int) (TimeUnit.MILLISECONDS.toHours(Timestamp) - TimeUnit.MILLISECONDS.toHours(TimeUnit.MILLISECONDS.toDays(Timestamp)));
//        int minutes = (int) (TimeUnit.MILLISECONDS.toMinutes(Timestamp) - TimeUnit.MILLISECONDS.toMinutes(TimeUnit.MILLISECONDS.toHours(Timestamp)));
        return new SplitDuration(days, hours, minutes);
    }

}
