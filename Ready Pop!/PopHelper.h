//
//  PopHelper.h
//  Ready Pop!
//
//  Created by Nathan Pabrai on 2/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>

@interface PopHelper : NSObject
{
    double powerHistory[15];//power records
}
@property (strong) AVAudioRecorder *recorder;//recorder to record the pops
@property (copy) NSTimer *levelTimer;//timer to check audio levels to recieve pops
@property double  threshold;// time interval in sec. to repeat timer, thereshold to consider a pop, holder for lowpass filtered audio results
@property (copy) NSDate *time2;
@property double silenceMean,progress,timeInterval;
@property int status;// bool to hold done counts
@property int counter, silenceCount;


-(void)setUpRecorder;//called to set up recorder. Makes settings, then initializes recorder.

-(void)startSampling;//called to start sampling. starts recorder and starts levelTimer.

-(void)levelTimerCallback:(NSTimer*)timer;// updates meters of recorder. applys lowpass. checks if pop thresh passed>If true (poptime) added to popTimes array. Then checks array if popinterval rises to correct value then INVALIDATES TIMER AND SETS 'STATUS' TO TRUE. THIS IS THE GOAL! Perfection achieved hopefully.


//-(void)addPopTime;//uses lowpassresults to store it in array.

//-(void)analyzePopTimes;//checks if popinterval is great enough. if true sets status to true. if false and there are less than 20 objects in array does nothing. if false and > 20 objects in array removes oldest object. 

@end
