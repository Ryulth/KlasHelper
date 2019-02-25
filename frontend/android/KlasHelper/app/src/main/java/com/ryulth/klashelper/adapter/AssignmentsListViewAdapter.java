package com.ryulth.klashelper.adapter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.Switch;
import android.widget.TextView;

import com.ryulth.klashelper.R;
import com.ryulth.klashelper.database.AssignmentRepository;
import com.ryulth.klashelper.pojo.model.Assignment;

import java.util.ArrayList;
import java.util.List;

import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper = false)
public class AssignmentsListViewAdapter extends BaseAdapter {
    private LayoutInflater inflater = null;
    private List<Assignment> assignments = new ArrayList<>();
    private AssignmentRepository assignmentRepository;
    private String tableName;
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
        HolderView holderView;
        assignmentRepository = new AssignmentRepository(parent.getContext());
        if (convertView == null) {
            final Context context = parent.getContext();
            if (inflater == null) {
                inflater = (LayoutInflater) context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
            }

            convertView = inflater.inflate(R.layout.listview_assignments, parent, false);
            holderView = new HolderView();
            holderView.assignmentSwitch = (Switch) convertView.findViewById(R.id.assignmentSwitch);
            holderView.assignmentTitle = (TextView) convertView.findViewById(R.id.assignmentTitle);
            holderView.assignmentDate = (TextView) convertView.findViewById(R.id.assignmentDate);
            holderView.assignmentClass = (TextView) convertView.findViewById(R.id.assignmentClass);
            convertView.setTag(holderView);
        } else {
            holderView = (HolderView) convertView.getTag();
        }
        String finishTime = ("0".equals(assignments.get(position).getWorkFinishTime()))
                ? "기한 없음" : assignments.get(position).getWorkFinishTime();
        holderView.assignmentTitle.setText(assignments.get(position).getWorkTitle());
        holderView.assignmentDate.setText("마감 기한 : " + finishTime);
        holderView.assignmentClass.setText(assignments.get(position).getWorkCourse());
        Boolean isAlarm = (assignments.get(position).getIsAlarm() == 1);
        holderView.assignmentSwitch.setChecked(isAlarm);
        holderView.assignmentSwitch.setTag(position);
        holderView.assignmentSwitch.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(final View v) {
                int position = (Integer) v.getTag();
                int isAlarm ;
                if (((Switch) v).isChecked()) {
                    ((Switch) v).setChecked(true);
                    isAlarm=1;
                } else {
                    ((Switch) v).setChecked(false);
                    isAlarm=0;
                }
                assignments.get(position).setIsAlarm(isAlarm);//this is imp to update the value in dataset which is provided to listview
                assignmentRepository.updateIsAlarmByWorkCode(
                        assignments.get(position).getWorkCode(),
                        isAlarm,tableName);

            }
        });

        return convertView;
    }

    static class HolderView {
        Switch assignmentSwitch;
        TextView assignmentTitle;
        TextView assignmentDate;
        TextView assignmentClass;
    }
}


