
#ifndef PianoKeys_GetBSDProcessList_h
#define PianoKeys_GetBSDProcessList_h

#include <sys/sysctl.h>

typedef struct kinfo_proc kinfo_proc;

int GetBSDProcessList(kinfo_proc **procList, size_t *procCount);

#endif
