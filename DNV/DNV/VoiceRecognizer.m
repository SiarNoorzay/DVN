//
//  VoiceRecognizer.m
//  DNV
//
//  Created by USI on 1/14/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import "VoiceRecognizer.h"
#import <OpenEars/LanguageModelGenerator.h>
#import <OpenEars/AcousticModel.h>

@implementation VoiceRecognizer

@synthesize pocketSphinxController;
@synthesize lmPath;
@synthesize dicPath;
@synthesize openEarsEventsObserver;
@synthesize heardWord;

-(void)setup
{
    //Set up for voice recognition.
    //This needs to be called before we start the actual recognition because it takes some time to set up.
    //Maybe move this to application did finish launching.
    //{
    LanguageModelGenerator *lmGenerator = [[LanguageModelGenerator alloc] init];
    
    NSError *error = [lmGenerator generateLanguageModelFromTextFile:[NSString stringWithFormat:@"%@/%@",[[NSBundle mainBundle] resourcePath], @"DVNCorpusTxt.txt"] withFilesNamed:@"OpenEarsDynamicGrammar" forAcousticModelAtPath:[AcousticModel pathToModel:@"AcousticModelEnglish"]];
    
    NSDictionary *languageGeneratorResults = nil;
    
    lmPath = nil;
    dicPath = nil;
    heardWord = nil;
	
    if([error code] == noErr) {
        
        languageGeneratorResults = [error userInfo];
		
        lmPath = [languageGeneratorResults objectForKey:@"LMPath"];
        dicPath = [languageGeneratorResults objectForKey:@"DictionaryPath"];
		
    } else {
        NSLog(@"Error: %@",[error localizedDescription]);
    }
    //}
    
}
//Move the following to the right class when we have it


//Lazy loading accessor methods
- (PocketsphinxController *)pocketsphinxController {
	if (pocketSphinxController == nil) {
		pocketSphinxController = [[PocketsphinxController alloc] init];
	}
	return pocketSphinxController;
}

- (OpenEarsEventsObserver *)openEarsEventsObserver {
	if (openEarsEventsObserver == nil) {
		openEarsEventsObserver = [[OpenEarsEventsObserver alloc] init];
	}
	return openEarsEventsObserver;
}

- (void)startVoiceRecognition{
    
    NSLog(@"Starting Voice Recognition");
    [self.openEarsEventsObserver setDelegate:self];
    
    
    [self.pocketsphinxController startListeningWithLanguageModelAtPath:lmPath dictionaryAtPath:dicPath acousticModelAtPath:[AcousticModel pathToModel:@"AcousticModelEnglish"] languageModelIsJSGF:NO];
    
}
- (void)stopVoiceRecognition{
    
    NSLog(@"Stoping Voice Recognition");
    
    [self.pocketSphinxController stopListening];
}


- (void) pocketsphinxDidReceiveHypothesis:(NSString *)hypothesis recognitionScore:(NSString *)recognitionScore utteranceID:(NSString *)utteranceID {
	NSLog(@"The received hypothesis is \"%@\" with a score of %@ and an ID of %@", hypothesis, recognitionScore, utteranceID);
    self.heardWord = hypothesis;
}

- (void) pocketsphinxDidStartCalibration {
	NSLog(@"Pocketsphinx calibration has started.");
}

- (void) pocketsphinxDidCompleteCalibration {
	NSLog(@"Pocketsphinx calibration is complete.");
}

- (void) pocketsphinxDidStartListening {
	NSLog(@"Pocketsphinx is now listening.");
}

- (void) pocketsphinxDidDetectSpeech {
	NSLog(@"Pocketsphinx has detected speech.");
}

- (void) pocketsphinxDidDetectFinishedSpeech {
	NSLog(@"Pocketsphinx has detected a period of silence, concluding an utterance.");
}

- (void) pocketsphinxDidStopListening {
	NSLog(@"Pocketsphinx has stopped listening.");
}

- (void) pocketsphinxDidSuspendRecognition {
	NSLog(@"Pocketsphinx has suspended recognition.");
}

- (void) pocketsphinxDidResumeRecognition {
	NSLog(@"Pocketsphinx has resumed recognition.");
}

- (void) pocketsphinxDidChangeLanguageModelToFile:(NSString *)newLanguageModelPathAsString andDictionary:(NSString *)newDictionaryPathAsString {
	NSLog(@"Pocketsphinx is now using the following language model: \n%@ and the following dictionary: %@",newLanguageModelPathAsString,newDictionaryPathAsString);
}

- (void) pocketSphinxContinuousSetupDidFail { // This can let you know that something went wrong with the recognition loop startup. Turn on OPENEARSLOGGING to learn why.
	NSLog(@"Setting up the continuous recognition loop has failed for some reason, please turn on OpenEarsLogging to learn more.");
}
- (void) testRecognitionCompleted {
	NSLog(@"A test file that was submitted for recognition is now complete.");
}



@end
