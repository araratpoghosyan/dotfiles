--- Custom linemode for yazi file manager that displays file information in a detailed format
--- Shows: file size, modification time, and permissions
--- @return string Formatted string with size, time, and permissions separated by spaces
function Linemode:full()
	-- Get file modification time (mtime) in Unix timestamp format
	-- Floor the value to remove any decimal precision
	local time = math.floor(self._file.cha.mtime or 0)

	-- Format the timestamp based on its value:
	-- - Empty string if time is 0 (file has no valid timestamp)
	-- - "MMM DD HH:MM" format if file was modified this year
	-- - "MMM DD  YYYY" format if file was modified in a previous year
	if time == 0 then
		time = ""
	elseif os.date("%Y", time) == os.date("%Y") then
		time = os.date("%b %d %H:%M", time)
	else
		time = os.date("%b %d  %Y", time)
	end

	-- Get file size in bytes
	local size = self._file:size()

	-- Get file permissions string (e.g., "rwxr-xr-x")
	local mode = self._file.cha:perm() or ""

	-- Return formatted string: "<size> <time> <permissions>"
	-- Size is human-readable (e.g., "1.2 KB"), or "-" if unavailable
	return string.format("%s %s %s", size and ya.readable_size(size) or "-", time, mode)
end