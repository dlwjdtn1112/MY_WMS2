package com.ssg.my_wms2.formatters;

import org.springframework.format.Formatter;

import java.text.ParseException;
import java.util.Locale;

public class CheckboxFormatter implements Formatter<Boolean> {
    @Override
    public Boolean parse(String text, Locale locale) throws ParseException {
        if(text == null) { return false;}
        return  text.equals("on");
       }

    @Override
    public String print(Boolean object, Locale locale) {
        return object.toString();
    }
}


