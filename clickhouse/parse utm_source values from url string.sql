SELECT url, splitByChar('&', splitByString('utm_source=', assumeNotNull(url))[2])[1] as utm_source 
FROM table1