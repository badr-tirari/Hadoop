create 'chrono', 'stats'
put 'chrono', '2023', 'stats:total', '25808484104'
put 'chrono', '1975', 'stats:total', '4206105352'
put 'chrono', '2021', 'stats:total', '73808103039'
scan 'chrono'
get 'chrono', '1975'
scan 'chrono', { STARTROW => '1975', STOPROW => '2021' }
