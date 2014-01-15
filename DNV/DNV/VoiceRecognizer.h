#import <Foundation/Foundation.h>
#import <OpenEars/PocketsphinxController.h>
#import <OpenEars/OpenEarsEventsObserver.h>


PocketsphinxController *pocketSphinxController;
OpenEarsEventsObserver *openEarsEventsObserver;


@interface VoiceRecognizer : NSObject<OpenEarsEventsObserverDelegate>

-(void)setup;
-(void)startVoiceRecognition;
-(void)stopVoiceRecognition;




@property (strong, nonatomic) PocketsphinxController *pocketSphinxController;
@property (strong, nonatomic) OpenEarsEventsObserver *openEarsEventsObserver;
@property (strong, nonatomic) NSString *lmPath;
@property (strong, nonatomic) NSString *dicPath;
@property (weak, atomic) NSString *heardWord;
@property BOOL listening;



@end
