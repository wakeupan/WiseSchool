//
//  API.h
//  wiseschool
//
//  Created by 张宝 on 15/7/24.
//  Copyright (c) 2015年 whatya. All rights reserved.
//

#ifndef wiseschool_API_h
#define wiseschool_API_h

#define HTTP_SUCCEED_FLAG @"1"

#define API_NAME_LOGIN_VALIDATE_MOBILE @"zhxy_v3_java/app/login/validateMobile.app"//验证手机号码

#define API_NAME_LOGIN_ADD_CLASS @"zhxy_v3_java/app/login/entryClass.app"//加入班级

#define API_NAME_CLASS_ADD_STYLE  @"zhxy_v3_java/app/class/setClassAudit.app"//加入班级方式

#define API_NAME_LOGIN_GET_AREA_FOR_CITY @"zhxy_v3_java/app/common/areaInfo.app"//获取城市下面的区域信息

#define API_NAME_LOGIN_GET_SCHOOL_FOR_AREA @"zhxy_v3_java/app/common/schoolInfo.app"//获取区域下面的学校信息

#define API_NAME_LOGIN_GET_GRADE_FOR_SCHOOL @"zhxy_v3_java/app/common/gradeInfo.app"//获取学校的年级信息

#define API_NAME_LOGIN_GET_SUBJECT_INFO @"zhxy_v3_java/app/common/subjectInfo.app"//获取科目信息

#define API_NAME_CLASS_GET_COURSE_INFO @"zhxy_v3_java/app/course/courseInfo.app"//获取课程表

#define API_NAME_CLASS_CREATE_COURSE @"zhxy_v3_java/app/common/subjectCreate.app" //添加科目信息

#define API_NAME_CLASS_SET_COURSE @"zhxy_v3_java/app/course/courseMerge.app"//设置课程表

#define API_NAME_CLASS_GET_HOME_WORK_LIST @"zhxy_v3_java/app/homework/homeworkInfo.app" //获取家庭作业列表

#define API_NAME_INDEX_GET_APPINFO @"zhxy_v3_java/app/index/getIndexInfo.app" //获取首页信息

#define API_NAME_CALSS_DELETE_HOMEWORK @"zhxy_v3_java/app/homework/homeworkDelete.app"//删除家庭作业

#define API_NAME_CALSS_DELETE_HOMEWORK @"zhxy_v3_java/app/homework/homeworkDelete.app"//删除家庭作业

#define API_NAME_CALSS_RELEASE_HOMEWORK @"zhxy_v3_java/app/homework//homeworkCreate.app"//发布家庭作业

#define API_NAME_CALSS_FIND_DETAIL_OF_HOMEWORK @"zhxy_v3_java/app/homework/homeworkDetail.app"//家庭作业信息详情

#define API_NAME_CALSS_CREATE_HOMEWORK_COMMENTS @"zhxy_v3_java/app/homework/homeworkCommentCreate.app"//家庭作业评论

#define API_NAME_NOTICE_RELEASE_NOTICE @"zhxy_v3_java/app/parentNotice/publishParentNotice.app"//发布通知

#endif
