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
            
            const char * sql_stmt4 = "CREATE TABLE IF NOT EXISTS QUESTION (ID INTEGER PRIMARY KEY AUTOINCREMENT, SUBELEMENTID INTEGER, QUESTIONTEXT TEXT, QUESTIONTYPE INTEGER, ISCOMPLETE INTEGER, POINTSPOSSIBLE REAL, POINTSAWARDED REAL, HELPTEXT TEXT, NOTES TEXT, ISTHUMBSUP INTEGER, ISTHUMBSDOWN INTEGER, NEEDSVERIFYING INTEGER, ISVERIFYDONE INTEGER, PARENTQUESTIONID INTEGER, POINTSNEEDEFORLAYER REAL)";
            
            const char * sql_stmt5 = "CREATE TABLE IF NOT EXISTS ANSWER (ID INTEGER PRIMARY KEY AUTOINCREMENT, QUESTIONID INTEGER, ANSWERTEXT TEXT, POINTSPOSSIBLE REAL, POINTSAWARDED REAL, ISSELECTED INTEGER)";
            
            const char * sql_stmt6 = "CREATE TABLE IF NOT EXISTS ATTACHMENT (ID INTEGER PRIMARY KEY AUTOINCREMENT, QUESTIONID INTEGER, ATTACHMENTNAME TEXT)";
            
            const char * sql_stmt7 = "CREATE TABLE IF NOT EXISTS CLIENT (ID INTEGER PRIMARY KEY AUTOINCREMENT, AUDITID INTEGER, USERID INTEGER, CLIENTNAME TEXT, DIVISION TEXT, SIC TEXT, NUMBEREMPLOYEES INTEGER, AUDITSITE TEXT, AUDITDATE TEXT, BASELINEAUDIT INTEGER, STREETADDRESS TEXT, CITYSTATEPROVINCE TEXT, COUNTRY TEXT)";
            
            const char * sql_stmt8 = "CREATE TABLE IF NOT EXISTS REPORT (ID INTEGER PRIMARY KEY AUTOINCREMENT, AUDITID INTEGER, CLIENTID INTEGER, USERID INTEGER, SUMMARY TEXT, APPROVEDBY TEXT, PROJECTNUMBER TEXT, DIAGRAMFILENAME TEXT)";
            
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
    
    NSArray * elements = audit.Elements;
    
    sqlite3_stmt * statement;
    
    //Open the DB
    if(sqlite3_open([self.databasePath UTF8String] , &dnvAuditDB)==SQLITE_OK){
        
        NSString * insertAuditSQL = [NSString stringWithFormat:@"INSERT INTO AUDIT (AUDITNAME, AUDITTYPE, LASTMODIFIED) VALUES ('%@', %d, '%@')", audit.name, 1, audit.lastModefied];
        
        //Preparing
        sqlite3_prepare_v2(dnvAuditDB, [insertAuditSQL UTF8String], -1, &statement, NULL);
        
        if(sqlite3_step(statement)==SQLITE_DONE){
            NSLog(@"Audit added to DB.");
        }
        else{
            NSLog(@"Failed to add audit.");
        }
        sqlite3_finalize(statement);
        sqlite3_close(dnvAuditDB);
    }
    
    
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
                
                NSLog(@"User ID: %@, Password: %@", identify, password);
                
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
