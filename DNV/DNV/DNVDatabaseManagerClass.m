//
//  DNVDatabaseManagerClass.m
//  DNV
//
//  Created by USI on 1/17/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import "DNVDatabaseManagerClass.h"

#import "AuditIDObject.h"

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
            const char * sql_stmt = "CREATE TABLE IF NOT EXISTS AUDIT (ID TEXT PRIMARY KEY, AUDITNAME TEXT, AUDITTYPE INTEGER, LASTMODIFIED TEXT)";
            
            const char * sql_stmt2 = "CREATE TABLE IF NOT EXISTS ELEMENT (ID INTEGER PRIMARY KEY AUTOINCREMENT, AUDITID TEXT, ELEMENTNAME TEXT, ISCOMPLETED INTEGER, ISREQUIRED INTEGER, POINTSPOSSIBLE REAL, POINTSAWARDED REAL, MODIFIEDNAPOINTS REAL)";
            
            const char * sql_stmt3 = "CREATE TABLE IF NOT EXISTS SUBELEMENT (ID INTEGER PRIMARY KEY AUTOINCREMENT, ELEMENTID INTEGER, SUBELEMENTNAME TEXT, ISCOMPLETED INTEGER, POINTSPOSSIBLE REAL, POINTSAWARDED REAL, MODIFIEDNAPOINTS REAL)";
            
            const char * sql_stmt4 = "CREATE TABLE IF NOT EXISTS QUESTION (ID INTEGER PRIMARY KEY AUTOINCREMENT, SUBELEMENTID INTEGER, QUESTIONTEXT TEXT, QUESTIONTYPE INTEGER, ISCOMPLETED INTEGER, POINTSPOSSIBLE REAL, POINTSAWARDED REAL, HELPTEXT TEXT, NOTES TEXT, ISTHUMBSUP INTEGER, ISTHUMBSDOWN INTEGER, ISAPPLICABLE INTEGER, NEEDSVERIFYING INTEGER, ISVERIFYDONE INTEGER, PARENTQUESTIONID INTEGER, POINTSNEEDEFORLAYER REAL)";
            
            const char * sql_stmt5 = "CREATE TABLE IF NOT EXISTS ANSWER (ID INTEGER PRIMARY KEY AUTOINCREMENT, QUESTIONID INTEGER, ANSWERTEXT TEXT, POINTSPOSSIBLE REAL, ISSELECTED INTEGER)";
            
            const char * sql_stmt6 = "CREATE TABLE IF NOT EXISTS ATTACHMENT (ID INTEGER PRIMARY KEY AUTOINCREMENT, QUESTIONID INTEGER, ATTACHMENTNAME TEXT, ISIMAGE INTEGER)";
            
            const char * sql_stmt7 = "CREATE TABLE IF NOT EXISTS CLIENT (ID INTEGER PRIMARY KEY AUTOINCREMENT, AUDITID TEXT, USERID TEXT, CLIENTNAME TEXT, DIVISION TEXT, SIC TEXT, NUMBEREMPLOYEES INTEGER, AUDITSITE TEXT, AUDITDATE TEXT, BASELINEAUDIT INTEGER, STREETADDRESS TEXT, CITYSTATEPROVINCE TEXT, COUNTRY TEXT)";
            
            const char * sql_stmt8 = "CREATE TABLE IF NOT EXISTS REPORT (ID INTEGER PRIMARY KEY AUTOINCREMENT, AUDITID TEXT, CLIENTID INTEGER, USERID TEXT, SUMMARY TEXT, APPROVEDBY TEXT, PROJECTNUMBER TEXT, CONCLUSION TEXT, DIAGRAMFILENAME TEXT)";
            
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

-(void)saveAudit:(Audit *)audit{
    
    //Open the DB
    if(sqlite3_open([self.databasePath UTF8String] , &dnvAuditDB)==SQLITE_OK){
        
        sqlite3_stmt * statement;
        
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        NSString * auditID = [NSString stringWithFormat:@"%@.%@.%@", [defaults objectForKey:@"currentClient"], [defaults objectForKey:@"currentAudit"], [defaults objectForKey:@"currentUser"]];
        auditID = [auditID stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        NSString * insertAuditSQL = [NSString stringWithFormat:@"INSERT INTO AUDIT (ID, AUDITNAME, AUDITTYPE, LASTMODIFIED) VALUES (\"%@\", \"%@\", %d, \"%@\")", auditID, audit.name, 1, audit.lastModefied];
        
        //Preparing
        sqlite3_prepare_v2(dnvAuditDB, [insertAuditSQL UTF8String], -1, &statement, NULL);
        
        if(sqlite3_step(statement)==SQLITE_DONE){
            NSLog(@"audit added to DB.");
        
            NSString * userID = @"cliff";
        
            Client * client = audit.client;
        
            NSString * insertClientSQL = [NSString stringWithFormat:@"INSERT INTO CLIENT (AUDITID, USERID, CLIENTNAME, DIVISION, SIC, NUMBEREMPLOYEES, AUDITSITE, AUDITDATE, BASELINEAUDIT, STREETADDRESS, CITYSTATEPROVINCE, COUNTRY) VALUES (\"%@\", \"%@\", \"%@\", \"%@\", \"%@\", %d, \"%@\", \"%@\", %d, \"%@\", \"%@\", \"%@\")", auditID, userID, client.companyName, client.division, client.SICNumber, client.numEmployees, client.auditedSite, client.auditDate, client.baselineAudit, client.address, client.cityStateProvince, client.country];
        
            [self insertRowInTable:insertClientSQL forTable:@"client"];
        
            int clientID = [self getID:@"CLIENT"];
        
            Report * report = audit.report;
        
            NSString * insertReportSQL = [NSString stringWithFormat:@"INSERT INTO REPORT (AUDITID, CLIENTID, USERID, SUMMARY, APPROVEDBY, PROJECTNUMBER, CONCLUSION, DIAGRAMFILENAME) VALUES (\"%@\", %d, \"%@\", \"%@\", \"%@\",\"%@\", \"%@\", \"%@\")", auditID, clientID, userID, report.summary, report.approvedBy, report.projectNum, report.conclusion, report.methodologyDiagramLocation];
        
            [self insertRowInTable:insertReportSQL forTable:@"report"];
    
            NSArray * elements = audit.Elements;
        
            for (Elements * ele in elements){
        
                NSString * insertElementSQL = [NSString stringWithFormat:@"INSERT INTO ELEMENT (AUDITID, ELEMENTNAME, ISCOMPLETED, ISREQUIRED, POINTSPOSSIBLE, POINTSAWARDED, MODIFIEDNAPOINTS) VALUES (\"%@\", \"%@\", %d, %d, %f, %f, %f)", auditID, ele.name, ele.isCompleted, ele.isRequired, ele.pointsPossible, ele.pointsAwarded, ele.modefiedNAPoints];
            
                [self insertRowInTable:insertElementSQL forTable:@"element"];
        
                int elementID = [self getID:@"ELEMENT"];
        
                NSArray * subElements = ele.Subelements;
        
                for (SubElements * subEle in subElements){
            
                    NSString * insertSubElementSQL = [NSString stringWithFormat:@"INSERT INTO SUBELEMENT (ELEMENTID, SUBELEMENTNAME, ISCOMPLETED, POINTSPOSSIBLE, POINTSAWARDED, MODIFIEDNAPOINTS) VALUES (%d, \"%@\", %d, %f, %f, %f)", elementID, subEle.name, subEle.isCompleted, subEle.pointsPossible, subEle.pointsAwarded, subEle.modefiedNAPoints];
        
                    [self insertRowInTable:insertSubElementSQL forTable:@"sub element"];
                
                    int subElementID = [self getID:@"SUBELEMENT"];
            
                    NSArray * questions = subEle.Questions;
            
                    for (Questions * question in questions){
                
                        NSString * insertQuestionSQL = [NSString stringWithFormat:@"INSERT INTO QUESTION (SUBELEMENTID, QUESTIONTEXT, QUESTIONTYPE, ISCOMPLETED, POINTSPOSSIBLE, POINTSAWARDED, HELPTEXT, NOTES, ISTHUMBSUP, ISTHUMBSDOWN, ISAPPLICABLE, NEEDSVERIFYING, ISVERIFYDONE, PARENTQUESTIONID, POINTSNEEDEFORLAYER) VALUES (%d, \"%@\", %d, %d, %f, %f, \"%@\", \"%@\", %d, %d, %d, %d, %d, %d, %f)", subElementID, question.questionText, question.questionType, question.isCompleted, question.pointsPossible, question.pointsAwarded, question.helpText, question.notes, question.isThumbsUp, question.isThumbsDown, question.isApplicable, question.needsVerifying, question.isVerifyDone, nil, question.pointsNeededForLayered];
                
                        //Preparing
                        sqlite3_prepare_v2(dnvAuditDB, [insertQuestionSQL UTF8String], -1, &statement, NULL);
                
                        if(sqlite3_step(statement)==SQLITE_DONE){
                            NSLog(@"question added to DB.");
                        
                            sqlite3_reset(statement);
                        
                            int questionID = [self getID:@"QUESTION"];
                        
                            NSArray * answers = question.Answers;
                        
                            for (Answers * answer in answers){
                            
                                NSString * insertAnswerSQL = [NSString stringWithFormat:@"INSERT INTO ANSWER (QUESTIONID, ANSWERTEXT, POINTSPOSSIBLE, ISSELECTED) VALUES (%d, \"%@\", %f, %d)", questionID, answer.answerText, answer.pointsPossibleOrMultiplier, answer.isSelected];
                            
                                [self insertRowInTable:insertAnswerSQL forTable:@"answer"];
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
                            
                                NSString * insertAttachSQL = [NSString stringWithFormat:@"INSERT INTO ATTACHMENT (QUESTIONID, ATTACHMENTNAME, ISIMAGE) VALUES (%d, \"%@\", %d)", questionID, attachments[i], isImage];
                            
                                [self insertRowInTable:insertAttachSQL forTable:@"attachment"];
                            }
                    
                            if (question.layeredQuesions.count > 0){
                        
                                sqlite3_reset(statement);
                        
                                int questionID = [self getID:@"QUESTION"];
                        
                                NSArray * layeredQuest = question.layeredQuesions;
                        
                                for (Questions * lQ in layeredQuest){
                            
                                    NSString * insertLQSQL = [NSString stringWithFormat:@"INSERT INTO QUESTION (SUBELEMENTID, QUESTIONTEXT, QUESTIONTYPE, ISCOMPLETED, POINTSPOSSIBLE, POINTSAWARDED, HELPTEXT, NOTES, ISTHUMBSUP, ISTHUMBSDOWN, ISAPPLICABLE, NEEDSVERIFYING, ISVERIFYDONE, PARENTQUESTIONID, POINTSNEEDEFORLAYER) VALUES (%d, \"%@\", %d, %d, %f, %f, \"%@\", \"%@\", %d, %d, %d, %d, %d, %d, %f)", subElementID, lQ.questionText, lQ.questionType, lQ.isCompleted, lQ.pointsPossible, lQ.pointsAwarded, lQ.helpText, lQ.notes, lQ.isThumbsUp, lQ.isThumbsDown, lQ.isApplicable, lQ.needsVerifying, lQ.isVerifyDone, questionID, lQ.pointsNeededForLayered];
                            
                                    [self insertRowInTable:insertLQSQL forTable:@"layered question"];
                            
                                    int LQID = [self getID:@"QUESTION"];
                            
                                    NSArray * LQanswers = lQ.Answers;
                            
                                    for (Answers * answer in LQanswers){
                                
                                        NSString * insertLQAnswerSQL = [NSString stringWithFormat:@"INSERT INTO ANSWER (QUESTIONID, ANSWERTEXT, POINTSPOSSIBLE, ISSELECTED) VALUES (%d, \"%@\", %f, %d)", LQID, answer.answerText, answer.pointsPossibleOrMultiplier, answer.isSelected];
                                
                                        [self insertRowInTable:insertLQAnswerSQL forTable:@"layered answer"];
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
                                
                                        NSString * insertAttachSQL = [NSString stringWithFormat:@"INSERT INTO ATTACHMENT (QUESTIONID, ATTACHMENTNAME, ISIMAGE) VALUES (%d, \"%@\", %d)", LQID, attachments[i], isImage];
                                
                                        [self insertRowInTable:insertAttachSQL forTable:@"layered attachment"];
                                    }
                                }
                            }
                        }
                        else{
                            NSLog(@"Failed to add question.");
                        }
                    }
                }
            }
        }
        else{
            NSLog(@"Failed to add audit.");
        }
        
        sqlite3_finalize(statement);
        sqlite3_close(dnvAuditDB);
    }
    else{
        
        NSLog(@"Failed to open/create DB.");
    }
    
}

-(NSArray *)retrieveAllAuditIDsOfType:(int)auditType{
    
    //create the statement Object
    sqlite3_stmt * statement;
    
    NSMutableArray * auditIDArray = [[NSMutableArray alloc]init];
    
    //Open the DB
    if(sqlite3_open([self.databasePath UTF8String], &dnvAuditDB)==SQLITE_OK){
        
        //Creating the SQL statment to retrieve the data from the database
        NSString * queryAuditSQL = [NSString stringWithFormat:@"SELECT ID FROM AUDIT WHERE AUDITTYPE = %d", auditType];
        
        //Prepare the Query
        if(sqlite3_prepare_v2(dnvAuditDB, [queryAuditSQL UTF8String], -1, &statement, NULL)==SQLITE_OK){
            
            //If this work, there must be a row if the data was there
            while (sqlite3_step(statement) == SQLITE_ROW){
                
                //Gets the first name data from DB and adding it to the temp Person Object
                NSString * identify = [[NSString alloc] initWithUTF8String:(const char*)sqlite3_column_text(statement, 0)];
                
                [auditIDArray addObject:identify];
                
            }
        }
    }
    
    return auditIDArray;
    
}

-(NSArray *)retrieveDistinctAuditNamesOfType:(int)auditType{
    
    //create the statement Object
    sqlite3_stmt * statement;
    
    NSMutableArray * auditArray = [[NSMutableArray alloc]init];
    
    //Open the DB
    if(sqlite3_open([self.databasePath UTF8String], &dnvAuditDB)==SQLITE_OK){
        
        //Creating the SQL statment to retrieve the data from the database
        NSString * queryAuditSQL = [NSString stringWithFormat:@"SELECT DISTINCT(AUDITNAME) FROM AUDIT WHERE AUDITTYPE = %d", auditType];
        
        //Prepare the Query
        if(sqlite3_prepare_v2(dnvAuditDB, [queryAuditSQL UTF8String], -1, &statement, NULL)==SQLITE_OK){
            
            //If this work, there must be a row if the data was there
            while (sqlite3_step(statement) == SQLITE_ROW){
                
                //Gets the middle name data from DB and adding it to the temp Person Object
                NSString * name = [[NSString alloc] initWithUTF8String:(const char*)sqlite3_column_text(statement, 0)];
                
                [auditArray addObject:name];
                
            }
        }
    }
    
    return auditArray;
    
}

-(Audit *)retrieveAudit:(NSString *)auditID{
   
    //create the statement Object
    sqlite3_stmt * statement;
    
    //Temperary person to hold the person information from DB
    Audit * tempAudit;
    
    //Open the DB
    if(sqlite3_open([self.databasePath UTF8String], &dnvAuditDB)==SQLITE_OK){
        
        //Creating the SQL statment to retrieve the data from the database
        NSString * queryAuditSQL = [NSString stringWithFormat:@"SELECT AUDITNAME, AUDITTYPE, LASTMODIFIED FROM AUDIT WHERE ID=\"%@\"", auditID];
        
        //Prepare the Query
        if(sqlite3_prepare_v2(dnvAuditDB, [queryAuditSQL UTF8String], -1, &statement, NULL)==SQLITE_OK){
            
            //If this work, there must be a row if the data was there
            while (sqlite3_step(statement) == SQLITE_ROW){
                
                //Gets the first name data from DB and adding it to the temp Person Object
                NSString * name = [[NSString alloc] initWithUTF8String:(const char*)sqlite3_column_text(statement, 0)];
                
                //Gets the middle name data from DB and adding it to the temp Person Object
                NSString * type = [[NSString alloc] initWithUTF8String:(const char*)sqlite3_column_text(statement, 1)];
                
                //Gets the last name data from DB and adding it to the temp Person Object
                NSString * lastmodified = [[NSString alloc] initWithUTF8String:(const char*)sqlite3_column_text(statement, 2)];
                
                //                NSLog(@"User ID: %@, Password: %@", identify, password);
                tempAudit.name = name;
                tempAudit.auditType = [type intValue];
                tempAudit.lastModefied = lastmodified;
                tempAudit.Elements = [self retrieveElementsOfAudit:auditID];
            }
        }
    }
    
    return tempAudit;
    
}

-(NSArray *)retrieveElementsOfAudit:(NSString *)auditID{
    
    //create the statement Object
    sqlite3_stmt * statement;
    
    //Temperary person to hold the person information from DB
    Elements * tempElement;
    int elementID;
    NSMutableArray * elementArray = [[NSMutableArray alloc]init];
    
    //Open the DB
    if(sqlite3_open([self.databasePath UTF8String], &dnvAuditDB)==SQLITE_OK){
        
        //Creating the SQL statment to retrieve the data from the database
        NSString * queryElementSQL = [NSString stringWithFormat:@"SELECT * FROM ELEMENT WHERE AUDITID=\"%@\"", auditID];
        
        //Prepare the Query
        if(sqlite3_prepare_v2(dnvAuditDB, [queryElementSQL UTF8String], -1, &statement, NULL)==SQLITE_OK){
            
            //If this work, there must be a row if the data was there
            while (sqlite3_step(statement) == SQLITE_ROW){
                
                //Gets the first name data from DB and adding it to the temp Person Object
                NSString * identify = [[NSString alloc] initWithUTF8String:(const char*)sqlite3_column_text(statement, 0)];
                
                //Gets the middle name data from DB and adding it to the temp Person Object
                NSString * name = [[NSString alloc] initWithUTF8String:(const char*)sqlite3_column_text(statement, 2)];
                
                //Gets the last name data from DB and adding it to the temp Person Object
                NSString * completed = [[NSString alloc] initWithUTF8String:(const char*)sqlite3_column_text(statement, 3)];
                
                //Gets the last name data from DB and adding it to the temp Person Object
                NSString * required = [[NSString alloc] initWithUTF8String:(const char*)sqlite3_column_text(statement, 4)];
                
                //Gets the last name data from DB and adding it to the temp Person Object
                NSString * ptsPoss = [[NSString alloc] initWithUTF8String:(const char*)sqlite3_column_text(statement, 5)];
                
                //Gets the last name data from DB and adding it to the temp Person Object
                NSString * ptsAward = [[NSString alloc] initWithUTF8String:(const char*)sqlite3_column_text(statement, 6)];
                
                //Gets the last name data from DB and adding it to the temp Person Object
                NSString * modNAPts = [[NSString alloc] initWithUTF8String:(const char*)sqlite3_column_text(statement, 7)];
                
                elementID = [identify integerValue];
                
                tempElement.name = name;
                tempElement.isCompleted = [completed integerValue];
                tempElement.isRequired = [required integerValue];
                tempElement.pointsPossible = [ptsPoss floatValue];
                tempElement.pointsAwarded = [ptsAward floatValue];
                tempElement.modefiedNAPoints = [modNAPts floatValue];
                tempElement.Subelements = [self retrieveSubElementsOfElement:elementID];
                
                [elementArray addObject:tempElement];
            }
        }
    }
    
    return elementArray;
}

-(NSArray *)retrieveSubElementsOfElement:(int) elementID{
    
    //create the statement Object
    sqlite3_stmt * statement;
    
    //Temperary person to hold the person information from DB
    SubElements * tempSubElement;
    int subElementID;
    NSMutableArray * subElementArray = [[NSMutableArray alloc]init];
    
    //Open the DB
    if(sqlite3_open([self.databasePath UTF8String], &dnvAuditDB)==SQLITE_OK){
        
        //Creating the SQL statment to retrieve the data from the database
        NSString * querySubElementSQL = [NSString stringWithFormat:@"SELECT * FROM SUBELEMENT WHERE ELEMENTID= %d", elementID];
        
        //Prepare the Query
        if(sqlite3_prepare_v2(dnvAuditDB, [querySubElementSQL UTF8String], -1, &statement, NULL)==SQLITE_OK){
            
            //If this work, there must be a row if the data was there
            while (sqlite3_step(statement) == SQLITE_ROW){
                
                //Gets the first name data from DB and adding it to the temp Person Object
                NSString * identify = [[NSString alloc] initWithUTF8String:(const char*)sqlite3_column_text(statement, 0)];
                
                //Gets the middle name data from DB and adding it to the temp Person Object
                NSString * name = [[NSString alloc] initWithUTF8String:(const char*)sqlite3_column_text(statement, 2)];
                
                //Gets the last name data from DB and adding it to the temp Person Object
                NSString * completed = [[NSString alloc] initWithUTF8String:(const char*)sqlite3_column_text(statement, 3)];
                
                //Gets the last name data from DB and adding it to the temp Person Object
                NSString * ptsPoss = [[NSString alloc] initWithUTF8String:(const char*)sqlite3_column_text(statement, 4)];
                
                //Gets the last name data from DB and adding it to the temp Person Object
                NSString * ptsAward = [[NSString alloc] initWithUTF8String:(const char*)sqlite3_column_text(statement, 5)];
                
                //Gets the last name data from DB and adding it to the temp Person Object
                NSString * modNAPts = [[NSString alloc] initWithUTF8String:(const char*)sqlite3_column_text(statement, 6)];
                
                subElementID = [identify integerValue];
                
                tempSubElement.name = name;
                tempSubElement.isCompleted = [completed integerValue];
                tempSubElement.pointsPossible = [ptsPoss floatValue];
                tempSubElement.pointsAwarded = [ptsAward floatValue];
                tempSubElement.modefiedNAPoints = [modNAPts floatValue];
                
                [subElementArray addObject:tempSubElement];
            }
        }
    }
    
    return subElementArray;
}

-(NSArray *)retrieveQuestionsOfSubElement:(int) subElementID{
    
    //create the statement Object
    sqlite3_stmt * statement;
    
    //Temperary person to hold the person information from DB
    Questions * tempQuestion;
    int questionID;
    int parentQID;
    NSMutableArray * questionArray = [[NSMutableArray alloc]init];
    
    //Open the DB
    if(sqlite3_open([self.databasePath UTF8String], &dnvAuditDB)==SQLITE_OK){
        
        //Creating the SQL statment to retrieve the data from the database
        NSString * queryQuestionSQL = [NSString stringWithFormat:@"SELECT * FROM QUESTION WHERE SUBELEMENTID= %d", subElementID];
        
        //Prepare the Query
        if(sqlite3_prepare_v2(dnvAuditDB, [queryQuestionSQL UTF8String], -1, &statement, NULL)==SQLITE_OK){
            
            //If this work, there must be a row if the data was there
            while (sqlite3_step(statement) == SQLITE_ROW){
                
                //Gets the first name data from DB and adding it to the temp Person Object
                NSString * identify = [[NSString alloc] initWithUTF8String:(const char*)sqlite3_column_text(statement, 0)];
                
                //Gets the middle name data from DB and adding it to the temp Person Object
                NSString * text = [[NSString alloc] initWithUTF8String:(const char*)sqlite3_column_text(statement, 2)];
                
                //Gets the middle name data from DB and adding it to the temp Person Object
                NSString * type = [[NSString alloc] initWithUTF8String:(const char*)sqlite3_column_text(statement, 3)];
                
                //Gets the last name data from DB and adding it to the temp Person Object
                NSString * completed = [[NSString alloc] initWithUTF8String:(const char*)sqlite3_column_text(statement, 4)];
                
                //Gets the last name data from DB and adding it to the temp Person Object
                NSString * ptsPoss = [[NSString alloc] initWithUTF8String:(const char*)sqlite3_column_text(statement, 5)];
                
                //Gets the last name data from DB and adding it to the temp Person Object
                NSString * ptsAward = [[NSString alloc] initWithUTF8String:(const char*)sqlite3_column_text(statement, 6)];
                
                //Gets the last name data from DB and adding it to the temp Person Object
                NSString * help = [[NSString alloc] initWithUTF8String:(const char*)sqlite3_column_text(statement, 7)];
                
                //Gets the middle name data from DB and adding it to the temp Person Object
                NSString * notes = [[NSString alloc] initWithUTF8String:(const char*)sqlite3_column_text(statement, 8)];
                
                //Gets the middle name data from DB and adding it to the temp Person Object
                NSString * thumbsUp = [[NSString alloc] initWithUTF8String:(const char*)sqlite3_column_text(statement, 9)];
                
                //Gets the middle name data from DB and adding it to the temp Person Object
                NSString * thumbsDown = [[NSString alloc] initWithUTF8String:(const char*)sqlite3_column_text(statement, 10)];
                
                //Gets the middle name data from DB and adding it to the temp Person Object
                NSString * isNA = [[NSString alloc] initWithUTF8String:(const char*)sqlite3_column_text(statement, 11)];
                
                //Gets the middle name data from DB and adding it to the temp Person Object
                NSString * isVerify = [[NSString alloc] initWithUTF8String:(const char*)sqlite3_column_text(statement, 12)];
                
                //Gets the middle name data from DB and adding it to the temp Person Object
                NSString * verifyDone = [[NSString alloc] initWithUTF8String:(const char*)sqlite3_column_text(statement, 13)];
                
                //Gets the middle name data from DB and adding it to the temp Person Object
                NSString *  parentQuestID = [[NSString alloc] initWithUTF8String:(const char*)sqlite3_column_text(statement, 14)];
                
                //Gets the middle name data from DB and adding it to the temp Person Object
                NSString * ptsPossForLay = [[NSString alloc] initWithUTF8String:(const char*)sqlite3_column_text(statement, 15)];
                
                questionID = [identify integerValue];
                parentQID = [parentQuestID integerValue];
                
                tempQuestion.questionText = text;
                tempQuestion.questionType = [type integerValue];
                tempQuestion.isCompleted = [completed integerValue];
                tempQuestion.pointsPossible = [ptsPoss floatValue];
                tempQuestion.pointsAwarded = [ptsAward floatValue];
                tempQuestion.helpText = help;
                tempQuestion.notes = notes;
                tempQuestion.isThumbsUp = [thumbsUp boolValue];
                tempQuestion.isThumbsDown = [thumbsDown boolValue];
                tempQuestion.isApplicable = [isNA boolValue];
                tempQuestion.needsVerifying = [isVerify integerValue];
                tempQuestion.isVerifyDone = [verifyDone boolValue];
                tempQuestion.pointsNeededForLayered = [ptsPossForLay floatValue];
                
                [questionArray addObject:tempQuestion];
            }
        }
    }
    
    return questionArray;
}


-(void)updateAudit:(NSInteger *)auditID auditType:(NSInteger *)auditType{
    
    
    
    
}

-(void)updateElement:(NSInteger *)elementID isCompleted:(BOOL)isCompleted ofAudit:(NSString *)auditID{
    
    
}

-(void)updateSubElment:(NSInteger *)subElementID isCompleted:(BOOL)isCompleted ofAudit:(NSString *)auditID{
    
    
}

-(void)updateQuestion:(NSInteger *)questionID isCompleted:(BOOL)isCompleted ofAudit:(NSString *)auditID{
    
    
}

-(void)updateAnswer:(NSInteger *)answerID isCompleted:(BOOL)isSelected ofAudit:(NSString *)auditID{
    
    
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
        
        NSString * insertUserSQL = [NSString stringWithFormat:@"INSERT INTO USER (ID, PASSWORD, OTHERINFO) VALUES (\"%@\", \"%@\", \"%@\")", [user objectForKey:@"userID"], [user objectForKey:@"password"], [user objectForKey:@"otherInfo"]];
        
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
        NSString * queryUserSQL = [NSString stringWithFormat:@"SELECT ID, PASSWORD, OTHERINFO FROM USER WHERE ID=\"%@\"", userID];
        
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
                
//                NSLog(@"User ID: %@, Password: %@", identify, password);
                
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

#pragma mark helper functions

-(int)getID:(NSString *) table{
    
    sqlite3_stmt * statement;
    int ID = -1;
    
    NSString * getIDSQL = [NSString stringWithFormat:@"SELECT MAX(ID) FROM \"%@\"", table];
    
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

-(void)insertRowInTable:(NSString *)insertSQL forTable:(NSString *) table{
    
    sqlite3_stmt * statement;
    
    //Preparing
    sqlite3_prepare_v2(dnvAuditDB, [insertSQL UTF8String], -1, &statement, NULL);
    
    if(sqlite3_step(statement)==SQLITE_DONE){
        NSLog(@"%@ added to DB.", table);
    }
    else{
        NSLog(@"Failed to add %@.", table);
    }
    sqlite3_finalize(statement);
}


@end
