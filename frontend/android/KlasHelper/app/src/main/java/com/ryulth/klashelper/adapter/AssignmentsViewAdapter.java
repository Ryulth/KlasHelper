package com.ryulth.klashelper.adapter;

import android.content.Context;
import android.support.v7.widget.SwitchCompat;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.CompoundButton;
import android.widget.Switch;
import android.widget.TextView;
import android.widget.Toast;

import com.ryulth.klashelper.R;
import com.ryulth.klashelper.pojo.model.Assignment;

import java.lang.reflect.Array;
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


        TextView assignmentTitle = (TextView) convertView.findViewById(R.id.assignmentTitle);
        TextView assignmentDate = (TextView) convertView.findViewById(R.id.assignmentDate);
        final TextView assignmentClass = (TextView) convertView.findViewById(R.id.assignmentClass);
        Switch assignmentSwitch = (Switch) convertView.findViewById(R.id.assignmentSwitch);
        assignmentSwitch.setTag(position);

        String finishTime = ("0".equals(assignments.get(position).getWorkFinishTime()))
                ? "기한 없음" : assignments.get(position).getWorkFinishTime();
        assignmentTitle.setText(assignments.get(position).getWorkTitle());
        assignmentDate.setText("마감 기한 : " + finishTime);
        assignmentClass.setText(assignments.get(position).getWorkCourse());
        assignmentSwitch.setOnCheckedChangeListener(null);
        assignmentSwitch.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {

            @Override
            public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                int position = (Integer)buttonView.getTag();
                assignments.get(position).getIsAlarm();

                if (isChecked){
                    assignments.get(position).setIsAlarm(1);
                }
                else {
                    assignments.get(position).setIsAlarm(0);
                }
                notifyDataSetChanged();
                buttonView.setChecked(isChecked);
                Log.d("switch",String.valueOf(isChecked));
            }
        });
        return convertView;
    }


}
