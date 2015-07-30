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

#define API_NAME_CALSS_RELEASE_HOMEWORK @"zhxy_v3_java/app/homework//homeworkCreate.app"//发布家庭作业

#define API_NAME_CALSS_FIND_DETAIL_OF_HOMEWORK @"zhxy_v3_java/app/homework/homeworkDetail.app"//家庭作业信息详情

#define API_NAME_CALSS_CREATE_HOMEWORK_COMMENTS @"zhxy_v3_java/app/homework/homeworkCommentCreate.app"//家庭作业评论

#define API_NAME_NOTICE_RELEASE_NOTICE @"zhxy_v3_java/app/parentNotice/publishParentNotice.app"//发布通知

#define API_NAME_RELEASE_BLACK_BOARD @"zhxy_v3_java/app/blackboard/blackboardCreate.app" //发布黑板报

#define API_NAME_LIST_OF_BLACK_BOARD @"zhxy_v3_java/app/blackboard/blackboardInfo.app" //黑板报列表

#define API_NAME_RATE_BLACK_BOARD @"zhxy_v3_java/app/blackboard/blackboardZambiaCreate.app" //黑板报点赞

#define API_NAME_POST_COMMENT_TO_BLACK_BOARD @"zhxy_v3_java/app/blackboard/blackboardCommentCreate.app" //黑板报评论

#define API_NAME_DETAIL_OF_BLACK_BOARD @"zhxy_v3_java/app/blackboard/blackboardDetail.app" //黑板报详情

#define API_NAME_CHECK_BLACK_BOARD @"zhxy_v3_java/app/blackboard/blackboardOperation.app" //黑板报审核

#define API_NAME_FETCH_CLASS_HOME_PAGE @"zhxy_v3_java/app/class/getClassIndexInfo.app" //获取班级首页

#define API_NAME_FETCH_CLASS_NAMES @"zhxy_v3_java/app/common/getClassList.app" //获取班级名称

#define API_NAME_TIMELINE_GET_STUDENT_INFO @"zhxy_v3_java/app/homeVisit/relStudentInfo.app"//获取学生列表信息

#define API_NAME_TIMELINE_GET_STUDENT_TIMELINE_INFO @"zhxy_v3_java/app/homeVisit/homeVisitInfo.app" //获取学生成长列表信息

#define API_NAME_TIMELINE_CREATE_COMMENT_INFO @"zhxy_v3_java/app/homeVisit/homeVisitCommentCreate.app" //学生成长发布评论信息

#define API_NAME_TIMELINE_CREATE_NEW_THREAM @"zhxy_v3_java/app/homeVisit/homeVisitCreate.app" //发布新主题

#define API_NAME_CLASS_RELEASE_NOTICE_DETAIL @"zhxy_v3_java/app/parentNotice/parentNoticeDetail.app" //告家长书详情

#define API_NAME_CLASS_RELEASE_NOTICE_REPLY  @"zhxy_v3_java/app/parentNotice/doReply.app"//告家长书回执

#define API_NAME_CLASS_ADDRESS_DETAIL @"zhxy_v3_java/app/class/getContactDetail.app" //班级通讯录详情

#endif
