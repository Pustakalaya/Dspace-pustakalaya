#!/bin/sh
# Author: Manoj
# Purpose: post build configuration
# Email: <manoj.gautam@olenepal.org>

#TODO: redefine.
/dspace/bin/dspace index-discovery -fb
# Re indexing
/dspace/bin/dspace index-discovery -b -s

echo "Building non-SOLR search and browse indexes... Please wait"

# Run the filters media
/dspace/bin/dspace filter-media

