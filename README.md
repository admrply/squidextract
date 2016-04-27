# squidextract
Tool to extract files from a squid cache based on search term.

I got sick of manually searching for and manually carving files, so I built a tool to do it for me!

## Usage
Must be run from the squid cache directory.

$ ./squidcache.sh term-to-search-for

#### Future Development
This was a fairly quick and dirty script, so the chances of me actually getting round to building these in are very slim, however it shouldn't be too difficult to implement the following if anyone should fancy doing so:
- Recover file names (should be possible from the HTTP headers)
- Reconstruct full websites using string matching and replacement in HTML/CSS/etc pages
- Add more magic numbers
