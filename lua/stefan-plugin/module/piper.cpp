#include <fcntl.h>
#include <string>
#include <unistd.h>
#include <sys/syscall.h>
#include <sys/types.h>
#include <sys/pidfd.h>


int main(){
    int fd = syscall(SYS_pidfd_open, 13156, PIDFD_NONBLOCK);    
    std::string buf = "echo hello";
    write(fd, buf.data(), buf.length());
    close(fd);
    return 0;
}
