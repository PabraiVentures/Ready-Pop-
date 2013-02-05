//
//  ReadyPopViewController.h
//  Ready Pop!
//
//  Created by Nathan Pabrai on 2/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PopHelper.h"
#import <AVFoundation/AVFoundation.h>

@interface ReadyPopViewController : UIViewController
<AVAudioPlayerDelegate>
{
    AVAudioPlayer *audioPlayer;
}
@property (copy) PopHelper *popHelp;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (copy) NSTimer *checkTimer;//timer to check if popHelp.status is true
@property (weak, nonatomic) IBOutlet UIProgressView *progress;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

- (IBAction)buttonAction:(id)sender;// triggers [helper startSample]

-(void)checkTimerCallback:(NSTimer*)timer;

@end
