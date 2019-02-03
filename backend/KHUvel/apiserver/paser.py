import requests
from bs4 import BeautifulSoup
import numpy as np
from . import models
from datetime import datetime
import json
def clova_login(req):
    LOGIN_INFO = {
        'USER_ID': req['id'],
        'PASSWORD': req['pw']
    }
    today = datetime.now().strftime('%Y.%m.%d %H:%M')
    with requests.Session() as s:

        login_req = s.post('https://klas.khu.ac.kr/user/loginUser.do', data=LOGIN_INFO)
        # 어떤 결과가 나올까요? (200이면 성공!)
        print(login_req.status_code)
        if login_req.status_code != 200:
            # raise Exception('페이지 로딩 실패' + str(login_req.status_code))
            status = "PageError"
            flag = 0;
        else:
            if len(s.cookies) == 1:
                # raise Exception('로그인 실패')
                flag = 0;
                status = "IdPwError"
            else:  # 로그인 성공문
                try:
                    models.UserTb.objects.get(klas_id=req['id'])
                except models.UserTb.DoesNotExist:
                    req = s.get('https://klas.khu.ac.kr/main/viewMainIndex.do')
                    html = req.text
                    soup = BeautifulSoup(html, 'html.parser')
                    name = soup.select("div.main_log_sec.login")[0].find('strong').get_text()
                    req = s.get('https://klas.khu.ac.kr/classroom/viewClassroomCourseMoreList.do?courseType=ing')
                    html = req.text
                    soup = BeautifulSoup(html, 'html.parser')
                    class_list = ''
                    table_body = soup.find('tbody')
                    rows = table_body.find_all('tr')
                    if rows[0].text.strip() != "데이터가 존재하지 않습니다.":
                        for row in rows:
                            class_list += row.find_all('td')[1].text.strip().split('[')[1].split(']')[0] + ','
                    user = models.UserTb(klas_id=LOGIN_INFO['USER_ID'], class_2018_2=class_list,name=name)
                    user.save()
                finally:
                    user_set = models.UserTb.objects.get(klas_id=req['id'])
                    class_list = str(user_set.class_2018_2).split(',')
                    class_list.pop()
                    temp = np.char.array('https://klas.khu.ac.kr/course/viewCourseClassroom.do?COURSE_ID=2018_20_')
                    class_arr = np.array(class_list)
                    class_link = temp + class_arr
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
                                            temp_str2 += '\n' + 'https://klas.khu.ac.kr' + \
                                                         temp.select('div')[0].find('a').attrs['href'].split("..")[1]

                                        else:
                                            temp_str2 += '\n' + 'no_files'
                                        online_list.append(temp_str2)
                                        temp_str2 = class_name + '\n'
                    def check_time(str_):
                        if str_ == "기간없음":
                            return [0, 0]
                        else:
                            return str_.split(' - ')

                    res = []
                    res1 = []
                    for work in result_list:
                        temp = [x for x in work.split('\n') if x]
                        if "제출 완료" in temp[3]:
                            temp.append(1)
                            file_name2 = temp[3].split("료")[1]
                        else:
                            temp.append(0)
                            file_name2 = temp[3].split("출")[1]
                        create_time, finish_time = check_time(temp[2].split("기간:")[1])
                        if not finish_time == 0:
                            if (finish_time > today and temp[6] == 0):
                                temp_dict = {
                                        "workCourse": temp[0],
                                        "workTitle": temp[1],
                                        "workFinishTime": finish_time,

                                    }
                                res.append(temp_dict)

                    for online in online_list:
                        temp = [x for x in online.split('\n') if x]
                        if len(temp) == 13:
                            create_time, finish_time = check_time(temp[2].split("기간:")[1])
                            if not finish_time == 0:
                                if (finish_time > today ):
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
                                    if flag == 0:
                                        temp_dict = {
                                            "workCourse": temp[0],
                                            "workTitle": temp[1],
                                            "workFinishTime": finish_time,

                                        }
                                        res1.append(temp_dict)
                    res=sorted(res, key=lambda r: r['workFinishTime'])
                    res1=sorted(res1, key=lambda r: r['workFinishTime'])
                    if len(res)>=2:
                        res=res[:2]
                        res1=res1[:2]
                    print(res1)
                    user_set.work=res
                    user_set.lec=res1
                    user_set.save()
                    status="success"
                    flag=1
        res = {"status": status, "flag": flag}
        return res
def clova_ass(req):
    status = "Error"
    try:
        user_set = models.UserTb.objects.get(klas_id=req['id'])
        status = "Success"
        name = user_set.name
        res = json.loads(user_set.work.replace("'",'"'))
        return {'STATUS': status, 'NAME': name, 'ASS': res}
    except models.UserTb.DoesNotExist:
        status = "UserError"
        return {'STATUS': status}
    return {'STATUS': status}
def clova_lec(req):
    status="Error"
    try:
        user_set= models.UserTb.objects.get(klas_id=req['id'])
        status ="Success"
        name=user_set.name
        res=json.loads(user_set.lec.replace("'",'"'))
        return {'STATUS':status,'NAME':name,'LEC':res}
    except models.UserTb.DoesNotExist:
        status="UserError"
        return {'STATUS':status}
    return  {'STATUS':status}

def login(req):
    LOGIN_INFO = {
        'USER_ID': req['id'],
        'PASSWORD': req['pw']
    }
    with requests.Session() as s:

        login_req = s.post('https://klas.khu.ac.kr/user/loginUser.do', data=LOGIN_INFO)
        # 어떤 결과가 나올까요? (200이면 성공!)
        print(login_req.status_code)
        if login_req.status_code != 200:
            #raise Exception('페이지 로딩 실패' + str(login_req.status_code))
            status="PageError"
            flag = 0;
        else :
            if len(s.cookies) == 1:
                #raise Exception('로그인 실패')
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
                    req = s.get('https://klas.khu.ac.kr/classroom/viewClassroomCourseMoreList.do?courseType=ing')
                    html = req.text
                    soup = BeautifulSoup(html, 'html.parser')
                    class_list = ''
                    table_body = soup.find('tbody')
                    rows = table_body.find_all('tr')
                    if rows[0].text.strip() != "데이터가 존재하지 않습니다.":
                        for row in rows:
                            class_list += row.find_all('td')[1].text.strip().split('[')[1].split(']')[0] + ','
                    user = models.UserTb( klas_id=LOGIN_INFO['USER_ID'], class_2018_2=class_list,name=name)
                    user.save()
                finally:
                    flag=1
                    status='Success'

    return {'status': status,'flag':flag}

def get_assignment(req):
    user_set = models.UserTb.objects.get(klas_id=req['id'])
    class_list=str(user_set.class_2018_2).split(',')
    class_list.pop()
    temp = np.char.array('https://klas.khu.ac.kr/course/viewCourseClassroom.do?COURSE_ID=2018_20_')
    class_arr = np.array(class_list)
    class_link = temp + class_arr
    LOGIN_INFO = {
        'USER_ID': req['id'],
        'PASSWORD': req['pw']
    }
    with requests.Session() as s:
        login_req = s.post('https://klas.khu.ac.kr/user/loginUser.do', data=LOGIN_INFO)
        # 어떤 결과가 나올까요? (200이면 성공!)
        print(login_req.status_code)
        if login_req.status_code != 200:
            raise Exception('홈페이지 오류')
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

    def check_time(str_):
        if str_ == "기간없음":
            return [0, 0]
        else:
            return str_.split(' - ')
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
            print('ERROR')
    return res