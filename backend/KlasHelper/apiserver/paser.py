import requests
from bs4 import BeautifulSoup
import numpy as np
from . import models
import json
from collections import defaultdict

def login(req):
    LOGIN_INFO = {
        'USER_ID': req['id'],
        'PASSWORD': req['pw']
    }
    with requests.Session() as s:

        login_req = s.post('https://klas.khu.ac.kr/user/loginUser.do', data=LOGIN_INFO)
        if login_req.status_code != 200:
            status="KlasPageError"
            flag = 0;
        else :
            if len(s.cookies) == 1:
                flag = 0;
                status = "IdPwError"
            else:# 로그인 성공문
                try :
                    models.UserTb.objects.get(klas_id=req['id'])
                except models.UserTb.DoesNotExist:
                    req = s.get('https://klas.khu.ac.kr/main/viewMainIndex.do')
                    html = req.text
                    soup = BeautifulSoup(html, 'html.parser')
                    name = soup.select("div.main_log_sec.login")[0].find('strong').get_text()
                    class_dict = {}
                    for i in range(1, 20):
                        req = s.get(
                            'https://klas.khu.ac.kr/classroom/viewClassroomCourseMoreList.do?courseType=end@pageIndex10&pageIndex=' + str(
                                i))
                        html = req.text
                        soup = BeautifulSoup(html, 'html.parser')
                        table_body = soup.find('tbody')
                        rows = table_body.find_all('tr')
                        if rows[0].text.strip() == "과목이 존재하지 않습니다.":
                            break;
                        for row in rows:
                            class_code = row.find_all('td')[1].text.strip().split('[')[1].split(']')[0]
                            class_date = row.find_all('td')[2].text.strip()
                            class_dict[class_code] = class_date
                    class_dict = get_semester_dict(class_dict)
                    user_semester = str.join(',', class_dict.keys())
                    user = models.UserTb( klas_id=LOGIN_INFO['USER_ID'],name=name,lectures=json.dumps(class_dict),semesters=user_semester)
                    user.save()
                finally:
                    flag=1
                    status="OK"
    return {'status': status,'flag':flag}

def get_assignment(req):
    user_set = models.UserTb.objects.get(klas_id=req['id'])
    try:
        semester=req['semester']
    except:
        semester = "2018_20"
    class_dict = json.loads(user_set.lectures)
    class_list=str(class_dict[semester]).split(',')
    class_list.pop()
    temp = np.char.array('https://klas.khu.ac.kr/course/viewCourseClassroom.do?COURSE_ID='+semester+'_')
    class_arr = np.array(class_list)
    class_link = temp + class_arr
    LOGIN_INFO = {
        'USER_ID': req['id'],
        'PASSWORD': req['pw']
    }
    with requests.Session() as s:
        login_req = s.post('https://klas.khu.ac.kr/user/loginUser.do', data=LOGIN_INFO)
        if login_req.status_code != 200:
            status="KlasPageError"
        else :
            if len(s.cookies) == 1:
                status = "IdPwError"
            else:
                status = "OK"
                result_list = []
                online_list = []
                for i in class_link:
                    req = s.get(i)
                    html = req.text
                    soup = BeautifulSoup(html, 'html.parser')
                    class_name = soup.find('div', attrs={'class', 'lf'}).text.strip()
                    temp_str = class_name + '\n'
                    temp_str2 = class_name + '\n'
                    for th in soup.find_all('div', attrs={'class': 'mycl_cont_info'}):
                        if th.find('div', attrs={'class': 'mycl_cont_top'}).text.strip() == "과제":
                            for temp in th.find_all('div', attrs={'class': ['mycl_cont_mid', 'mycl_cont_bot']}):
                                temp_str += temp.text.strip()
                                if (temp.select('div')[0].has_attr('id')):
                                    temp_str += '\n' + temp.select('div')[0]['id']
                                    if (temp.select('div')[0].find('a')):
                                        temp_str += '\n' + 'https://klas.khu.ac.kr' + \
                                                    temp.select('div')[0].find('a').attrs['href'].split("..")[1]
                                    else:
                                        temp_str += '\n' + 'no_files'
                                    result_list.append(temp_str)
                                    temp_str = class_name + '\n'
                        elif th.find('div', attrs={'class': 'mycl_cont_top'}).text.strip() == "강의자료":
                            for temp in th.find_all('div', attrs={'class': ['mycl_cont_mid', 'mycl_cont_bot']}):
                                temp_str2 += temp.text.strip()
                                if (temp.select('div')[0].has_attr('id')):
                                    temp_str2 += '\n' + temp.select('div')[0]['id']
                                    if (temp.select('div')[0].find('a')):
                                        temp_str2 += '\n' + 'https://klas.khu.ac.kr' + temp.select('div')[0].find('a').attrs['href'].split("..")[1]
                                    else:
                                        temp_str2 += '\n' + 'no_files'
                                    online_list.append(temp_str2)
                                    temp_str2 = class_name + '\n'
    res = []
    for work in result_list:
        temp = [x for x in work.split('\n') if x]
        if "제출 완료" in temp[3]:
            temp.append(1)
            file_name2 = temp[3].split("료")[1]
        else:
            temp.append(0)
            file_name2 = temp[3].split("출")[1]
        create_time, finish_time = check_time(temp[2].split("기간:")[1])
        temp_dict = {
            "semester": semester,
            "workType": "0",
            "workCode": temp[4],
            "workCourse": temp[0],
            "workTitle": temp[1],
            "workCreateTime": str(create_time).replace('.','-'),
            "workFinishTime": str(finish_time).replace('.','-'),
            "isSubmit": temp[6],
            "workFile": file_name2 + "[*]" + temp[5]
        }
        res.append(temp_dict)
    for online in online_list:
        temp = [x for x in online.split('\n') if x]
        if len(temp) == 7:
            create_time, finish_time = check_time(temp[2].split("기간:")[1])
            temp_dict = {
                "semester": semester,
                "workType": "2",  # 2강의자료
                "workCode": temp[5],
                "workCourse": temp[0],
                "workTitle": temp[1],
                "workCreateTime": str(create_time).replace('.','-'),
                "workFinishTime": str(finish_time).replace('.','-'),
                "isSubmit": "1",  # 강의자료는 다 제출
                "workFile": temp[4].split(')')[1] + "[*]" + temp[6]
            }
            res.append(temp_dict)
        elif len(temp) == 13:
            create_time, finish_time = check_time(temp[2].split("기간:")[1])
            ing_time = temp[5].split(':')[1].split('/')[0]
            watch_time = 0
            if "분" in ing_time:
                watch_time += int(ing_time.split("분")[0]) * 60
            else:
                watch_time += int(ing_time.split("초")[0])
            course_time = int(temp[3].split(':')[1].split("분")[0]) * 60
            if watch_time > course_time:
                flag = 1
            else:
                flag = 0
            temp_dict = {
                "semester": semester,
                "workType": "1",  # 1인강
                "workCode": temp[11],
                "workCourse": temp[0],
                "workTitle": temp[1],
                "workCreateTime": str(create_time).replace('.','-'),
                "workFinishTime": str(finish_time).replace('.','-'),
                "isSubmit": flag,  # 강의자료는 다 제출
                "workFile": temp[10].split(')')[1] + "[*]" + temp[12]
            }
            res.append(temp_dict)
        else:
            pass
    return {'status': status, 'assignment': res}
def get_semesters(req):
    status = "Error"
    semesters = ""
    try:
        user = models.UserTb.objects.get(klas_id=req['id'])
        status = "OK"
        semesters = user.semesters
    except models.UserTb.DoesNotExist:
        status = "NotUserError"
    return {'status': status,"semesters" : semesters}


def check_time(str_):
    if str_ == "기간없음":
        return [0, 0]
    else:
        return str_.split(' - ')


def get_semester_dict(class_dict):
    semester_list = list(zip([matching_semester(v) for v in class_dict.values()], class_dict.keys()))
    semester_dict=defaultdict(str)
    for semester, code in semester_list:
        semester_dict[semester]+=code+','
    return semester_dict

def matching_semester(date_range):
    year = date_range.split('.')[0]
    start_date , end_date = date_range.split('~')
    if start_date < year+".04.30"<end_date:
        return year+"_10" # 1학기
    elif start_date < year+".06.30"<end_date:
        return year+"_15" # 여름학기
    elif start_date < year+".09.30"<end_date:
        return year+"_20" # 2학기
    elif start_date < year+".12.31"<end_date:
        return year+"_25" # 겨울학기
    else :
        return None;