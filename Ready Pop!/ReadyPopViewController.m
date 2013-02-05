//
//  ReadyPopViewController.m
//  Ready Pop!
//
//  Created by Nathan Pabrai on 2/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ReadyPopViewController.h"
#define TIMERINTERVAL .4//SECONDS
#define THRESHOLD .3//THRESHOLD
@implementation ReadyPopViewController
{bool buttonPressed;
}
@synthesize progress;
@synthesize label;
@synthesize popHelp,checkTimer,startButton,activityIndicator;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    


	// Do any additional setup after loading the view, typically from a nib.
    buttonPressed=false;
    popHelp=[[PopHelper alloc]init];//initializing pophelp with values
    
    [popHelp setUpRecorder];
    [popHelp setTimeInterval:TIMERINTERVAL];
    [popHelp setThreshold:THRESHOLD];
    [popHelp setStatus:0];
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                         pathForResource:@"alarm"
                                         ofType:@"mp3"]];
    
    NSError *error;
    audioPlayer = [[AVAudioPlayer alloc]
                   initWithContentsOfURL:url
                   error:&error];
    if (error)
    {
        NSLog(@"Error in audioPlayer: %@", 
              [error localizedDescription]);
    } else {
        audioPlayer.delegate = self;
        [audioPlayer prepareToPlay];
    }

    
}

- (void)viewDidUnload
{
    [self setLabel:nil];
    [self setProgress:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated

{
    
	[super viewDidDisappear:animated];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (IBAction)buttonAction:(id)sender {
    if (buttonPressed==false){
        buttonPressed=true;
        startButton.hidden=true;
        activityIndicator.hidden = false;
        [activityIndicator startAnimating];
        
    [popHelp startSampling];//tells pophelper to start sampling
    checkTimer=[NSTimer scheduledTimerWithTimeInterval:TIMERINTERVAL target:self selector:@selector (checkTimerCallback:) userInfo:nil repeats:YES];//timer to check if popcorn done
    }
}



-(void) checkTimerCallback:(NSTimer*)timer
    
{
    progress.progress=popHelp.progress;
    if (popHelp.status==2)
    {
        [activityIndicator stopAnimating];
        label.text= @"Popcorn Done!";
        audioPlayer.volume=1;
        [audioPlayer play];
    }else label.text=@"Popping in Progress";
    
}
@end
