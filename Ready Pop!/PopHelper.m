//
//  PopHelper.m
//  Ready Pop!
//
//  Created by Nathan Pabrai on 2/10/12.
//  Copyright (c) 2012 __Pabrai_Enterprises__. All rights reserved.
//

#import "PopHelper.h"
#define POPINTERVAL 2.0  //seconds desired for ready popcorn 

@implementation PopHelper
@synthesize recorder,levelTimer,threshold,status,time2,counter,silenceMean,silenceCount,progress,timeInterval;

-(void)setUpRecorder
{
    NSURL *url=[NSURL fileURLWithPath:@"/dev/null"];
    
    NSDictionary *settings=[NSDictionary dictionaryWithObjectsAndKeys:
                            [NSNumber numberWithFloat:4000],//4000 samples/second
                            AVSampleRateKey,
                            [NSNumber numberWithInt:
                             kAudioFormatAppleLossless],
                            AVFormatIDKey,
                            [NSNumber numberWithInt: 1],
                            AVNumberOfChannelsKey,
                            [NSNumber numberWithInt:AVAudioQualityMax],//max aud quality
                            AVEncoderAudioQualityKey,
                            nil];//settings dictionary
    NSError *error;
    recorder=[[AVAudioRecorder alloc] initWithURL:url settings:settings error:&error
              ];//allocates and initializes recorder with previously stated setting
    


}


-(void)startSampling////called to start sampling. starts recorder and starts levelTimer.
{
    if(recorder)
    {
        [recorder prepareToRecord];
        recorder.meteringEnabled=YES;//enables metered recording
        [recorder record];//starts metered recording
    }
  //  popTimes=[[NSMutableArray alloc] initWithCapacity:40];//allocates and initializes 40 length array to hold poptimes.
    time2=[NSDate date];//sets time2 to time when pops are first starting to be checked
    counter=0;
    progress=.07;
levelTimer=[NSTimer scheduledTimerWithTimeInterval: timeInterval target:self selector:@selector(levelTimerCallback:) userInfo:nil repeats:YES];
}






-(void)levelTimerCallback:(NSTimer *)timer// updates meters of recorder. applys lowpass. checks if pop thresh passed>If true (poptime) added to popTimes array. Then checks array if popinterval rises to correct value then INVALIDATES TIMER AND SETS 'STATUS' TO TRUE. THIS IS THE GOAL! Perfection achieved hopefully.{
{
    [recorder updateMeters];//updates recorders meters
    
    double peakPowerForChannel=[recorder peakPowerForChannel:0];//stores peak power in memory
    
    
    
    //LOG AUDIO DATA
    
    
    
    if (status==2)//stops recorder and levelTimer if popcorn is done
    {
        [timer invalidate];// kills timer if status 2
        [recorder stop];
    }
if (counter<15)
{
    powerHistory[counter]=peakPowerForChannel+45;

    
}
 if (counter==14)
 {
     silenceMean=(1/15)*(powerHistory[0]+powerHistory[1]+powerHistory[2]+powerHistory[3]+powerHistory[4]+powerHistory[5]+powerHistory[6]+powerHistory[7]+powerHistory[8]+powerHistory[9]+powerHistory[10]+powerHistory[11]+powerHistory[12]+powerHistory[13]+powerHistory[14])+13;
     progress=.15;
 }//calculates silence mean +13. this is regarded as pop silence.
if(counter>=130+20 && (counter <145+20))
   {
       powerHistory[counter-(130+20)]=peakPowerForChannel+45;//sets up first values for the powerhistory
   }
if (counter>=145+20)
{
//remove last power and shift values down
    for (int i=0; i<14; i++)
    {
        powerHistory[i]=powerHistory[i+1];
    }
    
    
//add current to memory to top of stack
    powerHistory[14]=peakPowerForChannel+45;
    
    
//count how many were >= silence mean
    silenceCount=0;
    for (int j=0; j<15; j++)
    {
        if (powerHistory[j]-silenceMean<14) silenceCount++;
    }
}
    
    counter++;
    if (counter> (130+20)) progress=(silenceCount/13.0);

    NSLog(@"Pow:%f Pow-SilMean:%f silCount:%d", peakPowerForChannel+45,(peakPowerForChannel+45-silenceMean),silenceCount);

if ((silenceCount>=12) ||(counter>(1500/4)))
{
    
    progress=1;
    status=2;
}
}




    @end
