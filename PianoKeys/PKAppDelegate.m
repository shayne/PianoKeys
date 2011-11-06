
#import "PKAppDelegate.h"

#import "PKPianobarController.h"
#import "SPMediaKeyTap.h"
#import "GetBSDProcessList.h"


@interface PKAppDelegate ()

- (void)exitIfPianobarIsNotRunning;

@end


@implementation PKAppDelegate {
    PKPianobarController *pianobarController_;
    SPMediaKeyTap *keyTap_;
    
    NSTimer *processCheckTimer_;
}


@synthesize window = _window;


#pragma mark - NSObject

- (void)dealloc {
    [keyTap_ release];
    [pianobarController_ release];
    
    [super dealloc];
}


#pragma mark - NSApplicationDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    NSLog(@"PianoKeys started");
    pianobarController_ = [[PKPianobarController alloc] init];
	keyTap_ = [[SPMediaKeyTap alloc] initWithDelegate:self];
    
	if([SPMediaKeyTap usesGlobalMediaKeyTap]) {
		[keyTap_ startWatchingMediaKeys];
	} else {
		NSLog(@"Media key monitoring disabled");
    }
    
#ifdef AUTO_EXIT
    processCheckTimer_ = [NSTimer scheduledTimerWithTimeInterval:5.0
                                                          target:self
                                                        selector:@selector(exitIfPianobarIsNotRunning)
                                                        userInfo:nil
                                                         repeats:YES];
#endif
}


- (void)applicationWillTerminate:(NSNotification *)notification {
    [processCheckTimer_ invalidate];
}


#pragma mark - SPMediaKeyTapDelegate

-(void)mediaKeyTap:(SPMediaKeyTap*)keyTap receivedMediaKeyEvent:(NSEvent*)event {
	NSAssert([event type] == NSSystemDefined && [event subtype] == SPSystemDefinedEventMediaKeys,
             @"Unexpected NSEvent in mediaKeyTap:receivedMediaKeyEvent:");
    
	int keyCode = (([event data1] & 0xFFFF0000) >> 16);
	int keyFlags = ([event data1] & 0x0000FFFF);
	BOOL keyDown = (((keyFlags & 0xFF00) >> 8)) == 0xA;
    
    if (keyDown) {
        [pianobarController_ onMediaKeyDown:keyCode];
    } else {
        [pianobarController_ onMediaKeyUp:keyCode];
    }
}


#pragma mark - Private methods

- (void)exitIfPianobarIsNotRunning {
    kinfo_proc *procList = {0};
    size_t procCount;
    
    GetBSDProcessList(&procList, &procCount);
    
    BOOL pianobarFound = NO;
    
    for (int i = 0; i < procCount; i++) {
        kinfo_proc proc = procList[i];
        
        if (strcmp("pianobar", proc.kp_proc.p_comm) == 0) {
            pianobarFound = YES;
            break;
        }
    }
    
    if (procCount > 0) {
        free(procList);
    }
    
    if (!pianobarFound) {
        [NSApp terminate:self];
    }
}


@end
