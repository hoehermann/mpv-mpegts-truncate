/**
 * fcollapse
 * 
 * Simple program to invoke fallocate with FALLOC_FL_COLLAPSE_RANGE.
 * 
 * Thanks to
 * https://stackoverflow.com/questions/18072180/
 * https://unix.stackexchange.com/questions/355953/
 * 
 * Compile via
 * gcc -o fcollapse -D_FILE_OFFSET_BITS=64 -Wall -Werror fcollapse.c
 */

#define _GNU_SOURCE // enable fallocate
#include <fcntl.h> // fallocate
#include <stdio.h> // fprintf
#include <string.h> // sscanf
#include <errno.h> // strerror
#include <unistd.h> // close

int main(int argc, const char * argv[])
{
    if (argc != 4) {
        fprintf(stderr, "need excactly 3 arguments: filename offset length\n");
        return 1;
    }
    int fd = 0;
    off_t offset = 0;
    off_t len = 0;
    sscanf(argv[2], "%ld", &offset);
    sscanf(argv[3], "%ld", &len);
    fd = open(argv[1], O_RDWR);
    if (fd == -1) {
        fprintf(stderr, "open failed: %s\n", strerror(errno));
        return errno;
    }

    int err;
    err = fallocate(fd, FALLOC_FL_COLLAPSE_RANGE, offset, len);
    if (err) {
        fprintf(stderr, "fallocate failed: %s\n", strerror(errno));
        return errno;
    }

    close(fd);
    return 0;
}
