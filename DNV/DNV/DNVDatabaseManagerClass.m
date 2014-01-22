//
//  DNVDatabaseManagerClass.m
//  DNV
//
//  Created by USI on 1/17/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import "DNVDatabaseManagerClass.h"

@implementation DNVDatabaseManagerClass

static DNVDatabaseManagerClass *sharedInstance = nil;

+(DNVDatabaseManagerClass *)getSharedInstance{
    
    if (!sharedInstance) {
        sharedInstance = [[super allocWithZone:NULL]init];
    }
    return sharedInstance;
}

+(id)allocWithZone:(struct _NSZone *)zone{
    return sharedInstance;
}

-(id)init{
    
    self = [super init];
    
    if(self){
        //Creating the DNV Audit DB
        NSString * docsDirectory;
        NSArray * dirPaths;
        
        //Getting the Directory Paths
        dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true);
        
        //Storing the correct path onto the docsDirectory
        docsDirectory = [dirPaths objectAtIndex:0];
        
        //Setting databasePath for the Contacts database
        self.databasePath = [[NSString alloc]initWithString:[docsDirectory stringByAppendingPathComponent:@"dnvAudit.db"]];
    
    }
    return self;
}

#pragma mark Audit methods

-(void)createAuditTables{
    
    //Object to save errors
    char * errMsg;
    
//    NSFileManager * fileManager = [NSFileManager defaultManager];
//    
//    if(![fileManager fileExistsAtPath:self.databasePath]){
        //Opening the SQLite DB
        if(sqlite3_open([self.databasePath UTF8String], &dnvAuditDB)==SQLITE_OK){
         
            //Create the DB
            const char * sql_stmt = "CREATE TABLE IF NOT EXISTS AUDIT (ID INTEGER PRIMARY KEY AUTOINCREMENT, AUDITNAME TEXT, AUDITTYPE INTEGER, LASTMODIFIED TEXT)";
            
            const char * sql_stmt2 = "CREATE TABLE IF NOT EXISTS ELEMENT (ID INTEGER PRIMARY KEY AUTOINCREMENT, AUDITID INTEGER, ELEMENTNAME TEXT, ISCOMPLETE INTEGER, ISREQUIRED INTEGER, POINTSPOSSIBLE REAL, POINTSAWARDED REAL)";
            
            const char * sql_stmt3 = "CREATE TABLE IF NOT EXISTS SUBELEMENT (ID INTEGER PRIMARY KEY AUTOINCREMENT, ELEMENTID INTEGER, SUBELEMENTNAME TEXT, ISCOMPLETE INTEGER, POINTSPOSSIBLE REAL, POINTSAWARDED REAL)";
            
            const char * sql_stmt4 = "CREATE TABLE IF NOT EXISTS QUESTION (ID INTEGER PRIMARY KEY AUTOINCREMENT, SUBELEMENTID INTEGER, QUESTIONTEXT TEXT, QUESTIONTYPE INTEGER, ISCOMPLETE INTEGER, POINTSPOSSIBLE REAL, POINTSAWARDED REAL, HELPTEXT TEXT, NOTES TEXT, ISTHUMBSUP INTEGER, ISTHUMBSDOWN INTEGER, ISAPPLICABLE INTEGER, NEEDSVERIFYING INTEGER, ISVERIFYDONE INTEGER, PARENTQUESTIONID INTEGER, POINTSNEEDEFORLAYER REAL)";
            
            const char * sql_stmt5 = "CREATE TABLE IF NOT EXISTS ANSWER (ID INTEGER PRIMARY KEY AUTOINCREMENT, QUESTIONID INTEGER, ANSWERTEXT TEXT, POINTSPOSSIBLE REAL, ISSELECTED INTEGER)";
            
            const char * sql_stmt6 = "CREATE TABLE IF NOT EXISTS ATTACHMENT (ID INTEGER PRIMARY KEY AUTOINCREMENT, QUESTIONID INTEGER, ATTACHMENTNAME TEXT, ISIMAGE INTEGER)";
            
            const char * sql_stmt7 = "CREATE TABLE IF NOT EXISTS CLIENT (ID INTEGER PRIMARY KEY AUTOINCREMENT, AUDITID INTEGER, USERID TEXT, CLIENTNAME TEXT, DIVISION TEXT, SIC TEXT, NUMBEREMPLOYEES INTEGER, AUDITSITE TEXT, AUDITDATE TEXT, BASELINEAUDIT INTEGER, STREETADDRESS TEXT, CITYSTATEPROVINCE TEXT, COUNTRY TEXT)";
            
            const char * sql_stmt8 = "CREATE TABLE IF NOT EXISTS REPORT (ID INTEGER PRIMARY KEY AUTOINCREMENT, AUDITID INTEGER, CLIENTID INTEGER, USERID TEXT, SUMMARY TEXT, APPROVEDBY TEXT, PROJECTNUMBER TEXT, CONCLUSION TEXT, DIAGRAMFILENAME TEXT)";
            
            //Verifying the execution of the create table SQL script
            if(!(sqlite3_exec(dnvAuditDB, sql_stmt, NULL, NULL, &errMsg)==SQLITE_OK))
            {
                NSLog(@"Can't create a table.");
            }
            
            //Verifying the execution of the create table SQL script
            if(!(sqlite3_exec(dnvAuditDB, sql_stmt2, NULL, NULL, &errMsg)==SQLITE_OK))
            {
                NSLog(@"Can't create a table.");
            }
            
            //Verifying the execution of the create table SQL script
            if(!(sqlite3_exec(dnvAuditDB, sql_stmt3, NULL, NULL, &errMsg)==SQLITE_OK))
            {
                NSLog(@"Can't create a table.");
            }
            
            //Verifying the execution of the create table SQL script
            if(!(sqlite3_exec(dnvAuditDB, sql_stmt4, NULL, NULL, &errMsg)==SQLITE_OK))
            {
                NSLog(@"Can't create a table.");
            }
            
            //Verifying the execution of the create table SQL script
            if(!(sqlite3_exec(dnvAuditDB, sql_stmt5, NULL, NULL, &errMsg)==SQLITE_OK))
            {
                NSLog(@"Can't create a table.");
            }
            
            //Verifying the execution of the create table SQL script
            if(!(sqlite3_exec(dnvAuditDB, sql_stmt6, NULL, NULL, &errMsg)==SQLITE_OK))
            {
                NSLog(@"Can't create a table.");
            }
            
            //Verifying the execution of the create table SQL script
            if(!(sqlite3_exec(dnvAuditDB, sql_stmt7, NULL, NULL, &errMsg)==SQLITE_OK))
            {
                NSLog(@"Can't create a table.");
            }
            
            //Verifying the execution of the create table SQL script
            if(!(sqlite3_exec(dnvAuditDB, sql_stmt8, NULL, NULL, &errMsg)==SQLITE_OK))
            {
                NSLog(@"Can't create a table.");
            }
            
            sqlite3_close(dnvAuditDB);
        }
        else{
            NSLog(@"Failed to open/create DB.");
        }
//    }
}

-(void)saveClient:(Client *)client{
    
    //Open the DB
    if(sqlite3_open([self.databasePath UTF8String] , &dnvAuditDB)==SQLITE_OK){
        
        sqlite3_stmt * statement;
        
        int auditID = [self getID:@"AUDIT"];
        NSString * userID = @"cliff";
        
        NSString * insertClientSQL = [NSString stringWithFormat:@"INSERT INTO CLIENT (AUDITID, USERID, CLIENTNAME, DIVISION, SIC, NUMBEREMPLOYEES, AUDITSITE, AUDITDATE, BASELINEAUDIT, STREETADDRESS, CITYSTATEPROVINCE, COUNTRY) VALUES (%d, '%@', '%@', '%@', '%@', %d, '%@', '%@', %d, '%@', '%@', '%@'", auditID, userID, client.companyName, client.division, client.SICNumber, client.numEmployees, client.auditedSite, client.auditDate, client.baselineAudit, client.address, client.cityStateProvince, client.country];
        
        //Preparing
        sqlite3_prepare_v2(dnvAuditDB, [insertClientSQL UTF8String], -1, &statement, NULL);
        
        if(sqlite3_step(statement)==SQLITE_DONE){
            NSLog(@"Client added to DB.");
        }
        else{
            NSLog(@"Failed to add client.");
        }
        sqlite3_finalize(statement);
        sqlite3_close(dnvAuditDB);
    }
    else{
        
        NSLog(@"Failed to open/create DB.");
    }
    
}


-(void)saveAudit:(Audit *)audit{
    
    //Open the DB
    if(sqlite3_open([self.databasePath UTF8String] , &dnvAuditDB)==SQLITE_OK){
        
        sqlite3_stmt * statement;
        
        //
        NSString * insertAuditSQL = [NSString stringWithFormat:@"INSERT INTO AUDIT (AUDITNAME, AUDITTYPE, LASTMODIFIED) VALUES ('%@', %d, '%@')", audit.name, 1, audit.lastModefied];
        
        //Preparing
        sqlite3_prepare_v2(dnvAuditDB, [insertAuditSQL UTF8String], -1, &statement, NULL);
        
        if(sqlite3_step(statement)==SQLITE_DONE){
            NSLog(@"Audit added to DB.");
        }
        else{
            NSLog(@"Failed to add audit.");
        }
        sqlite3_reset(statement);
    
        int auditID = [self getID:@"AUDIT"];
        NSString * userID = @"cliff";
        
        Client * client = audit.client;
//        [self saveClient:client];
        
        NSString * insertClientSQL = [NSString stringWithFormat:@"INSERT INTO CLIENT (AUDITID, USERID, CLIENTNAME, DIVISION, SIC, NUMBEREMPLOYEES, AUDITSITE, AUDITDATE, BASELINEAUDIT, STREETADDRESS, CITYSTATEPROVINCE, COUNTRY) VALUES (%d, '%@', '%@', '%@', '%@', %d, '%@', '%@', %d, '%@', '%@', '%@'", auditID, userID, client.companyName, client.division, client.SICNumber, client.numEmployees, client.auditedSite, client.auditDate, client.baselineAudit, client.address, client.cityStateProvince, client.country];
        
        //Preparing
        sqlite3_prepare_v2(dnvAuditDB, [insertClientSQL UTF8String], -1, &statement, NULL);
        
        if(sqlite3_step(statement)==SQLITE_DONE){
            NSLog(@"Client added to DB.");
        }
        else{
            NSLog(@"Failed to add client.");
        }
        
        sqlite3_reset(statement);
        
        int clientID = [self getID:@"CLIENT"];
        
        Report * report = audit.report;
        
        NSString * insertReportSQL = [NSString stringWithFormat:@"INSERT INTO REPORT (AUDITID, CLIENTID, USERID, SUMMARY, APPROVEDBY, PROJECTNUMBER, CONCLUSION, DIAGRAMFILENAME) VALUES (%d, %d, '%@', '%@', '%@','%@', '%@', '%@')", auditID, clientID, userID, report.summary, report.approvedBy, report.projectNum, report.conclusion, report.methodologyDiagramLocation];
        
        //Preparing
        sqlite3_prepare_v2(dnvAuditDB, [insertReportSQL UTF8String], -1, &statement, NULL);
        
        if(sqlite3_step(statement)==SQLITE_DONE){
            NSLog(@"Report added to DB.");
        }
        else{
            NSLog(@"Failed to add report.");
        }
        
        sqlite3_reset(statement);
    
        NSArray * elements = audit.Elements;
        
        for (Elements * ele in elements){
        
            NSString * insertElementSQL = [NSString stringWithFormat:@"INSERT INTO ELEMENT (AUDITID, ELEMENTNAME, ISCOMPLETED, ISREQUIRED, POINTSPOSSIBLE, POINTSAWARDED) VALUES (%d, '%@', %d, %d, %f, %f)", auditID, ele.name, ele.isCompleted, ele.isRequired, ele.pointsPossible, ele.pointsAwarded];
            
            //Preparing
            sqlite3_prepare_v2(dnvAuditDB, [insertElementSQL UTF8String], -1, &statement, NULL);
            
            if(sqlite3_step(statement)==SQLITE_DONE){
                NSLog(@"Element added to DB.");
            }
            else{
                NSLog(@"Failed to add element.");
            }
            
            sqlite3_reset(statement);
        
            int elementID = [self getID:@"ELEMENT"];
        
            NSArray * subElements = ele.Subelements;
        
            for (SubElements * subEle in subElements){
            
                NSString * insertSubElementSQL = [NSString stringWithFormat:@"INSERT INTO SUBELEMENT (ELEMENTID, SUBELEMENTNAME, ISCOMPLETED, POINTSPOSSIBLE, POINTSAWARDED) VALUES (%d, '%@', %d, %f, %f)", elementID, subEle.name, subEle.isCompleted, subEle.pointsPossible, subEle.pointsAwarded];
        
                //Preparing
                sqlite3_prepare_v2(dnvAuditDB, [insertSubElementSQL UTF8String], -1, &statement, NULL);
            
                if(sqlite3_step(statement)==SQLITE_DONE){
                    NSLog(@"Sub Element added to DB.");
                }
                else{
                    NSLog(@"Failed to add sub element.");
                }
                
                sqlite3_reset(statement);
            
                int subElementID = [self getID:@"SUBELEMENT"];
            
                NSArray * questions = subEle.Questions;
            
                for (Questions * question in questions){
                
                    NSString * insertQuestionSQL = [NSString stringWithFormat:@"INSERT INTO QUESTION (SUBELEMENTID, QUESTIONTEXT, QUESTIONTYPE, ISCOMPLETE, POINTSPOSSIBLE, POINTSAWARDED, HELPTEXT, NOTES, ISTHUMBSUP, ISTHUMBSDOWN, ISAPPLICABLE, NEEDSVERIFYING, ISVERIFYDONE, PARENTQUESTIONID, POINTSNEEDEFORLAYER) VALUES (%d, '%@', %d, %d, %f, %f, '%@', '%@', %d, %d, %d, %d, %d, %d, %f)", subElementID, question.questionText, question.questionType, question.isCompleted, question.pointsPossible, question.pointsAwarded, question.helpText, question.notes, question.isThumbsUp, question.isThumbsDown, question.isApplicable, question.needsVerifying, question.isVerifyDone, nil, question.pointsNeededForLayered];
                
                    //Preparing
                    sqlite3_prepare_v2(dnvAuditDB, [insertQuestionSQL UTF8String], -1, &statement, NULL);
                
                    if(sqlite3_step(statement)==SQLITE_DONE){
                        NSLog(@"Question added to DB.");
                    
                        if (question.layeredQuestion.count > 0){
                        
                            sqlite3_reset(statement);
                        
                            int questionID = [self getID:@"QUESTION"];
                        
                            NSArray * layeredQuest = question.layeredQuestion;
                        
                            for (Questions * lQ in layeredQuest){
                            
                                NSString * insertLQSQL = [NSString stringWithFormat:@"INSERT INTO QUESTION (SUBELEMENTID, QUESTIONTEXT, QUESTIONTYPE, ISCOMPLETE, POINTSPOSSIBLE, POINTSAWARDED, HELPTEXT, NOTES, ISTHUMBSUP, ISTHUMBSDOWN, ISAPPLICABLE, NEEDSVERIFYING, ISVERIFYDONE, PARENTQUESTIONID, POINTSNEEDEFORLAYER) VALUES (%d, '%@', %d, %d, %f, %f, '%@', '%@', %d, %d, %d, %d, %d, %d, %f)", subElementID, lQ.questionText, lQ.questionType, lQ.isCompleted, lQ.pointsPossible, lQ.pointsAwarded, lQ.helpText, lQ.notes, lQ.isThumbsUp, lQ.isThumbsDown, lQ.isApplicable, lQ.needsVerifying, lQ.isVerifyDone, questionID, lQ.pointsNeededForLayered];
                            
                                //Preparing
                                sqlite3_prepare_v2(dnvAuditDB, [insertLQSQL UTF8String], -1, &statement, NULL);
                            
                                if(sqlite3_step(statement)==SQLITE_DONE){
                                    NSLog(@"Layered question added to DB.");
                                }
                                else{
                                    NSLog(@"Failed to add layered question.");
                                }
                            
                                sqlite3_reset(statement);
                            
                                int LQID = [self getID:@"QUESTION"];
                            
                                NSArray * LQanswers = lQ.Answers;
                            
                                for (Answers * answer in LQanswers){
                                
                                    NSString * insertLQAnswerSQL = [NSString stringWithFormat:@"INSERT INTO ANSWER (QUESTIONID, ANSWERTEXT, POINTSPOSSIBLE, ISSELECTED) VALUES (%d, '%@', %f, %d)", LQID, answer.answerText, answer.pointsPossibleOrMultiplier, answer.isSelected];
                                
                                    //Preparing
                                    sqlite3_prepare_v2(dnvAuditDB, [insertLQAnswerSQL UTF8String], -1, &statement, NULL);
                                
                                    if(sqlite3_step(statement)==SQLITE_DONE){
                                        NSLog(@"Answer added to DB.");
                                    }
                                    else{
                                        NSLog(@"Failed to add answer.");
                                    }
                                
                                    sqlite3_reset(statement);
                                }
                            
                                NSMutableArray * attachments = [NSMutableArray arrayWithArray:lQ.imageLocationArray];
                            
                                for (NSString * attach in lQ.attachmentsLocationArray)
                                    [attachments addObject:attach];
                            
                                for (int i = 0; i < attachments.count; i++){
                                
                                    BOOL isImage;
                                    
                                    if (i < lQ.imageLocationArray.count)
                                        isImage = true;
                                    else
                                        isImage = false;
                                
                                    NSString * insertAttachSQL = [NSString stringWithFormat:@"INSERT INTO ATTACHMENT (QUESTIONID, ATTACHMENTNAME, ISIMAGE) VALUES (%d, '%@', %d)", LQID, attachments[i], isImage];
                                
                                    //Preparing
                                    sqlite3_prepare_v2(dnvAuditDB, [insertAttachSQL UTF8String], -1, &statement, NULL);
                                
                                    if(sqlite3_step(statement)==SQLITE_DONE){
                                        NSLog(@"Attachment added to DB.");
                                    }
                                    else{
                                        NSLog(@"Failed to add attachment.");
                                    }
                                
                                    sqlite3_reset(statement);
                                }
                            }
                        }
                    }
                    else{
                        NSLog(@"Failed to add question.");
                    }
                    
                    sqlite3_reset(statement);
                    
                    int questionID = [self getID:@"QUESTION"];
                        
                    NSArray * answers = question.Answers;
                        
                    for (Answers * answer in answers){
                            
                        NSString * insertAnswerSQL = [NSString stringWithFormat:@"INSERT INTO ANSWER (QUESTIONID, ANSWERTEXT, POINTSPOSSIBLE, ISSELECTED) VALUES (%d, '%@', %f, %d)", questionID, answer.answerText, answer.pointsPossibleOrMultiplier, answer.isSelected];
                            
                        //Preparing
                        sqlite3_prepare_v2(dnvAuditDB, [insertAnswerSQL UTF8String], -1, &statement, NULL);
                            
                        if(sqlite3_step(statement)==SQLITE_DONE){
                            NSLog(@"Answer added to DB.");
                        }
                        else{
                            NSLog(@"Failed to add answer.");
                        }
                    
                        sqlite3_reset(statement);
                    }
                        
                    NSMutableArray * attachments = [NSMutableArray arrayWithArray:question.imageLocationArray];
                
                    for (NSString * attach in question.attachmentsLocationArray)
                        [attachments addObject:attach];
                        
                    for (int i = 0; i < attachments.count; i++){
                            
                        BOOL isImage;
                        if (i < question.imageLocationArray.count)
                            isImage = true;
                        else
                            isImage = false;
                            
                        NSString * insertAttachSQL = [NSString stringWithFormat:@"INSERT INTO ATTACHMENT (QUESTIONID, ATTACHMENTNAME, ISIMAGE) VALUES (%d, '%@', %d)", questionID, attachments[i], isImage];
                            
                        //Preparing
                        sqlite3_prepare_v2(dnvAuditDB, [insertAttachSQL UTF8String], -1, &statement, NULL);
                            
                            if(sqlite3_step(statement)==SQLITE_DONE){
                                NSLog(@"Attachment added to DB.");
                            }
                            else{
                                NSLog(@"Failed to add attachment.");
                            }
                        
                        sqlite3_reset(statement);
                    }
                }
            }
        }
        
        sqlite3_finalize(statement);
        sqlite3_close(dnvAuditDB);
    }
    else{
        
        NSLog(@"Failed to open/create DB.");
    }
    
}

-(int)getID:(NSString *) table{
    
    sqlite3_stmt * statement;
    int ID = -1;

    NSString * getIDSQL = [NSString stringWithFormat:@"SELECT MAX(ID) FROM '%@'", table];
    
    //Prepare the Query
    if(sqlite3_prepare_v2(dnvAuditDB, [getIDSQL UTF8String], -1, &statement, NULL)==SQLITE_OK){
        
        //If this work, there must be a row if the data was there
        while (sqlite3_step(statement) == SQLITE_ROW){
            
            //Gets the first name data from DB and adding it to the temp Person Object
            NSString * identify = [[NSString alloc] initWithUTF8String:(const char*)sqlite3_column_text(statement, 0)];
            
            ID = [identify integerValue];
        }
    }

    sqlite3_finalize(statement);
    
    return ID;
}

-(void)updateAudit:(NSInteger *)auditID auditType:(NSInteger *)auditType{
    
    
    
    
}

-(void)updateElement:(NSInteger *)elementID isCompleted:(BOOL)isCompleted{
    
    
}

-(void)updateSubElment:(NSInteger *)subElementID isCompleted:(BOOL)isCompleted{
    
    
}

-(void)updateQuestion:(NSInteger *)questionID isCompleted:(BOOL)isCompleted{
    
    
}

-(void)updateAnswer:(NSInteger *)answerID isCompleted:(BOOL)isSelected{
    
    
}

-(void)deleteAudit:(NSInteger *)auditID{
    
    
}

#pragma mark User methods

//create user table
-(void)createUserTable{
    
    //Opening the SQLite DB
    if(sqlite3_open([self.databasePath UTF8String], &dnvAuditDB)==SQLITE_OK){
        
        //Object to save errors
        char * errMsg;
        
        const char * sql_stmt = "CREATE TABLE IF NOT EXISTS USER (ID TEXT PRIMARY KEY, PASSWORD TEXT, USERFULLNAME TEXT, RANK INTEGER, OTHERINFO TEXT)";
        
        //Verifying the execution of the create table SQL script
        if(!(sqlite3_exec(dnvAuditDB, sql_stmt, NULL, NULL, &errMsg)==SQLITE_OK))
        {
            NSLog(@"Can't create a table.");
        }
        sqlite3_close(dnvAuditDB);
    }
    else{
        
        NSLog(@"Failed to open/create DB.");
    }
}

//save to user table
-(void)saveUser:(User *)user{
    
    sqlite3_stmt * statement;
    
    //Open the DB
    if(sqlite3_open([self.databasePath UTF8String] , &dnvAuditDB)==SQLITE_OK){
        
        NSString * insertUserSQL = [NSString stringWithFormat:@"INSERT INTO USER (ID, PASSWORD, OTHERINFO) VALUES ('%@', '%@', '%@')", [user objectForKey:@"userID"], [user objectForKey:@"password"], [user objectForKey:@"otherInfo"]];
        
        //Preparing
        sqlite3_prepare_v2(dnvAuditDB, [insertUserSQL UTF8String], -1, &statement, NULL);
        
        if(sqlite3_step(statement)==SQLITE_DONE){
            NSLog(@"User added to DB.");
        }
        else{
            NSLog(@"Failed to add user.");
        }
        sqlite3_finalize(statement);
        sqlite3_close(dnvAuditDB);
    }
}

//retrieve user from user table
-(User *)retrieveUser:(NSString *)userID{
    
    //create the statement Object
    sqlite3_stmt * statement;
    
    //Temperary person to hold the person information from DB
    User * tempUser = [[User alloc]init];
    
    //Open the DB
    if(sqlite3_open([self.databasePath UTF8String], &dnvAuditDB)==SQLITE_OK){
        
        //Creating the SQL statment to retrieve the data from the database
        NSString * queryUserSQL = [NSString stringWithFormat:@"SELECT ID, PASSWORD, OTHERINFO FROM USER WHERE ID='%@'", userID];
        
        //Prepare the Query
        if(sqlite3_prepare_v2(dnvAuditDB, [queryUserSQL UTF8String], -1, &statement, NULL)==SQLITE_OK){
            
            //If this work, there must be a row if the data was there
            while (sqlite3_step(statement) == SQLITE_ROW){
                
                //Gets the first name data from DB and adding it to the temp Person Object
                NSString * identify = [[NSString alloc] initWithUTF8String:(const char*)sqlite3_column_text(statement, 0)];
                
                //Gets the middle name data from DB and adding it to the temp Person Object
                NSString * password = [[NSString alloc] initWithUTF8String:(const char*)sqlite3_column_text(statement, 1)];
                
                //Gets the last name data from DB and adding it to the temp Person Object
                NSString * otherInfo = [[NSString alloc] initWithUTF8String:(const char*)sqlite3_column_text(statement, 2)];
                
//                NSLog(@"User ID: %@, Password: %@", identify, password);
                
                tempUser.userID = identify;
                tempUser.password = password;
                tempUser.otherUserInfo = otherInfo;
            }
        }
    }
    
    return tempUser;
}

//retrieve all users from table
-(NSArray *)retrieveAllUsers{
    
    //create the statement Object
    sqlite3_stmt * statement;
    
    NSMutableArray * userArray = [[NSMutableArray alloc]init];
    
    //Open the DB
    if(sqlite3_open([self.databasePath UTF8String], &dnvAuditDB)==SQLITE_OK){
        
        //Creating the SQL statment to retrieve the data from the database
        NSString * queryUserSQL = [NSString stringWithFormat:@"SELECT ID, PASSWORD, OTHERINFO FROM USER"];
        
        //Prepare the Query
        if(sqlite3_prepare_v2(dnvAuditDB, [queryUserSQL UTF8String], -1, &statement, NULL)==SQLITE_OK){
            
            //If this work, there must be a row if the data was there
            while (sqlite3_step(statement) == SQLITE_ROW){
                
                User * tempUser = [[User alloc]init];
                
                //Gets the first name data from DB and adding it to the temp Person Object
                NSString * identify = [[NSString alloc] initWithUTF8String:(const char*)sqlite3_column_text(statement, 0)];
                
                //Gets the middle name data from DB and adding it to the temp Person Object
                NSString * password = [[NSString alloc] initWithUTF8String:(const char*)sqlite3_column_text(statement, 1)];
                
                //Gets the last name data from DB and adding it to the temp Person Object
                NSString * otherInfo = [[NSString alloc] initWithUTF8String:(const char*)sqlite3_column_text(statement, 2)];
                
                NSLog(@"User ID: %@, Password: %@", identify, password);
                
                tempUser.userID = identify;
                tempUser.password = password;
                tempUser.otherUserInfo = otherInfo;
                
                [userArray addObject:tempUser];
            }
        }
    }
    
    return userArray;
}

//delete user table
-(void)deleteUserTable{
    
    //Opening the SQLite DB
    if(sqlite3_open([self.databasePath UTF8String], &dnvAuditDB)==SQLITE_OK){
        
        //Object to save errors
        char * errMsg;
        
        const char * sql_stmt = "DROP TABLE IF EXISTS USER";
        
        //Verifying the execution of the create table SQL script
        if(!(sqlite3_exec(dnvAuditDB, sql_stmt, NULL, NULL, &errMsg)==SQLITE_OK))
        {
            NSLog(@"Can't delete a table.");
        }
        sqlite3_close(dnvAuditDB);
    }
    else{
        
        NSLog(@"Failed to open/create DB.");
    }
    
}

@end
