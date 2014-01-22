//
//  DNVDatabaseManagerClass.h
//  DNV
//
//  Created by USI on 1/17/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"

#import "Audit.h"
#import "Elements.h"
#import "SubElements.h"
#import "Questions.h"
#import "Answers.h"

#import "User.h"
#import "Client.h"
#import "Report.h"

@interface DNVDatabaseManagerClass : NSObject
{
    //Variable to the Audit Database
    sqlite3 * dnvAuditDB;
}

@property (strong, nonatomic) NSString * databasePath;

+(DNVDatabaseManagerClass *)getSharedInstance;

-(id)init;

-(void)createUserTable;
-(User *)retrieveUser:(NSString *) userID;
-(NSArray *)retrieveAllUsers;
-(void)saveUser:(User *) user;
-(void)deleteUserTable;

-(void)createAuditTables;
-(Audit *)retrieveAudit:(NSInteger *) auditID;
-(NSArray *)retrieveAllAudits;
-(void)saveAudit:(Audit *) audit;
-(void)saveClient:(Client *) client;
-(void)updateAudit:(NSInteger *) auditID auditType:(NSInteger *) auditType;
-(void)updateElement:(NSInteger *) elementID isCompleted:(BOOL) isCompleted;
-(void)updateSubElment:(NSInteger *) subElementID isCompleted:(BOOL) isCompleted;
-(void)updateQuestion:(NSInteger *) questionID isCompleted:(BOOL) isCompleted;
-(void)updateAnswer:(NSInteger *) answerID isCompleted:(BOOL) isSelected;
-(void)deleteAudit:(NSInteger *) auditID;



//-(void)createAuditTable
//-(void)createElementTable
//-(void)createSubElementTable
//-(void)createQuestionTable
//-(void)createAnswerTable
//-(void)createAttachmentTable
//-(void)createClientTable
//-(void)createReportTable


@end
