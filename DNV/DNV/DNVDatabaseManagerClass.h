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
#import "Observations.h"
#import "Records.h"

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
-(NSArray *)retrieveAllClients;
-(Questions *)retrieveQuestion:(int)questionID;
-(BOOL)saveAudit:(Audit *) audit;
-(void)saveClient:(Client *)client forAudit:(NSString *)auditID;
-(void)saveReport:(Report *)report forAudit:(NSString *)auditID;
-(int)saveObservationVerify:(Observations *)observe ofType:(int)vType forQuestion:(int)questionID;
-(int)saveRecordVerify:(Records *)record forQuestion:(int)questionID;
-(void)updateAudit:(Audit *)audit;
-(void)updateClient:(Client *)client;
-(void)updateReport:(Report *)report;
-(void)updateElement:(Elements *)element;
-(void)updateSubElment:(SubElements *)subElement;
-(void)updateQuestion:(Questions *)question;
-(void)updateOVerify:(Observations *)observe;
-(void)updateRVerify:(Records *)record;
-(void)deleteAudit:(NSString *) auditID;
-(void)deleteVerifyForQuestion:(int)questionID ofType:(int)vType;
-(void)deleteVerify:(int)verifyID;

//Helper methods
-(NSArray *)getElementIDS:(NSString *) fKeyValue;
-(NSArray *)getIDSFrom:(NSString *) table where:(NSString *) fKeyName equals:(int) fKeyValue;

@end
