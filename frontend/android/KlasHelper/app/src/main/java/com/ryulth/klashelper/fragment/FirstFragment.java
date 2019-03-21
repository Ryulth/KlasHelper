package com.ryulth.klashelper.fragment;


import android.content.Intent;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ListView;

import com.ryulth.klashelper.R;
import com.ryulth.klashelper.activity.DetailActivity;
import com.ryulth.klashelper.adapter.AssignmentsListViewAdapter;
import com.ryulth.klashelper.pojo.model.Assignment;

import java.util.List;

public class FirstFragment extends Fragment {

    private AssignmentsListViewAdapter adapter;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fragment_first, container, false);

        adapter = new AssignmentsListViewAdapter();

        ListView listView = view.findViewById(R.id.navigation_assignment);
        listView.setAdapter(adapter);
        listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                Intent intent = new Intent(getContext(), DetailActivity.class);
                intent.putExtra("assignmentIntent", ((Assignment) adapter.getItem(position)));
                startActivity(intent);
            }
        });

        return view;
    }

    public void setData(List<Assignment> list, String tableName) {
        adapter.setAssignments(list);
        adapter.setTableName(tableName);
        adapter.notifyDataSetChanged();
    }
}
