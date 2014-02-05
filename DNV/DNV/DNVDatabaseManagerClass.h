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

//User methods
-(void)createUserTable;
-(User *)retrieveUser:(NSString *) userID;
-(NSArray *)retrieveAllUsers;
-(void)saveUser:(User *) user;
-(void)deleteUserTable;

//Audit methods
-(void)createAuditTables;
-(Audit *)retrieveAudit:(NSString *) auditID;
-(NSArray *)retrieveDistinctAuditNamesForClientOfType:(int) auditType;
-(NSArray *)retrieveAllAuditIDsOfType:(int) auditType forAuditName:(NSString *) auditName;
-(void)saveAudit:(Audit *) audit;
-(void)saveClient:(Client *)client forAudit:(NSString *)auditID;
-(void)updateAudit:(Audit *)audit;
-(void)updateClient:(Client *)client;
-(void)updateReport:(Report *)report;
-(void)updateElement:(Elements *)element;
-(void)updateSubElment:(SubElements *)subElement;
-(void)updateQuestion:(Questions *)question;
-(void)deleteAudit:(NSString *) auditID;

//Helper methods
-(NSArray *)getElementIDS:(NSString *) fKeyValue;
-(NSArray *)getIDSFrom:(NSString *) table where:(NSString *) fKeyName equals:(int) fKeyValue;


//-(void)createAuditTable
//-(void)createElementTable
//-(void)createSubElementTable
//-(void)createQuestionTable
//-(void)createAnswerTable
//-(void)createAttachmentTable
//-(void)createClientTable
//-(void)createReportTable


@end
