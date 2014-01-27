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
            
            const char * sql_stmt4 = "CREATE TABLE IF NOT EXISTS QUESTION (ID INTEGER PRIMARY KEY AUTOINCREMENT, SUBELEMENTID INTEGER, QUESTIONTEXT TEXT, QUESTIONTYPE INTEGER, ISCOMPLETED INTEGER, POINTSPOSSIBLE REAL, POINTSAWARDED REAL, HELPTEXT TEXT, NOTES TEXT, ISTHUMBSUP INTEGER, ISTHUMBSDOWN INTEGER, ISAPPLICABLE INTEGER, NEEDSVERIFYING INTEGER, ISVERIFYDONE INTEGER, PARENTQUESTIONID INTEGER, NUMBEROFLAYERED INTEGER, POINTSNEEDEFORLAYER REAL)";
            
            const char * sql_stmt5 = "CREATE TABLE IF NOT EXISTS ANSWER (ID INTEGER PRIMARY KEY AUTOINCREMENT, QUESTIONID INTEGER, ANSWERTEXT TEXT, POINTSPOSSIBLE REAL, ISSELECTED INTEGER)";
            
            const char * sql_stmt6 = "CREATE TABLE IF NOT EXISTS ATTACHMENT (ID INTEGER PRIMARY KEY AUTOINCREMENT, QUESTIONID INTEGER, ATTACHMENTNAME TEXT, ISIMAGE INTEGER)";
            
            const char * sql_stmt7 = "CREATE TABLE IF NOT EXISTS CLIENT (ID INTEGER PRIMARY KEY AUTOINCREMENT, AUDITID TEXT, CLIENTNAME TEXT, DIVISION TEXT, SIC TEXT, NUMBEREMPLOYEES INTEGER, AUDITOR TEXT, AUDITSITE TEXT, AUDITDATE TEXT, BASELINEAUDIT INTEGER, STREETADDRESS TEXT, CITYSTATEPROVINCE TEXT, POSTALCODE TEXT, COUNTRY TEXT)";
            
            const char * sql_stmt8 = "CREATE TABLE IF NOT EXISTS REPORT (ID INTEGER PRIMARY KEY AUTOINCREMENT, AUDITID TEXT, CLIENTREF TEXT, SUMMARY TEXT, EXECSUMMARY TEXT, PREPAREDBY TEXT, APPROVEDBY TEXT, PROJECTNUMBER TEXT, SCORINGASSUMPTIONS TEXT, CONCLUSION TEXT, DIAGRAMFILENAME TEXT)";
            
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
        
        //Using the user defaults to create the audit ID
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        NSString * auditID = [NSString stringWithFormat:@"%@.%@.%@", [defaults objectForKey:@"currentClient"], [defaults objectForKey:@"currentAudit"], [defaults objectForKey:@"currentUser"]];
        auditID = [auditID stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        //Query to insert into the audit table
        NSString * insertAuditSQL = [NSString stringWithFormat:@"INSERT INTO AUDIT (ID, AUDITNAME, AUDITTYPE, LASTMODIFIED) VALUES (\"%@\", \"%@\", %d, \"%@\")", auditID, audit.name, 1, audit.lastModefied];
        
        //Preparing
        sqlite3_prepare_v2(dnvAuditDB, [insertAuditSQL UTF8String], -1, &statement, NULL);
        
        if(sqlite3_step(statement)==SQLITE_DONE){
            NSLog(@"audit added to DB.");
        
            Client * client = audit.client;
        
            //Query to insert into the client table
            NSString * insertClientSQL = [NSString stringWithFormat:@"INSERT INTO CLIENT (AUDITID, CLIENTNAME, DIVISION, SIC, NUMBEREMPLOYEES, AUDITOR, AUDITSITE, AUDITDATE, BASELINEAUDIT, STREETADDRESS, CITYSTATEPROVINCE, POSTALCODE, COUNTRY) VALUES (\"%@\", \"%@\", \"%@\", \"%@\", %d, \"%@\", \"%@\", \"%@\", %d, \"%@\", \"%@\", \"%@\", \"%@\")", auditID, client.companyName, client.division, client.SICNumber, client.numEmployees, client.auditor, client.auditedSite, client.auditDate, client.baselineAudit, client.address, client.cityStateProvince, client.postalCode, client.country];
        
            //Call to insert a row into a table
            [self insertRowInTable:insertClientSQL forTable:@"client"];
        
            Report * report = audit.report;
        
            //Query to insert into the report table
            NSString * insertReportSQL = [NSString stringWithFormat:@"INSERT INTO REPORT (AUDITID, SUMMARY, EXECSUMMARY, PREPAREDBY, APPROVEDBY, PROJECTNUMBER, SCORINGASSUMPTIONS, CONCLUSION, DIAGRAMFILENAME) VALUES (\"%@\", \"%@\", \"%@\", \"%@\", \"%@\",\"%@\", \"%@\", \"%@\", \"%@\")", auditID, report.summary, report.executiveSummary, report.preparedBy, report.approvedBy, report.projectNum, report.scoringAssumptions, report.conclusion, report.methodologyDiagramLocation];
        
            //Call to insert a row into a table
            [self insertRowInTable:insertReportSQL forTable:@"report"];
    
            NSArray * elements = audit.Elements;
        
            //Loop for elements
            for (Elements * ele in elements){
        
                //Query to insert into the element table
                NSString * insertElementSQL = [NSString stringWithFormat:@"INSERT INTO ELEMENT (AUDITID, ELEMENTNAME, ISCOMPLETED, ISREQUIRED, POINTSPOSSIBLE, POINTSAWARDED, MODIFIEDNAPOINTS) VALUES (\"%@\", \"%@\", %d, %d, %f, %f, %f)", auditID, ele.name, ele.isCompleted, ele.isRequired, ele.pointsPossible, ele.pointsAwarded, ele.modefiedNAPoints];
            
                //Call to insert a row into a table
                [self insertRowInTable:insertElementSQL forTable:@"element"];
        
                int elementID = [self getID:@"ELEMENT"];
        
                NSArray * subElements = ele.Subelements;
        
                //Loop for sub elements
                for (SubElements * subEle in subElements){
            
                    //Query to insert into the sub element table
                    NSString * insertSubElementSQL = [NSString stringWithFormat:@"INSERT INTO SUBELEMENT (ELEMENTID, SUBELEMENTNAME, ISCOMPLETED, POINTSPOSSIBLE, POINTSAWARDED, MODIFIEDNAPOINTS) VALUES (%d, \"%@\", %d, %f, %f, %f)", elementID, subEle.name, subEle.isCompleted, subEle.pointsPossible, subEle.pointsAwarded, subEle.modefiedNAPoints];
        
                    //Call to insert a row into a table
                    [self insertRowInTable:insertSubElementSQL forTable:@"sub element"];
                
                    int subElementID = [self getID:@"SUBELEMENT"];
            
                    NSArray * questions = subEle.Questions;
            
                    //Loop for questions
                    for (Questions * question in questions){
                
                        //Query to insert into the question table
                        NSString * insertQuestionSQL = [NSString stringWithFormat:@"INSERT INTO QUESTION (SUBELEMENTID, QUESTIONTEXT, QUESTIONTYPE, ISCOMPLETED, POINTSPOSSIBLE, POINTSAWARDED, HELPTEXT, NOTES, ISTHUMBSUP, ISTHUMBSDOWN, ISAPPLICABLE, NEEDSVERIFYING, ISVERIFYDONE, PARENTQUESTIONID, NUMBEROFLAYERED, POINTSNEEDEFORLAYER) VALUES (%d, \"%@\", %d, %d, %f, %f, \"%@\", \"%@\", %d, %d, %d, %d, %d, %d, %d, %f)", subElementID, question.questionText, question.questionType, question.isCompleted, question.pointsPossible, question.pointsAwarded, question.helpText, question.notes, question.isThumbsUp, question.isThumbsDown, question.isApplicable, question.needsVerifying, question.isVerifyDone, nil, question.layeredQuesions.count, question.pointsNeededForLayered];
                
                        //Preparing
                        sqlite3_prepare_v2(dnvAuditDB, [insertQuestionSQL UTF8String], -1, &statement, NULL);
                
                        if(sqlite3_step(statement)==SQLITE_DONE){
                            NSLog(@"question added to DB.");
                        
                            sqlite3_reset(statement);
                        
                            int questionID = [self getID:@"QUESTION"];
                        
                            NSArray * answers = question.Answers;
                        
                            //Loop for answers
                            for (Answers * answer in answers){
                            
                                //Query to insert into the answer table
                                NSString * insertAnswerSQL = [NSString stringWithFormat:@"INSERT INTO ANSWER (QUESTIONID, ANSWERTEXT, POINTSPOSSIBLE, ISSELECTED) VALUES (%d, \"%@\", %f, %d)", questionID, answer.answerText, answer.pointsPossible, answer.isSelected];
                            
                                //Call to insert a row into a table
                                [self insertRowInTable:insertAnswerSQL forTable:@"answer"];
                            }
                        
                            //
                            NSMutableArray * attachments = [NSMutableArray arrayWithArray:question.imageLocationArray];
                            for (NSString * attach in question.attachmentsLocationArray)
                                [attachments addObject:attach];
                        
                            //Loop for attachments
                            for (int i = 0; i < attachments.count; i++){
                            
                                BOOL isImage;
                                if (i < question.imageLocationArray.count)
                                    isImage = true;
                                else
                                    isImage = false;
                            
                                //Query to insert into the attachment table
                                NSString * insertAttachSQL = [NSString stringWithFormat:@"INSERT INTO ATTACHMENT (QUESTIONID, ATTACHMENTNAME, ISIMAGE) VALUES (%d, \"%@\", %d)", questionID, attachments[i], isImage];
                            
                                //Call to insert a row into a table
                                [self insertRowInTable:insertAttachSQL forTable:@"attachment"];
                            }
                    
                            //Condition for layered questions
                            if (question.layeredQuesions.count > 0){
                        
                                sqlite3_reset(statement);
                        
                                int questionID = [self getID:@"QUESTION"];
                        
                                NSArray * layeredQuest = question.layeredQuesions;
                        
                                //Loop for layered questions
                                for (Questions * lQ in layeredQuest){
                            
                                    //Query to insert layered questions into the questions table
                                    NSString * insertLQSQL = [NSString stringWithFormat:@"INSERT INTO QUESTION (SUBELEMENTID, QUESTIONTEXT, QUESTIONTYPE, ISCOMPLETED, POINTSPOSSIBLE, POINTSAWARDED, HELPTEXT, NOTES, ISTHUMBSUP, ISTHUMBSDOWN, ISAPPLICABLE, NEEDSVERIFYING, ISVERIFYDONE, PARENTQUESTIONID, NUMBEROFLAYERED, POINTSNEEDEFORLAYER) VALUES (%d, \"%@\", %d, %d, %f, %f, \"%@\", \"%@\", %d, %d, %d, %d, %d, %d, %d, %f)", subElementID, lQ.questionText, lQ.questionType, lQ.isCompleted, lQ.pointsPossible, lQ.pointsAwarded, lQ.helpText, lQ.notes, lQ.isThumbsUp, lQ.isThumbsDown, lQ.isApplicable, lQ.needsVerifying, lQ.isVerifyDone, questionID, lQ.layeredQuesions.count, lQ.pointsNeededForLayered];
                            
                                    //Call to insert a row into a table
                                    [self insertRowInTable:insertLQSQL forTable:@"layered question"];
                            
                                    int LQID = [self getID:@"QUESTION"];
                            
                                    NSArray * LQanswers = lQ.Answers;
                            
                                    //Loop for layered question answers
                                    for (Answers * answer in LQanswers){
                                
                                        //Query to insert LQ answers into the answers table
                                        NSString * insertLQAnswerSQL = [NSString stringWithFormat:@"INSERT INTO ANSWER (QUESTIONID, ANSWERTEXT, POINTSPOSSIBLE, ISSELECTED) VALUES (%d, \"%@\", %f, %d)", LQID, answer.answerText, answer.pointsPossible, answer.isSelected];
                                
                                        //Call to insert a row into a table
                                        [self insertRowInTable:insertLQAnswerSQL forTable:@"layered answer"];
                                    }
                            
                                    //
                                    NSMutableArray * attachments = [NSMutableArray arrayWithArray:lQ.imageLocationArray];
                                    for (NSString * attach in lQ.attachmentsLocationArray)
                                        [attachments addObject:attach];
                            
                                    //Loop for Attachments
                                    for (int i = 0; i < attachments.count; i++){
                                
                                        BOOL isImage;
                                    
                                        if (i < lQ.imageLocationArray.count)
                                            isImage = true;
                                        else
                                            isImage = false;
                                
                                        //Query to insert LQ attachments into the attachments table
                                        NSString * insertAttachSQL = [NSString stringWithFormat:@"INSERT INTO ATTACHMENT (QUESTIONID, ATTACHMENTNAME, ISIMAGE) VALUES (%d, \"%@\", %d)", LQID, attachments[i], isImage];
                                
                                        //Call to insert a row into a table
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


-(NSArray *)retrieveAllAuditIDsOfType:(int)auditType forAuditName:(NSString *)auditName{
    
    //Create the statement Object
    sqlite3_stmt * statement;
    
    NSMutableArray * auditIDArray = [[NSMutableArray alloc]init];
    
    //Open the DB
    if(sqlite3_open([self.databasePath UTF8String], &dnvAuditDB)==SQLITE_OK){
        
        //Creating the SQL statment to retrieve the data from the database
        NSString * queryAuditSQL = [NSString stringWithFormat:@"SELECT ID FROM AUDIT WHERE AUDITTYPE = %d AND AUDITNAME = \"%@\"", auditType, auditName];
        
        //Prepare the Query
        if(sqlite3_prepare_v2(dnvAuditDB, [queryAuditSQL UTF8String], -1, &statement, NULL)==SQLITE_OK){
            
            //If this work, there must be a row if the data was there
            while (sqlite3_step(statement) == SQLITE_ROW){
                
                //Gets the audit id data from DB and adding it to the temp audit ID array
                NSString * identify = [[NSString alloc] initWithUTF8String:(const char*)sqlite3_column_text(statement, 0)];
                
                [auditIDArray addObject:identify];
                
            }
        }
    }
    
    return auditIDArray;
}


-(NSArray *)retrieveDistinctAuditNamesForClientOfType:(int)auditType{
    
    //Create the statement Object
    sqlite3_stmt * statement;
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray * auditArray = [[NSMutableArray alloc]init];
    
    //Open the DB
    if(sqlite3_open([self.databasePath UTF8String], &dnvAuditDB)==SQLITE_OK){
        
        //Creating the SQL statment to retrieve the data from the database
        NSString * queryAuditSQL = [NSString stringWithFormat:@"SELECT DISTINCT(AUDITNAME) FROM AUDIT INNER JOIN CLIENT ON CLIENT.AUDITID = AUDIT.ID WHERE AUDITTYPE = %d AND CLIENTNAME = \"%@\"", auditType, [defaults objectForKey:@"currentClient"]];
        
        //Prepare the Query
        if(sqlite3_prepare_v2(dnvAuditDB, [queryAuditSQL UTF8String], -1, &statement, NULL)==SQLITE_OK){
            
            //If this work, there must be a row if the data was there
            while (sqlite3_step(statement) == SQLITE_ROW){
                
                //Gets the audit name data from DB and adding it to the temp audit name array
                NSString * name = [[NSString alloc] initWithUTF8String:(const char*)sqlite3_column_text(statement, 0)];
                
                [auditArray addObject:name];
                
            }
        }
    }
    
    return auditArray;
}


-(Audit *)retrieveAudit:(NSString *)auditID{
   
    //Create the statement Object
    sqlite3_stmt * statement;
    
    //Temperary audit to hold the audit information from DB
    Audit * tempAudit = [Audit new];
    
    //Open the DB
    if(sqlite3_open([self.databasePath UTF8String], &dnvAuditDB)==SQLITE_OK){
        
        //Creating the SQL statment to retrieve the data from the database
        NSString * queryAuditSQL = [NSString stringWithFormat:@"SELECT AUDITNAME, AUDITTYPE, LASTMODIFIED FROM AUDIT WHERE ID=\"%@\"", auditID];
        
        //Prepare the Query
        if(sqlite3_prepare_v2(dnvAuditDB, [queryAuditSQL UTF8String], -1, &statement, NULL)==SQLITE_OK){
            
            //If this work, there must be a row if the data was there
            while (sqlite3_step(statement) == SQLITE_ROW){
                
                //Gets the audit name data from DB and adding it to the temp Audit Object
                NSString * name = [[NSString alloc] initWithUTF8String:(const char*)sqlite3_column_text(statement, 0)];
                
                //Gets the audit type data from DB and adding it to the temp Audit Object
                NSString * type = [[NSString alloc] initWithUTF8String:(const char*)sqlite3_column_text(statement, 1)];
                
                //Gets the last modified data from DB and adding it to the temp Audit Object
                NSString * lastmodified = [[NSString alloc] initWithUTF8String:(const char*)sqlite3_column_text(statement, 2)];
                
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
    
    //Create the statement Object
    sqlite3_stmt * statement;
    
    NSMutableArray * elementArray = [[NSMutableArray alloc]init];
    
    //Open the DB
    if(sqlite3_open([self.databasePath UTF8String], &dnvAuditDB)==SQLITE_OK){
        
        //Creating the SQL statment to retrieve the data from the database
        NSString * queryElementSQL = [NSString stringWithFormat:@"SELECT * FROM ELEMENT WHERE AUDITID=\"%@\"", auditID];
        
        //Prepare the Query
        if(sqlite3_prepare_v2(dnvAuditDB, [queryElementSQL UTF8String], -1, &statement, NULL)==SQLITE_OK){
            
            //If this work, there must be a row if the data was there
            while (sqlite3_step(statement) == SQLITE_ROW){
                
                //Temperary element to hold the element information from DB
                Elements * tempElement = [Elements new];
                int elementID;

                
                //Gets the element id data from DB and adding it to the temp Element Object
                NSString * identify = [[NSString alloc] initWithUTF8String:(const char*)sqlite3_column_text(statement, 0)];
                
                //Gets the element name data from DB and adding it to the temp Element Object
                NSString * name = [[NSString alloc] initWithUTF8String:(const char*)sqlite3_column_text(statement, 2)];
                
                //Gets the isCompleted data from DB and adding it to the temp Element Object
                NSString * completed = [[NSString alloc] initWithUTF8String:(const char*)sqlite3_column_text(statement, 3)];
                
                //Gets the isRequired data from DB and adding it to the temp Element Object
                NSString * required = [[NSString alloc] initWithUTF8String:(const char*)sqlite3_column_text(statement, 4)];
                
                //Gets the pointsPossible data from DB and adding it to the temp Element Object
                NSString * ptsPoss = [[NSString alloc] initWithUTF8String:(const char*)sqlite3_column_text(statement, 5)];
                
                //Gets the pointsAwarded data from DB and adding it to the temp Element Object
                NSString * ptsAward = [[NSString alloc] initWithUTF8String:(const char*)sqlite3_column_text(statement, 6)];
                
                //Gets the modifiedNAPoints data from DB and adding it to the temp Element Object
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
    
    NSMutableArray * subElementArray = [[NSMutableArray alloc]init];
    
    //Open the DB
    if(sqlite3_open([self.databasePath UTF8String], &dnvAuditDB)==SQLITE_OK){
        
        //Creating the SQL statment to retrieve the data from the database
        NSString * querySubElementSQL = [NSString stringWithFormat:@"SELECT * FROM SUBELEMENT WHERE ELEMENTID= %d", elementID];
        
        //Prepare the Query
        if(sqlite3_prepare_v2(dnvAuditDB, [querySubElementSQL UTF8String], -1, &statement, NULL)==SQLITE_OK){
            
            //If this work, there must be a row if the data was there
            while (sqlite3_step(statement) == SQLITE_ROW){
                
                //Temperary sub element to hold the sub element information from DB
                SubElements * tempSubElement = [SubElements new];
                int subElementID;
                
                //Gets the sub element id data from DB and adding it to the temp Sub Element Object
                NSString * identify = [[NSString alloc] initWithUTF8String:(const char*)sqlite3_column_text(statement, 0)];
                
                //Gets the sub element name data from DB and adding it to the temp Sub Element Object
                NSString * name = [[NSString alloc] initWithUTF8String:(const char*)sqlite3_column_text(statement, 2)];
                
                //Gets the isCompleted data from DB and adding it to the temp Sub Element Object
                NSString * completed = [[NSString alloc] initWithUTF8String:(const char*)sqlite3_column_text(statement, 3)];
                
                //Gets the pointsPossible data from DB and adding it to the temp Sub Element Object
                NSString * ptsPoss = [[NSString alloc] initWithUTF8String:(const char*)sqlite3_column_text(statement, 4)];
                
                //Gets the pointsAwarded data from DB and adding it to the temp Sub Element Object
                NSString * ptsAward = [[NSString alloc] initWithUTF8String:(const char*)sqlite3_column_text(statement, 5)];
                
                //Gets the modifiedNAPoints data from DB and adding it to the temp Sub Element Object
                NSString * modNAPts = [[NSString alloc] initWithUTF8String:(const char*)sqlite3_column_text(statement, 6)];
                
                subElementID = [identify integerValue];
                
                tempSubElement.name = name;
                tempSubElement.isCompleted = [completed integerValue];
                tempSubElement.pointsPossible = [ptsPoss floatValue];
                tempSubElement.pointsAwarded = [ptsAward floatValue];
                tempSubElement.modefiedNAPoints = [modNAPts floatValue];
                tempSubElement.Questions = [self retrieveQuestionsOfSubElement:subElementID gettingLayeredQuestions:false theParentQuestionID:0];
                
                [subElementArray addObject:tempSubElement];
            }
        }
    }
    
    return subElementArray;
}

-(NSArray *)retrieveQuestionsOfSubElement:(int) subElementID gettingLayeredQuestions:(BOOL)bLayeredQuestion theParentQuestionID:(int)pQID{
    
    //Create the statement Object
    sqlite3_stmt * statement;
    
    NSMutableArray * questionArray = [[NSMutableArray alloc]init];
//    NSMutableArray * layeredQuestionArray = [[NSMutableArray alloc]init];
    
    //Open the DB
    if(sqlite3_open([self.databasePath UTF8String], &dnvAuditDB)==SQLITE_OK){
        
        NSString * queryQuestionSQL;
        //Creating the SQL statment to retrieve the data from the database
//        if( !bLayeredQuestion)
//            queryQuestionSQL = [NSString stringWithFormat:@"SELECT * FROM QUESTION WHERE SUBELEMENTID= %d ", subElementID];
//        else
            queryQuestionSQL = [NSString stringWithFormat:@"SELECT * FROM QUESTION WHERE SUBELEMENTID= %d AND PARENTQUESTIONID = %d", subElementID, pQID];
        
        //Prepare the Query
        if(sqlite3_prepare_v2(dnvAuditDB, [queryQuestionSQL UTF8String], -1, &statement, NULL)==SQLITE_OK){
            
            //If this work, there must be a row if the data was there
            while (sqlite3_step(statement) == SQLITE_ROW){
                
                //Temperary question to hold the question information from DB
                Questions * tempQuestion = [Questions new];
                int questionID;
                int parentQID;
                
                //Gets the question id data from DB and adding it to the temp Question Object
                NSString * identify = [[NSString alloc] initWithUTF8String:(const char*)sqlite3_column_text(statement, 0)];
                
                //Gets the auditText data from DB and adding it to the temp Question Object
                NSString * text = [[NSString alloc] initWithUTF8String:(const char*)sqlite3_column_text(statement, 2)];
                
                //Gets the auditType data from DB and adding it to the temp Question Object
                NSString * type = [[NSString alloc] initWithUTF8String:(const char*)sqlite3_column_text(statement, 3)];
                
                //Gets the isCompleted data from DB and adding it to the temp Question Object
                NSString * completed = [[NSString alloc] initWithUTF8String:(const char*)sqlite3_column_text(statement, 4)];
                
                //Gets the pointsPossible data from DB and adding it to the temp Question Object
                NSString * ptsPoss = [[NSString alloc] initWithUTF8String:(const char*)sqlite3_column_text(statement, 5)];
                
                //Gets the pointsAwarded data from DB and adding it to the temp Question Object
                NSString * ptsAward = [[NSString alloc] initWithUTF8String:(const char*)sqlite3_column_text(statement, 6)];
                
                //Gets the help text data from DB and adding it to the temp Question Object
                NSString * help = [[NSString alloc] initWithUTF8String:(const char*)sqlite3_column_text(statement, 7)];
                
                //Gets the notes data from DB and adding it to the temp Question Object
                NSString * notes = [[NSString alloc] initWithUTF8String:(const char*)sqlite3_column_text(statement, 8)];
                
                //Gets the isThumbsUp data from DB and adding it to the temp Question Object
                NSString * thumbsUp = [[NSString alloc] initWithUTF8String:(const char*)sqlite3_column_text(statement, 9)];
                
                //Gets the isThumbsDown data from DB and adding it to the temp Question Object
                NSString * thumbsDown = [[NSString alloc] initWithUTF8String:(const char*)sqlite3_column_text(statement, 10)];
                
                //Gets the isApplicable data from DB and adding it to the temp Question Object
                NSString * isNA = [[NSString alloc] initWithUTF8String:(const char*)sqlite3_column_text(statement, 11)];
                
                //Gets the needVerifying data from DB and adding it to the temp Question Object
                NSString * isVerify = [[NSString alloc] initWithUTF8String:(const char*)sqlite3_column_text(statement, 12)];
                
                //Gets the isVerifyDone data from DB and adding it to the temp Question Object
                NSString * verifyDone = [[NSString alloc] initWithUTF8String:(const char*)sqlite3_column_text(statement, 13)];
                
                //Gets the parent question ID data from DB and adding it to the temp Question Object
                NSString *  parentQuestID = [[NSString alloc] initWithUTF8String:(const char*)sqlite3_column_text(statement, 14)];
                
                //Gets the parent question ID data from DB and adding it to the temp Question Object
                NSString *  numOfLayered = [[NSString alloc] initWithUTF8String:(const char*)sqlite3_column_text(statement, 15)];
                
                //Gets the pointsPossibleForLayered data from DB and adding it to the temp Question Object
                NSString * ptsPossForLay = [[NSString alloc] initWithUTF8String:(const char*)sqlite3_column_text(statement, 16)];
                
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
                tempQuestion.Answers = [self retrieveAnswersOfQuestion:questionID];
                
                if( [numOfLayered integerValue] > 0 )
                    tempQuestion.layeredQuesions = [self retrieveQuestionsOfSubElement:subElementID gettingLayeredQuestions:true theParentQuestionID:questionID];
                
//                if( !bLayeredQuestion)
                    [questionArray addObject:tempQuestion];
//                else
//                    [layeredQuestionArray addObject:tempQuestion];
            }
        }
    }
    
    return questionArray;
}

-(NSArray *)retrieveAnswersOfQuestion:(int)questionID{
    
    //Create the statement Object
    sqlite3_stmt * statement;
    
    NSMutableArray * answerArray = [[NSMutableArray alloc]init];
    
    //Open the DB
    if(sqlite3_open([self.databasePath UTF8String], &dnvAuditDB)==SQLITE_OK){
        
        //Creating the SQL statment to retrieve the data from the database
        NSString * queryAnswerSQL = [NSString stringWithFormat:@"SELECT * FROM ANSWER WHERE QUESTIONID= %d", questionID];
        
        //Prepare the Query
        if(sqlite3_prepare_v2(dnvAuditDB, [queryAnswerSQL UTF8String], -1, &statement, NULL)==SQLITE_OK){
            
            //If this work, there must be a row if the data was there
            while (sqlite3_step(statement) == SQLITE_ROW){
                
                //Temperary answer to hold the answer information from DB
                Answers * tempAnswer = [Answers new];
                
                //Gets the answer text data from DB and adding it to the temp Answer Object
                NSString * text = [[NSString alloc] initWithUTF8String:(const char*)sqlite3_column_text(statement, 2)];
                
                //Gets the pointsPossible data from DB and adding it to the temp Answer Object
                NSString * ptsPoss = [[NSString alloc] initWithUTF8String:(const char*)sqlite3_column_text(statement, 3)];
                
                //Gets the pointsPossible data from DB and adding it to the temp Answer Object
                NSString * selected = [[NSString alloc] initWithUTF8String:(const char*)sqlite3_column_text(statement, 4)];
                
            
                tempAnswer.answerText = text;
                tempAnswer.pointsPossible = [ptsPoss floatValue];
                tempAnswer.isSelected = [selected boolValue];
                
                [answerArray addObject:tempAnswer];
                
            }
        }
    }
    
    return answerArray;
    
}

-(void)updateAudit:(NSString *)auditID auditType:(int)auditType{
    
    //Opening the SQLite DB
    if(sqlite3_open([self.databasePath UTF8String], &dnvAuditDB)==SQLITE_OK){
        
        NSString * updateAuditSQL = [NSString stringWithFormat:@"UPDATE AUDIT SET AUDITTYPE = %d WHERE ID = \"%@\"", auditType, auditID];
    
        sqlite3_stmt * statement;
    
        //Prepare the Query
        sqlite3_prepare_v2(dnvAuditDB, [updateAuditSQL UTF8String], -1, &statement, NULL);
    
        if(sqlite3_step(statement)==SQLITE_DONE)
        {
            NSLog(@"Row updated from Audit table.");
        }
        else {
            NSLog(@"Failed to update row from Audit table.");
        }
    
        sqlite3_finalize(statement);
        sqlite3_close(dnvAuditDB);
    }
    else{
        
        NSLog(@"Failed to open/create DB.");
    }
}


-(void)updateElement:(int)elementID forElement:(Elements *)element{
    
    //Opening the SQLite DB
    if(sqlite3_open([self.databasePath UTF8String], &dnvAuditDB)==SQLITE_OK){
    
        NSString * updateElementSQL = [NSString stringWithFormat:@"UPDATE ELEMENT SET ISCOMPLETED = %d, POINTSPOSSIBLE = %f, POINTSAWARDED = %f, MODIFIEDNAPOINTS = %f, WHERE ID = %d", element.isCompleted, element.pointsPossible, element.pointsAwarded, element.modefiedNAPoints, elementID];
    
        sqlite3_stmt * statement;
    
        //Prepare the Query
        sqlite3_prepare_v2(dnvAuditDB, [updateElementSQL UTF8String], -1, &statement, NULL);
    
        if(sqlite3_step(statement)==SQLITE_DONE)
        {
            NSLog(@"Row updated from Element table.");
        }
        else {
            NSLog(@"Failed to update row from Element table.");
        }
    
        sqlite3_finalize(statement);
        sqlite3_close(dnvAuditDB);
    }
    else{
        
        NSLog(@"Failed to open/create DB.");
    }
}


-(void)updateSubElment:(int)subElementID forSubElement:(SubElements *) subElement{
    
    //Opening the SQLite DB
    if(sqlite3_open([self.databasePath UTF8String], &dnvAuditDB)==SQLITE_OK){
    
        NSString * updateSubElementSQL = [NSString stringWithFormat:@"UPDATE SUBELEMENT SET ISCOMPLETED = %d, POINTSPOSSIBLE = %f, POINTSAWARDED = %f, MODIFIEDNAPOINTS = %f WHERE ID = %d", subElement.isCompleted, subElement.pointsPossible, subElement.pointsAwarded, subElement.modefiedNAPoints, subElementID];
    
        sqlite3_stmt * statement;
    
        //Prepare the Query
        sqlite3_prepare_v2(dnvAuditDB, [updateSubElementSQL UTF8String], -1, &statement, NULL);
    
        if(sqlite3_step(statement)==SQLITE_DONE)
        {
            NSLog(@"Row updated from Sub Element table.");
        }
        else {
            NSLog(@"Failed to update row from Sub Element table.");
        }
    
        sqlite3_finalize(statement);
        sqlite3_close(dnvAuditDB);
    }
    else{
    
        NSLog(@"Failed to open/create DB.");
    }
}


-(void)updateQuestion:(int)questionID forQuestion:(Questions *)question {
    
    //Opening the SQLite DB
    if(sqlite3_open([self.databasePath UTF8String], &dnvAuditDB)==SQLITE_OK){
    
        NSString * updateQuestionSQL = [NSString stringWithFormat:@"UPDATE QUESTION SET ISCOMPLETED = %d, POINTSAWARDED = %f, NOTES = \"%@\", ISTHUMBSUP = %d, ISTHUMBSDOWN = %d, ISAPPLICABLE = %d, NEEDSVERIFYING = %d, ISVERIFYDONE = %d, WHERE ID = %d", question.isCompleted, question.pointsAwarded, question.notes, question.isThumbsUp, question.isThumbsDown, question.isApplicable, question.needsVerifying, question.isVerifyDone, questionID];
    
        sqlite3_stmt * statement;
    
        //Prepare the Query
        sqlite3_prepare_v2(dnvAuditDB, [updateQuestionSQL UTF8String], -1, &statement, NULL);
    
        if(sqlite3_step(statement)==SQLITE_DONE)
        {
            NSLog(@"Row updated from Question table.");
            NSArray * answerIDs = [self getIDSFrom:@"ANSWER" where:@"QUESTIONID" equals:questionID];
            
            for (int index = 0; index < question.Answers.count; index++)
                [self updateAnswer:[answerIDs[index] integerValue] forAnswer:question.Answers[index]];
        }
        else {
            NSLog(@"Failed to update row from Question table.");
        }
    
        sqlite3_finalize(statement);
        sqlite3_close(dnvAuditDB);
    }
    else{
        
        NSLog(@"Failed to open/create DB.");
    }
}


-(void)updateAnswer:(int)answerID forAnswer:(Answers *)answer{
    
    NSString * updateAnswerSQL = [NSString stringWithFormat:@"UPDATE ANSWER SET ANSWERTEXT = \"%@\", ISSELECTED = %d, WHERE ID = %d", answer.answerText, answer.isSelected, answerID];
    
    sqlite3_stmt * statement;
    
    //Prepare the Query
    sqlite3_prepare_v2(dnvAuditDB, [updateAnswerSQL UTF8String], -1, &statement, NULL);
    
    if(sqlite3_step(statement)==SQLITE_DONE)
    {
        NSLog(@"Row updated from Answer table.");
    }
    else {
        NSLog(@"Failed to update row from Answer table.");
    }
    
    sqlite3_finalize(statement);
    
}


-(void)deleteAudit:(NSString *)auditID{
    
    //Opening the SQLite DB
    if(sqlite3_open([self.databasePath UTF8String], &dnvAuditDB)==SQLITE_OK){
        
        //Object to save errors
        sqlite3_stmt * statement;
        
        NSString * deleteSQL = [NSString stringWithFormat:@"DELETE FROM AUDIT WHERE ID = \"%@\"", auditID];
        
        //Prepare the Query
        sqlite3_prepare_v2(dnvAuditDB, [deleteSQL UTF8String], -1, &statement, NULL);
        
        if(sqlite3_step(statement)==SQLITE_DONE)
        {
            NSLog(@"Row deleted from Audit table.");
            [self deleteClient:auditID];
            [self deleteReport:auditID];
            [self deleleElements:auditID];
        }
        else {
            
            NSLog(@"Failed to delete row from Audit table.");
        }
        
        sqlite3_finalize(statement);
        sqlite3_close(dnvAuditDB);
    }
    else{
        
        NSLog(@"Failed to open/create DB.");
    }
}

-(void)deleteClient:(NSString *)auditID{
    
    NSString * deleteSQL = [NSString stringWithFormat:@"DELETE FROM CLIENT WHERE AUDITID = \"%@\"", auditID];
    
    sqlite3_stmt * statement;
    
    //Prepare the Query
    sqlite3_prepare_v2(dnvAuditDB, [deleteSQL UTF8String], -1, &statement, NULL);
    
    if(sqlite3_step(statement)==SQLITE_DONE)
    {
        NSLog(@"Row deleted from Client table.");
    }
    else {
        NSLog(@"Failed to delete row from Client table.");
    }
    
    sqlite3_finalize(statement);
    
}

-(void)deleteReport:(NSString *)auditID{
    
    NSString * deleteSQL = [NSString stringWithFormat:@"DELETE FROM REPORT WHERE AUDITID = \"%@\"", auditID];
    
    sqlite3_stmt * statement;
    
    //Prepare the Query
    sqlite3_prepare_v2(dnvAuditDB, [deleteSQL UTF8String], -1, &statement, NULL);
    
    if(sqlite3_step(statement)==SQLITE_DONE)
    {
        NSLog(@"Row deleted from Report table.");
    }
    else {
        NSLog(@"Failed to delete row from Report table.");
    }
    
    sqlite3_finalize(statement);
}

-(void)deleleElements:(NSString *)auditID{
    
    NSArray * elementIDS = [self getElementIDS:auditID];
        
    NSString * deleteSQL = [NSString stringWithFormat:@"DELETE FROM ELEMENT WHERE AUDITID = \"%@\"", auditID];
    
    sqlite3_stmt * statement;

    //Prepare the Query
    sqlite3_prepare_v2(dnvAuditDB, [deleteSQL UTF8String], -1, &statement, NULL);
    
    if(sqlite3_step(statement)==SQLITE_DONE)
    {
        NSLog(@"Row deleted from Element table.");
        
        for (NSNumber * ID in elementIDS)
            [self deleteSubElements:[ID integerValue]];
        
    }
    else {
        NSLog(@"Failed to delete row from Element table.");
    }
    
    sqlite3_finalize(statement);
    
}

-(void)deleteSubElements:(int)elementID{
    
    NSArray * subElementIDS = [self getIDSFrom:@"SUBELEMENT" where:@"ELEMENTID" equals:elementID];
    
    NSString * deleteSQL = [NSString stringWithFormat:@"DELETE FROM SUBELEMENT WHERE ELEMENTID = %d", elementID];
    
    sqlite3_stmt * statement;
    
    //Prepare the Query
    sqlite3_prepare_v2(dnvAuditDB, [deleteSQL UTF8String], -1, &statement, NULL);
    
    if(sqlite3_step(statement)==SQLITE_DONE)
    {
        NSLog(@"Row deleted from Sub Element table.");
        
        for (NSNumber * ID in subElementIDS)
            [self deleteQuestions:[ID integerValue]];
        
    }
    else {
        NSLog(@"Failed to delete row from Sub Element table.");
    }
    
    sqlite3_finalize(statement);
    
}

-(void)deleteQuestions:(int)subElementID{
    
    NSArray * questionIDS = [self getIDSFrom:@"QUESTION" where:@"SUBELEMENTID" equals:subElementID];
    
    NSString * deleteSQL = [NSString stringWithFormat:@"DELETE FROM QUESTION WHERE SUBELEMENTID = %d", subElementID];
    
    sqlite3_stmt * statement;
    
    //Prepare the Query
    sqlite3_prepare_v2(dnvAuditDB, [deleteSQL UTF8String], -1, &statement, NULL);
    
    if(sqlite3_step(statement)==SQLITE_DONE)
    {
        NSLog(@"Row deleted from Question table.");
        
        for (NSNumber * ID in questionIDS)
            [self deleteAnswers:[ID integerValue]];
        
    }
    else {
        NSLog(@"Failed to delete row from Question table.");
    }
    
    sqlite3_finalize(statement);
    
}

-(void)deleteAnswers:(int)questionID{
    
    NSString * deleteSQL = [NSString stringWithFormat:@"DELETE FROM ANSWER WHERE QUESTIONID = %d", questionID];
    
    sqlite3_stmt * statement;
    
    //Prepare the Query
    sqlite3_prepare_v2(dnvAuditDB, [deleteSQL UTF8String], -1, &statement, NULL);
    
    if(sqlite3_step(statement)==SQLITE_DONE)
    {
        NSLog(@"Row deleted from Answer table.");
        
    }
    else {
        NSLog(@"Failed to delete row from Answer table.");
    }
    
    sqlite3_finalize(statement);
    
}

#pragma mark User methods

//create user table
-(void)createUserTable{
    
    //Opening the SQLite DB
    if(sqlite3_open([self.databasePath UTF8String], &dnvAuditDB)==SQLITE_OK){
        
        //Object to save errors
        char * errMsg;
        
        const char * sql_stmt = "CREATE TABLE IF NOT EXISTS USER (ID TEXT PRIMARY KEY, PASSWORD TEXT, FULLNAME TEXT, RANK INTEGER, OTHERINFO TEXT)";
        
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
        
        NSString * insertUserSQL = [NSString stringWithFormat:@"INSERT INTO USER (ID, PASSWORD, FULLNAME, RANK, OTHERINFO) VALUES (\"%@\", \"%@\", \"%@\", %d, \"%@\")", [user objectForKey:@"userID"], [user objectForKey:@"password"], [user objectForKey:@"fullName"], [[user objectForKey:@"rank"] integerValue], [user objectForKey:@"otherInfo"]];
        
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
    
    //Temperary user to hold the user information from DB
    User * tempUser = [User new];
    
    //Open the DB
    if(sqlite3_open([self.databasePath UTF8String], &dnvAuditDB)==SQLITE_OK){
        
        //Creating the SQL statment to retrieve the data from the database
        NSString * queryUserSQL = [NSString stringWithFormat:@"SELECT PASSWORD, FULLNAME, RANK, OTHERINFO FROM USER WHERE ID=\"%@\"", userID];
        
        //Prepare the Query
        if(sqlite3_prepare_v2(dnvAuditDB, [queryUserSQL UTF8String], -1, &statement, NULL)==SQLITE_OK){
            
            //If this work, there must be a row if the data was there
            while (sqlite3_step(statement) == SQLITE_ROW){
                
                //Gets the password data from DB and adding it to the temp User Object
                NSString * password = [[NSString alloc] initWithUTF8String:(const char*)sqlite3_column_text(statement, 0)];
                
                //Gets the password data from DB and adding it to the temp User Object
                NSString * name = [[NSString alloc] initWithUTF8String:(const char*)sqlite3_column_text(statement, 1)];
                
                //Gets the password data from DB and adding it to the temp User Object
                NSString * rank = [[NSString alloc] initWithUTF8String:(const char*)sqlite3_column_text(statement, 2)];
                
                //Gets the other info data from DB and adding it to the temp User Object
                NSString * otherInfo = [[NSString alloc] initWithUTF8String:(const char*)sqlite3_column_text(statement, 3)];
                
                tempUser.userID = userID;
                tempUser.password = password;
                tempUser.fullname = name;
                tempUser.rank = [rank integerValue];
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
        NSString * queryUserSQL = [NSString stringWithFormat:@"SELECT ID, PASSWORD, FULLNAME, RANK, OTHERINFO FROM USER"];
        
        //Prepare the Query
        if(sqlite3_prepare_v2(dnvAuditDB, [queryUserSQL UTF8String], -1, &statement, NULL)==SQLITE_OK){
            
            //If this work, there must be a row if the data was there
            while (sqlite3_step(statement) == SQLITE_ROW){
                
                User * tempUser = [User new];
                
                //Gets the first name data from DB and adding it to the temp Person Object
                NSString * identify = [[NSString alloc] initWithUTF8String:(const char*)sqlite3_column_text(statement, 0)];
                
                //Gets the middle name data from DB and adding it to the temp Person Object
                NSString * password = [[NSString alloc] initWithUTF8String:(const char*)sqlite3_column_text(statement, 1)];
                
                //Gets the password data from DB and adding it to the temp User Object
                NSString * name = [[NSString alloc] initWithUTF8String:(const char*)sqlite3_column_text(statement, 2)];
                
                //Gets the password data from DB and adding it to the temp User Object
                NSString * rank = [[NSString alloc] initWithUTF8String:(const char*)sqlite3_column_text(statement, 3)];
                
                //Gets the last name data from DB and adding it to the temp Person Object
                NSString * otherInfo = [[NSString alloc] initWithUTF8String:(const char*)sqlite3_column_text(statement, 4)];
                
                tempUser.userID = identify;
                tempUser.password = password;
                tempUser.fullname = name;
                tempUser.rank = [rank integerValue];
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
            
            //Gets the id data from DB
            NSString * identify = [[NSString alloc] initWithUTF8String:(const char*)sqlite3_column_text(statement, 0)];
            
            ID = [identify integerValue];
        }
    }
    
    sqlite3_finalize(statement);
    
    return ID;
}

-(NSArray *)getElementIDS:(NSString *) fKeyValue{
    
    NSMutableArray * tableIDS = [NSMutableArray new];
    
    sqlite3_stmt * statement;
    
    NSString * getIdsArraySQL = [NSString stringWithFormat:@"SELECT ID FROM ELEMENT WHERE AUDITID = \"%@\"", fKeyValue];
    
    //Prepare the Query
    if(sqlite3_prepare_v2(dnvAuditDB, [getIdsArraySQL UTF8String], -1, &statement, NULL)==SQLITE_OK){
        
        //If this work, there must be a row if the data was there
        while (sqlite3_step(statement) == SQLITE_ROW){
            
            //Gets the id data from DB
            NSString * identify = [[NSString alloc] initWithUTF8String:(const char*)sqlite3_column_text(statement, 0)];
            NSNumber * ID = [NSNumber numberWithInt:[identify integerValue]];
            
            [tableIDS addObject:ID];
        }
    }
    
    sqlite3_finalize(statement);
    
    return tableIDS;
}

-(NSArray *)getIDSFrom:(NSString *) table where:(NSString *) fKeyName equals:(int) fKeyValue{
    
    NSMutableArray * tableIDS = [NSMutableArray new];
    
    sqlite3_stmt * statement;
    
    NSString * getIdsArraySQL = [NSString stringWithFormat:@"SELECT ID FROM \"%@\" WHERE \"%@\" = %d", table, fKeyName, fKeyValue];
    
    //Prepare the Query
    if(sqlite3_prepare_v2(dnvAuditDB, [getIdsArraySQL UTF8String], -1, &statement, NULL)==SQLITE_OK){
        
        //If this work, there must be a row if the data was there
        while (sqlite3_step(statement) == SQLITE_ROW){
            
            //Gets the id data from DB
            NSString * identify = [[NSString alloc] initWithUTF8String:(const char*)sqlite3_column_text(statement, 0)];
            NSNumber * ID = [NSNumber numberWithInt:[identify integerValue]];
            
            [tableIDS addObject:ID];
        }
    }
    
    sqlite3_finalize(statement);
    
    return tableIDS;
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
