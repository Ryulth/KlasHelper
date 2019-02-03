package com.example.ryulth.klashelper.adapter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ListView;
import android.widget.TextView;

import com.example.ryulth.klashelper.R;
import com.example.ryulth.klashelper.pojo.model.Assignment;

import java.util.ArrayList;
import java.util.List;

import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper=false)
public class AssignmentsViewAdapter extends BaseAdapter {
    private LayoutInflater inflater = null;
    private List<Assignment> assignments = new ArrayList<>();

    @Override
    public int getCount() {
        return assignments.size();
    }

    @Override
    public Object getItem(int position) {
        return assignments.get(position);
    }

    @Override
    public long getItemId(int position) {
        return position;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        if (convertView == null)
        {
            final Context context = parent.getContext();
            if (inflater == null)
            {
                inflater = (LayoutInflater) context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
            }
            convertView = inflater.inflate(R.layout.listview_assignments, parent, false);
        }

        TextView oTextTitle = (TextView) convertView.findViewById(R.id.textTitle);
        TextView oTextDate = (TextView) convertView.findViewById(R.id.textDate);

        oTextTitle.setText(assignments.get(position).getWorkTitle());
        oTextDate.setText(assignments.get(position).getWorkFinishTime());
        return convertView;
    }
}
