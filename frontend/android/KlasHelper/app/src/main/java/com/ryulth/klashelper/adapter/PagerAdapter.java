package com.ryulth.klashelper.adapter;

import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentPagerAdapter;

import com.ryulth.klashelper.fragment.FirstFragment;
import com.ryulth.klashelper.fragment.SecondFragment;
import com.ryulth.klashelper.fragment.ThirdFragment;
import com.ryulth.klashelper.pojo.model.Assignment;

import java.util.List;

public class PagerAdapter extends FragmentPagerAdapter {

    private FirstFragment firstFragment;

    public PagerAdapter(FragmentManager fm) {
        super(fm);
    }

    @Override
    public Fragment getItem(int position) {
        switch (position) {
            case 0:
                firstFragment = new FirstFragment();
                return firstFragment;
            case 1:
                return new SecondFragment();
            case 2:
                return new ThirdFragment();
        }
        return null;
    }

    @Override
    public int getCount() {
        return 3;
    }

    public void setData(List<Assignment> list, String tableName) {
        firstFragment.setData(list, tableName);
    }
}
