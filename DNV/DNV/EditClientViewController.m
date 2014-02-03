//
//  EditClientViewController.m
//  DNV
//
//  Created by USI on 1/29/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import "EditClientViewController.h"

@interface EditClientViewController ()

@end

@implementation EditClientViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    
    [self.baselineAuditBtn setImage:[UIImage imageNamed:@"checkbox_checked_gray_border.png"] forState:UIControlStateSelected];
    [self.baselineAuditBtn setImage:[UIImage imageNamed:@"empty_checkbox_gray_border.png"] forState:UIControlStateNormal];
    
    self.dnvDBManager = [DNVDatabaseManagerClass getSharedInstance];
    
    [self setTextfieldDelegates];
    
    if ([self.report.clientRef isEqualToString:@"(null)"] || [self.report.clientRef isEqualToString:@""]) {
        self.clientRefTxt.enabled = true;
    }
    else{
    
        self.clientRefTxt.enabled = false;
        self.clientRefTxt.text = self.report.clientRef;
    }
    
    self.companyNameTxt.text = self.client.companyName;
    self.divisionTxt.text = self.client.division;
    self.SICnumberTxt.text = self.client.SICNumber;
    self.numOfEmpTxt.text = [NSString stringWithFormat:@"%d", self.client.numEmployees];
    self.addressTxt.text = self.client.address;
    self.cityStateProvTxt.text = self.client.cityStateProvince;
    self.postalCodeTxt.text = self.client.postalCode;
    
    if ([self.client.auditor isEqualToString:@""] || [self.client.auditor isEqualToString:@"(null)"]){
        self.client.auditor = [defaults objectForKey:@"currentUserName"];
    }
    
    self.auditorTxt.text = self.client.auditor;
    self.auditSiteTxt.text = self.client.auditedSite;
    self.auditDateTxt.text = self.client.auditDate;
    
    [self.baselineAuditBtn setSelected:self.client.baselineAudit];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)baselineAuditPushed:(UIButton *)sender {
    self.client.baselineAudit = !self.client.baselineAudit;
    [self.baselineAuditBtn setSelected: !self.baselineAuditBtn.selected];
}

- (IBAction)saveClientInfoBtn:(UIButton *)sender {
    UIAlertView * clientAlert = [[UIAlertView alloc] initWithTitle: @"Save Client Information" message: @"Are you sure you want to save all changes to the Client information?" delegate: self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes",nil];
    
    [clientAlert show];
}

#pragma mark Alertview methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex == 0)
    {
        UIAlertView * cancelNotice = [[UIAlertView alloc] initWithTitle:@"Cancel Client Updated" message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [cancelNotice show];
    }
    if (buttonIndex == 1)
    {
        if (![self.report.clientRef isEqualToString:self.clientRefTxt.text]) {
            self.report.clientRef = self.clientRefTxt.text;
            
            [self.dnvDBManager updateReport:self.report];
        }
        
        self.client.companyName = self.companyNameTxt.text;
        self.client.division = self.divisionTxt.text;
        self.client.SICNumber = self.SICnumberTxt.text;
        self.client.numEmployees = [self.numOfEmpTxt.text integerValue];
        self.client.address = self.addressTxt.text;
        self.client.cityStateProvince = self.cityStateProvTxt.text;
        self.client.postalCode = self.postalCodeTxt.text;
        self.client.auditor = self.auditorTxt.text;
        self.client.auditedSite = self.auditSiteTxt.text;
        self.client.auditDate = self.auditDateTxt.text;
        self.client.baselineAudit = self.baselineAuditBtn.selected;
        
        [self.dnvDBManager updateClient:self.client];
        
        UIAlertView * clientUpdateNotice = [[UIAlertView alloc] initWithTitle:@"Client Updated" message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [clientUpdateNotice show];
        
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    return [textField resignFirstResponder];
}

-(void)setTextfieldDelegates{
    
    self.clientRefTxt.delegate = self;
    self.companyNameTxt.delegate = self;
    self.divisionTxt.delegate = self;
    self.SICnumberTxt.delegate = self;
    self.numOfEmpTxt.delegate = self;
    self.addressTxt.delegate = self;
    self.cityStateProvTxt.delegate = self;
    self.postalCodeTxt.delegate = self;
    self.auditorTxt.delegate = self;
    self.auditSiteTxt.delegate = self;
    self.auditDateTxt.delegate = self;

}

@end
