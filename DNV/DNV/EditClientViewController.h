//
//  EditClientViewController.h
//  DNV
//
//  Created by USI on 1/29/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DNVDatabaseManagerClass.h"

#import "Client.h"
#import "Report.h"

@interface EditClientViewController : UIViewController<UIAlertViewDelegate, UITextFieldDelegate>

@property (strong, nonatomic) DNVDatabaseManagerClass * dnvDBManager;
@property (nonatomic) Client * client;
@property (nonatomic) Report * report;
@property (strong, nonatomic) NSString * auditID;

@property (strong, nonatomic) IBOutlet UITextField *clientRefTxt;

//Client Info textfields
@property (strong, nonatomic) IBOutlet UITextField *companyNameTxt;
@property (strong, nonatomic) IBOutlet UITextField *divisionTxt;
@property (strong, nonatomic) IBOutlet UITextField *SICnumberTxt;
@property (strong, nonatomic) IBOutlet UITextField *numOfEmpTxt;

//Client Address textfields
@property (strong, nonatomic) IBOutlet UITextField *addressTxt;
@property (strong, nonatomic) IBOutlet UITextField *cityStateProvTxt;
@property (strong, nonatomic) IBOutlet UITextField *postalCodeTxt;

//Audit Info textfields
@property (strong, nonatomic) IBOutlet UITextField *auditorTxt;
@property (strong, nonatomic) IBOutlet UITextField *auditSiteTxt;
@property (strong, nonatomic) IBOutlet UITextField *auditDateTxt;
@property (strong, nonatomic) IBOutlet UIButton *baselineAuditBtn;

//Buttons
- (IBAction)baselineAuditPushed:(UIButton *)sender;
- (IBAction)saveClientInfoBtn:(UIButton *)sender;

@end
