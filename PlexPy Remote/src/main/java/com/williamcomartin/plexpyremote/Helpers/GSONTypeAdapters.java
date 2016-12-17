package com.williamcomartin.plexpyremote.Helpers;

import com.google.gson.TypeAdapter;
import com.google.gson.stream.JsonReader;
import com.google.gson.stream.JsonToken;
import com.google.gson.stream.JsonWriter;

import java.io.IOException;

/**
 * Created by wcomartin on 16-01-22.
 */
public class GSONTypeAdapters {

    public static final TypeAdapter<Number> DoubleTypeAdapter = new TypeAdapter<Number>() {

        @Override
        public void write(JsonWriter out, Number value)
                throws IOException {
            out.value(value);
        }

        @Override
        public Number read(JsonReader in) throws IOException {
            if (in.peek() == JsonToken.NULL) {
                in.nextNull();
                return null;
            }
            try {
                String result = in.nextString();
                return Double.parseDouble(result);
            } catch (NumberFormatException e) {
                return null;
            }
        }
    };

    public static final TypeAdapter<Number> IntegerTypeAdapter = new TypeAdapter<Number>() {

        @Override
        public void write(JsonWriter out, Number value)
                throws IOException {
            out.value(value);
        }

        @Override
        public Number read(JsonReader in) throws IOException {
            if (in.peek() == JsonToken.NULL) {
                in.nextNull();
                return null;
            }
            try {
                String result = in.nextString();
                return Integer.parseInt(result);
            } catch (NumberFormatException e) {
                return null;
            }
        }
    };

    public static final TypeAdapter<Long> LongTypeAdapter = new TypeAdapter<Long>() {

        @Override
        public void write(JsonWriter out, Long value)
                throws IOException {
            out.value(value);
        }

        @Override
        public Long read(JsonReader in) throws IOException {
            if (in.peek() == JsonToken.NULL) {
                in.nextNull();
                return null;
            }
            try {
                String result = in.nextString();
                return Long.parseLong(result);
            } catch (NumberFormatException e) {
                return null;
            }
        }
    };

}
