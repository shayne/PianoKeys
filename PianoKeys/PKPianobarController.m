
#import <IOKit/hidsystem/ev_keymap.h>

#import "PKPianobarController.h"


@interface PKPianobarController ()

- (void)sendCommand:(NSString *)command;
- (void)cancelDelayedCommand;
- (void)sendDelayedCommand:(NSString *)command;

- (BOOL)shouldHandleMediaKey:(int)keyCode;

- (BOOL)isPendingDelayedCommand;
- (void)setDelayedCommandPending:(BOOL)pending;
- (BOOL)didSendDelayedCommand;
- (void)setDelayedCommandSent:(BOOL)sent;

@end


#define DELAY_INTERVAL 0.3


@implementation PKPianobarController {
    BOOL delayedCommandPending_;
    BOOL delayedCommandSent_;
}


- (void)onMediaKeyDown:(int)keyCode {
    // NSLog(@"onMediaKeyDown: %d", keyCode);
    
    if (![self shouldHandleMediaKey:keyCode]) {
        return;
    }
    
    if ([self isPendingDelayedCommand]) {
        return;
    }
    
    switch (keyCode) {
        case NX_KEYTYPE_PLAY:
            [self sendDelayedCommand:@"+"];
            break;
            
        case NX_KEYTYPE_FAST:
            [self sendDelayedCommand:@"-"];
            break;
            
        case NX_KEYTYPE_REWIND:
        default:
            break;
    }

}


- (void)onMediaKeyUp:(int)keyCode {
    // NSLog(@"onMediaKeyUp: %d", keyCode);
    
    if (![self shouldHandleMediaKey:keyCode]) {
        return;
    }
    
    if ([self didSendDelayedCommand]) {
        [self setDelayedCommandSent:NO];
        
        return;
    } else if ([self isPendingDelayedCommand]) {
        [self cancelDelayedCommand];
    }
    
    [self setDelayedCommandPending:NO];
    
    
    switch (keyCode) {
        case NX_KEYTYPE_PLAY:
            [self sendCommand:@"p"];
            break;
        
        case NX_KEYTYPE_FAST:
            [self sendCommand:@"n"];
            break;
        
        case NX_KEYTYPE_REWIND:
        default:
            break;
    }
}


#pragma mark Private methods

- (void)sendCommand:(NSString *)command {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    if ([self isPendingDelayedCommand]) {
        [self setDelayedCommandSent:YES];
    }
    
#ifdef DEBUG_SEND
    NSLog(@"Would've sent: %@", command);
#else
    NSData *commandData = [command dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString *path = [@"~/.config/pianobar/ctl" stringByExpandingTildeInPath];
    NSFileHandle *handle = [NSFileHandle fileHandleForWritingAtPath:path];
    
    [handle writeData:commandData];
    [handle closeFile];
#endif
}


- (void)cancelDelayedCommand {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}


- (void)sendDelayedCommand:(NSString *)command {
    [self cancelDelayedCommand];
    [self performSelector:@selector(sendCommand:) withObject:command afterDelay:DELAY_INTERVAL];
    
    [self setDelayedCommandPending:YES];
}


- (BOOL)shouldHandleMediaKey:(int)keyCode {
    switch (keyCode) {
        case NX_KEYTYPE_PLAY:
        case NX_KEYTYPE_FAST:
        case NX_KEYTYPE_REWIND:
            return YES;
            
        default:
            return NO;
            break;
    }
}


- (BOOL)isPendingDelayedCommand {
    return delayedCommandPending_;
}


- (void)setDelayedCommandPending:(BOOL)pending {
    delayedCommandPending_ = pending;
}


- (BOOL)didSendDelayedCommand {
    return delayedCommandSent_;
}


- (void)setDelayedCommandSent:(BOOL)sent {
    delayedCommandSent_ = sent;
}


@end
