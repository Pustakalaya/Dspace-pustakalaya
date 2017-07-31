#!/bin/sh
# Author: Manoj
# Purpose: post build configuration
# Email: <manoj.gautam@olenepal.org>

#TODO: redefine.
/dspace/bin/dspace index-discovery -fb
# Re indexing
/dspace/bin/dspace index-discovery -b -s

echo "Building non-SOLR search and browse indexes... Please wait"


# Run some media filters
# 1000 objectes at a time
/dspace/bin/dspace filter-media -v -f -m 1000 -p "ImageMagick Image Thumbnail"
/dspace/bin/dspace filter-media -v -f -m 1000 -p "ImageMagick PDF Thumbnail"

# Importing existing authors and keeping the index up to date
/dspace/bin/dspace index-authority

# Update the items
/dspace/bin/dspace itemupdate
