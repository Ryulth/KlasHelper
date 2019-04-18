# backend
django_backend_server

* 사용자의 개인 비밀번호는 저장하지 않습니다.

## architecture
![fingp_ar](https://user-images.githubusercontent.com/32893340/47712803-0ef82900-dc7c-11e8-8230-c4a2bd43bb19.jpg)

## API

#### login {POST} / 로그인 요청을 하는 기능

http://klashelper.ryulth.com/login

* Request

```json
{
    "id" : "klasID",
    "pw" : "klasPW"
}
```

* Response

```json
{
    "flag": 1,
    "status": "OK"
}
```

| 필드명 | 응답값                               | 설명                                                         |
| :----- | ------------------------------------ | ------------------------------------------------------------ |
| flag   | 1<br />0                             | 1 -> 성공<br />0 -> 실패                                     |
| status | OK<br />IdPwError<br />KlasPageError | OK  -> 성공<br />IdPwError -> IdPw 오류<br />KlasPageError -> KlasPage 응답시간 초과 |

#### assignments/<semester_code> {GET} / 학기의 과제를 가져오는 api

http://klashelper.ryulth.com/assignments/<semester_code>

* RequestHeader 

| Key      | Value  | 설명                 |
| -------- | ------ | -------------------- |
| appToken | test   | 인증된 연결인지 확인 |
| id       | KlasID | Klas id              |
| pw       | KlasPW | Klas pw              |

| UrlPath       | 요청값                                         | 설명                                                         |
| ------------- | ---------------------------------------------- | ------------------------------------------------------------ |
| semester_code | 2018_10<br />2018_15<br />2018_20<br />2018_25 | 학기 코드로 학교에서 사용하는 코드 조합이다<br />년도_학기로 이루어져 있다<br />1학기 -> 10<br />여름학기 -> 15<br />2학기 -> 20<br />겨울학기 -> 25 |

* Response

```json
{
    "status" : "OK",
    "assignment": [
        {
            "workCode": "file_LES_180907074240c7d164fb",
            "workFile": "[*]no_files",
            "workCourse": "데이터센터프로그래밍",
            "isSubmit": 1,
            "workCreateTime": "2018-09-07 08:00",
            "workFinishTime": "2018-12-31 23:50",
            "semester": "2018_20",
            "workTitle": "Reading Assignment #2: Virtualizatoin",
            "workType": "0"
        }
}
```

| 필드명     | 응답값                                                       | 설명                                                         |
| ---------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| status     | OK<br />IdPwError<br />KlasPageError<br />SemesterCodeError<br />NotUserError | OK  -> 성공<br />IdPwError -> IdPw 오류<br />KlasPageError -> KlasPage 응답시간 초과<br />SemesterCodeError -> 자신의 수강 학기가 아님<br />NotUserError -> KlasHelper 로그인을 한번도 하지 않은 사용자 |
| assignment | assignment List                                              | 과제 리스트                                                  |

* Assignment Object

| 필드명         | 응답값                                  | 설명                                                         |
| -------------- | --------------------------------------- | ------------------------------------------------------------ |
| workCode       | String                                  | 과제의 고유한 String 값                                      |
| workFile       | [\*]no_files<br />"파일이름"[*]파일주소 | 파일 이름과 강의 자료와 같은 첨부파일의 링크                 |
| workCourse     | String                                  | 강의 명                                                      |
| isSubmit       | 0<br />1                                | 0 -> 미제출<br />1 -> 제출 / 강의자료는 다 제출              |
| workCreateTime | String                                  | 과제 생성 시간                                               |
| workFinishTime | String                                  | 과제 마감 시간                                               |
| semester       | String                                  | 학기 코드                                                    |
| workTitle      | String                                  | 과제 명                                                      |
| workType       | String                      | HOMEWORK -> 과제<br />ONLINE -> 인터넷 강의<br />NOTE -> 강의 자료만 올라와있는 경우 |



#### semesters {GET} / 수강했던 학기들 리스트를 보내준다.

http://klashelper.ryulth.com/semesters

* RequestHeader

| Key      | Value  | 설명                 |
| -------- | ------ | -------------------- |
| appToken | test   | 인증된 연결인지 확인 |
| id       | KlasID | Klas id              |

* Response

```json
{
    "semesters": "2018_20,2018_15,2018_10,2017_25,2017_20",
    "status": "OK"
}
```

| 필드명    | 응답값                  | 설명                                                         |
| --------- | ----------------------- | ------------------------------------------------------------ |
| status    | OK<br />NotUserError    | OK -> 성공 <br />NotUserError -> KlasHelper 로그인을 한번도 하지 않은 사용자 |
| semesters | 2018_20,2018_15,2018_10 | 자신이 수강했던 학기들을 쉼표 구분자로 뭉쳐진 String 으로 보내준다. |

