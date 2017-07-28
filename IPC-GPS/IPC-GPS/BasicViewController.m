//
//  ViewController.m
//  IPC-GPS
//
//  Created by smrithy r varma on 28/07/17.
//  Copyright © 2017 Silicus Technologies. All rights reserved.
//

#import "BasicViewController.h"
#import "EventTrackerLog.h"
#import "AppDelegate.h"
#import "LocationTracker.h"

@interface BasicViewController ()<LocationTrackerDelegate>
{
    LocationTracker *tracLoc;
    AppDelegate *appDelegate;
}

@property(nonatomic)MFMailComposeViewController *mailComposer;
@property(nonatomic,strong) NSString *logFilePath;
@property(nonatomic,strong) NSData *logFileData;


@end

@implementation BasicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    tracLoc = [[LocationTracker alloc]init];
    tracLoc.delegate = self;
    
    
    self.mailComposer = [[MFMailComposeViewController alloc]init];
    [_mailComposer setMailComposeDelegate:self];
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
  //  _logFilePath = appDelegate.fileLogger.currentLogFileInfo.filePath;

}

- (IBAction)sendMailBtnActn:(id)sender {
    
    NSString *emailTitle = @"Device Log";
    NSString *messageBody = @"Device log details";
    NSArray *toRecipents = [NSArray arrayWithObjects:@"smrithy.varma@silicus.com", nil];
    NSData *noteData = [NSData dataWithContentsOfFile:_logFilePath];
    
    [_mailComposer setSubject:emailTitle];
    [_mailComposer setMessageBody:messageBody isHTML:false];
    [_mailComposer setToRecipients:toRecipents];
    [_mailComposer addAttachmentData:noteData mimeType:@"text/plain" fileName:@"filename.log"];
    
    [self presentViewController:_mailComposer animated:true completion:nil];
    
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(nullable NSError *)error
{
    switch(result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail Cancelled");
        case MFMailComposeResultSaved:
            NSLog(@"Mail Saved");
        case MFMailComposeResultSent:
            NSLog(@"mail sent");
        case MFMailComposeResultFailed:
            NSLog(@"failed withn error %@",[error localizedDescription]);
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark tracker delegate method

-(void)retrievSpeedValue:(double )speed
{
    NSLog(@"Here speed now received is %.f",speed);
    _speedLbl.text = [NSString stringWithFormat:@"%.f",speed];
    if(speed>=0){
        [appDelegate callNotification];
    }
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
