package com.williamcomartin.plexwatch.Models;

/**
 * Created by wcomartin on 2015-11-04.
 */
public class Stat {

    private int Value;
    private String Name;

    public Stat(String Name, int Value) {
        this.Name = Name;
        this.Value = Value;
    }

    public String getName() {
        return Name;
    }

    public int getValue() {
        return Value;
    }


}
