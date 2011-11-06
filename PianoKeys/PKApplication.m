
#import "PKApplication.h"
#import "SPMediaKeyTap.h"


@implementation PKApplication

- (void)sendEvent:(NSEvent *)theEvent {
	// If event tap is not installed, handle events that reach the app instead
	BOOL shouldHandleMediaKeyEventLocally = ![SPMediaKeyTap usesGlobalMediaKeyTap];
    
	if(shouldHandleMediaKeyEventLocally && [theEvent type] == NSSystemDefined && [theEvent subtype] == SPSystemDefinedEventMediaKeys) {
		[(id)[self delegate] mediaKeyTap:nil receivedMediaKeyEvent:theEvent];
	}
    
	[super sendEvent:theEvent];
}


@end
