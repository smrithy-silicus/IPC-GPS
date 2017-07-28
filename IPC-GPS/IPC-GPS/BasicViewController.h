//
//  ViewController.h
//  IPC-GPS
//
//  Created by smrithy r varma on 28/07/17.
//  Copyright © 2017 Silicus Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface BasicViewController : UIViewController<MFMailComposeViewControllerDelegate>
@property (strong, nonatomic) IBOutlet UILabel *speedLbl;

@end

