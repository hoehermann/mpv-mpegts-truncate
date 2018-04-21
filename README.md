# mpv mpegts truncate

Allows truncating a currently playing mpegts file.  
Currently allows truncating at the FRONT only.  
(Removing intermediate parts or truncating at the end can be implemented, too.)  
File is NOT completely rewritten/copied/muxed/encoded.
File is edited directly on disk.  

Relies on provided tool fcollapse.  
fcollapse uses fallocate with FALLOC_FL_COLLAPSE_RANGE, which is 
only available on Linux 3.15 (or later) on XFS or ext4 (extent-based files).  
See http://man7.org/linux/man-pages/man2/fallocate.2.html.

Please note: The point at which the file is truncated is aligned to the
nearest file system block size. The cut mpegts frame will be damaged virtually
always. The rest of the stream should be fine.

I use this myself on files of recorded TV shows to remove advertisements
from the beginning of the recording.
