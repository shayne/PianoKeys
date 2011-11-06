
#import "PKApplication.h"
#import "PKAppDelegate.h"

int main (void) {
#ifdef DAEMONIZE
    pid_t pid = fork();
    
	if (pid < 0) {
		exit(EXIT_FAILURE);
	} else if (pid > 0) {
		exit(EXIT_SUCCESS);
	}
    
	close(STDIN_FILENO);
	close(STDOUT_FILENO);
	close(STDERR_FILENO);
#endif

    @autoreleasepool {
        NSApplication *app = [PKApplication sharedApplication];
        app.delegate = [[[PKAppDelegate alloc] init] autorelease];
        [app run];
    }
    
    return EXIT_SUCCESS;
}
