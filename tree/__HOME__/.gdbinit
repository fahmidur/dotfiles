set disassembly-flavor intel
set history save on
set history size 1000
set history remove-duplicates 1000
set debuginfod enabled off
define hook-quit
  set confirm off
end
