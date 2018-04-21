-- mpegts truncate
--
-- Allows truncating a currently playing mpegts file.
-- Currently allows truncating at the FRONT only.
-- (Removing intermediate parts or truncating at the end can be implemented, too.)
-- File is NOT completely rewritten/copied/muxed/encoded.
-- File is edited directly on disk.
--
-- Relies on provided tool fcollapse.
-- fcollapse uses fallocate with FALLOC_FL_COLLAPSE_RANGE, which is
-- only available on Linux 3.15 (or later) on XFS or ext4 (extent-based files).
-- See http://man7.org/linux/man-pages/man2/fallocate.2.html.
--
-- Please note: The point at which the file is truncated is aligned to the
-- nearest file system block size. The cut mpegts frame will be damaged virtually
-- always. The rest of the stream should be fine.
--
-- ##############################################
-- #                                            #
-- #                  CAUTION:                  #
-- #       This deletes data permanently!       #
-- #   The process inaccurate and unreliable.   #
-- #       Do not use on important files.       #
-- #                                            #
-- ##############################################

BLOCKSIZE = 4096 -- Adjust to your filesystem's blocksize

function mpegts_truncate_front()
  -- check if opened stream is actually mpegts
  local file_format = mp.get_property("file-format")
  if file_format ~= "mpegts" then
    mp.osd_message(
      "mpegts_truncate_front: no action (file format is not mpegts)"
    )
  else
    -- get current position as bytes
    local pos = mp.get_property_number("stream-pos")
    -- regard additional bytes already read into cache
    local cache_used = mp.get_property_native("cache-used")
    if cache_used == nil then
      -- in case there is no cache
      cache_used = 0
    end
    local pos_without_cache = pos-cache_used
    -- adjust position to cut at block-size
    local aligned_pos = math.floor(pos_without_cache/BLOCKSIZE)*BLOCKSIZE
    print(
      string.format(
        "mpegts_truncate_front invoked at byte %d (aligned from byte %d with %d bytes cached)", 
        aligned_pos, pos, cache_used
      )
    )
    -- get path to currently opened file
    local file_path = mp.get_property("stream-path")
    -- get directory of script
    local script_directory = debug.getinfo(1).source:sub(2):match("(.*/)")
    -- execute external helper script
    cmd = string.format(
      '%smpegts_truncate.sh "%s" 0 %d',
      script_directory, file_path, aligned_pos
    )
    local returncode = os.execute(cmd)
    if returncode == true then
      -- reload newly truncated file
      mp.commandv("loadfile", file_path)
    end
  end
end

-- provide default keybinding
mp.add_key_binding("Alt+F", "mpegts_truncate_front", mpegts_truncate_front)
