# mpv mpegts truncate

Allows truncating a currently playing mpegts file.  
File is NOT completely rewritten/copied/muxed/encoded.
File is edited directly on disk.  

Relies on fallocate as supplied with your system.  
Uses fallocate with FALLOC_FL_COLLAPSE_RANGE, which is 
only available on Linux 3.15 (or later) on XFS or ext4 (extent-based files).  
See http://man7.org/linux/man-pages/man2/fallocate.2.html.

Please note: The point at which the file is truncated is aligned to the
nearest file system block size. The cut mpegts frame will be damaged virtually
always. The rest of the stream should be fine.

I use this myself on files of recorded TV shows to remove advertisements
from the beginning of the recording.

## Installation

Copy `mpegts_truncate.lua` and `mpegts_truncate.sh` to your mpv script directory (usually `~/.mpv/scripts`).  

In case you prefer having `mpegts_truncate.sh` in your path, you can adjust `mpegts_truncate.lua` accordingly.

## Usage

Use the shortcut `Alt+Shift+f` to truncate the currently playing MPEG-TS file up to the current position.

Use the shortcut `Alt+Shift+b` to truncate the currently playing MPEG-TS file at the current position.
